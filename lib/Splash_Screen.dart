import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Screens/Sign_up.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(context, 
      MaterialPageRoute(builder: (context) => SignUpScreen()));
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedTextKit(animatedTexts: [TyperAnimatedText("Pixel",
              textStyle: GoogleFonts.recursive(
                fontSize: 50,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              speed: const Duration(milliseconds: 100),
            ),],
            repeatForever: false,),
            
            SizedBox(
              height: 2,
            ),
            Text(
              "Every Event . One Frame",
              style: GoogleFonts.recursive(fontSize: 18, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
