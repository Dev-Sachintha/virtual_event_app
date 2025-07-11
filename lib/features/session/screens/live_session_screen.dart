import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LiveSessionScreen extends StatelessWidget {
  final String sessionId;
  const LiveSessionScreen({super.key, required this.sessionId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Session: $sessionId'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.videocam, size: 100, color: Colors.grey),
            const SizedBox(height: 20),
            const Text(
              'Video SDK (Agora/Jitsi/Zoom) would be integrated here.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Logic to show breakout rooms
              },
              child: const Text('View Breakout Rooms'),
            ),
            ElevatedButton(
              onPressed: () => context.pop(),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Leave Session'),
            ),
          ],
        ),
      ),
    );
  }
}
