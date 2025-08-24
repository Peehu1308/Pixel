import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Components/List_club.dart';
import 'package:pixel/Components/club_box_new.dart';
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
  List<dynamic> clubs = [];
  String profileImage = "";
  final loggedInUserEmail =
      Supabase.instance.client.auth.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    fetchProfileImage();
    fetchclubdata();
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

  Future<void> fetchclubdata() async {
    final response = await Supabase.instance.client
        .from('Clubs')
        .select('Club_name,Image_url,Club_description,id');


    setState(() {
      clubs = response;
      // If you need to access the id of each club, do it inside the itemBuilder or loop through clubs here if needed.
      // Example: final int id = int.parse(clubs[0]['id'].toString());
    });
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
                        content:
                            Text("You need to be logged in to view profile"),
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
          automaticallyImplyLeading: false),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                "Find your community",
                style: GoogleFonts.recursive(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Column(
              children: [
                clubs.isEmpty
                    ? const Center(
                        child: Text("loading"),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: clubs.length,
                        itemBuilder: (context, index) {
                          final club = clubs[index];
                          return ClubBoxNew(
                            imageUrl: club['Image_url'] ?? '',
                            description: club['Club_description'] ?? '',
                            clubname: club['Club_name'] ?? '',
                            clubId: club['id'].toString(),

                          );
                        })
              ],
            )
            // ClubBoxNew(
            //   imageUrl: 'lib/assets/school.png',
            //   description: "this is a good club",
            //   clubname: 'peehu',
            // ),
            // ClubBoxNew(
            //   imageUrl: 'lib/assets/club.jpeg',
            //   description: "this is a good club",
            //   clubname: 'peehu',
            // ),
            // ClubBoxNew(
            //   imageUrl: 'lib/assets/party.jpeg',
            //   description: "this is a good club",
            //   clubname: 'peehu',
            // ),
            // ClubBoxNew(
            //   imageUrl: 'lib/assets/evening.jpeg',
            //   description: "this is a good club",
            //   clubname: 'peehu',
            // ),
            // ClubBoxNew(
            //   imageUrl: 'lib/assets/club.jpeg',
            //   description: "this is a good club",
            //   clubname: 'peehu',
            // ),

            // // Club_List(
            // //   clubName: 'Google Developers Club',

            // //   imageUrl: 'lib/assets/club.jpeg',

            // // ),
            // // Club_List(
            // //   clubName: 'CSI',

            // //   imageUrl: 'lib/assets/school.png',

            // // ),
            // // Club_List(
            // //   clubName: 'Mobilon',

            // //   imageUrl: 'lib/assets/party.jpeg',

            // // ),
            // // Club_List(
            // //   clubName: 'AR/VR',

            // //   imageUrl: 'lib/assets/evening.jpeg',

            // // ),
            // // Club_List(
            // //   clubName: 'Fullstack',

            // //   imageUrl: 'lib/assets/Business.jpeg',

            // // ),
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
