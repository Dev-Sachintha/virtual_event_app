// lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart'; // Import for kDebugMode
import 'package:google_sign_in/google_sign_in.dart';
import 'package:otp/otp.dart';
import 'package:virtual_event_app/core/constants/firestore_collections.dart';
import 'package:virtual_event_app/core/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ... (No changes needed in authStateChanges or other methods above 2FA) ...
  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        final userDocRef = _firestore
            .collection(FirestoreCollections.users)
            .doc(firebaseUser.uid);
        final userDoc = await userDocRef.get();
        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data()!, firebaseUser.uid);
        } else {
          final defaultUser = UserModel(
              uid: firebaseUser.uid,
              email: firebaseUser.email ?? 'no-email@provided.com',
              name: firebaseUser.displayName ?? 'New User',
              role: 'attendee');
          await userDocRef.set(defaultUser.toMap());
          return defaultUser;
        }
      } catch (e) {
        if (kDebugMode) {
          print('FATAL ERROR fetching user document: $e');
        }
        return null;
      }
    });
  }

  // --- 2FA Methods ---

  String generate2FASecret() {
    return OTP.randomSecret();
  }

  // --- DEBUG-READY VERSION of the verification logic ---
  Future<bool> _isValidCode(String secret, String userProvidedCode) {
    final int time = DateTime.now().millisecondsSinceEpoch;
    bool isValid = false;

    if (kDebugMode) {
      print("--- 2FA Code Verification ---");
      print("User Provided Code: $userProvidedCode");
      print("Secret Key Used: $secret");
      print("Current Time (ms): $time");
      print("-----------------------------");
    }

    // Check against the current, previous, and next 30-second time windows.
    for (var i = -1; i <= 1; i++) {
      final int interval = i * 30000;
      final int adjustedTime = time + interval;

      final String expectedCode = OTP.generateTOTPCodeString(
        secret,
        adjustedTime,
        algorithm: Algorithm.SHA1,
        isGoogle: true,
      );

      if (kDebugMode) {
        final window = i == -1 ? 'Previous' : (i == 0 ? 'Current' : 'Next');
        print("Checking [${window}] window... Expected Code: $expectedCode");
      }

      if (expectedCode == userProvidedCode) {
        isValid = true;
        if (kDebugMode) {
          print("✅ MATCH FOUND!");
        }
        break;
      }
    }

    if (kDebugMode && !isValid) {
      print("❌ NO MATCH FOUND IN ANY TIME WINDOW.");
    }
    if (kDebugMode) {
      print("-----------------------------\n");
    }

    return Future.value(isValid);
  }

  /// Verifies the initial TOTP code and saves the secret to the user's profile.
  Future<bool> verifyAndEnable2FA(
      String secret, String userProvidedCode) async {
    final bool isValid = await _isValidCode(secret, userProvidedCode);
    if (!isValid) {
      return false;
    }
    final userId = _firebaseAuth.currentUser!.uid;
    return _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .update({'otpSecret': secret})
        .then((_) => true)
        .catchError((_) => false);
  }

  /// Verifies the TOTP code for a user who is trying to log in.
  Future<bool> verify2FACodeForCurrentUser(String userProvidedCode) async {
    final userId = _firebaseAuth.currentUser!.uid;
    final userDoc = await _firestore
        .collection(FirestoreCollections.users)
        .doc(userId)
        .get();
    final user = UserModel.fromMap(userDoc.data()!, userId);
    if (!user.is2faEnabled || user.otpSecret == null) {
      return false;
    }
    return _isValidCode(user.otpSecret!, userProvidedCode);
  }

  // ... (The rest of the file remains the same) ...
  Future<bool> is2FAEnabledForUser(String email) async {
    try {
      final querySnapshot = await _firestore
          .collection(FirestoreCollections.users)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      if (querySnapshot.docs.isEmpty) return false;
      final user = UserModel.fromMap(
          querySnapshot.docs.first.data(), querySnapshot.docs.first.id);
      return user.is2faEnabled;
    } catch (e) {
      return false;
    }
  }

  Future<void> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) throw FirebaseAuthException(code: 'USER_CANCELLED');
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);
    await _firebaseAuth.signInWithCredential(credential);
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);
    if (userCredential.user != null) {
      final newUser =
          UserModel(uid: userCredential.user!.uid, email: email, name: name);
      await _firestore
          .collection(FirestoreCollections.users)
          .doc(userCredential.user!.uid)
          .set(newUser.toMap());
    }
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _firebaseAuth.signOut();
  }
}
