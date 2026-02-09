import 'dart:io';
import 'package:docx_template/docx_template.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pixel/Screens/Createteam.dart';
import 'package:pixel/Screens/Jointeam.dart';
import 'package:pixel/Screens/event_home.dart';
import 'package:pixel/Screens/recommendation.dart';
import 'package:pixel/Screens/stallmap.dart';
import 'package:share_plus/share_plus.dart';

class Description_Screen extends StatelessWidget {
  final String title;
  final String clubName;
  final String date;
  final String imageUrl;
  final String description;
  final String email;
  final String time;
  final String type;
  final String venue; // ✅ Added venue

  const Description_Screen({
    super.key,
    required this.title,
    required this.clubName,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.email,
    required this.time,
    required this.type,
    required this.venue, // ✅ Added to constructor
  });

  Future<void> generateDocxReport({
    required String title,
    required String clubName,
    required String date,
    required String time,
    required String description,
  }) async {
    final templateBytes =
        await rootBundle.load('lib/assets/event_template.docx');
    final bytes = templateBytes.buffer.asUint8List();
    final docx = await DocxTemplate.fromBytes(bytes);

    final content = Content()
      ..add(TextContent("TITLE", title))
      ..add(TextContent("CLUB", clubName))
      ..add(TextContent("DATE", date))
      ..add(TextContent("TIME", time))
      ..add(TextContent("DESCRIPTION", description));

    final fileBytes = await docx.generate(content);

    final directory = await getApplicationDocumentsDirectory();
    final file = File("${directory.path}/event_report.docx");
    await rootBundle.loadString('lib/assets/event_template.docx').catchError((e) {
      print("Failed to load asset: $e");
    });

    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
      print("Word file saved to ${file.path}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: Text(
          "Eventra",
          style: GoogleFonts.recursive(color: Colors.white, fontSize: 30),
        ),
        backgroundColor: Colors.black,
      ),

      // ✅ Only show the floating location button when title is NOT "Ideathon"
      floatingActionButton: title.toLowerCase() != "ideathon"
          ? FloatingActionButton(
              backgroundColor: Colors.redAccent,
              tooltip: "View Stall Map",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => StallMapScreen()),
                );
              },
              child:
                  const Icon(Icons.location_on_outlined, color: Colors.white),
            )
          : null,

      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image section with overlay
            Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: double.infinity,
                  color: Colors.black.withOpacity(0.6), // overlay
                ),
                // Content inside image
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Title
                      Text(
                        title,
                        style: GoogleFonts.recursive(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),

                      // Date & Time Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            child: const Icon(
                              Icons.calendar_today,
                              size: 18,
                              color: Colors.white70,
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => StallMapScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "$date  |  $time",
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white70,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // ✅ Venue Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.location_on_outlined,
                              size: 20, color: Colors.redAccent),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              venue,
                              style: const TextStyle(
                                fontSize: 16,
                                color: Colors.white70,
                                fontWeight: FontWeight.w400,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Type & Organizer as chips
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: 10,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              type,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.black),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(20),
                              border:
                                  Border.all(color: Colors.white, width: 1),
                            ),
                            child: Text(
                              clubName,
                              style: const TextStyle(
                                  fontSize: 14, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ],
            ),

            // Foreground content
            Padding(
              padding: const EdgeInsets.only(
                  left: 16.0, right: 16, top: 16, bottom: 60),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey[800],
                        child: const Icon(Icons.group, color: Colors.white),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(clubName,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white)),
                          const Text("Organizer",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text("About",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white)),
                  const SizedBox(height: 5),
                  Text(
                    description,
                    style: const TextStyle(
                        fontSize: 15, color: Colors.white70, height: 1.5),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 🔍 Find Teammates - Solid Black Button
                        // SizedBox(
                        //   height: 50,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (_) =>
                        //                   Recommendation(email: email)));
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.black,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       "Find Teammates",
                        //       style: TextStyle(
                        //           color: Colors.white, fontSize: 16),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 12),

                        // // ✨ Create Team - White Button
                        // SizedBox(
                        //   height: 50,
                        //   child: ElevatedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (_) => UniqueCode(
                        //                   email: email,
                        //                   hackathontitle: title)));
                        //     },
                        //     style: ElevatedButton.styleFrom(
                        //       backgroundColor: Colors.white,
                        //       foregroundColor: Colors.black,
                        //       elevation: 3,
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       "Create Team",
                        //       style: TextStyle(
                        //           fontSize: 16, fontWeight: FontWeight.w500),
                        //     ),
                        //   ),
                        // ),
                        // const SizedBox(height: 12),

                        // // 🤝 Join Team - Outlined Button
                        // SizedBox(
                        //   height: 50,
                        //   child: OutlinedButton(
                        //     onPressed: () {
                        //       Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //               builder: (_) =>
                        //                   JoinTeam(email: email)));
                        //     },
                        //     style: OutlinedButton.styleFrom(
                        //       foregroundColor: Colors.white,
                        //       side: const BorderSide(
                        //           color: Colors.white, width: 1.4),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(12),
                        //       ),
                        //     ),
                        //     child: const Text(
                        //       "Join Team",
                        //       style: TextStyle(
                        //           fontSize: 16, fontWeight: FontWeight.w500),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
