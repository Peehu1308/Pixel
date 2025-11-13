// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:amplify_flutter/amplify_flutter.dart' hide AuthException;
// import 'package:pixel/Screens/Sign_up.dart';
// import 'package:pixel/admin/Admin_home.dart';
// import 'package:pixel/main.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   String message = "";
//   bool isLoading = false;

//   Future<bool> checkadmin(String email) async {
//     final response = await Supabase.instance.client
//         .from('admin')
//         .select('admin_email')
//         .eq('admin_email', email)
//         .maybeSingle();
//     return response != null;
//   }

//   Future<void> handleLogin() async {
//     if (!Amplify.isConfigured) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text("⚠️ Amplify is not ready")),
//       );
//       return;
//     }

//     setState(() => isLoading = true);
//     final email = emailController.text.trim();
//     final password = passwordController.text.trim();

//     try {
//       final session = await Amplify.Auth.fetchAuthSession();
//       if (session.isSignedIn) {
//         await Amplify.Auth.signOut();
//       }

//       final result = await Amplify.Auth.signIn(
//         username: email,
//         password: password,
//       );

//       if (result.isSignedIn) {
//         final isadmin = await checkadmin(email);

//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("✅ Login Successful!")),
//         );

//         if (!mounted) return;

//         if (isadmin) {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => AdminHome(email: email)),
//           );
//         } else {
//           Navigator.pushReplacement(
//             context,
//             MaterialPageRoute(builder: (_) => MainScreen(email: email)),
//           );
//         }
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text("❌ Login failed. Check credentials.")),
//         );
//       }
//     } on AuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Login error: ${e.message}")),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("Unexpected error: ")),
//       );
//     } finally {
//       setState(() => isLoading = false);
//     }
//   }

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   Widget _buildInputField(
//       TextEditingController controller, String label, IconData icon,
//       {bool obscure = false}) {
//     return TextField(
//       controller: controller,
//       obscureText: obscure,
//       style: GoogleFonts.poppins(),
//       decoration: InputDecoration(
//         prefixIcon: Icon(icon, color: Colors.black54),
//         labelText: label,
//         labelStyle: GoogleFonts.poppins(color: Colors.black54),
//         filled: true,
//         fillColor: Colors.grey.shade100,
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(14),
//           borderSide: BorderSide.none,
//         ),
//         contentPadding:
//             const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Column(
//           children: [
//             // Scrollable content
//             Expanded(
//               child: SingleChildScrollView(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     const SizedBox(height: 40),

//                     // Branding
//                     Text(
//                       "Pixel",
//                       style: GoogleFonts.recursive(
//                         fontSize: 52,
//                         fontWeight: FontWeight.bold,
//                         color: Colors.black,
//                       ),
//                     ),
//                     const SizedBox(height: 8),
//                     Text(
//                       "Login to your account",
//                       style: GoogleFonts.poppins(
//                         fontSize: 18,
//                         color: Colors.black54,
//                       ),
//                     ),
//                     const SizedBox(height: 40),

//                     // Email
//                     _buildInputField(emailController, "Bennett Email", Icons.email),
//                     const SizedBox(height: 18),

//                     // Password
//                     _buildInputField(passwordController, "Password", Icons.lock,
//                         obscure: true),
//                     const SizedBox(height: 30),

//                     // Login Button
//                     SizedBox(
//                       width: double.infinity,
//                       height: 52,
//                       child: ElevatedButton(
//                         onPressed: isLoading ? null : handleLogin,
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.black,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                         child: isLoading
//                             ? const SizedBox(
//                                 width: 24,
//                                 height: 24,
//                                 child: CircularProgressIndicator(
//                                   strokeWidth: 2,
//                                   color: Colors.white,
//                                 ),
//                               )
//                             : Text(
//                                 "Login",
//                                 style: GoogleFonts.poppins(
//                                   fontSize: 16,
//                                   fontWeight: FontWeight.w600,
//                                   color: Colors.white,
//                                 ),
//                               ),
//                       ),
//                     ),

//                     const SizedBox(height: 20),

//                     // Error message
//                     if (message.isNotEmpty)
//                       Text(
//                         message,
//                         style: const TextStyle(color: Colors.red),
//                       ),
//                   ],
//                 ),
//               ),
//             ),

//             // Signup link fixed at bottom
//             Padding(
//               padding: const EdgeInsets.only(bottom: 20),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text("Don't have an account?",
//                       style: GoogleFonts.poppins(color: Colors.black87)),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => const SignUpScreen()),
//                       );
//                     },
//                     child: Text(
//                       "Sign up here",
//                       style: GoogleFonts.poppins(
//                         fontWeight: FontWeight.w600,
//                         decoration: TextDecoration.underline,
//                         color: Colors.black,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:amplify_flutter/amplify_flutter.dart' hide AuthException;
import 'package:pixel/Screens/Sign_up.dart';
import 'package:pixel/admin/Admin_home.dart';
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
  final enrollmentController = TextEditingController();

  String message = "";
  bool isLoading = false;

  /// Check if admin user
  Future<bool> checkadmin(String email) async {
    final response = await Supabase.instance.client
        .from('admin')
        .select('admin_email')
        .eq('admin_email', email)
        .maybeSingle();
    return response != null;
  }

  /// Regular Amplify login (after Nov 20, 2025)
  Future<void> handleAmplifyLogin() async {
    if (!Amplify.isConfigured) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Amplify is not ready")),
      );
      return;
    }

    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    try {
      final session = await Amplify.Auth.fetchAuthSession();
      if (session.isSignedIn) {
        await Amplify.Auth.signOut();
      }

      final result = await Amplify.Auth.signIn(
        username: email,
        password: password,
      );

      if (result.isSignedIn) {
        final isadmin = await checkadmin(email);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Login Successful!")),
        );

        if (!mounted) return;

        if (isadmin) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AdminHome(email: email)),
          );
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => MainScreen(email: email)),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("❌ Login failed. Check credentials.")),
        );
      }
    } on AuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Login error: ${e.message}")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Unexpected error: ")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  /// Simple early access login (before Nov 20, 2025)
Future<void> handleEarlyAccessLogin() async {
  final enrollment = enrollmentController.text.trim();

  if (enrollment.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("⚠️ Please enter your enrollment number")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    // Check if the email already exists in the Users table
    final existingUser = await Supabase.instance.client
        .from('Users')
        .select('Email')
        .eq('Email', enrollment)
        .maybeSingle();

    if (existingUser == null) {
      // Insert only if not present
      await Supabase.instance.client.from('Users').insert({
        'Email': enrollment,
        'created_at': DateTime.now().toIso8601String(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Enrollment saved! Welcome.")),
      );
    } else {
      // Allow entry if already exists
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Welcome back!")),
      );
    }

    if (!mounted) return;

    // Navigate to main page in both cases
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => MainScreen(email: enrollment)),
    );
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error saving enrollment: ")),
    );
  } finally {
    setState(() => isLoading = false);
  }
}

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    enrollmentController.dispose();
    super.dispose();
  }

  Widget _buildInputField(
      TextEditingController controller, String label, IconData icon,
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
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentDate = DateTime.now();
    final releaseDate = DateTime(2025, 11, 20);
    final isEarlyAccess = currentDate.isBefore(releaseDate);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      "Pixel",
                      style: GoogleFonts.recursive(
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      isEarlyAccess
                          ? "Early Access — Enter Bennett Email"
                          : "Login to your account",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Early access: Enrollment input only
                    if (isEarlyAccess)
                      _buildInputField(
                          enrollmentController, "Bennett Email", Icons.badge)
                    else ...[
                      _buildInputField(
                          emailController, "Bennett Email", Icons.email),
                      const SizedBox(height: 18),
                      _buildInputField(passwordController, "Password", Icons.lock,
                          obscure: true),
                    ],

                    const SizedBox(height: 30),

                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : isEarlyAccess
                                ? handleEarlyAccessLogin
                                : handleAmplifyLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: isLoading
                            ? const SizedBox(
                                width: 24,
                                height: 24,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : Text(
                                isEarlyAccess ? "Continue" : "Login",
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    if (message.isNotEmpty)
                      Text(
                        message,
                        style: const TextStyle(color: Colors.red),
                      ),
                  ],
                ),
              ),
            ),

            // Signup link only for full login (after release)
            if (!isEarlyAccess)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?",
                        style: GoogleFonts.poppins(color: Colors.black87)),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      child: Text(
                        "Sign up here",
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
}

