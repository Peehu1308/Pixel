import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Screens/Createteam.dart';
import 'package:pixel/Screens/Jointeam.dart';
import 'package:pixel/Screens/recommendation.dart';
import 'package:share_plus/share_plus.dart';

class EventHome extends StatelessWidget {
  final String title;
  final String clubName;
  final String date;
  final String imageUrl;
  final String description;
  final String email;
  final String time;

  const EventHome({
    super.key,
    required this.title,
    required this.clubName,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.email,
    required this.time,
  });

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
          
          SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
            child: Padding(
              padding: const EdgeInsets.only(left:8.0,right: 8.0,top: 8.0,bottom: 16),
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
                    const SizedBox(height: 10),
                    Text(
                      "Organized by: $clubName".toUpperCase(),
                      style: const TextStyle(fontSize: 18, color: Colors.white70),
                    ),
                    const SizedBox(height: 20),

                    
                    // Text(
                    //   "$description",
                    //   style: GoogleFonts.recursive(
                    //       fontSize: 16, color: Colors.white),
                    // ),
                    SizedBox(height: 20),
                    SizedBox(
                      height: 50,
                      width: 600,
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        Recommendation(email: email)));
                          },
                          child: Text(
                            "Find Teammates",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ButtonStyle(backgroundColor:
                                
                                MaterialStateProperty.all(Color.fromARGB(250, 89, 88, 88)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                          )),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 600,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UniqueCode(
                                        email: email,
                                        hackathontitle: title,
                                      )));
                        },
                        child: Text(
                          "Create Team",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 50,
                      width: 600,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => JoinTeam(email: email)));
                        },
                        child: Text(
                          "Join Team",
                          style: TextStyle(color: Colors.black),
                        ),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10))),
                        ),
                      ),
                    )
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
