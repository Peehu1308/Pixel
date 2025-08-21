import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:pixel/Screens/confirmation.dart';
import 'package:pixel/Screens/login.dart';
// import 'confirmation_screen.dart'; // Make sure this file is in your project

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final nameController = TextEditingController();

  Future<void> handleSignUp() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final name = nameController.text.trim();

    if (!email.endsWith('@bennett.edu.in')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please use your @bennett.edu.in email."),
        ),
      );
      return;
    }

    try {
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(userAttributes: {
          CognitoUserAttributeKey.email: email,
          CognitoUserAttributeKey.custom('display_name'): name,
        }),
      );

      if (!result.isSignUpComplete) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Verification code sent to your email.")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ConfirmationScreen(email: email),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Sign-up complete! You can now log in.")),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.message}")),
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(25.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Text(
                "Pixel",
                style: GoogleFonts.recursive(
                  fontSize: 60,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Sign Up",
                style: GoogleFonts.recursive(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 40),
          
              // Name
              SizedBox(
                width: 300,
                child: TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: "Full Name",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              // Email
              SizedBox(
                width: 300,
                child: TextField(
                  controller: emailController,
                  decoration: const InputDecoration(
                    labelText: "Bennett Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              // Password
              SizedBox(
                width: 300,
                child: TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
          
              // Sign-Up Button
              ElevatedButton(
                onPressed: handleSignUp,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(300, 50),
                ),
                child: const Text(
                  "Sign Up",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),
          
              // Login link
              TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context)=>LoginScreen())
                  ); // You can redirect to login screen here
                },
                child: const Text("Already have an account? Login here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
