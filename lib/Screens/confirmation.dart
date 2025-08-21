import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:pixel/Info/personal.dart';
import 'package:pixel/Screens/login.dart';
import 'package:pixel/main.dart';

class ConfirmationScreen extends StatefulWidget {
  final String email;

  const ConfirmationScreen({super.key, required this.email});

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  final codeController = TextEditingController();
  String message = "";

  Future<void> confirmSignUp() async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: widget.email,
        confirmationCode: codeController.text.trim(),
      );

      if (result.isSignUpComplete) {
        setState(() {
          message = "Verification successful! You can now log in.";
        });
        // Optionally, navigate to login screen
        await Future.delayed(const Duration(milliseconds: 30));
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Personal(email: widget.email)));
      } else {
        setState(() {
          message = "Verification failed. Try again.";
        });
      }
    } on AuthException catch (e) {
      setState(() {
        message = e.message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Confirm Your Email")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Enter the verification code sent to: ${widget.email}"),
            const SizedBox(height: 16),
            TextField(
              controller: codeController,
              decoration: const InputDecoration(labelText: 'Verification Code'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: confirmSignUp,
              child: const Text("Verify"),
            ),
            const SizedBox(height: 20),
            Text(message),
          ],
        ),
      ),
    );
  }
}
