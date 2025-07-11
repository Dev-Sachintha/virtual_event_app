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

  UserModel? get user => _user;
  AuthStatus get status => _status;
  bool get isLoggedIn => _status == AuthStatus.authenticated;

  void _onAuthStateChanged(UserModel? user) {
    _user = user;
    _status =
        user == null ? AuthStatus.unauthenticated : AuthStatus.authenticated;
    notifyListeners();
  }

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

  // NEW: Method to handle sign-up
  Future<String?> signUp(String name, String email, String password) async {
    try {
      await _authService.signUpWithEmailAndPassword(name, email, password);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An sign-up error occurred.";
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  // NEW: Method to handle password reset
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await _authService.sendPasswordResetEmail(email);
      return null;
    } on FirebaseAuthException catch (e) {
      return e.message ?? "An error occurred.";
    } catch (e) {
      return "An unexpected error occurred.";
    }
  }

  Future<void> logout() async {
    await _authService.signOut();
  }
}
