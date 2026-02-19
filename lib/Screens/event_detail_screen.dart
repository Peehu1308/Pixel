import 'package:flutter/material.dart';
import 'package:pixel/Components/eventsbox_small.dart';

class EventDetailScreen extends StatelessWidget {
  final Map<String, dynamic> event;
  final int clubId;

  const EventDetailScreen({super.key, required this.event,required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(event['Name'] ?? 'Event Details',style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.black,
        
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (event['Image'] != null)
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(event['Image']),
                ),
              const SizedBox(height: 20),
              Text(
                event['Name'] ?? '',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "${event['Date']} at ${event['Time']}",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 20),
              Text(
                event['Description'] ?? 'No description provided.',
                style: const TextStyle(color: Colors.white),
              ),
              // Text("Projects",style: TextStyle(color: Colors.white,fontSize: 30),),
              // EventsboxSmall(clubId: clubId),
              
            ],
          ),
        ),
      ),
    );
  }
}
