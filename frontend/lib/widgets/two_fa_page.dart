import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:frontend/viewmodel/login_page_view_model.dart';
import 'package:frontend/view/home_page.dart';

class TwoFaPage extends StatefulWidget {
  final String email;
  const TwoFaPage({super.key, required this.email});

  @override
  State<TwoFaPage> createState() => _TwoFaPageState();
}

class _TwoFaPageState extends State<TwoFaPage> {
  final TextEditingController _otpController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // We access the SAME viewModel instance passed from the LoginPage
    final viewModel = context.watch<LoginPageViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Verify Your Identity")),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("A 6-digit code was sent to ${widget.email}"),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                labelText: "Enter 2FA Code",
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            if (viewModel.text.isNotEmpty)
              Text(viewModel.text, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                bool success = await viewModel.verifyOtp(
                  widget.email, 
                  _otpController.text,
                );

                if (success && mounted) {
                  // Navigate to Home if code is correct
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => HomePage(user: viewModel.user)),
                    (route) => false,
                  );
                }
              },
              child: const Text("Verify & Login"),
            ),
          ],
        ),
      ),
    );
  }
}