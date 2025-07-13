// lib/features/auth/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_app/core/providers/auth_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final is2faEnabled = authProvider.user?.is2faEnabled ?? false;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Two-Factor Authentication'),
            subtitle: Text(is2faEnabled ? 'Enabled' : 'Disabled'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              if (!is2faEnabled) {
                final secret = authProvider.generate2FASecret();
                context.go('/setup-2fa', extra: secret);
              } else {
                // Here you could add logic to disable 2FA
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Disabling 2FA is not yet implemented.')),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
