/**
 * Cloud Functions für Projekt Unbarmherzigkeit
 */

const {onCall, onRequest, HttpsError} =
    require("firebase-functions/v2/https");
const {setGlobalOptions} = require("firebase-functions/v2");
const {logger} = require("firebase-functions/v2");
const admin = require("firebase-admin");

admin.initializeApp();

setGlobalOptions({
  maxInstances: 10,
  region: "europe-west1",
});

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
    logger.info(`Claims gesetzt für ${uid}`);
    return {success: true, message: "Claims gesetzt", claims: claims};
  } catch (error) {
    logger.error("Fehler:", error);
    throw new HttpsError("internal", error.message);
  }
});

exports.getUserClaims = onCall({cors: true}, async (request) => {
  if (!request.auth) {
    throw new HttpsError("unauthenticated", "Authentifizierung erforderlich");
  }

  const {uid} = request.data;
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
    await admin.firestore().collection("admin_actions").add({
      action: "make_admin",
      targetUid: uid,
      performedBy: request.auth.uid,
      claims: claims,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`User ${uid} zum Admin gemacht`);
    return {success: true, message: `User zum ${level} gemacht`, claims};
  } catch (error) {
    logger.error("Fehler:", error);
    throw new HttpsError("internal", error.message);
  }
});

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
    await admin.firestore().collection("admin_actions").add({
      action: "remove_admin",
      targetUid: uid,
      performedBy: request.auth.uid,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    });

    logger.info(`Admin-Status entfernt für ${uid}`);
    return {success: true, message: "Admin-Status entfernt"};
  } catch (error) {
    logger.error("Fehler:", error);
    throw new HttpsError("internal", error.message);
  }
});

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

    return {success: true, admins: admins, count: admins.length};
  } catch (error) {
    logger.error("Fehler:", error);
    throw new HttpsError("internal", error.message);
  }
});

exports.initializeSuperAdmin = onRequest({cors: true}, async (req, res) => {
  const {email, secret} = req.body;

  if (secret !== "INIT_SUPER_ADMIN_SECRET_2024") {
    res.status(403).json({error: "Ungültiger Secret Key"});
    return;
  }

  if (!email) {
    res.status(400).json({error: "E-Mail erforderlich"});
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
    logger.info(`Super-Admin initialisiert: ${email}`);

    res.json({
      success: true,
      message: `Super-Admin initialisiert für ${email}`,
      uid: userRecord.uid,
    });
  } catch (error) {
    logger.error("Fehler:", error);
    res.status(500).json({error: error.message});
  }
});

/**
 * Prüft Super-Admin Status
 * @param {string} uid User ID
 * @return {Promise<boolean>} True wenn Super-Admin
 */
async function checkSuperAdmin(uid) {
  try {
    const userRecord = await admin.auth().getUser(uid);
    const claims = userRecord.customClaims || {};
    return claims.admin === true && claims.adminLevel === "super";
  } catch (error) {
    return false;
  }
}

/**
 * Prüft Admin Status
 * @param {string} uid User ID
 * @return {Promise<boolean>} True wenn Admin
 */
async function checkAdmin(uid) {
  try {
    const userRecord = await admin.auth().getUser(uid);
    const claims = userRecord.customClaims || {};
    return claims.admin === true;
  } catch (error) {
    return false;
  }
}
