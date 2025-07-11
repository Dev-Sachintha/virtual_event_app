// lib/core/services/auth_service.dart

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_event_app/core/constants/firestore_collections.dart';
import 'package:virtual_event_app/core/models/user_model.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<UserModel?> get authStateChanges {
    return _firebaseAuth.authStateChanges().asyncMap((firebaseUser) async {
      if (firebaseUser == null) return null;
      try {
        final userDoc = await _firestore
            .collection(FirestoreCollections.users)
            .doc(firebaseUser.uid)
            .get();

        if (userDoc.exists) {
          return UserModel.fromMap(userDoc.data()!, firebaseUser.uid);
        } else {
          return UserModel(
            uid: firebaseUser.uid,
            email: firebaseUser.email ?? '',
            name: 'New User',
            role: 'attendee',
          );
        }
      } catch (e) {
        print('Error fetching user document: $e');
        return null;
      }
    });
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // NEW: Method to handle user registration
  Future<void> signUpWithEmailAndPassword(
      String name, String email, String password) async {
    // First, create the user in Firebase Authentication
    UserCredential userCredential = await _firebaseAuth
        .createUserWithEmailAndPassword(email: email, password: password);

    // Then, create a UserModel with the provided details
    final newUser = UserModel(
      uid: userCredential.user!.uid,
      email: email,
      name: name,
      role: 'attendee', // Default role for new users
    );

    // Finally, save the new user's data to Firestore
    await _firestore
        .collection(FirestoreCollections.users)
        .doc(newUser.uid)
        .set(newUser.toMap());
  }

  // NEW: Method to send a password reset email
  Future<void> sendPasswordResetEmail(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
