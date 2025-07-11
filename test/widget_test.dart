import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_app/app.dart'; // Import app.dart instead of main.dart
import 'package:virtual_event_app/core/providers/auth_provider.dart';
import 'package:virtual_event_app/core/services/auth_service.dart';
import 'package:virtual_event_app/features/events/providers/event_provider.dart';
import 'package:virtual_event_app/features/events/services/event_service.dart';

void main() {
  // This is a more complex test that will build your app's widget tree.
  // Note: This does not test Firebase itself, just the UI.
  testWidgets('App builds and shows splash screen initially',
      (WidgetTester tester) async {
    // Set up all the providers your app needs to run.
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          Provider<AuthService>(create: (_) => AuthService()),
          ChangeNotifierProxyProvider<AuthService, AuthProvider>(
            create: (context) => AuthProvider(context.read<AuthService>()),
            update: (context, authService, authProvider) =>
                AuthProvider(authService),
          ),
          Provider<EventService>(create: (_) => EventService()),
          ChangeNotifierProxyProvider<EventService, EventProvider>(
            create: (context) => EventProvider(context.read<EventService>()),
            update: (context, eventService, eventProvider) =>
                EventProvider(eventService),
          ),
        ],
        child: const App(), // Use the App widget from app.dart
      ),
    );

    // Verify that the splash screen's loading indicator is present.
    // We expect to find a CircularProgressIndicator or similar widget.
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
