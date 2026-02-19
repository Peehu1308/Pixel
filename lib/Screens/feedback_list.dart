import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Components/feedback_box.dart';
import 'package:pixel/Components/highlight.dart';
import 'package:pixel/Components/Club_box.dart';
import 'package:pixel/Components/highlight_manager.dart';
import 'package:pixel/Components/navbar.dart';
import 'package:pixel/Screens/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Event {
  final String title;
  final String clubName;
  final String date;
  final String imageUrl;
  final String description;
  final String time;

  Event({
    required this.title,
    required this.clubName,
    required this.date,
    required this.imageUrl,
    this.description = '',
    required this.time,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      title: json['Name'] ?? '',
      clubName: json['Club_Name'] ?? '',
      date: json['date'] ?? '',
      imageUrl: json['Image_url'] ?? '',
      description: json['Description'] ?? '',
      time: json['Time'],
    );
  }
}

class Feedback_List extends StatefulWidget {
  final String email;

  const Feedback_List({super.key, required this.email});

  @override
  State<Feedback_List> createState() => _Feedback_ListState();
}

class _Feedback_ListState extends State<Feedback_List> {
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

  Future<List<Event>> fetchEvents() async {
    final response = await Supabase.instance.client.from('Hackathon').select();
    return (response as List).map((data) => Event.fromJson(data)).toList();
  }

  // Future<List<HighlightModel>> fetchHighlights() async {
  //   try {
  //     final response = await Supabase.instance.client
  //         .from('Highlights')
  //         .select('club_name, images');

  //     List<dynamic> data = response as List<dynamic>;
  //     return data.map((e) => HighlightModel.fromJson(e)).toList();
  //   } catch (error) {
  //     throw Exception('Error fetching highlights: $error');
  //   }
  // }

  @override
  void initState() {
    super.initState();
    fetchProfileImage();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Eventra",
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
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
            //   child: SizedBox(
            //     height: 110,
            //     child: FutureBuilder<List<HighlightModel>>(
            //       future: fetchHighlights(),
            //       builder: (context, snapshot) {
            //         if (snapshot.connectionState == ConnectionState.waiting) {
            //           return const Center(child: CircularProgressIndicator());
            //         } else if (snapshot.hasError) {
            //           return Center(child: Text('Error: ${snapshot.error}'));
            //         } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            //           return const Center(child: Text('No highlights found.'));
            //         } else {
            //           final highlights = snapshot.data!;
            //           return ListView.builder(
            //             scrollDirection: Axis.horizontal,
            //             itemCount: highlights.length,
            //             itemBuilder: (context, index) {
            //               return Padding(
            //                 padding:
            //                     const EdgeInsets.symmetric(horizontal: 8.0),
            //                 child: Highlight(model: highlights[index]),
            //               );
            //             },
            //           );
            //         }
            //       },
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        "Feedback for past Events:",
                        style: GoogleFonts.recursive(
                            fontSize: 20, color: Colors.black),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FutureBuilder<List<Event>>(
                    future: fetchEvents(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Text('No events found.');
                      } else {
                        return Column(
                          children: snapshot.data!
                              .map((event) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12.0),
                                    child: FeedbackBox(
                                      title: event.title,
                                      clubName: event.clubName,
                                      date: event.date,
                                      imageUrl: event.imageUrl,
                                      description: event.description,
                                      email: widget.email,
                                      time: event.time,
                                    ),
                                  ))
                              .toList(),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      
    );
  }
}
