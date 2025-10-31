import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';

/// Service für die Verwaltung von Admin-Rollen und Berechtigungen
class AdminManagementService {
  final FirebaseFunctions _functions = FirebaseFunctions.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // ========== ADMIN ROLE MANAGEMENT ==========

  /// Set admin status for a user
  Future<void> setUserAdmin(String uid, bool isAdmin) async {
    try {
      final callable = _functions.httpsCallable('setAdminClaims');
      final result = await callable.call({'uid': uid, 'admin': isAdmin});

      if (result.data['success'] != true) {
        throw Exception(result.data['message'] ?? 'Unbekannter Fehler');
      }
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw Exception('Fehler beim Setzen der Admin-Rolle: $e');
    }
  }

  /// Set specific role for a user
  Future<void> setUserRole(String uid, String role) async {
    try {
      final callable = _functions.httpsCallable('setUserRole');
      final result = await callable.call({'uid': uid, 'role': role});

      if (result.data['success'] != true) {
        throw Exception(result.data['message'] ?? 'Unbekannter Fehler');
      }
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw Exception('Fehler beim Setzen der Benutzerrolle: $e');
    }
  }

  /// Set permissions for a user
  Future<void> setUserPermissions(String uid, List<String> permissions) async {
    try {
      final callable = _functions.httpsCallable('setUserPermissions');
      final result = await callable.call({
        'uid': uid,
        'permissions': permissions,
      });

      if (result.data['success'] != true) {
        throw Exception(result.data['message'] ?? 'Unbekannter Fehler');
      }
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw Exception('Fehler beim Setzen der Benutzerberechtigungen: $e');
    }
  }

  // ========== USER INFORMATION ==========

  /// Get user claims and information
  Future<UserManagementInfo> getUserInfo(String uid) async {
    try {
      final callable = _functions.httpsCallable('getUserClaims');
      final result = await callable.call({'uid': uid});

      if (result.data['success'] != true) {
        throw Exception(result.data['message'] ?? 'Unbekannter Fehler');
      }

      return UserManagementInfo.fromJson(result.data);
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw Exception('Fehler beim Abrufen der Benutzerinformationen: $e');
    }
  }

  /// List all users with their claims (paginated)
  Future<UserListResult> listUsers({
    String? pageToken,
    int maxResults = 50,
  }) async {
    try {
      final callable = _functions.httpsCallable('listUsersWithClaims');
      final result = await callable.call({
        'pageToken': pageToken,
        'maxResults': maxResults,
      });

      if (result.data['success'] != true) {
        throw Exception(result.data['message'] ?? 'Unbekannter Fehler');
      }

      return UserListResult.fromJson(result.data);
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw Exception('Fehler beim Abrufen der Benutzerliste: $e');
    }
  }

  // ========== INITIALIZATION ==========

  /// Initialize the first admin user (one-time setup)
  Future<void> initializeAdmin(String email) async {
    try {
      final callable = _functions.httpsCallable('initializeAdmin');
      final result = await callable.call({'email': email});

      if (result.data['success'] != true) {
        throw Exception(result.data['message'] ?? 'Unbekannter Fehler');
      }
    } on FirebaseFunctionsException catch (e) {
      throw _handleFunctionsException(e);
    } catch (e) {
      throw Exception('Fehler beim Initialisieren des Admin-Benutzers: $e');
    }
  }

  // ========== UTILITY METHODS ==========

  /// Get available roles
  List<String> getAvailableRoles() {
    return ['admin', 'moderator', 'editor', 'user'];
  }

  /// Get available permissions
  List<String> getAvailablePermissions() {
    return [
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
  }

  /// Get permission descriptions
  Map<String, String> getPermissionDescriptions() {
    return {
      'create_victim': 'Opfer erstellen',
      'update_victim': 'Opfer bearbeiten',
      'delete_victim': 'Opfer löschen',
      'create_camp': 'Lager erstellen',
      'update_camp': 'Lager bearbeiten',
      'delete_camp': 'Lager löschen',
      'create_commander': 'Kommandant erstellen',
      'update_commander': 'Kommandant bearbeiten',
      'delete_commander': 'Kommandant löschen',
      'view_admin_dashboard': 'Admin-Dashboard anzeigen',
      'manage_users': 'Benutzer verwalten',
      'export_data': 'Daten exportieren',
      'import_data': 'Daten importieren',
    };
  }

  /// Get role descriptions
  Map<String, String> getRoleDescriptions() {
    return {
      'admin': 'Administrator - Vollzugriff auf alle Funktionen',
      'moderator': 'Moderator - Kann Inhalte moderieren und bearbeiten',
      'editor': 'Editor - Kann Inhalte erstellen und bearbeiten',
      'user': 'Benutzer - Grundlegende Lese- und Schreibberechtigungen',
    };
  }

  // ========== ERROR HANDLING ==========

  String _handleFunctionsException(FirebaseFunctionsException e) {
    switch (e.code) {
      case 'unauthenticated':
        return 'Sie müssen angemeldet sein, um diese Aktion durchzuführen.';
      case 'permission-denied':
        return 'Sie haben keine Berechtigung für diese Aktion.';
      case 'invalid-argument':
        return 'Ungültige Parameter: ${e.message}';
      case 'not-found':
        return 'Benutzer nicht gefunden.';
      case 'already-exists':
        return 'Ressource existiert bereits.';
      case 'internal':
        return 'Interner Serverfehler. Versuchen Sie es später erneut.';
      default:
        return e.message ?? 'Ein unbekannter Fehler ist aufgetreten.';
    }
  }

  // ========== AUDIT LOGGING ==========

  /// Log admin actions for audit purposes
  Future<void> _logAdminAction({
    required String action,
    required String targetUserId,
    String? targetUserEmail,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) return;

      await _firestore.collection('audit_logs').add({
        'action': action,
        'performedBy': currentUser.uid,
        'performedByEmail': currentUser.email,
        'targetUserId': targetUserId,
        'targetUserEmail': targetUserEmail,
        'metadata': metadata ?? {},
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Log error but don't throw - audit logging shouldn't break the main flow
      debugPrint('Error logging admin action: $e');
    }
  }
}

// ========== DATA MODELS ==========

/// Information about a user for management purposes
class UserManagementInfo {
  final String uid;
  final String? email;
  final String? displayName;
  final bool emailVerified;
  final bool disabled;
  final Map<String, dynamic> customClaims;
  final DateTime? creationTime;
  final DateTime? lastSignInTime;

  UserManagementInfo({
    required this.uid,
    this.email,
    this.displayName,
    required this.emailVerified,
    required this.disabled,
    required this.customClaims,
    this.creationTime,
    this.lastSignInTime,
  });

  factory UserManagementInfo.fromJson(Map<String, dynamic> json) {
    return UserManagementInfo(
      uid: json['uid'] ?? '',
      email: json['email'],
      displayName: json['displayName'],
      emailVerified: json['emailVerified'] ?? false,
      disabled: json['disabled'] ?? false,
      customClaims: Map<String, dynamic>.from(json['claims'] ?? {}),
      creationTime: json['creationTime'] != null
          ? DateTime.parse(json['creationTime'])
          : null,
      lastSignInTime: json['lastSignInTime'] != null
          ? DateTime.parse(json['lastSignInTime'])
          : null,
    );
  }

  /// Get user role
  String get role => customClaims['role'] ?? 'user';

  /// Check if user is admin
  bool get isAdmin =>
      customClaims['admin'] == true || customClaims['role'] == 'admin';

  /// Get user permissions
  List<String> get permissions {
    final perms = customClaims['permissions'];
    if (perms is List) {
      return perms.cast<String>();
    }
    return [];
  }

  /// Get user roles (multiple roles support)
  List<String> get roles {
    final rolesList = customClaims['roles'];
    if (rolesList is List) {
      return rolesList.cast<String>();
    }

    final singleRole = customClaims['role'];
    if (singleRole is String) {
      return [singleRole];
    }

    return ['user'];
  }
}

/// Result of listing users
class UserListResult {
  final List<UserManagementInfo> users;
  final String? nextPageToken;

  UserListResult({required this.users, this.nextPageToken});

  factory UserListResult.fromJson(Map<String, dynamic> json) {
    final usersList = json['users'] as List<dynamic>? ?? [];
    final users = usersList
        .map(
          (user) =>
              UserManagementInfo.fromJson(Map<String, dynamic>.from(user)),
        )
        .toList();

    return UserListResult(users: users, nextPageToken: json['pageToken']);
  }
}

/// Admin action types for audit logging
enum AdminActionType {
  setAdmin,
  removeAdmin,
  setRole,
  setPermissions,
  createUser,
  deleteUser,
  enableUser,
  disableUser,
}

extension AdminActionTypeExtension on AdminActionType {
  String get value {
    switch (this) {
      case AdminActionType.setAdmin:
        return 'set_admin';
      case AdminActionType.removeAdmin:
        return 'remove_admin';
      case AdminActionType.setRole:
        return 'set_role';
      case AdminActionType.setPermissions:
        return 'set_permissions';
      case AdminActionType.createUser:
        return 'create_user';
      case AdminActionType.deleteUser:
        return 'delete_user';
      case AdminActionType.enableUser:
        return 'enable_user';
      case AdminActionType.disableUser:
        return 'disable_user';
    }
  }
}
