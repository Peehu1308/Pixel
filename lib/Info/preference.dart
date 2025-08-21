import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Info/hobbies.dart';
import 'package:pixel/Info/project.dart';
import 'package:pixel/Screens/Home_Screen.dart';
import 'package:pixel/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Preference extends StatefulWidget {
  final String email;  // Add email parameter like in Personal class

  const Preference({super.key, required this.email});  // Make it required

  @override
  State<Preference> createState() => _PreferenceState();
}

class _PreferenceState extends State<Preference> {
  final supabase = Supabase.instance.client;

  final List<String> topics = [
    'Technical',
    'AR/VR',
    'AI/ML',
    'Blockchain',
    'Web3',
    'Startups',
    'Hackathons',
    'Drones',
    'Microsoft',
    'Google',
  ];

  List<String> selectedTopics = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadPreferences();
    });
  }

  Future<void> loadPreferences() async {
    try {
      final response = await supabase
          .from('Users')
          .select('Liked')
          .eq('Email', widget.email)  // Use widget.email directly
          .maybeSingle();

      if (response != null && response['Liked'] != null) {
        setState(() {
          selectedTopics = List<String>.from(response['Liked']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading preferences: $e")),
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

  Future<void> savePreferences() async {
    try {
      final updates = {
        'Email': widget.email,  // Use widget.email directly as in Personal class
        'Liked': selectedTopics,
      };
      
      // Use the same upsert method that works in Personal class
      final result = await supabase
          .from('Users')
          .upsert(updates, onConflict: 'Email')
          .select();
      
      print("Preference save result: $result");
      
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Save failed. Try again!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Preferences saved successfully!")),
        );
      }
    } catch (e) {
      print("Error details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving preferences: $e")),
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
              "What types of events are you\ninterested in?",
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
    await savePreferences();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Project(email:  widget.email),  // Pass email here
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