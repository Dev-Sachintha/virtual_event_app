// lib/core/providers/auth_provider.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:virtual_event_app/core/models/user_model.dart';
import 'package:virtual_event_app/core/services/auth_service.dart';

enum AuthStatus { unknown, authenticated, unauthenticated }

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  UserModel? _user;
  AuthStatus _status = AuthStatus.unknown;

  AuthProvider(this._authService) {
    _authService.authStateChanges.listen(_onAuthStateChanged);
  }

  // --- Public Getters ---
  UserModel? get user => _user;
  AuthStatus get status => _status;
  bool get isLoggedIn => _status == AuthStatus.authenticated;

  // --- Core State Management ---
  void _onAuthStateChanged(UserModel? user) {
    _user = user;
    _status =
        user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }

  // --- Authentication Methods ---

  Future<String?> login(String email, String password) async {
    try {
      await _authService.signInWithEmailAndPassword(email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An authentication error occurred.";
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  Future<String?> signInWithGoogle() async {
    try {
      await _authService.signInWithGoogle();
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'USER_CANCELLED') {
        return 'Sign-in cancelled.';
      }
      return e.message ?? "An authentication error occurred.";
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  Future<String?> signUp(String name, String email, String password) async {
    try {
      await _authService.signUpWithEmailAndPassword(name, email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "A sign-up error occurred.";
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred sending the reset email.";
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  // --- NEW: 2FA Wrapper Methods ---

  /// Generates a new Base32 secret key for setting up 2FA.
  String generate2FASecret() {
    return _authService.generate2FASecret();
  }

  /// Verifies the initial TOTP code and saves the secret to the user's profile.
  Future<bool> verifyAndEnable2FA(String secret, String code) async {
    final success = await _authService.verifyAndEnable2FA(secret, code);
    if (success) {
      // Manually trigger a refresh of the user data to get the new 'otpSecret' field
      final userModel = await _authService.authStateChanges.first;
      _onAuthStateChanged(userModel);
    }
    return success;
  }

  /// Handles the second step of logging in for a 2FA-enabled user.
  Future<String?> verify2FALogin(
      String email, String password, String code) async {
    try {
      // Step 1: Sign in silently to create a user session.
      await _authService.signInWithEmailAndPassword(email, password);

      // Step 2: With a valid session, verify the TOTP code against the user's secret.
      final isValid = await _authService.verify2FACodeForCurrentUser(code);

      if (isValid) {
        return null; // Success! The router will handle the redirect.
      } else {
        // If code is wrong, sign the user out immediately to prevent unauthorized access.
        await _authService.signOut();
        return 'Invalid 2FA code. Please try again.';
      }
    } on FirebaseAuthException catch (e) {
      // This will catch wrong password errors
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred.';
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
