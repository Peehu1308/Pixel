import 'package:flutter/material.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:pixel/Components/navbar.dart';
import 'package:pixel/Screens/Home_Screen.dart';
import 'package:pixel/Screens/Sign_up.dart';
import 'package:pixel/Screens/auth.dart';
import 'package:pixel/Screens/club.dart';
import 'package:pixel/Screens/event.dart';
import 'package:pixel/Screens/friends_screen.dart';
import 'package:pixel/Screens/login.dart';
import 'package:pixel/Screens/stallmap.dart';
import 'package:pixel/Splash_Screen.dart';
import 'package:pixel/admin/Admin_home.dart';
import 'package:pixel/admin/add_highlight.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'amplifyconfiguration.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://wmuhbnagyakqvdsyydbe.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6IndtdWhibmFneWFrcXZkc3l5ZGJlIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDQ4MDY0NTQsImV4cCI6MjA2MDM4MjQ1NH0.tt1tt8s3WYfBCPRmd_TNXfZ4GaEoXbldKztA_DQKlT0',
  );

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _amplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    configureAmplify();
  }

  Future<void> configureAmplify() async {
    final auth = AmplifyAuthCognito();
    try {
      await Amplify.addPlugin(auth);
      await Amplify.configure(amplifyconfig);
      setState(() {
        _amplifyConfigured = true;
      });
    } on AmplifyAlreadyConfiguredException {
      safePrint("Amplify configured");
      setState(() {
        _amplifyConfigured = true;
      });
    } catch (e) {
      safePrint("$e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: _amplifyConfigured
          // ? SplashScreen()
          ?LoginScreen()
          // ?InteractiveStallMap()
          // ?StallMapScreen()
          // ?AddingFrames(email: "E23CSEU2289@bennett.edu.in")
          // ? AdminHome(email: "E23CSEU2289@bennett.edu.in")
          // ? Clubs_Screen(email: 'S24CSEU0489@bennett.edu.in')
          // ? Clubs_Screen(email: 'E23CSEU2289@bennett.edu.in')
          : Scaffold(body: Center(child: CircularProgressIndicator())),
    );
  }
}

class MainScreen extends StatefulWidget {
  final String email;

  const MainScreen({super.key, required this.email});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  late final List<Widget> screens;

  @override
  void initState() {
    super.initState();
    screens = [
      Home_Screen(email: widget.email),
      FriendsScreen(email: widget.email),
      Event_Screen(email: widget.email),
      Clubs_Screen(email: widget.email),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[currentIndex],
      bottomNavigationBar: Navbar(
        currentIndex: currentIndex,
        onTap: (i) => setState(() => currentIndex = i),
        email: widget.email,
      ),
    );
  }
}
