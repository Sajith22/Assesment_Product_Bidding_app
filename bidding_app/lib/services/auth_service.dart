// ─────────────────────────────────────────────────────────────────────────────
// services/auth_service.dart
// Firebase Auth wrapper — used by BOTH admin and user login screens.
// ─────────────────────────────────────────────────────────────────────────────
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/app_models.dart';

class AuthService {
  final _auth = FirebaseAuth.instance;
  final _db   = FirebaseFirestore.instance;

  // ── Current user stream ───────────────────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();
  User? get currentUser => _auth.currentUser;

  // ── Fetch AppUser profile from Firestore ──────────────────────────────────
  Future<AppUser?> getAppUser(String uid) async {
    try {
      final doc = await _db.collection('users').doc(uid).get();
      if (!doc.exists) return null;
      return AppUser.fromMap(doc.data()!, doc.id);
    } catch (e) {
      return null;
    }
  }

  // ── User Registration ─────────────────────────────────────────────────────
  Future<AuthResult> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = AppUser(
        uid: credential.user!.uid,
        name: name.trim(),
        email: email.trim(),
        role: UserRole.user,       // all self-registrations are users
        createdAt: DateTime.now(),
      );

      await _db.collection('users').doc(user.uid).set(user.toMap());

      return AuthResult.success(user);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_authErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred.');
    }
  }

  // ── Login (admin or user — role checked after login) ─────────────────────
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final appUser = await getAppUser(credential.user!.uid);
      if (appUser == null) {
        await _auth.signOut();
        return AuthResult.failure('Account not found. Please register first.');
      }

      return AuthResult.success(appUser);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_authErrorMessage(e.code));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred.');
    }
  }

  // ── Admin Login — extra role check ────────────────────────────────────────
  Future<AuthResult> loginAdmin({
    required String email,
    required String password,
  }) async {
    final result = await login(email: email, password: password);
    if (!result.isSuccess) return result;

    if (result.user!.role != UserRole.admin) {
      await _auth.signOut();
      return AuthResult.failure('This account does not have admin access.');
    }
    return result;
  }

  // ── Update FCM token ──────────────────────────────────────────────────────
  Future<void> updateFcmToken(String uid, String token) async {
    await _db.collection('users').doc(uid).update({'fcmToken': token});
  }

  // ── Sign Out ──────────────────────────────────────────────────────────────
  Future<void> signOut() => _auth.signOut();

  // ── Friendly error messages ───────────────────────────────────────────────
  String _authErrorMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password is too weak. Use at least 8 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'too-many-requests':
        return 'Too many failed attempts. Try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication failed. Please try again.';
    }
  }
}

// ── Result wrapper ────────────────────────────────────────────────────────────
class AuthResult {
  final bool isSuccess;
  final AppUser? user;
  final String? errorMessage;

  const AuthResult._({required this.isSuccess, this.user, this.errorMessage});

  factory AuthResult.success(AppUser user) =>
      AuthResult._(isSuccess: true, user: user);

  factory AuthResult.failure(String message) =>
      AuthResult._(isSuccess: false, errorMessage: message);
}
