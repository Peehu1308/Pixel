// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pixel/Info/personal.dart';
// import 'package:pixel/Screens/Sign_up.dart';
// import 'package:pixel/Components/navbar.dart';
// import 'package:pixel/main.dart';

// class Login extends StatefulWidget {
//   const Login({super.key});

//   @override
//   State<Login> createState() => _LoginState();
// }

// class _LoginState extends State<Login> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();

//   @override
//   void dispose() {
//     emailController.dispose();
//     passwordController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 200),
//             Center(
//               child: Text(
//                 "Pixel",
//                 style: GoogleFonts.recursive(
//                   fontSize: 60,
//                   color: Colors.black,
//                 ),
//               ),
//             ),
//             Text(
//               "Login",
//               style: GoogleFonts.recursive(
//                 fontSize: 18,
//                 decoration: TextDecoration.underline,
//               ),
//             ),
//             const SizedBox(height: 40),
//             SizedBox(
//               width: 300,
//               child: TextField(
//                 controller: emailController,
//                 decoration: const InputDecoration(
//                   labelText: "Email",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             SizedBox(
//               width: 300,
//               child: TextField(
//                 controller: passwordController,
//                 obscureText: true,
//                 decoration: const InputDecoration(
//                   labelText: "Password",
//                   border: OutlineInputBorder(),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => const MainScreen(email: em,)),
//                 );
//               },
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.black,
//                 minimumSize: const Size(300, 50),
//               ),
//               child: const Text(
//                 "Login",
//                 style: TextStyle(color: Colors.white),
//               ),
//             ),
//             const SizedBox(height: 20),
//             TextButton(
//               onPressed: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => Personal(email: emailController.text)),
//                 );
//               },
//               child: const Text("Don't have an account? Sign Up"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }