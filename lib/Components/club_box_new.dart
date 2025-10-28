import 'package:flutter/material.dart';
import 'package:pixel/Screens/clubdata.dart';

class ClubBoxNew extends StatelessWidget {
  final String clubname;
  final String imageUrl;
  final String description;
  final int clubId;

  const ClubBoxNew({
    super.key,
    required this.clubname,
    required this.imageUrl,
    required this.description,required this.clubId,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ClubData(
                clubName: clubname,
                imageUrl: imageUrl, description_club:description,
                clubId: clubId,
              ),
            ),
          );
        },
        child: Material(
          color: Colors.white,
          elevation: 6,
          borderRadius: BorderRadius.circular(15),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Stack(
              children: [
                // Background image
                Image.network(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
        
                // Black tint overlay
                Container(
                  width: double.infinity,
                  height: 200,
                  color: Colors.black.withOpacity(0.4),
                ),
        
                // Text content
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        clubname,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        description,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                          
                        ),
                        maxLines: 2,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

