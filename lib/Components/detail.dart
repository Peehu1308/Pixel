import 'package:flutter/material.dart';
class HackathonDetailPage extends StatelessWidget {
  final int id;

  const HackathonDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch hackathon detail using the id if needed
    return Scaffold(
      appBar: AppBar(title: Text("Hackathon Detail")),
      body: Center(child: Text("Hackathon ID: $id")),
    );
  }
}

class EventDetailPage extends StatelessWidget {
  final int id;

  const EventDetailPage({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Fetch event detail using the id if needed
    return Scaffold(
      appBar: AppBar(title: Text("Event Detail")),
      body: Center(child: Text("Event ID: $id")),
    );
  }
}
