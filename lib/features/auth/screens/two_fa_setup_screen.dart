// lib/features/auth/screens/two_fa_setup_screen.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:virtual_event_app/core/providers/auth_provider.dart';
import 'package:virtual_event_app/core/widgets/custom_button.dart';
import 'package:virtual_event_app/utils/validators.dart';

class TwoFactorSetupScreen extends StatefulWidget {
  final String secretKey;
  const TwoFactorSetupScreen({super.key, required this.secretKey});

  @override
  State<TwoFactorSetupScreen> createState() => _TwoFactorSetupScreenState();
}

class _TwoFactorSetupScreenState extends State<TwoFactorSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  bool _isLoading = false;

  /// Generates the standard URI used by authenticator apps.
  String _getProvisioningUri() {
    final userEmail = context.read<AuthProvider>().user!.email;
    return 'otpauth://totp/VirtualEventHub:$userEmail?secret=${widget.secretKey}&issuer=VirtualEventHub';
  }

  /// Launches the authenticator app with the secret key pre-filled.
  Future<void> _launchAuthenticator() async {
    final uri = Uri.parse(_getProvisioningUri());
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Could not find an authenticator app. Please add the key manually.'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  /// Verifies the code from the authenticator app to complete setup.
  Future<void> _verifyAndEnable2FA() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final authProvider = context.read<AuthProvider>();
    final success = await authProvider.verifyAndEnable2FA(
      widget.secretKey,
      _codeController.text.trim(),
    );

    if (mounted) {
      setState(() => _isLoading = false);
      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('2FA Enabled Successfully!'),
              backgroundColor: Colors.green),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Invalid code. Please check your authenticator app.'),
              backgroundColor: Colors.red),
        );
      }
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
      appBar: AppBar(title: const Text('Enable Two-Factor Auth')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Center(
          child: Column(
            children: [
              const Text(
                '1. Add this account to your authenticator app.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.open_in_new),
                  label: const Text('Open Authenticator App'),
                  onPressed: _launchAuthenticator,
                  style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12)),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Or scan the QR code:', textAlign: TextAlign.center),
              const SizedBox(height: 10),
              Container(
                color: Colors.white,
                padding: const EdgeInsets.all(12),
                child: QrImageView(
                  data: _getProvisioningUri(),
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              const SizedBox(height: 20),
              const Text("Or enter this key manually:",
                  textAlign: TextAlign.center),
              const SizedBox(height: 8),
              SelectableText(
                widget.secretKey,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 24),
              const Text(
                '2. Enter the 6-digit code from your app to complete setup.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                      labelText: '6-Digit Verification Code'),
                  keyboardType: TextInputType.number,
                  validator: Validators.requiredField,
                  maxLength: 6,
                ),
              ),
              const SizedBox(height: 32),
              CustomButton(
                text: 'Verify & Enable',
                onPressed: _verifyAndEnable2FA,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
