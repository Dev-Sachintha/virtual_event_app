// lib/main.dart

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_app/app.dart';
import 'package:virtual_event_app/core/providers/auth_provider.dart';
// THIS IS THE FIX: Changed 'package.' to 'package:'
import 'package:virtual_event_app/core/services/auth_service.dart';
import 'package:virtual_event_app/features/events/providers/event_provider.dart';
import 'package:virtual_event_app/features/events/services/event_service.dart';
import 'firebase_options.dart';

void main() async {
  // Ensure Flutter engine bindings are initialized.
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase. This must complete before any Firebase services are used.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Run the main application widget.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider is the perfect place to create and provide objects
    // to the entire widget tree.
    return MultiProvider(
      providers: [
        // --- SERVICES (Singletons that don't change) ---
        // We provide instances of our services that can be read by providers.
        Provider<AuthService>(create: (_) => AuthService()),
        Provider<EventService>(create: (_) => EventService()),

        // --- VIEW MODELS / PROVIDERS (That depend on services) ---
        // ChangeNotifierProvider creates and listens to AuthProvider.
        // It reads AuthService from the context to pass to the constructor.
        // This ensures AuthProvider is created at the right time in the widget tree.
        ChangeNotifierProvider<AuthProvider>(
          create: (context) => AuthProvider(context.read<AuthService>()),
        ),

        // EventProvider is created similarly, depending on EventService.
        ChangeNotifierProvider<EventProvider>(
          create: (context) => EventProvider(context.read<EventService>()),
        ),
      ],
      // The App widget now has access to all the providers defined above.
      child: const App(),
    );
  }
}
