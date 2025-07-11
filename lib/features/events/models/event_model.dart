// REPLACE THE ENTIRE CONTENT OF THIS FILE

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class EventModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dateTime;
  final String bannerUrl;
  final bool isLive;

  const EventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    required this.bannerUrl,
    this.isLive = false,
  });

  // This is the method that was missing or incorrect
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'dateTime': Timestamp.fromDate(dateTime),
      'bannerUrl': bannerUrl,
      'isLive': isLive,
    };
  }

  factory EventModel.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map<String, dynamic>;
    return EventModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dateTime: (data['dateTime'] as Timestamp).toDate(),
      bannerUrl: data['bannerUrl'] ?? 'https://via.placeholder.com/400x200',
      isLive: data['isLive'] ?? false,
    );
  }

  @override
  List<Object?> get props =>
      [id, title, description, dateTime, bannerUrl, isLive];
}
