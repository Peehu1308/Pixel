// // First, let's create an authentication service (auth_service.dart)

// import 'package:supabase_flutter/supabase_flutter.dart';

// class AuthService {
//   final supabase = Supabase.instance.client;
  
//   // Check if user is logged in
//   bool isLoggedIn() {
//     return supabase.auth.currentUser != null;
//   }
  
//   // Get current user email
//   String? getCurrentUserEmail() {
//     return supabase.auth.currentUser?.email;
//   }
  
//   // Sign in with email and password
//   Future<AuthResponse> signIn(String email, String password) async {
//     return await supabase.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );
//   }
  
//   // Sign up with email and password
//   Future<AuthResponse> signUp(String email, String password) async {
//     return await supabase.auth.signUp(
//       email: email,
//       password: password,
//     );
//   }
  
//   // Sign out
//   Future<void> signOut() async {
//     await supabase.auth.signOut();
//   }
// }

// // Updated main.dart to initialize Supabase properly

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:pixel/Screens/login_screen.dart';

// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
  
//   // Initialize Supabase
//   await Supabase.initialize(
//     url: 'YOUR_SUPABASE_URL', // Replace with your Supabase URL
//     anonKey: 'YOUR_ANON_KEY', // Replace with your Supabase anon key
//   );
  
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Pixel',
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//       ),
//       home: const LoginScreen(),
//     );
//   }
// }

// // Create a login screen (login_screen.dart)

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pixel/Screens/home_screen.dart';
// import 'package:pixel/Services/auth_service.dart';

// class LoginScreen extends StatefulWidget {
//   const LoginScreen({super.key});

//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   final emailController = TextEditingController();
//   final passwordController = TextEditingController();
//   final AuthService _authService = AuthService();
//   bool isLoading = false;
  
//   @override
//   void initState() {
//     super.initState();
//     _checkIfAlreadyLoggedIn();
//   }
  
//   void _checkIfAlreadyLoggedIn() async {
//     if (_authService.isLoggedIn()) {
//       _navigateToHome();
//     }
//   }
  
//   void _navigateToHome() {
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => HomeScreen()),
//     );
//   }

//   Future<void> _signIn() async {
//     if (emailController.text.isEmpty || passwordController.text.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Please enter both email and password')),
//       );
//       return;
//     }
    
//     setState(() {
//       isLoading = true;
//     });
    
//     try {
//       final response = await _authService.signIn(
//         emailController.text.trim(),
//         passwordController.text.trim(),
//       );
      
//       if (response.user != null) {
//         print("✅ Login successful: ${response.user?.email}");
//         _navigateToHome();
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Login failed')),
//         );
//       }
//     } catch (e) {
//       print("❌ Login error: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Login error: $e')),
//       );
//     } finally {
//       setState(() {
//         isLoading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(
//                 "Pixel",
//                 style: GoogleFonts.recursive(
//                   fontSize: 48,
//                   color: Colors.black,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               const SizedBox(height: 40),
//               TextField(
//                 controller: emailController,
//                 decoration: InputDecoration(
//                   labelText: 'Email',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   fillColor: const Color.fromARGB(62, 238, 238, 238),
//                   filled: true,
//                 ),
//                 keyboardType: TextInputType.emailAddress,
//               ),
//               const SizedBox(height: 16),
//               TextField(
//                 controller: passwordController,
//                 decoration: InputDecoration(
//                   labelText: 'Password',
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   fillColor: const Color.fromARGB(62, 238, 238, 238),
//                   filled: true,
//                 ),
//                 obscureText: true,
//               ),
//               const SizedBox(height: 24),
//               ElevatedButton(
//                 onPressed: isLoading ? null : _signIn,
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.black,
//                   minimumSize: const Size(double.infinity, 50),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10),
//                   ),
//                 ),
//                 child: isLoading
//                     ? const CircularProgressIndicator(color: Colors.white)
//                     : const Text('Login', style: TextStyle(color: Colors.white)),
//               ),
//               const SizedBox(height: 16),
//               TextButton(
//                 onPressed: () {
//                   // Navigate to sign up screen
//                 },
//                 child: const Text('Don\'t have an account? Sign up'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Updated Home_Screen.dart (renamed to home_screen.dart for better naming convention)

// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:pixel/Components/event_box.dart';
// import 'package:pixel/Screens/profile.dart';
// import 'package:pixel/Services/auth_service.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});

//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }

// class _HomeScreenState extends State<HomeScreen> {
//   final AuthService _authService = AuthService();
//   String? userEmail;
  
//   @override
//   void initState() {
//     super.initState();
//     _getUserEmail();
//   }
  
//   void _getUserEmail() {
//     setState(() {
//       userEmail = _authService.getCurrentUserEmail();
//     });
//     print("Current user email: $userEmail");
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: Text(
//           "Pixel",
//           style: GoogleFonts.recursive(color: Colors.black, fontSize: 30),
//         ),
//         backgroundColor: Colors.white,
//         actions: [
//           Container(
//             margin: const EdgeInsets.only(right: 20),
//             child: CircleAvatar(
//               radius: 20,
//               child: IconButton(
//                 onPressed: () {
//                   print("Navigating to Profile with email: $userEmail");
                  
//                   if (userEmail != null && userEmail!.isNotEmpty) {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => Profile(email: userEmail!)),
//                     );
//                   } else {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text("You need to be logged in to view profile")),
//                     );
//                   }
//                 },
//                 icon: Container(
//                   width: 40,
//                   height: 40,
//                   decoration: const BoxDecoration(
//                     shape: BoxShape.circle,
//                     image: DecorationImage(
//                       image: AssetImage("lib/assets/profile.jpeg"),
//                       fit: BoxFit.fill,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           )
//         ],
//       ),
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             Container(
//               margin: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 border: Border.all(color: Colors.black, width: 1),
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Row(
//                 children: [
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.menu,
//                       color: Colors.black,
//                     ),
//                   ),
//                   const Expanded(
//                     child: TextField(
//                       decoration: InputDecoration(
//                         hintText: "Search...",
//                       ),
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () {},
//                     icon: const Icon(
//                       Icons.search,
//                       color: Colors.black,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
            
//             // Rest of the home screen content (same as before)
//             // ...
//           ],
//         ),
//       ),
//     );
//   }
// }

// // Updated Profile.dart with better debugging

// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class Profile extends StatefulWidget {
//   final String email;
//   const Profile({super.key, required this.email});

//   @override
//   State<Profile> createState() => _ProfileState();
// }

// class _ProfileState extends State<Profile> {
//   final supabase = Supabase.instance.client;
  
//   String name = '';
//   String university = '';
//   String description = '';
//   String contact = '';
//   int semester = 0;
//   List<String> techStack = [];
//   List<String> projects = [];
//   List<String> likedTopics = [];
//   bool isLoading = true;
//   String? errorMessage;

//   @override
//   void initState() {
//     super.initState();
//     print("Profile widget initialized with email: ${widget.email}");
//     fetchProfileData();
//   }

//   Future<void> fetchProfileData() async {
//     try {
//       final emailToFetch = widget.email.trim();
//       print("🔍 Fetching profile for email: '$emailToFetch'");
      
//       // Check authentication status
//       final currentUser = supabase.auth.currentUser;
//       print("🔑 Current auth user: ${currentUser?.email ?? 'Not logged in'}");
      
//       // Query database
//       final response = await supabase
//           .from('Users')
//           .select()
//           .eq('Email', emailToFetch)
//           .maybeSingle();
      
//       print("📥 Raw response: $response");

//       if (response != null) {
//         setState(() {
//           name = response['Name'] ?? '';
//           university = response['University'] ?? '';
//           description = response['Description'] ?? '';
//           contact = response['Contact'] ?? '';
//           semester = response['Semester'] ?? 0;
          
//           // Parse lists safely
//           techStack = List<String>.from(response['Tech_Stack'] ?? []);
//           projects = List<String>.from(response['Project'] ?? []);
//           likedTopics = List<String>.from(response['Liked'] ?? []);
          
//           isLoading = false;
//           errorMessage = null;
          
//           print("✅ Profile data loaded successfully");
//         });
//       } else {
//         // No profile found - check if the user exists in database
//         final allUsers = await supabase.from('Users').select('Email');
//         print("📋 All emails in database: ${allUsers.map((u) => u['Email']).toList()}");
        
//         setState(() {
//           isLoading = false;
//           errorMessage = "No profile found. Have you created your profile yet?";
//         });
        
//         // Navigate to Personal screen to create profile
//         if (mounted) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text("No profile found. Let's create one!"),
//               duration: Duration(seconds: 3),
//             ),
//           );
//         }
//       }
//     } catch (e) {
//       print("❌ Error fetching profile: $e");
//       setState(() {
//         isLoading = false;
//         errorMessage = "Error: $e";
//       });
      
//       if (mounted) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text("Error loading profile: $e")),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     if (isLoading) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Profile'),
//           backgroundColor: Colors.white,
//           iconTheme: const IconThemeData(color: Colors.black),
//         ),
//         body: const Center(child: CircularProgressIndicator()),
//       );
//     }
    
//     if (errorMessage != null) {
//       return Scaffold(
//         appBar: AppBar(
//           title: const Text('Profile'),
//           backgroundColor: Colors.white,
//           iconTheme: const IconThemeData(color: Colors.black),
//         ),
//         body: Center(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Text(errorMessage!),
//               const SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: () {
//                   // Here you would navigate to Personal screen to create a profile
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) => Personal(email: widget.email)));
//                 },
//                 child: const Text('Create Profile'),
//               ),
//             ],
//           ),
//         ),
//       );
//     }
    
//     // The rest of your profile display code (unchanged)
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: Column(
//           children: [
//             const SizedBox(height: 40),
//             Stack(
//               children: [
//                 // Background Image
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                   child: Container(
//                     height: 400,
//                     width: double.infinity,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       image: const DecorationImage(
//                         image: AssetImage("lib/assets/profile.jpeg"),
//                         fit: BoxFit.cover,
//                       ),
//                     ),
//                   ),
//                 ),
//                 // Back Button
//                 Positioned(
//                   top: 10,
//                   left: 16,
//                   child: CircleAvatar(
//                     backgroundColor: const Color.fromARGB(45, 255, 255, 255),
//                     child: IconButton(
//                       icon: const Icon(Icons.arrow_back, color: Colors.black),
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                     ),
//                   ),
//                 ),
//                 // Text Overlay at bottom of image
//                 Positioned(
//                   bottom: 20,
//                   left: 32,
//                   right: 32,
//                   child: Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.6),
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           name,
//                           style: const TextStyle(
//                             fontSize: 24,
//                             fontWeight: FontWeight.bold,
//                             color: Colors.white,
//                           ),
//                         ),
//                         const SizedBox(height: 4),
//                         Text(
//                           "$university - Semester $semester",
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.white70,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),

//             // Rest of your profile display (unchanged)
//             // ...
//           ],
//         ),
//       ),
//     );
//   }
// }