import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Info/hobbies.dart';
import 'package:pixel/Screens/Home_Screen.dart';
import 'package:pixel/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Project extends StatefulWidget {
  final String email;  // Add email parameter like in Personal class

  const Project({super.key, required this.email});  // Make it required

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  final supabase = Supabase.instance.client;

  final List<String> topics = [
  'Artificial Intelligence', 'Machine Learning', 'Web Development', 'Mobile App Development', 'Blockchain', 'Cybersecurity', 'Game Development', 'Data Science', 'Internet of Things (IoT)', 'Augmented Reality', 'Virtual Reality', 'Cloud Computing', 'UI/UX Design', 'DevOps', 'Open Source Project', 'Healthcare Technology', 'Education Technology', 'Finance & Fintech', 'Sustainability & Green Tech', 'Robotics'

  ];

  List<String> selectedTopics = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadProjects();
    });
  }

  Future<void> loadProjects() async {
    try {
      final response = await supabase
          .from('Users')
          .select('Projects')
          .eq('Email', widget.email)  // Use widget.email directly
          .maybeSingle();

      if (response != null && response['Projects'] != null) {
        setState(() {
          selectedTopics = List<String>.from(response['Project']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading Project")),
      );
    }
  }

  void toggleTopic(String topic) {
    setState(() {
      if (selectedTopics.contains(topic)) {
        selectedTopics.remove(topic);
      } else {
        selectedTopics.add(topic);
      }
    });
  }

  Future<void> saveProjects() async {
    try {
      final updates = {
        'Email': widget.email,  // Use widget.email directly as in Personal class
        'Projects': selectedTopics,
      };
      
      // Use the same upsert method that works in Personal class
      final result = await supabase
          .from('Users')
          .upsert(updates, onConflict: 'Email')
          .select();
      
      print("Project saved save result: $result");
      
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Save failed. Try again!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Project saved saved successfully!")),
        );
      }
    } catch (e) {
      print("Error details");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving Projects")),
      );
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
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "What kind of projects would you like to work on in the future?",
              style: GoogleFonts.recursive(
                fontSize: 20,
                color: Colors.black,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Expanded(
              child: GridView.builder(
                itemCount: topics.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 2.5,
                ),
                itemBuilder: (context, index) {
                  final topic = topics[index];
                  final isSelected = selectedTopics.contains(topic);

                  return ElevatedButton.icon(
                    onPressed: () => toggleTopic(topic),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isSelected ? Colors.blue : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    icon: isSelected
                        ? const Icon(Icons.check, color: Colors.white)
                        : const SizedBox.shrink(),
                    label: Text(
                      topic,
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
  onPressed: () async {
    await saveProjects();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Hobbies(email: widget.email),  // Pass email here
      ),
    );
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.green,
    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: const Text(
    "Done",
    style: TextStyle(fontSize: 18, color: Colors.white),
  ),
),

          ],
        ),
      ),
    );
  }
}