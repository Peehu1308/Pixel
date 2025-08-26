import 'package:flutter/material.dart';
import 'package:pixel/Screens/Desc.dart';
import 'package:pixel/Screens/event_home.dart';

class ClubBox extends StatefulWidget {
  final String title;
  final String clubName;
  final String date;
  final String imageUrl;
  final String description;
  final String email;
  final String time;

  const ClubBox({
    super.key,
    required this.title,
    required this.clubName,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.email,
    required this.time
  });


  @override
  State<ClubBox> createState() => _EventCardState();
}

class _EventCardState extends State<ClubBox> {
  bool isRegistered = false;

  void toggleRegister() {
    setState(() {
      isRegistered = !isRegistered;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      
      width: MediaQuery.of(context).size.width - 20,
      // height: 150,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
          side: const BorderSide(color: Colors.black12),
        ),
        elevation: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(15),
                topRight: Radius.circular(15),
              ),
              child: Image.network(
                widget.imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 150,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(width: 1),
                      Text(
                        widget.date,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color.fromARGB(59, 0, 0, 0),
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => Description_Screen(
                      //       description: widget.description,
                      //       title: widget.title,
                      //       clubName: widget.clubName,
                      //       date: widget.date,
                      //       imageUrl: widget.imageUrl,
                      //       email: widget.email,
                      //       time: widget.time, 
                      //       type: widget.ty,
                      //     ),
                      //   ),
                      // );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                    child: Text(
                      "Read More",
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 12, bottom: 12),
              child: Text(
                widget.clubName,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
