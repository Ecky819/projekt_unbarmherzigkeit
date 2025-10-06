/**
 * Cloud Functions für Projekt Unbarmherzigkeit
 * Sichere Version mit Environment Variables für Secrets
 */

const { onCall, onRequest, HttpsError } =
  require("firebase-functions/v2/https");
const { setGlobalOptions } = require("firebase-functions/v2");
const { logger } = require("firebase-functions/v2");
const { defineString } = require("firebase-functions/params");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({
  maxInstances: 10,
  region: "europe-west1",
});

// Environment Variable für Super Admin Initialisierung
// eslint-disable-next-line max-len
// Wird gesetzt mit: firebase functions:config:set admin.init_secret="DEIN_SECRET"
const SUPER_ADMIN_INIT_SECRET = defineString("SUPER_ADMIN_INIT_SECRET", {
  description: "Secret Key für Super-Admin Initialisierung",
  default: "CHANGE_ME_AFTER_FIRST_USE",
});

// ========== CUSTOM CLAIMS MANAGEMENT ==========

/**
 * Setzt Custom Claims für einen User (nur Super-Admin)
 */
exports.setUserClaims = onCall({ cors: true }, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const isSuperAdmin = await checkSuperAdmin(request.auth.uid);
  if (!isSuperAdmin) {
    throw new HttpsError("permission-denied", "Super-Admin erforderlich");
  }

  const { uid, claims } = request.data;

  if (!uid) {
    throw new HttpsError("invalid-argument", "UID erforderlich");
  }

  try {
    await admin.auth().setCustomUserClaims(uid, claims);
    logger.info(`Claims gesetzt für ${uid}`);
    return { success: true, message: "Claims gesetzt", claims: claims };
  } catch (error) {
    logger.error("Fehler:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Ruft Custom Claims für einen User ab
 */
exports.getUserClaims = onCall({ cors: true }, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const { uid } = request.data;
  const canAccess = request.auth.uid === uid ||
    (await checkAdmin(request.auth.uid));

  if (!canAccess) {
    throw new HttpsError("permission-denied", "Keine Berechtigung");
  }

  try {
    const userRecord = await admin.auth().getUser(uid || request.auth.uid);
    return {
      uid: userRecord.uid,
      email: userRecord.email,
      customClaims: userRecord.customClaims || {},
    };
  } catch (error) {
    logger.error("Fehler:", error);
    throw new HttpsError("internal", error.message);
  }
});

// ========== ADMIN MANAGEMENT ==========

/**
 * Macht einen User zum Admin (nur Super-Admin)
 */
exports.makeUserAdmin = onCall({ cors: true }, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const isSuperAdmin = await checkSuperAdmin(request.auth.uid);
  if (!isSuperAdmin) {
    throw new HttpsError("permission-denied", "Super-Admin erforderlich");
  }

  const { uid, adminLevel } = request.data;
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
    await admin.firestore().collection("admin_actions").add({
      action: "make_admin",
      targetUid: uid,
      performedBy: request.auth.uid,
      claims: claims,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`User ${uid} zum Admin gemacht`);
    return { success: true, message: `User zum ${level} gemacht`, claims };
  } catch (error) {
    logger.error("Fehler:", error);
    throw new HttpsError("internal", error.message);
  }
});

/**
 * Entfernt Admin-Status von einem User (nur Super-Admin)
 */
exports.removeUserAdmin = onCall({ cors: true }, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const isSuperAdmin = await checkSuperAdmin(request.auth.uid);
  if (!isSuperAdmin) {
    throw new HttpsError("permission-denied", "Super-Admin erforderlich");
  }

  const { uid } = request.data;

  if (!uid) {
    throw new HttpsError("invalid-argument", "UID erforderlich");
  }

  try {
    await admin.auth().setCustomUserClaims(uid, {});
    await admin.firestore().collection("admin_actions").add({
      action: "remove_admin",
      targetUid: uid,
      performedBy: request.auth.uid,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Admin-Status entfernt für ${uid}`);
    return { success: true, message: "Admin-Status entfernt" };
  } catch (error) {
    logger.error("Fehler:", error);
    throw new HttpsError("internal", error.message);
  }
});

// ========== SUPER ADMIN INITIALIZATION ==========

/**
 * Initialisiert den ersten Super-Admin (einmalig verwendbar)
 * WICHTIG: Diese Funktion sollte nach der ersten Nutzung deaktiviert werden!
 *
 * Verwendung:
 * curl -X POST https://europe-west1-PROJEKT-ID.cloudfunctions.net/initializeSuperAdmin \
 *   -H "Content-Type: application/json" \
 *   -d '{"email": "admin@example.com", "secret": "DEIN_SECRET"}'
 */
exports.initializeSuperAdmin = onRequest({ cors: true }, async (req, res) => {
  // Prüfen ob bereits ein Super-Admin existiert
  try {
    const existingSuperAdmins = await admin.firestore()
      .collection("admin_actions")
      .where("action", "==", "init_super_admin")
      .limit(1)
      .get();

    if (!existingSuperAdmins.empty) {
      // eslint-disable-next-line max-len
      logger.warn("Versuch, Super-Admin zu initialisieren, obwohl bereits einer existiert");
      res.status(403).json({
        // eslint-disable-next-line max-len
        error: "Super-Admin bereits initialisiert. Diese Funktion ist nicht mehr verfügbar.",
      });
      return;
    }
  } catch (error) {
    logger.error("Fehler beim Prüfen existierender Super-Admins:", error);
    res.status(500).json({ error: "Interner Serverfehler" });
    return;
  }

  const { email, secret } = req.body;

  // Secret Key Validierung mit Environment Variable
  if (secret !== SUPER_ADMIN_INIT_SECRET.value()) {
    // eslint-disable-next-line max-len
    logger.warn(`Ungültiger Secret Key verwendet bei Super-Admin Init für ${email}`);
    res.status(403).json({ error: "Ungültiger Secret Key" });
    return;
  }

  if (!email) {
    res.status(400).json({ error: "E-Mail erforderlich" });
    return;
  }

  try {
    const userRecord = await admin.auth().getUserByEmail(email);
    const claims = {
      admin: true,
      adminLevel: "super",
      role: "super_admin",
      assignedAt: new Date().toISOString(),
      assignedBy: "system_init",
    };

    await admin.auth().setCustomUserClaims(userRecord.uid, claims);

    // Dokumentation der Initialisierung
    await admin.firestore().collection("admin_actions").add({
      action: "init_super_admin",
      email: email,
      uid: userRecord.uid,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Super-Admin initialisiert: ${email} (UID: ${userRecord.uid})`);

    res.json({
      success: true,
      message: `Super-Admin initialisiert für ${email}`,
      uid: userRecord.uid,
      // eslint-disable-next-line max-len
      notice: "WICHTIG: Diese Funktion kann nicht mehr verwendet werden. Bitte Secret Key ändern und Funktion ggf. deaktivieren.",
    });
  } catch (error) {
    logger.error("Fehler bei Super-Admin Initialisierung:", error);
    res.status(500).json({ error: error.message });
  }
});

// ========== HELPER FUNCTIONS ==========

/**
 * Prüft ob ein User Super-Admin ist
 * @param {string} uid User ID
 * @return {Promise<boolean>} True wenn Super-Admin
 */
async function checkSuperAdmin(uid) {
  try {
    const userRecord = await admin.auth().getUser(uid);
    const claims = userRecord.customClaims || {};
    return claims.admin === true && claims.adminLevel === "super";
  } catch (error) {
    logger.error(`Fehler beim Super-Admin Check für ${uid}:`, error);
    return false;
  }
}

/**
 * Prüft ob ein User Admin ist (beliebiges Level)
 * @param {string} uid User ID
 * @return {Promise<boolean>} True wenn Admin
 */
async function checkAdmin(uid) {
  try {
    const userRecord = await admin.auth().getUser(uid);
    const claims = userRecord.customClaims || {};
    return claims.admin === true;
  } catch (error) {
    logger.error(`Fehler beim Admin Check für ${uid}:`, error);
    return false;
  }
}
