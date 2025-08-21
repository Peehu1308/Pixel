import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Components/List_club.dart';
import 'package:pixel/Components/navbar.dart';
import 'package:pixel/Screens/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Clubs_Screen extends StatefulWidget {
  final String email;

  const Clubs_Screen({super.key, required this.email});

  @override
  State<Clubs_Screen> createState() => _Clubs_ScreenState();
}

class _Clubs_ScreenState extends State<Clubs_Screen> {
  String profileImage = "";
  final loggedInUserEmail =
      Supabase.instance.client.auth.currentUser?.email ?? '';

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
      backgroundColor: Colors.white,
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
        automaticallyImplyLeading: false

      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              "Find your community",
              style: GoogleFonts.recursive(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 10),
            Club_List(
              clubName: 'Google Developers Club',
              
              imageUrl: 'lib/assets/club.jpeg',
              
            ),
            Club_List(
              clubName: 'CSI',
              
              imageUrl: 'lib/assets/school.png',
              
            ),
            Club_List(
              clubName: 'Mobilon',
              
              imageUrl: 'lib/assets/party.jpeg',
              
            ),
            Club_List(
              clubName: 'AR/VR',
              
              imageUrl: 'lib/assets/evening.jpeg',
              
            ),
            Club_List(
              clubName: 'Fullstack',
              
              imageUrl: 'lib/assets/Business.jpeg',
              
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar(
        currentIndex: 3,
        onTap: (index) {},
        email: widget.email,
      ),
    );
  }
}
