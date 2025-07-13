// REPLACE THE ENTIRE FILE WITH THIS CODE
import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String role; // 'attendee' or 'admin'
  final String? otpSecret; // NEW: Store the 2FA secret key, nullable

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.role = 'attendee',
    this.otpSecret, // Nullable field
  });

  // Helper getter to check if 2FA is enabled
  bool get is2faEnabled => otpSecret != null && otpSecret!.isNotEmpty;

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'attendee',
      otpSecret: data['otpSecret'], // Can be null
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
      'otpSecret': otpSecret, // Can be null
    };
  }

  @override
  List<Object?> get props => [uid, email, name, role, otpSecret];
}
