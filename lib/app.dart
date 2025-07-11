// lib/app.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_app/core/config/app_theme.dart';
import 'package:virtual_event_app/core/providers/auth_provider.dart';
import 'package:virtual_event_app/features/auth/screens/forgot_password_screen.dart';
import 'package:virtual_event_app/features/auth/screens/login_screen.dart';
import 'package:virtual_event_app/features/auth/screens/sign_up_screen.dart';
import 'package:virtual_event_app/features/auth/screens/splash_screen.dart';
import 'package:virtual_event_app/features/events/screens/event_calendar_screen.dart';
import 'package:virtual_event_app/features/events/screens/event_detail_screen.dart';
import 'package:virtual_event_app/features/session/screens/live_session_screen.dart';
import 'package:virtual_event_app/features/admin/screens/create_event_screen.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    final router = GoRouter(
      refreshListenable: authProvider,
      initialLocation: '/splash',
      routes: [
        GoRoute(path: '/splash', builder: (_, __) => const SplashScreen()),
        GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
        GoRoute(
            path: '/forgot-password',
            builder: (_, __) => const ForgotPasswordScreen()),
        GoRoute(path: '/home', builder: (_, __) => const EventCalendarScreen()),
        GoRoute(
            path: '/event/:eventId',
            builder: (context, state) => EventDetailScreen(
                  eventId: state.pathParameters['eventId']!,
                )),
        GoRoute(
            path: '/event/:eventId/live',
            builder: (context, state) => LiveSessionScreen(
                  sessionId: state.pathParameters['eventId']!,
                )),
        GoRoute(
          path: '/admin/create-event',
          builder: (context, state) => const CreateEventScreen(),
        ),
      ],
      redirect: (BuildContext context, GoRouterState state) {
        final authStatus = authProvider.status;
        final location = state.matchedLocation;

        if (authStatus == AuthStatus.unknown) {
          return '/splash';
        }

        final isLoggedIn = authStatus == AuthStatus.authenticated;
        final isAuthRoute = location == '/login' ||
            location == '/signup' ||
            location == '/forgot-password';

        // If the user is logged in and they are trying to access an authentication
        // route (or the splash screen), redirect them to the home screen.
        if (isLoggedIn && (isAuthRoute || location == '/splash')) {
          return '/home';
        }

        // --- THIS IS THE FIX ---
        // If the user is NOT logged in and they are trying to access any page
        // that is NOT an authentication route, redirect them to the login screen.
        // This correctly handles redirecting from the splash screen.
        if (!isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        // No redirect needed.
        return null;
      },
    );

    return MaterialApp.router(
      title: 'Virtual Event App',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: router,
    );
  }
}
