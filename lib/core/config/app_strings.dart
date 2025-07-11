/// A utility class that holds all the static strings used in the app.
///
/// This helps in maintaining consistency and makes internationalization (translation) easier.
class AppStrings {
  // Private constructor to prevent instantiation.
  AppStrings._();

  // --- General ---
  static const String appName = 'Virtual Event Hub';
  static const String pleaseWait = 'Please wait...';
  static const String success = 'Success';
  static const String error = 'Error';

  // --- Authentication ---
  static const String login = 'Login';
  static const String logout = 'Logout';
  static const String email = 'Email';
  static const String password = 'Password';
  static const String loginSuccess = 'Login Successful!';
  static const String loginFailed =
      'Login Failed. Please check your credentials.';

  // --- Events ---
  static const String events = 'Events';
  static const String eventCalendar = 'Event Calendar';
  static const String eventDetails = 'Event Details';
  static const String noEventsToday = 'No events scheduled for this day.';
  static const String aboutThisEvent = 'About this Event';
  static const String joinLiveSession = 'Join Live Session';
  static const String sessionIsLive = 'SESSION IS LIVE';
  static const String upcoming = 'UPCOMING';

  // --- Admin ---
  static const String adminPanel = 'Admin Panel';
  static const String createEvent = 'Create Event';
  static const String saveEvent = 'Save Event';
  static const String eventTitle = 'Event Title';
  static const String eventDescription = 'Event Description';
  static const String eventDateAndTime = 'Event Date & Time';
  static const String selectDate = 'Select Date';
  static const String notSelected = 'Not selected';
  static const String eventCreatedSuccess = 'Event created successfully!';
  static const String eventCreatedError = 'Failed to create event';
  static const String pleaseSelectDate = 'Please select a date and time';

  // --- Validation Messages ---
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email address';
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least 6 characters';
  static const String fieldRequired = 'This field is required';
}
