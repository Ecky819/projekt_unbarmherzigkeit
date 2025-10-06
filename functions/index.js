/**
 * Cloud Functions für Projekt Unbarmherzigkeit
 * Diese Functions verwalten Admin-Rollen und Custom Claims in Firebase Auth.
 */

const {onCall, HttpsError} = require("firebase-functions/v2/https");
const {setGlobalOptions} = require("firebase-functions/v2");
const {logger} = require("firebase-functions/v2");
const admin = require("firebase-admin");

// Firebase Admin SDK initialisieren
admin.initializeApp();

// Globale Einstellungen für alle Functions
setGlobalOptions({
  maxInstances: 10,
  region: "europe-west1",
});

// ============================================================================
// CUSTOM CLAIMS MANAGEMENT
// ============================================================================

/**
 * Setzt Custom Claims für einen Benutzer
 * Nur Super-Admins können diese Function aufrufen
 * @param {string} request.data.uid - User ID
 * @param {object} request.data.claims - Claims Objekt
 * @returns {object} Success-Objekt mit gesetzten Claims
 */
exports.setUserClaims = onCall({cors: true}, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const isSuperAdmin = await checkSuperAdmin(request.auth.uid);
  if (!isSuperAdmin) {
    throw new HttpsError("permission-denied", "Super-Admin erforderlich");
  }

  const {uid, claims} = request.data;

  if (!uid) {
    throw new HttpsError("invalid-argument", "UID erforderlich");
  }

  try {
    await admin.auth().setCustomUserClaims(uid, claims);
    logger.info(`Claims gesetzt für ${uid}`, {claims});
    return {success: true, message: "Claims gesetzt", claims: claims};
  } catch (error) {
    logger.error("Fehler beim Setzen der Claims:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Ruft Custom Claims eines Benutzers ab
 * User können ihre eigenen Claims abrufen, Admins können alle Claims abrufen
 * @returns {object} User-Informationen mit Claims
 */
exports.getUserClaims = onCall({cors: true}, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const {uid} = request.data;
  const targetUid = uid || request.auth.uid;
  const canAccess = request.auth.uid === targetUid ||
        (await checkAdmin(request.auth.uid));

  if (!canAccess) {
    throw new HttpsError("permission-denied", "Keine Berechtigung");
  }

  try {
    const userRecord = await admin.auth().getUser(targetUid);
    return {
      success: true,
      uid: userRecord.uid,
      email: userRecord.email,
      customClaims: userRecord.customClaims || {},
    };
  } catch (error) {
    logger.error("Fehler beim Abrufen der Claims:", error);
    throw new HttpsError("internal", error.message);
  }
});

// ============================================================================
// ADMIN MANAGEMENT
// ============================================================================

/**
 * Macht einen Benutzer zum Admin
 * Nur Super-Admins können diese Function aufrufen
 * @param {string} request.data.uid - User ID
 * @param {string} request.data.adminLevel - Admin Level (default: "admin")
 * @returns {object} Success-Objekt mit gesetzten Claims
 */
exports.makeUserAdmin = onCall({cors: true}, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const isSuperAdmin = await checkSuperAdmin(request.auth.uid);
  if (!isSuperAdmin) {
    throw new HttpsError("permission-denied", "Super-Admin erforderlich");
  }

  const {uid, adminLevel} = request.data;
  const level = adminLevel || "admin";

  if (!uid) {
    throw new HttpsError("invalid-argument", "UID erforderlich");
  }

  try {
    const claims = {
      admin: true,
      adminLevel: level,
      role: "admin",
      assignedAt: new Date().toISOString(),
      assignedBy: request.auth.uid,
    };

    await admin.auth().setCustomUserClaims(uid, claims);

    // Logge Admin-Aktion in Firestore
    await admin.firestore().collection("admin_actions").add({
      action: "make_admin",
      targetUid: uid,
      performedBy: request.auth.uid,
      claims: claims,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`User ${uid} zum ${level} gemacht von ${request.auth.uid}`);
    return {success: true, message: `User zum ${level} gemacht`, claims};
  } catch (error) {
    logger.error("Fehler beim Erstellen des Admins:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Entfernt Admin-Status von einem Benutzer
 * Nur Super-Admins können diese Function aufrufen
 * @param {string} request.data.uid - User ID
 * @returns {object} Success-Objekt
 */
exports.removeUserAdmin = onCall({cors: true}, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const isSuperAdmin = await checkSuperAdmin(request.auth.uid);
  if (!isSuperAdmin) {
    throw new HttpsError("permission-denied", "Super-Admin erforderlich");
  }

  const {uid} = request.data;

  if (!uid) {
    throw new HttpsError("invalid-argument", "UID erforderlich");
  }

  try {
    const claims = {admin: null, adminLevel: null, role: "user"};
    await admin.auth().setCustomUserClaims(uid, claims);
    // Logge Admin-Aktion in Firestore
    await admin.firestore().collection("admin_actions").add({
      action: "remove_admin",
      targetUid: uid,
      performedBy: request.auth.uid,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Admin-Status entfernt für ${uid} von ${request.auth.uid}`);
    return {success: true, message: "Admin-Status entfernt"};
  } catch (error) {
    logger.error("Fehler beim Entfernen des Admin-Status:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Listet alle Admins auf
 * Nur Admins können diese Function aufrufen
 * @returns {object} Liste aller Admins
 */
exports.listAdmins = onCall({cors: true}, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const isAdmin = await checkAdmin(request.auth.uid);
  if (!isAdmin) {
    throw new HttpsError("permission-denied", "Admin-Rechte erforderlich");
  }

  try {
    const admins = [];
    const listUsersResult = await admin.auth().listUsers(1000);

    for (const userRecord of listUsersResult.users) {
      if (userRecord.customClaims && userRecord.customClaims.admin) {
        admins.push({
          uid: userRecord.uid,
          email: userRecord.email,
          displayName: userRecord.displayName,
          claims: userRecord.customClaims,
          disabled: userRecord.disabled,
          emailVerified: userRecord.emailVerified,
        });
      }
    }

    // eslint-disable-next-line max-len
    logger.info(`Admin-Liste abgerufen von ${request.auth.uid}, ${admins.length} Admins gefunden`);
    return {success: true, admins: admins, count: admins.length};
  } catch (error) {
    logger.error("Fehler beim Abrufen der Admin-Liste:", error);
    throw new HttpsError("internal", error.message);
  }
});

// ============================================================================
// SUPER-ADMIN INITIALISIERUNG
// ============================================================================

/**
 * Initialisiert den ersten Super-Admin
 * WICHTIG: Diese Function kann nur EINMAL pro Projekt aufgerufen werden!
 * Sie verwendet onCall und benötigt KEINE IAM-Berechtigungen.
 * Voraussetzungen:
 * - Der Benutzer muss bereits in Firebase Auth registriert sein
 * - Korrekter Secret Key muss übergeben werden
 * - Es darf noch kein Super-Admin existieren
 * @param {string} request.data.email - E-Mail des Super-Admins
 * @param {string} request.data.secret - Secret Key zur Authentifizierung
 * @returns {object} Success-Objekt mit UID und Claims
 * @throws {HttpsError} already-exists - Super-Admin existiert bereits
 * @throws {HttpsError} permission-denied - Ungültiger Secret Key
 * @throws {HttpsError} invalid-argument - E-Mail fehlt
 * @throws {HttpsError} not-found - Benutzer existiert nicht
 */
exports.initializeSuperAdmin = onCall({cors: true}, async (request) => {
  // Hole Parameter aus request.data
  const {email, secret} = request.data;

  logger.info("Super-Admin Initialisierung gestartet", {email});

  // SCHRITT 1: Prüfe ob bereits ein Super-Admin existiert
  try {
    const existingSuperAdmins = await admin.firestore()
        .collection("admin_actions")
        .where("action", "==", "init_super_admin")
        .limit(1)
        .get();

    if (!existingSuperAdmins.empty) {
      logger.warn("Versuch, Super-Admin erneut zu initialisieren", {
        email,
        existingDoc: existingSuperAdmins.docs[0].id,
      });
      throw new HttpsError(
          "already-exists",
          "Super-Admin wurde bereits initialisiert. " +
          "Diese Funktion kann nur einmal verwendet werden.",
      );
    }
  } catch (error) {
    // Wenn es ein HttpsError ist, weiterwerfen
    if (error instanceof HttpsError) {
      throw error;
    }
    // Firestore-Fehler loggen, aber weitermachen
    logger.error("Fehler beim Prüfen bestehender Super-Admins:", error);
  }

  // SCHRITT 2: Überprüfe Secret Key
  if (secret !== "INIT_SUPER_ADMIN_SECRET_2024") {
    logger.warn("Ungültiger Secret Key verwendet", {email});
    throw new HttpsError("permission-denied", "Ungültiger Secret Key");
  }

  // SCHRITT 3: Validiere E-Mail
  if (!email) {
    logger.error("E-Mail fehlt in der Anfrage");
    throw new HttpsError("invalid-argument", "E-Mail erforderlich");
  }

  // SCHRITT 4: Hole User aus Firebase Auth
  let userRecord;
  try {
    userRecord = await admin.auth().getUserByEmail(email);
    logger.info("User gefunden in Firebase Auth", {
      uid: userRecord.uid,
      email: userRecord.email,
    });
  } catch (error) {
    if (error.code === "auth/user-not-found") {
      logger.error("User nicht gefunden in Firebase Auth", {email});
      throw new HttpsError(
          "not-found",
          `Benutzer mit E-Mail ${email} existiert nicht. ` +
          `Bitte registriere dich zuerst in der App.`,
      );
    }
    logger.error("Fehler beim Abrufen des Users:", error);
    throw new HttpsError("internal", "Fehler beim Abrufen des Benutzers");
  }

  // SCHRITT 5: Setze Super-Admin Claims
  try {
    const claims = {
      admin: true,
      adminLevel: "super",
      role: "super_admin",
      assignedAt: new Date().toISOString(),
      assignedBy: "system_init",
    };

    await admin.auth().setCustomUserClaims(userRecord.uid, claims);
    logger.info("Super-Admin Claims gesetzt", {
      uid: userRecord.uid,
      claims,
    });

    // SCHRITT 6: Logge die Initialisierung in Firestore
    // Dies verhindert weitere Aufrufe dieser Function
    await admin.firestore().collection("admin_actions").add({
      action: "init_super_admin",
      targetUid: userRecord.uid,
      targetEmail: email,
      performedBy: "system",
      claims: claims,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
      metadata: {
        initializedAt: new Date().toISOString(),
        version: "1.0",
      },
    });

    logger.info("🎉 Super-Admin erfolgreich initialisiert!", {
      email,
      uid: userRecord.uid,
    });

    // SCHRITT 7: Gebe Erfolg zurück
    return {
      success: true,
      message: `Super-Admin erfolgreich initialisiert für ${email}`,
      uid: userRecord.uid,
      claims: claims,
      note: "Bitte Token aktualisieren (Logout + Login) damit die Claims " +
        "aktiv werden",
    };
  } catch (error) {
    logger.error("❌ Fehler bei Super-Admin Initialisierung:", error);

    // Wenn es bereits ein HttpsError ist, weiterwerfen
    if (error instanceof HttpsError) {
      throw error;
    }

    // Sonst als interner Fehler werfen
    // eslint-disable-next-line max-len
    throw new HttpsError("internal", `Fehler bei der Initialisierung: ${error.message}`);
  }
});

// ============================================================================
// HILFSFUNKTIONEN
// ============================================================================

/**
 * Prüft ob ein Benutzer Super-Admin ist
 *
 * @param {string} uid - User ID
 * @return {Promise<boolean>} True wenn Super-Admin
 */
async function checkSuperAdmin(uid) {
  try {
    const userRecord = await admin.auth().getUser(uid);
    const claims = userRecord.customClaims || {};
    return claims.admin === true && claims.adminLevel === "super";
  } catch (error) {
    logger.error("Fehler beim Prüfen des Super-Admin Status:", error);
    return false;
  }
}

/**
 * Prüft ob ein Benutzer Admin ist
 *
 * @param {string} uid - User ID
 * @return {Promise<boolean>} True wenn Admin (beliebiges Level)
 */
async function checkAdmin(uid) {
  try {
    const userRecord = await admin.auth().getUser(uid);
    const claims = userRecord.customClaims || {};
    return claims.admin === true;
  } catch (error) {
    logger.error("Fehler beim Prüfen des Admin Status:", error);
    return false;
  }
}
