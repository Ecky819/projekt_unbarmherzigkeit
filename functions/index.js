// functions/index.js
const { onCall, HttpsError } = require('firebase-functions/v2/https');
const { onDocumentCreated } = require('firebase-functions/v2/firestore');
const admin = require('firebase-admin');
const { logger } = require('firebase-functions');

admin.initializeApp();

// ========== HELPER FUNCTIONS ==========

/**
 * Check if the calling user is an admin
 */
async function requireAdmin(context) {
    if (!context.auth) {
        throw new HttpsError('unauthenticated', 'Benutzer muss angemeldet sein');
    }

    const userRecord = await admin.auth().getUser(context.auth.uid);
    const customClaims = userRecord.customClaims || {};

    // Check for admin role or legacy admin email
    const isAdmin = customClaims.admin === true ||
        customClaims.role === 'admin' ||
        context.auth.token.email === 'marcoeggert73@gmail.com';

    if (!isAdmin) {
        throw new HttpsError('permission-denied', 'Admin-Berechtigung erforderlich');
    }

    return userRecord;
}

/**
 * Validate user UID
 */
function validateUid(uid) {
    if (!uid || typeof uid !== 'string' || uid.length === 0) {
        throw new HttpsError('invalid-argument', 'Ungültige User ID');
    }
}

// ========== CUSTOM CLAIMS FUNCTIONS ==========

/**
 * Set admin claims for a user
 * Only callable by existing admins
 */
exports.setAdminClaims = onCall(async (request) => {
    try {
        // Check admin permission
        await requireAdmin(request);

        const { uid, admin: isAdmin } = request.data;
        validateUid(uid);

        if (typeof isAdmin !== 'boolean') {
            throw new HttpsError('invalid-argument', 'admin muss ein Boolean sein');
        }

        // Get current user record
        const userRecord = await admin.auth().getUser(uid);
        const currentClaims = userRecord.customClaims || {};

        // Set new claims
        const newClaims = {
            ...currentClaims,
            admin: isAdmin,
            role: isAdmin ? 'admin' : (currentClaims.role || 'user'),
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        // Set custom claims
        await admin.auth().setCustomUserClaims(uid, newClaims);

        // Log the action
        logger.info(`Admin claims updated for user ${uid}:`, {
            adminStatus: isAdmin,
            updatedBy: request.auth.uid,
            updatedByEmail: request.auth.token.email,
        });

        return {
            success: true,
            message: `Admin-Status für Benutzer ${uid} wurde auf ${isAdmin} gesetzt`,
            claims: newClaims,
        };
    } catch (error) {
        logger.error('Error setting admin claims:', error);

        if (error instanceof HttpsError) {
            throw error;
        }

        throw new HttpsError('internal', 'Fehler beim Setzen der Admin-Claims');
    }
});

/**
 * Set specific role for a user
 */
exports.setUserRole = onCall(async (request) => {
    try {
        await requireAdmin(request);

        const { uid, role } = request.data;
        validateUid(uid);

        const validRoles = ['admin', 'moderator', 'editor', 'user'];
        if (!validRoles.includes(role)) {
            throw new HttpsError('invalid-argument', `Ungültige Rolle: ${role}`);
        }

        const userRecord = await admin.auth().getUser(uid);
        const currentClaims = userRecord.customClaims || {};

        const newClaims = {
            ...currentClaims,
            role: role,
            admin: role === 'admin',
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        await admin.auth().setCustomUserClaims(uid, newClaims);

        logger.info(`Role updated for user ${uid}:`, {
            newRole: role,
            updatedBy: request.auth.uid,
        });

        return {
            success: true,
            message: `Rolle für Benutzer ${uid} wurde auf ${role} gesetzt`,
            claims: newClaims,
        };
    } catch (error) {
        logger.error('Error setting user role:', error);

        if (error instanceof HttpsError) {
            throw error;
        }

        throw new HttpsError('internal', 'Fehler beim Setzen der Benutzerrolle');
    }
});

/**
 * Set permissions for a user
 */
exports.setUserPermissions = onCall(async (request) => {
    try {
        await requireAdmin(request);

        const { uid, permissions } = request.data;
        validateUid(uid);

        if (!Array.isArray(permissions)) {
            throw new HttpsError('invalid-argument', 'Permissions müssen ein Array sein');
        }

        const validPermissions = [
            'create_victim',
            'update_victim',
            'delete_victim',
            'create_camp',
            'update_camp',
            'delete_camp',
            'create_commander',
            'update_commander',
            'delete_commander',
            'view_admin_dashboard',
            'manage_users',
            'export_data',
            'import_data',
        ];

        const invalidPermissions = permissions.filter(p => !validPermissions.includes(p));
        if (invalidPermissions.length > 0) {
            throw new HttpsError('invalid-argument',
                `Ungültige Berechtigungen: ${invalidPermissions.join(', ')}`);
        }

        const userRecord = await admin.auth().getUser(uid);
        const currentClaims = userRecord.customClaims || {};

        const newClaims = {
            ...currentClaims,
            permissions: permissions,
            updatedAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        await admin.auth().setCustomUserClaims(uid, newClaims);

        logger.info(`Permissions updated for user ${uid}:`, {
            newPermissions: permissions,
            updatedBy: request.auth.uid,
        });

        return {
            success: true,
            message: `Berechtigungen für Benutzer ${uid} wurden aktualisiert`,
            claims: newClaims,
        };
    } catch (error) {
        logger.error('Error setting user permissions:', error);

        if (error instanceof HttpsError) {
            throw error;
        }

        throw new HttpsError('internal', 'Fehler beim Setzen der Benutzerberechtigungen');
    }
});

/**
 * Get user claims (admin only)
 */
exports.getUserClaims = onCall(async (request) => {
    try {
        await requireAdmin(request);

        const { uid } = request.data;
        validateUid(uid);

        const userRecord = await admin.auth().getUser(uid);

        return {
            success: true,
            claims: userRecord.customClaims || {},
            email: userRecord.email,
            emailVerified: userRecord.emailVerified,
            disabled: userRecord.disabled,
        };
    } catch (error) {
        logger.error('Error getting user claims:', error);

        if (error instanceof HttpsError) {
            throw error;
        }

        throw new HttpsError('internal', 'Fehler beim Abrufen der Benutzer-Claims');
    }
});

/**
 * List all users with their claims (admin only, paginated)
 */
exports.listUsersWithClaims = onCall(async (request) => {
    try {
        await requireAdmin(request);

        const { pageToken, maxResults = 50 } = request.data;

        if (maxResults > 100) {
            throw new HttpsError('invalid-argument', 'maxResults darf nicht größer als 100 sein');
        }

        const listUsersResult = await admin.auth().listUsers(maxResults, pageToken);

        const users = listUsersResult.users.map(userRecord => ({
            uid: userRecord.uid,
            email: userRecord.email,
            displayName: userRecord.displayName,
            emailVerified: userRecord.emailVerified,
            disabled: userRecord.disabled,
            customClaims: userRecord.customClaims || {},
            creationTime: userRecord.metadata.creationTime,
            lastSignInTime: userRecord.metadata.lastSignInTime,
        }));

        return {
            success: true,
            users: users,
            pageToken: listUsersResult.pageToken,
        };
    } catch (error) {
        logger.error('Error listing users:', error);

        if (error instanceof HttpsError) {
            throw error;
        }

        throw new HttpsError('internal', 'Fehler beim Abrufen der Benutzerliste');
    }
});

/**
 * Initialize admin user (one-time setup)
 * This function should be called manually or via a secure endpoint
 */
exports.initializeAdmin = onCall(async (request) => {
    try {
        // Security check - only allow this if no admin exists yet
        const listResult = await admin.auth().listUsers(100);
        const hasAdmin = listResult.users.some(user =>
            user.customClaims?.admin === true || user.customClaims?.role === 'admin'
        );

        if (hasAdmin) {
            throw new HttpsError('already-exists', 'Admin-Benutzer existiert bereits');
        }

        const { email } = request.data;
        if (!email) {
            throw new HttpsError('invalid-argument', 'E-Mail-Adresse ist erforderlich');
        }

        // Find user by email
        let userRecord;
        try {
            userRecord = await admin.auth().getUserByEmail(email);
        } catch (error) {
            throw new HttpsError('not-found', `Benutzer mit E-Mail ${email} nicht gefunden`);
        }

        // Set admin claims
        const adminClaims = {
            admin: true,
            role: 'admin',
            permissions: [
                'create_victim',
                'update_victim',
                'delete_victim',
                'create_camp',
                'update_camp',
                'delete_camp',
                'create_commander',
                'update_commander',
                'delete_commander',
                'view_admin_dashboard',
                'manage_users',
                'export_data',
                'import_data',
            ],
            createdAt: admin.firestore.FieldValue.serverTimestamp(),
        };

        await admin.auth().setCustomUserClaims(userRecord.uid, adminClaims);

        logger.info(`Initial admin user created:`, {
            uid: userRecord.uid,
            email: userRecord.email,
        });

        return {
            success: true,
            message: `Admin-Benutzer ${email} wurde erfolgreich initialisiert`,
        };
    } catch (error) {
        logger.error('Error initializing admin:', error);

        if (error instanceof HttpsError) {
            throw error;
        }

        throw new HttpsError('internal', 'Fehler beim Initialisieren des Admin-Benutzers');
    }
});

// ========== AUTOMATIC TRIGGERS ==========

/**
 * Automatically set default claims for new users
 */
exports.setDefaultClaimsOnUserCreate = onDocumentCreated(
    'users/{userId}',
    async (event) => {
        try {
            const userId = event.params.userId;

            // Set default user claims
            const defaultClaims = {
                role: 'user',
                admin: false,
                permissions: [],
                createdAt: admin.firestore.FieldValue.serverTimestamp(),
            };

            await admin.auth().setCustomUserClaims(userId, defaultClaims);

            logger.info(`Default claims set for new user: ${userId}`);
        } catch (error) {
            logger.error(`Error setting default claims for user ${event.params.userId}:`, error);
        }
    }
);

/**
 * Utility function to refresh a user's token
 * Forces the client to get a new token with updated claims
 */
exports.refreshUserToken = onCall(async (request) => {
    try {
        if (!request.auth) {
            throw new HttpsError('unauthenticated', 'Benutzer muss angemeldet sein');
        }

        // This will force the client to refresh their token
        // The actual token refresh happens on the client side
        return {
            success: true,
            message: 'Token-Refresh angefordert',
            timestamp: Date.now(),
        };
    } catch (error) {
        logger.error('Error in refresh token function:', error);
        throw new HttpsError('internal', 'Fehler beim Token-Refresh');
    }
});