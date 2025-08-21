import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Screens/Home_Screen.dart';
// import 'package:pixel/Screens/main.dart';
import 'package:pixel/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Hobbies extends StatefulWidget {
  final String email;  // Add email parameter like in Personal class

  const Hobbies({super.key, required this.email});  // Make it required

  @override
  State<Hobbies> createState() => _HobbiesState();
}

class _HobbiesState extends State<Hobbies> {
  final supabase = Supabase.instance.client;

  final List<String> topics = [
    'Competitive Programming', 'App Development', 'Web Development', 'Machine Learning', 'Robotics', 'Cybersecurity', 'Blockchain', 'Game Development', 'UI/UX Design', 'Cloud Computing', 'Photography', 'Graphic Designing', 'Content Writing', 'Poetry', 'Drama', 'Singing', 'Dancing', 'Debating', 'Video Editing', 'Event Management'

  ];

  List<String> selectedTopics = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadHobbiess();
    });
  }

  Future<void> loadHobbiess() async {
    try {
      final response = await supabase
          .from('Users')
          .select('Hobbies')
          .eq('Email', widget.email)  // Use widget.email directly
          .maybeSingle();

      if (response != null && response['Hobbies'] != null) {
        setState(() {
          selectedTopics = List<String>.from(response['Hobbies']);
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error loading Hobbiess: $e")),
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

  Future<void> saveHobbiess() async {
    try {
      final updates = {
        'Email': widget.email,  // Use widget.email directly as in Personal class
        'Hobbies': selectedTopics,
      };
      
      // Use the same upsert method that works in Personal class
      final result = await supabase
          .from('Users')
          .upsert(updates, onConflict: 'Email')
          .select();
      
      print("Hobbies saved save result: $result");
      
      if (result.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Save failed. Try again!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Hobbies saved saved successfully!")),
        );
      }
    } catch (e) {
      print("Error details: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving Hobbiess: $e")),
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
              "What are your hobbies?",
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
    await saveHobbiess();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(email: widget.email),  // Pass email here
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