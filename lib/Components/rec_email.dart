import 'dart:math';
import 'package:flutter/material.dart';
import 'package:pixel/Screens/viewer_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'viewer_profile.dart'; // import your viewer profile screen

class RecommendationsFromEmail extends StatefulWidget {
  final String email;

  const RecommendationsFromEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<RecommendationsFromEmail> createState() => _RecommendationsFromEmailState();
}

class _RecommendationsFromEmailState extends State<RecommendationsFromEmail> {
  late Future<List<Map<String, dynamic>>> recommendationsFuture;

  final List<String> topics = [
    'Competitive Programming', 'App Development', 'Web Development', 'Machine Learning', 'Robotics',
    'Cybersecurity', 'Blockchain', 'Game Development', 'UI/UX Design', 'Cloud Computing', 'Photography',
    'Graphic Designing', 'Content Writing', 'Poetry', 'Drama', 'Singing', 'Dancing', 'Debating',
    'Video Editing', 'Event Management', 'Technical', 'AR/VR', 'AI/ML', 'Web3', 'Startups', 'Hackathons',
    'Drones', 'Microsoft', 'Google', 'Artificial Intelligence', 'Mobile App Development', 'Data Science',
    'Internet of Things (IoT)', 'Augmented Reality', 'Virtual Reality', 'DevOps', 'Open Source Project',
    'Healthcare Technology', 'Education Technology', 'Finance & Fintech', 'Sustainability & Green Tech'
  ];

  @override
  void initState() {
    super.initState();
    recommendationsFuture = fetchRecommendations(widget.email);
  }

  Future<List<Map<String, dynamic>>> fetchRecommendations(String email) async {
    final response = await Supabase.instance.client
        .from('Users')
        .select();

    final List<Map<String, dynamic>> allUsers = List<Map<String, dynamic>>.from(response);

    final currentUser = allUsers.firstWhere((user) => user['Email'] == email, orElse: () => {});

    if (currentUser.isEmpty) return [];

    List<int> buildVector(Map<String, dynamic> user) {
      String liked = (user['Liked'] ?? []).join(' ').toString().toLowerCase();
      String hobbies = (user['Hobbies'] ?? []).join(' ').toString().toLowerCase();
      String projects = (user['Projects'] ?? []).join(' ').toString().toLowerCase();
      String profile = '$liked $hobbies $projects';

      return topics.map((topic) => profile.contains(topic.toLowerCase()) ? 1 : 0).toList();
    }

    double cosine(List<int> a, List<int> b) {
      int dot = 0;
      double magA = 0;
      double magB = 0;
      for (int i = 0; i < a.length; i++) {
        dot += a[i] * b[i];
        magA += a[i] * a[i];
        magB += b[i] * b[i];
      }
      if (magA == 0 || magB == 0) return 0;
      return dot / (sqrt(magA) * sqrt(magB));
    }

    List<int> currentVector = buildVector(currentUser);

    List<Map<String, dynamic>> others = allUsers.where((u) => u['Email'] != email).toList();

    others.sort((a, b) {
      double simA = cosine(currentVector, buildVector(a));
      double simB = cosine(currentVector, buildVector(b));
      return simB.compareTo(simA);
    });

    return others.take(4).toList(); // Show 4 recommendations
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: recommendationsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null || snapshot.data!.isEmpty) {
          return const Center(child: Text('No recommendations found.'));
        }

        final recommendations = snapshot.data!;

        return Column(
          children: recommendations.map((user) {
            final imageUrl = user['Image'] ?? '';
            final name = user['Name'] ?? 'No Name';
            final semester = user['Semester']?.toString() ?? 'Year';
            final List<dynamic> liked = user['Liked'] ?? [];
            final email=user['Email'] ?? '';

            final likedString = liked.take(2).join(", ") + (liked.length > 2 ? " Etc" : "");

            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: imageUrl.isNotEmpty
                            ? Image.network(imageUrl, width: 70, height: 70, fit: BoxFit.cover)
                            : Container(
                                width: 70,
                                height: 70,
                                color: Colors.grey[300],
                                child: const Icon(Icons.person, size: 40),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                            Text('$semester -Semester', style: const TextStyle(color: Colors.grey, fontSize: 14)),
                            const SizedBox(height: 4),
                            Text(likedString, style: const TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => ViewerProfile(email:email,)
                          ));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text('Know More', style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(thickness: 1),
                const SizedBox(height: 8),
              ],
            );
          }).toList(),
        );
      },
    );
  }
}
