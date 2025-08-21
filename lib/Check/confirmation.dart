// import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
// import 'package:flutter/material.dart';
// import 'package:amplify_flutter/amplify_flutter.dart';
// import 'package:pixel/Screens/Sign_up.dart';
// // import 'package:pixel/login_screen.dart';

// class ConfirmationScreen extends StatefulWidget {
//   final String email;

//   const ConfirmationScreen({super.key, required this.email});

//   @override
//   State<ConfirmationScreen> createState() => _ConfirmationScreenState();
// }

// class _ConfirmationScreenState extends State<ConfirmationScreen> {
//   final codeController = TextEditingController();

//   Future<void> confirmSignUp() async {
//     try {
//       final result = await Amplify.Auth.confirmSignUp(
//         username: widget.email,
//         confirmationCode: codeController.text.trim(),
//       );

//       if (result.isSignUpComplete) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Sign up confirmed! Please log in.')),
//         );

//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (_) => SignUpScreen()),
//         );
//       }
//     } on AuthException catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         // SnackBar(content: Text('Error: ${e.message}')),
//       );
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Confirm Email')),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Enter the confirmation code sent to your email'),
//             const SizedBox(height: 20),
//             TextField(
//               controller: codeController,
//               decoration: const InputDecoration(
//                 labelText: 'Confirmation Code',
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: confirmSignUp,
//               child: const Text('Confirm'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
