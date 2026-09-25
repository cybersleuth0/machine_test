import 'package:firebase_auth/firebase_auth.dart';
import '../../core/services/firebase_auth_service.dart';

class AuthRepository {
  final FirebaseAuthService firebaseAuthService;

  AuthRepository({required this.firebaseAuthService});

  Future<User?> login({required String email, required String password}) async {
    try {
      final userCredential = await firebaseAuthService.signIn(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<User?> signUp(String email, String password) async {
    try {
      final userCredential = await firebaseAuthService.signUp(email: email, password: password);
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'An unexpected error occurred. Please try again.';
    }
  }

  Future<void> signOut() async {
    try {
      await firebaseAuthService.signOut();
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw 'Failed to sign out. Please try again.';
    }
  }

  Future<bool> isSignedIn() async {
    try {
      return await firebaseAuthService.isSignedIn();
    } catch (e) {
      return false;
    }
  }

  User? getUser() {
    return firebaseAuthService.currentUser;
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No user found for that email address.';
      case 'wrong-password':
      case 'invalid-credential':
        return 'Incorrect email or password.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'weak-password':
        return 'The password is too weak. Please use at least 6 characters.';
      case 'invalid-email':
        return 'The email address is invalid.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'network-request-failed':
        return 'Network connection error. Please check your internet.';
      default:
        return e.message ?? 'Authentication failed. Please try again.';
    }
  }
}
