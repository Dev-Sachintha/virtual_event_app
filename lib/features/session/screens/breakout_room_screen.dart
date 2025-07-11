import 'package:flutter/material.dart';

class BreakoutRoomScreen extends StatelessWidget {
  final String roomId;
  const BreakoutRoomScreen({super.key, required this.roomId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Breakout Room: $roomId'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.group, size: 100, color: Colors.grey),
              const SizedBox(height: 20),
              Text(
                'Breakout Room Integration',
                style: Theme.of(context).textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              const Text(
                'This is where a group chat or smaller video meeting interface (using the VideoService) would be displayed.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
