import 'package:flutter/material.dart';
import 'package:virtual_event_app/core/widgets/loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // The routing logic in app.dart handles redirection.
    // This screen just shows a loading indicator until the auth state is known.
    return const Scaffold(
      body: LoadingIndicator(),
    );
  }
}
