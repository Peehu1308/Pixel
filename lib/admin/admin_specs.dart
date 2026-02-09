import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Components/comment_update.dart';
import 'package:pixel/Components/commentbox.dart';
import 'package:pixel/Components/frames.dart';
import 'package:pixel/Components/frames_manager.dart';
import 'package:pixel/Components/navbar.dart';
import 'package:pixel/Screens/profile.dart';
import 'package:pixel/admin/navbar_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Admin_FriendsScreen extends StatefulWidget {
  const Admin_FriendsScreen({
    super.key,
    required this.email,
  });
  final String email;

  @override
  State<Admin_FriendsScreen> createState() => _Admin_FriendsScreenState();
}

class _Admin_FriendsScreenState extends State<Admin_FriendsScreen> {
  String profileImage = "";

  @override
  void initState() {
    super.initState();
    fetchProfileImage();
  }

  Future<List<FramesModel>> fetchFrames() async {
    try {
      final response =
          await Supabase.instance.client.from('frames').select('user,Images,likes');

      List<dynamic> data = response as List<dynamic>;
      return data.map((e) => FramesModel.fromJson(e)).toList();
    } catch (error) {
      throw Exception('Error fetching frames: $error');
    }
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
          "Eventra",
          style: GoogleFonts.recursive(color: Colors.black, fontSize: 30),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
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
                            Text("You need to be logged in to view profile")),
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
          )
        ],
        automaticallyImplyLeading: false

      ),
      body: SafeArea(
        child: Stack(
          children: [
            
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: ListView(
                padding: EdgeInsets.only(
                    bottom: 120),
                children: [
                  SizedBox(
                    height: 110,
                    child: FutureBuilder<List<FramesModel>>(
                      future: fetchFrames(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (snapshot.hasError) {
                          return Center(
                              child: Text('Error: ${snapshot.error}'));
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Center(child: Text('No frames found.'));
                        }
                        final frames = snapshot.data!;
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: frames.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Frames(model: frames[index]),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  // const SizedBox(height: 12),
                  Text(
                    'Specs',
                    style: GoogleFonts.recursive(
                        fontSize: 30, color: Colors.black),
                  ),
                  const SizedBox(height: 8),
                  Commentbox(),
                  
                ],
              ),
            ),

            
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                color: Colors.white,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: UpdateCommet(userEmail: widget.email),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar_Admin(
        currentIndex: 1,
        onTap: (index) {},
        email: widget.email,
      ),
    );
  }
}
