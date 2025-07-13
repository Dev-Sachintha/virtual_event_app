// lib/features/auth/screens/two_fa_verify_screen.dart

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:virtual_event_app/core/providers/auth_provider.dart';
import 'package:virtual_event_app/core/widgets/custom_button.dart';
import 'package:virtual_event_app/utils/validators.dart';

class TwoFactorVerifyScreen extends StatefulWidget {
  final String email;
  final String password;

  const TwoFactorVerifyScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<TwoFactorVerifyScreen> createState() => _TwoFactorVerifyScreenState();
}

class _TwoFactorVerifyScreenState extends State<TwoFactorVerifyScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;

  /// Called when the user presses the 'Verify Login' button.
  Future<void> _verifyLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    final authProvider = context.read<AuthProvider>();

    // The AuthProvider will handle the logic of signing in and then
    // checking the 2FA code against the user's stored secret.
    final error = await authProvider.verify2FALogin(
      widget.email,
      widget.password,
      _codeController.text.trim(),
    );

    // IMPORTANT: We only handle the error case here.
    // On success, the AuthProvider's stream will notify the app of the
    // new "authenticated" state, and the GoRouter redirect logic in app.dart
    // will automatically navigate the user to the home screen.
    if (mounted && error != null) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Two-Factor Verification')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.shield_outlined, size: 80, color: Colors.blue),
                const SizedBox(height: 16),
                const Text(
                  'Enter the 6-digit code from your authenticator app.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  controller: _codeController,
                  decoration:
                      const InputDecoration(labelText: 'Verification Code'),
                  keyboardType: TextInputType.number,
                  validator: Validators.requiredField,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 20, letterSpacing: 8),
                  maxLength: 6,
                ),
                const SizedBox(height: 32),
                CustomButton(
                  text: 'Verify Login',
                  onPressed: _verifyLogin,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
