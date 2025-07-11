import 'package:flutter/material.dart';

class ManageAttendeesScreen extends StatelessWidget {
  final String eventId;
  const ManageAttendeesScreen({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    // In a real app, you would fetch the list of registered users for this eventId
    // from a subcollection like 'events/{eventId}/registrations'
    final attendees = [
      'attendee1@example.com',
      'attendee2@example.com',
      'attendee3@example.com',
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Attendees for Event $eventId'),
      ),
      body: ListView.builder(
        itemCount: attendees.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(attendees[index]),
            trailing: IconButton(
              icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
              onPressed: () {
                // Logic to remove attendee
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Remove user ${attendees[index]}')),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
