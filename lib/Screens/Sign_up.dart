import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:pixel/Screens/confirmation.dart';
import 'package:pixel/Screens/login.dart';

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
        const SnackBar(content: Text("⚠️ Please use your @bennett.edu.in email.")),
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
          const SnackBar(content: Text("📩 Verification code sent to your email.")),
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ConfirmationScreen(email: email)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Sign-up complete! You can now log in.")),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("❌ Error: ${e.message}")),
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
      resizeToAvoidBottomInset: true, // shift UI up with keyboard
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Scrollable content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 40),

                    // Branding
                    Text(
                      "Eventra",
                      style: GoogleFonts.recursive(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Create your account",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Input fields
                    _buildInputField(nameController, "Full Name", Icons.person),
                    const SizedBox(height: 18),
                    _buildInputField(emailController, "Bennett Email", Icons.email),
                    const SizedBox(height: 18),
                    _buildInputField(passwordController, "Password", Icons.lock,
                        obscure: true),

                    const SizedBox(height: 30),

                    // Sign-Up Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: handleSignUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          "Sign Up",
                          style: GoogleFonts.poppins(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Fixed footer (Login link)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?",
                      style: GoogleFonts.poppins(color: Colors.black87)),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginScreen()),
                      );
                    },
                    child: Text(
                      "Login here",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(TextEditingController controller, String label, IconData icon,
      {bool obscure = false}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: GoogleFonts.poppins(),
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black54),
        labelText: label,
        labelStyle: GoogleFonts.poppins(color: Colors.black54),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
