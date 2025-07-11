import 'package:flutter/foundation.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtual_event_app/features/events/models/event_model.dart';
import 'package:virtual_event_app/features/events/services/event_service.dart';

class EventProvider with ChangeNotifier {
  final EventService _eventService;
  List<EventModel> _events = [];
  bool _isLoading = false;

  EventProvider(this._eventService);

  List<EventModel> get events => _events;
  bool get isLoading => _isLoading;

  Future<void> fetchEvents() async {
    _isLoading = true;
    notifyListeners();
    try {
      _events = await _eventService.getEvents();
    } catch (e) {
      // Handle error appropriately
      if (kDebugMode) {
        print(e);
      }
    }
    _isLoading = false;
    notifyListeners();
  }

  List<EventModel> getEventsForDay(DateTime day) {
    return _events.where((event) => isSameDay(event.dateTime, day)).toList();
  }
}
