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

  const Description_Screen({
    super.key,
    required this.title,
    required this.clubName,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.email,
    // required String type,
    required this.time,
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
      appBar: AppBar(
        title: Text(
          "Pixel",
          style: GoogleFonts.recursive(color: Colors.black, fontSize: 30),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Fullscreen Background Image with Black Overlay
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              color: Colors.black.withOpacity(0.8),
            ),
          ),
          // Foreground Content
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.recursive(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Date: $date",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      "Time: $time",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Organized by: $clubName",
                      style:
                          const TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    Center(
                      child: Row(
                        children: [
                          Text(
                            'Share this event',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30,
                                color: Colors.white),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                                onPressed: () {
                                  Share.share(
                                      'Come participate in this exciting event happening soon!\n$title\nDate: $date\nTime: $time\nOrganized by: $clubName\nDescription: $description\nJoin us and be part of the fun! \nFor more details, download the Pixel app now!');
                                },
                                child: Icon(Icons.share,
                                    color: Colors.black, size: 15),
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Colors.white.withOpacity(1)),
                                  shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5),
                                  )),
                                )),
                          ),
                        ],
                      ),

                      // child:
                    ),
                    Row(
                      children: [
                        Text("Create a docx file"),
                        ElevatedButton(
                          onPressed: () {
                            generateDocxReport(
                              title: title,
                              clubName: clubName,
                              date: date,
                              time: time,
                              description: description,
                            );
                          },
                          child: Text("Generate Word Report"),
                        ),
                      ],
                    ),
                    Text(
                      "$description",
                      style: GoogleFonts.recursive(
                          fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 600,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EventHome(
                                        title: title,
                                        clubName: clubName,
                                        date: date,
                                        imageUrl: imageUrl,
                                        description: description,
                                        email: email,
                                        time: time)));
                          },
                          child: Text(
                            "Register",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.white),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
