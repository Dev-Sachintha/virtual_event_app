class FirestoreCollections {
  // This class is not meant to be instantiated.
  // We use a private constructor to prevent it.
  FirestoreCollections._();

  /// Collection name for user profiles.
  static const String users = 'users';

  /// Collection name for event details.
  static const String events = 'events';

  /// Sub-collection for users registered for a specific event.
  /// Stored under: /events/{eventId}/registrations/{userId}
  static const String registrations = 'registrations';
}
