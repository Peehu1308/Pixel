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
    final exists = await rootBundle
        .loadString('lib/assets/event_template.docx')
        .catchError((e) {
      print("Failed to load asset: $e");
    });

    if (fileBytes != null) {
      await file.writeAsBytes(fileBytes);
      print("Word file saved to ${file.path}");
      // Optionally: share the file using share_plus
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
          backgroundColor: Colors.transparent,
        ),
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
          
                        // Date
                        Text(
                          date,
                          style: const TextStyle(
                            fontSize: 18,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
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
          
                        // Short description
                        // Padding(
                        //   padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        //   child: Text(
                        //     description,
                        //     style: const TextStyle(
                        //       fontSize: 16,
                        //       color: Colors.white70,
                        //     ),
                        //     textAlign: TextAlign.center,
                        //   ),
                        // ),
                      ],
                    ),
                  ),
                ],
              ),
          
              // Foreground content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey[300],
                          child: const Icon(Icons.group, color: Colors.black),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(clubName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16)),
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
                            color: Colors.black)),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 15, color: Colors.black87),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
