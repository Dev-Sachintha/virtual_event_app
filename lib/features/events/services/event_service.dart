import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:virtual_event_app/core/constants/firestore_collections.dart';
import 'package:virtual_event_app/features/events/models/event_model.dart';

class EventService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch all events
  Future<List<EventModel>> getEvents() async {
    try {
      final snapshot =
          await _firestore.collection(FirestoreCollections.events).get();
      return snapshot.docs.map((doc) => EventModel.fromFirestore(doc)).toList();
    } catch (e) {
      // In a real app, use a proper logging service
      print('Error fetching events: $e');
      rethrow;
    }
  }

  // Fetch a single event by its ID
  Future<EventModel> getEventById(String eventId) async {
    try {
      final doc = await _firestore
          .collection(FirestoreCollections.events)
          .doc(eventId)
          .get();
      return EventModel.fromFirestore(doc);
    } catch (e) {
      print('Error fetching event by ID: $e');
      rethrow;
    }
  }

  // Create a new event
  Future<void> createEvent(EventModel event) async {
    try {
      await _firestore
          .collection(FirestoreCollections.events)
          .add(event.toMap());
    } catch (e) {
      print('Error creating event: $e');
      rethrow;
    }
  }
}
