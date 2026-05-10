import 'package:flutter/material.dart';
import 'package:pixel/Screens/Desc.dart';
import 'package:pixel/Screens/event_home.dart';

class EventCard extends StatefulWidget {
  final String title;
  final String clubName;
  final String date;
  final String imageUrl;
  final String email;
  final VoidCallback onRegister;
  final String description;
  final String type;
  final String time;
  final String venue;

  const EventCard({
    super.key,
    required this.title,
    required this.clubName,
    required this.date,
    required this.imageUrl,
    required this.email,
    required this.onRegister,
    required this.description,
    required this.type,
    required this.time,
    required this.venue,
  });

  @override
  State<EventCard> createState() => _EventCardState();
}

class _EventCardState extends State<EventCard> {
  bool isRegistered = false;

  void handleRegister() {
    widget.onRegister();
    setState(() {
      isRegistered = true;
    });
  }

  Color getButtonColor(String type) {
    switch (type.toLowerCase()) {
      // Technical Events (Cool Colors)
      case 'webinar':
        return Colors.teal;
      case 'seminar':
        return const Color.fromARGB(255, 0, 149, 255);
      case 'workshop':
        return Colors.green;
      case 'hackathon':
        return Colors.blueGrey;
      case 'tech talk':
        return Colors.lightBlue;
      case 'panel discussion':
        return Colors.indigo;
      case 'code jam':
        return Colors.cyan;
      case 'tech exhibition':
        return Colors.blue;
      case 'bootcamp':
        return Colors.deepPurple;
      case 'ideathon':
        // return Colors.lightBlueAccent;
        return Colors.black;
      case 'robotics':
        return Colors.deepPurpleAccent;

      case 'showcase':
        return Colors.black;

      // Non-Technical Events (Warm Colors)
      case 'talent show':
        return Colors.redAccent;
      case 'movie night':
        return Colors.amber;
      case 'jam session':
        return const Color.fromARGB(255, 241, 21, 116);
      case 'treasure hunt':
        return Colors.deepOrange;
      case 'event': // Group Discussion
        return Colors.black;
      case 'sports':
        return Colors.deepOrangeAccent;
      case 'law':
        return Colors.amber;
      case 'poetry':
        return const Color.fromARGB(255, 234, 146, 74);

      // Default fallback
      default:
        return const Color.fromARGB(255, 205, 71, 71);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Description_Screen(
                        title: widget.title,
                        clubName: widget.clubName,
                        date: widget.date,
                        imageUrl: widget.imageUrl,
                        description: widget.description,
                        // type: widget.type,
                        venue: widget.venue,
                        email: widget.email,
                        time: widget.time,
                        type: widget.type,
                      )));
        },
        child: Container(
          width: 250,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
              side: const BorderSide(color: Colors.black12),
            ),
            elevation: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                  ),
                  child: widget.imageUrl.startsWith("http")
                      ? Image.network(
                          widget.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          widget.imageUrl,
                          height: 100,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                  // Navigator.push(context, route)
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: const TextStyle(
                              fontSize: 16,
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
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: getButtonColor(widget.type),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                        ),
                        child: Text(
                          widget.type,
                          style: const TextStyle(
                              fontSize: 13, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.clubName.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Colors.grey,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      // Text(
                      //   'Stop by!',
                      //   style: const TextStyle(
                      //     fontSize: 10,
                      //     color: Color.fromARGB(255, 245, 5, 5),
                      //     fontWeight: FontWeight.w900,
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
