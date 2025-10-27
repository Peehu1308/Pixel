import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/admin/Add_update.dart';
import 'package:pixel/admin/add_highlight.dart';
import 'package:pixel/admin/create_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pixel/Screens/profile.dart';

class Choice_Admin extends StatefulWidget {
  final String email;
  const Choice_Admin({super.key, required this.email});

  @override
  State<Choice_Admin> createState() => _Choice_AdminState();
}

class _Choice_AdminState extends State<Choice_Admin> {
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    fetchProfileImage();
  }

  Future<void> fetchProfileImage() async {
    final response = await Supabase.instance.client
        .from('Users')
        .select('Image')
        .eq('Email', widget.email)
        .maybeSingle();

    if (response != null && mounted) {
      setState(() {
        profileImage = response['Image'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // clean white background
      appBar:  AppBar(
        title: Text("Pixel",
            style: GoogleFonts.recursive(color: Colors.black, fontSize: 30)),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                if (widget.email.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Profile(email: widget.email),
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("You need to be logged in to view profile"),
                    ),
                  );
                }
              },
              child: CircleAvatar(
                radius: 22,
                backgroundColor: Colors.black12,
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : const AssetImage("lib/assets/profile.jpeg")
                        as ImageProvider,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sophisticated Welcome Text
            Text(
              "Welcome back, Admin",
              style: GoogleFonts.poppins(
                color: Colors.black,
                fontSize: 28,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              "Manage events and updates with ease.",
              style: GoogleFonts.poppins(
                color: Colors.grey[600],
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 50),

            // Create Event Button
            _buildActionButton(
              text: "Create an Event",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => CreateEvent(email: widget.email),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // Post Update Button
            _buildActionButton(
              text: "Post an Update",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddUpdateScreen(userEmail: widget.email),
                  ),
                );
              },
            ),
            SizedBox(height: 20,),
             _buildActionButton(
              text: "Post an Frame",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        AddingHighlights(email: widget.email),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({
    required String text,
    required VoidCallback onPressed,
  }) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 18),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          elevation: 3,
        ),
        onPressed: onPressed,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}
