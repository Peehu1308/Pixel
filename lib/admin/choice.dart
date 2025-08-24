import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/admin/Add_update.dart';
import 'package:pixel/admin/create_event.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // make sure this is imported
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
      appBar: AppBar(
        title: Text(
          "Pixel",
          style: GoogleFonts.recursive(color: Colors.black, fontSize: 30),
        ),
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
                radius: 20,
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : const AssetImage("lib/assets/profile.jpeg")
                        as ImageProvider,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Center(
            child: Text("Welcome Admin!"),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => CreateEvent(email: widget.email)));
              },
              child: Text("Create an Event")),
              ElevatedButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => AddUpdateScreen(userEmail: widget.email,)));
              },
              child: Text("Create an Update"))
        ],
      ),
    );
  }
}
