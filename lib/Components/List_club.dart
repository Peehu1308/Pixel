// import 'package:chatbox/chatbox.dart';
import 'package:flutter/material.dart';
import 'package:pixel/Components/chatbox_club.dart';

class Club_List extends StatelessWidget {
  final String clubName;
  // final String joinclub;
  final String imageUrl;
  // final String join_community;

  const Club_List({
    super.key,
    required this.clubName,
    // required this.joinclub,
    required this.imageUrl,
    // required this.join_community,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      elevation: 6,
      
      child: Container(
        
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 5),
              
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start, // Align top
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                imageUrl,
                height: 80,
                width: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
      
            // Club Name and Buttons on the right
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clubName,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ChatBoxClub(clubname: clubName, image: imageUrl,)));
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            "Join Chat",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 12),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextButton(
                          onPressed: () {},
                          style: TextButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                                side: BorderSide(color: Colors.black)),
                          ),
                          child: Text(
                            "Join Club",
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                                color: Colors.black, fontSize: 12),
                          ),
                        ),
                      ),
                    ],
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
