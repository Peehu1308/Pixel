import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Components/Updatemodel.dart';
import 'package:pixel/Components/highlight.dart';
import 'package:pixel/Components/Club_box.dart';
import 'package:pixel/Components/highlight_manager.dart';
import 'package:pixel/Components/navbar.dart';
import 'package:pixel/Components/update_box.dart';
import 'package:pixel/Components/updates_dart.dart';
import 'package:pixel/Screens/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Updates {
  final String title;
  final String clubName;
  final String date;
  final String imageUrl;
  final String description;
  final String time;

  Updates({
    required this.title,
    required this.clubName,
    required this.date,
    required this.imageUrl,
    this.description = '',
    required this.time,
  });

  factory Updates.fromJson(Map<String, dynamic> json) {
    return Updates(
      title: json['Name'] ?? '',
      clubName: json['Club_Name'] ?? '',
      date: json['date'] ?? '',
      imageUrl: json['Image_url'] ?? '',
      description: json['Description'] ?? '',
      time: json['Time'],
    );
  }
}

class Updates_Screen extends StatefulWidget {
  final String email;

  const Updates_Screen({super.key, required this.email});

  @override
  State<Updates_Screen> createState() => _Updates_ScreenState();
}

class _Updates_ScreenState extends State<Updates_Screen> {
  String profileImage = "";

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

  Future<List<Updates>> fetchUpdatess() async {
    final response = await Supabase.instance.client.from('Hackathon').select();
    return (response as List).map((data) => Updates.fromJson(data)).toList();
  }

  Future<List<HighlightModel>> fetchHighlights() async {
    try {
      final response = await Supabase.instance.client
          .from('Highlights')
          .select('club_name, images');

      List<dynamic> data = response as List<dynamic>;
      return data.map((e) => HighlightModel.fromJson(e)).toList();
    } catch (error) {
      throw Exception('Error fetching highlights: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfileImage();
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
                        builder: (context) => Profile(email: widget.email)),
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
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔹 Highlights Section
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
              child: SizedBox(
                height: 110,
                child: FutureBuilder<List<HighlightModel>>(
                  future: fetchHighlights(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No highlights found.'));
                    } else {
                      final highlights = snapshot.data!;
                      return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: highlights.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Highlight(model: highlights[index]),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ),

            // 🔹 Updatess Section
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8, top: 2, bottom: 8),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        "Updates",
                        style: GoogleFonts.recursive(
                            fontSize: 30, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  // 🔹 Updates Section
                  FutureBuilder<List<Updatemodel>>(
                    future: fetchUpdate(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const Center(
                            child: CircularProgressIndicator());
                      }
                      if (snapshot.hasError) {
                        return Center(
                            child: Text("Error: ${snapshot.error}"));
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                            child: Text("No updates available"));
                      }

                      final updates = snapshot.data!;
                      return ListView.builder(
                        shrinkWrap: true,
                        physics:
                            const NeverScrollableScrollPhysics(), 
                        itemCount: updates.length,
                        itemBuilder: (context, index) {
                          final update = updates[index];
                          return GestureDetector(
                            child: UpdateBox(
                              heading: update.heading,
                              update: update.Update, image:update.Image!,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UpdatesBox_Data(heading: update.heading, image: update.Image!, update: update.Update)
                                ),
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          Navbar(currentIndex: 2, onTap: (index) {}, email: widget.email),
    );
  }
}
