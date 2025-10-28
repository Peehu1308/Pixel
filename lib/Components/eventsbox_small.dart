import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class EventsboxSmall extends StatefulWidget {
  final int clubId; // Fetch projects for this club ID

  const EventsboxSmall({super.key, required this.clubId});

  @override
  State<EventsboxSmall> createState() => _EventsboxSmallState();
}

class _EventsboxSmallState extends State<EventsboxSmall> {
  late Future<List<Map<String, dynamic>>> _futureProjects;

  Future<List<Map<String, dynamic>>> fetchProjects() async {
    try {
      final response = await Supabase.instance.client
          .from('Projects')
          .select('project_title, project_description')
          .eq('club_id', widget.clubId);

      if (response.isEmpty) {
        return [];
      }
      return List<Map<String, dynamic>>.from(response);
    } catch (error, stack) {
      print('❌ Error fetching projects: $error');
      print(stack);
      return [];
    }
  }

  @override
  void initState() {
    super.initState();
    _futureProjects = fetchProjects();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _futureProjects,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: CircularProgressIndicator(color: Colors.white),
            ),
          );
        } else if (snapshot.hasError) {
          return const Center(
            child: Text(
              "Error fetching events",
              style: TextStyle(color: Colors.redAccent),
            ),
          );
        } else if (snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              "No live events available",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),
          );
        }

        final projects = snapshot.data!;

        return Column(
          children: projects.map((p) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Container(
                height: 130,
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['project_title'] ?? 'Untitled Event',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        p['project_description'] ?? 'No description available',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.7),
                          fontSize: 14,
                          height: 1.4,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          onPressed: () {
                            _showProjectDialog(
                              context,
                              title: p['project_title'] ?? 'Untitled Event',
                              description: p['project_description'] ?? '',
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            "View Details",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showProjectDialog(BuildContext context,
      {required String title, required String description}) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white24, width: 1),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 15),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 25),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  alignment: WrapAlignment.center,
                  children: [
                    _dialogButton("I Visited the Stall", Icons.location_on),
                    _dialogButton("I Liked the Project", Icons.favorite_border),
                    _dialogButton("Recommend Improvements", Icons.lightbulb_outline),
                  ],
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    "Close",
                    style: TextStyle(color: Colors.white70),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _dialogButton(String text, IconData icon) {
    return ElevatedButton.icon(
      onPressed: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$text selected!',style: TextStyle(color: Colors.white),),
            backgroundColor: Colors.black,
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            duration: const Duration(seconds: 1),
          ),
        );
      },
      icon: Icon(icon, color: Colors.black),
      label: Text(
        text,
        style: const TextStyle(color: Colors.black, fontSize: 13),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
