import 'package:equatable/equatable.dart';

class UserModel extends Equatable {
  final String uid;
  final String email;
  final String name;
  final String role; // 'attendee' or 'admin'

  const UserModel({
    required this.uid,
    required this.email,
    required this.name,
    this.role = 'attendee',
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      uid: documentId,
      email: data['email'] ?? '',
      name: data['name'] ?? '',
      role: data['role'] ?? 'attendee',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'name': name,
      'role': role,
    };
  }

  @override
  List<Object?> get props => [uid, email, name, role];
}
