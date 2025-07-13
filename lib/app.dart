// lib/app.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_app/core/config/app_theme.dart';
import 'package:virtual_event_app/core/providers/auth_provider.dart';
import 'package:virtual_event_app/features/admin/screens/create_event_screen.dart';
import 'package:virtual_event_app/features/auth/screens/forgot_password_screen.dart';
import 'package:virtual_event_app/features/auth/screens/login_screen.dart';
import 'package:virtual_event_app/features/auth/screens/settings_screen.dart';
import 'package:virtual_event_app/features/auth/screens/sign_up_screen.dart';
import 'package:virtual_event_app/features/auth/screens/splash_screen.dart';
import 'package:virtual_event_app/features/auth/screens/two_fa_setup_screen.dart';
import 'package:virtual_event_app/features/auth/screens/two_fa_verify_screen.dart';
import 'package:virtual_event_app/features/events/screens/event_calendar_screen.dart';
import 'package:virtual_event_app/features/events/screens/event_detail_screen.dart';
import 'package:virtual_event_app/features/session/screens/live_session_screen.dart';

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
        GoRoute(path: '/settings', builder: (_, __) => const SettingsScreen()),
        GoRoute(
          path: '/setup-2fa',
          builder: (context, state) =>
              TwoFactorSetupScreen(secretKey: state.extra as String),
        ),
        GoRoute(
            path: '/verify-2fa',
            builder: (context, state) {
              final params = state.extra as Map<String, String>;
              return TwoFactorVerifyScreen(
                email: params['email']!,
                password: params['password']!,
              );
            }),
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
      // --- THIS IS THE FINAL FIX: A more robust redirection logic ---
      redirect: (BuildContext context, GoRouterState state) {
        final authStatus = authProvider.status;
        final location = state.matchedLocation;

        // While the auth state is being determined, always show the splash screen.
        if (authStatus == AuthStatus.unknown) {
          return '/splash';
        }

        final isLoggedIn = authStatus == AuthStatus.authenticated;

        final isAuthRoute = location == '/login' ||
            location == '/signup' ||
            location == '/forgot-password' ||
            location == '/verify-2fa';

        // --- Case 1: User is Logged In ---
        if (isLoggedIn) {
          // If they are on the splash screen or any auth screen, send them home.
          if (location == '/splash' || isAuthRoute) {
            return '/home';
          }
        }
        // --- Case 2: User is Logged Out ---
        else {
          // If they are anywhere BUT an authentication route, send them to the login page.
          // This correctly handles redirecting from '/splash' to '/login'.
          if (!isAuthRoute) {
            return '/login';
          }
        }

        // If none of the above conditions are met, no redirect is needed.
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
