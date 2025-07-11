// REPLACE THE ENTIRE CONTENT OF THIS FILE

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_app/core/config/app_strings.dart';
import 'package:virtual_event_app/core/widgets/loading_indicator.dart';
import 'package:virtual_event_app/features/events/models/event_model.dart';
import 'package:virtual_event_app/features/events/providers/event_provider.dart';
import 'package:virtual_event_app/utils/date_formatter.dart';

class EventDetailScreen extends StatelessWidget {
  final String eventId;
  const EventDetailScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final eventProvider = context.watch<EventProvider>();

    EventModel? event;
    try {
      event = eventProvider.events.firstWhere((e) => e.id == eventId);
    } catch (e) {
      event = null;
    }

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text(AppStrings.eventDetails)),
        body: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              LoadingIndicator(),
              SizedBox(height: 16),
              Text("Event not found or still loading..."),
            ],
          ),
        ),
      );
    }

    // THIS IS THE FIX: Create a new non-nullable variable.
    // Because of the `if (event == null)` check above, Dart knows `event`
    // is not null here, so `finalEvent` is promoted to a non-nullable type.
    final finalEvent = event;

    return Scaffold(
      appBar: AppBar(title: Text(finalEvent.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              finalEvent.bannerUrl,
              width: double.infinity,
              height: 200,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    finalEvent.title,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(DateFormatter.formatEventDate(finalEvent.dateTime)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(Icons.access_time,
                          size: 16, color: Colors.grey),
                      const SizedBox(width: 8),
                      Text(DateFormatter.formatEventTime(finalEvent.dateTime)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (finalEvent.isLive)
                    const Chip(
                      label: Text(AppStrings.sessionIsLive),
                      backgroundColor: Colors.red,
                      labelStyle: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  const SizedBox(height: 24),
                  const Text(
                    AppStrings.aboutThisEvent,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(finalEvent.description),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: finalEvent.isLive
          ? Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                // Now we use the safe, non-nullable `finalEvent`. This is 100% safe.
                onPressed: () => context.go('/event/${finalEvent.id}/live'),
                child: const Text(AppStrings.joinLiveSession),
              ),
            )
          : null,
    );
  }
}
