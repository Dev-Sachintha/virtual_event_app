import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:virtual_event_app/core/providers/auth_provider.dart';
import 'package:virtual_event_app/features/events/models/event_model.dart';
import 'package:virtual_event_app/features/events/providers/event_provider.dart';

class EventCalendarScreen extends StatefulWidget {
  const EventCalendarScreen({super.key});

  @override
  State<EventCalendarScreen> createState() => _EventCalendarScreenState();
}

class _EventCalendarScreenState extends State<EventCalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    // Fetch events when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<EventProvider>().fetchEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final eventProvider = context.watch<EventProvider>();
    final isAdmin = authProvider.user?.role == 'admin';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Virtual Events'),
        actions: [
          if (isAdmin)
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              onPressed: () => context.go('/admin/create-event'),
              tooltip: 'Create Event',
            ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.read<AuthProvider>().logout(),
          ),
        ],
      ),
      body: Column(
        children: [
          TableCalendar<EventModel>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: (day) {
              return eventProvider.getEventsForDay(day);
            },
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isNotEmpty) {
                  return Positioned(
                    right: 1,
                    bottom: 1,
                    child: Container(
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                      width: 16.0,
                      height: 16.0,
                      child: Center(
                        child: Text(
                          '${events.length}',
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12.0),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: eventProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : _buildEventList(eventProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList(EventProvider eventProvider) {
    final events = eventProvider.getEventsForDay(_selectedDay ?? _focusedDay);
    if (events.isEmpty) {
      return const Center(child: Text("No events for this day."));
    }
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: ListTile(
            title: Text(event.title),
            subtitle: Text(event.description),
            trailing: event.isLive
                ? const Chip(label: Text('LIVE'), backgroundColor: Colors.red)
                : null,
            onTap: () => context.go('/event/${event.id}'),
          ),
        );
      },
    );
  }
}
