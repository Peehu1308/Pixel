import 'package:flutter/material.dart';
import 'package:pixel/Screens/Sign_up.dart';
import 'package:pixel/Screens/login.dart';



class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Welcome')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text("Login"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
              ),
            ),
            ElevatedButton(
              child: const Text("Sign Up"),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SignUpScreen()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
