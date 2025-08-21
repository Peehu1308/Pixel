import 'package:flutter/material.dart';
import 'package:pixel/Info/personal.dart';
import 'package:pixel/Screens/Sign_up.dart';
import 'package:pixel/utils/encrypt.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'package:pixel/utils/decrypt.dart';

class Profile extends StatefulWidget {
  final String email;
  final cryto = CryptoHelper(); // Assumes decryptText method exists

  Profile({super.key, required this.email});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final supabase = Supabase.instance.client;

  String name = '';
  String university = '';
  String description = '';
  String contact = '';
  int semester = 0;
  List<String> techStack = [];
  List<String> projects = [];
  List<String> likedTopics = [];
  bool isLoading = true;
  String image = '';

  @override
  void initState() {
    super.initState();
    fetchProfileData();
  }

  Future<void> fetchProfileData() async {
    try {
      final response = await supabase
          .from('Users')
          .select()
          .eq('Email', widget.email)
          .maybeSingle();

      if (response != null) {
        setState(() {
          name = widget.cryto.decryptText(response['Name'] ?? '');
//           String rawName = response['Name'] ?? '';
// print("Encrypted Name: $rawName");

// try {
//   name = widget.cryto.decryptText(rawName);
// } catch (e) {
//   print("Decryption failed for Name: $e");
//   name = "[Decryption Failed]";
// }

          university = widget.cryto.decryptText(response['University'] ?? '');
          semester = response['Semester'] ?? 0;
          description = widget.cryto.decryptText(response['Description'] ?? '');
          contact = widget.cryto.decryptText(response['Contact'] ?? '');
          image = response['Image'] ?? '';

          // Decrypt list fields
          techStack = List<String>.from(
            (response['Tech_Stack'] ?? []).map((e) => widget.cryto.decryptText(e)),
          );

          projects = List<String>.from(
            (response['Project'] ?? []).map((e) => widget.cryto.decryptText(e)),
          );

          likedTopics = List<String>.from(response['Liked'] ?? []);

          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No profile data found.")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching profile data: $e")),
        
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  buildHeaderImage(),
                  buildCard(title: "About Me", child: Text(description)),
                  buildCard(
                    title: "Tech Stack",
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: techStack
                          .map((tech) => Chip(
                                label: Text(tech),
                                backgroundColor: Colors.grey[200],
                              ))
                          .toList(),
                    ),
                  ),
                  buildCard(
                    title: "Projects",
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: projects.length,
                      itemBuilder: (context, index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Row(
                          children: [
                            const Icon(Icons.code, color: Colors.black54),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(projects[index],
                                  style: const TextStyle(fontSize: 15)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  buildCard(
                    title: "Liked Topics",
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: likedTopics
                          .map((topic) => Chip(
                                label: Text(topic),
                                backgroundColor: Colors.grey[200],
                              ))
                          .toList(),
                    ),
                  ),
                  buildActionButtons(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget buildHeaderImage() {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Container(
            height: 400,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              image: DecorationImage(
                image: image.isNotEmpty
                    ? NetworkImage(image)
                    : const AssetImage("lib/assets/profile.jpeg")
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Positioned(
          top: 10,
          left: 16,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(45, 255, 255, 255),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        Positioned(
          top: 10,
          right: 16,
          child: CircleAvatar(
            backgroundColor: const Color.fromARGB(224, 102, 114, 103),
            child: IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Personal(email: widget.email),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.black),
            ),
          ),
        ),
        Positioned(
          bottom: 20,
          left: 32,
          right: 32,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                const SizedBox(height: 4),
                Text("$university - Semester $semester",
                    style: const TextStyle(
                        fontSize: 16, color: Colors.white70)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget buildActionButtons() {
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              // ScaffoldMessenger.of(context).showSnackBar(
              //   SnackBar(content: Text("Contact: $contact")),
                
              // );
              

            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "Contact",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: ElevatedButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SignUpScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 50),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              "LogOut",
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }
}
