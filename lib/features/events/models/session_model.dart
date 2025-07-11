import 'package:equatable/equatable.dart';

class SessionModel extends Equatable {
  final String id;
  final String eventId;
  final String title;
  final String description;
  final bool isBreakoutRoom;

  const SessionModel({
    required this.id,
    required this.eventId,
    required this.title,
    required this.description,
    this.isBreakoutRoom = false,
  });

  @override
  List<Object?> get props => [id, eventId, title, description, isBreakoutRoom];
}
