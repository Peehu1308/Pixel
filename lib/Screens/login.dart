import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart' hide AuthException;
import 'package:pixel/Check/blank.dart';
import 'package:pixel/Screens/Desc.dart';
import 'package:pixel/Screens/Home_Screen.dart';
import 'package:pixel/Screens/Sign_up.dart';
import 'package:pixel/Screens/feedback.dart';
import 'package:pixel/admin/Admin_home.dart';
// import 'package:pixel/Screens/main.dart';
import 'package:pixel/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String message = "";
  bool isLoading = false;

  Future<bool> checkadmin(String email) async {
    final response = await Supabase.instance.client
        .from('admin')
        .select('admin_email')
        .eq('admin_email', email)
        .maybeSingle();

    if (response != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> handleLogin() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        bool isadmin = await checkadmin(email);

        //
        if (isadmin) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminHome(email: email)
                // Home_Screen(email: email)
                ),
          );
        } 
        else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Login successful!")),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen(email: email)
                // Home_Screen(email: email)
                ),
          );
        }

        //
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Login failed. Check credentials.")),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: ${e.message}")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
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
                "Login",
                style: GoogleFonts.recursive(
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
              ),
              const SizedBox(height: 40),

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
              isLoading
              ?const CircularProgressIndicator()
              :ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  minimumSize: const Size(300, 50),
                ),
                child: const Text(
                  "Login",
                  style: TextStyle(color: Colors.white),
                ),
              ),
              const SizedBox(height: 20),

              // Feedback message
              Text(
                message,
                style: const TextStyle(color: Colors.red),
              ),

              // Signup link
              TextButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SignUpScreen())); // Or push to signup screen
                },
                child: const Text("Don't have an account? Sign up here"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
