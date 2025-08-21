import 'package:flutter/material.dart';
import 'package:pixel/Info/personal.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewerProfile extends StatefulWidget {
  final String email;
  const ViewerProfile({super.key, required this.email});

  @override
  State<ViewerProfile> createState() => _ViewerProfileState();
}

class _ViewerProfileState extends State<ViewerProfile> {
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
    fetchViewerProfileData();
  }

  Future<void> fetchViewerProfileData() async {
    try {
      final response = await supabase
          .from('Users')
          .select()
          .eq('Email', widget.email)
          .maybeSingle();

      if (response != null) {
        setState(() {
          name = response['Name'] ?? '';
          university = response['University'] ?? '';
          semester = response['Semester'] ?? 0;
          description = response['Description'] ?? '';
          contact = response['Contact'] ?? '';
          image = response['Image'] ?? '';
          techStack = List<String>.from(response['Tech_Stack'] ?? []);
          projects = List<String>.from(response['Project'] ?? []);
          likedTopics = List<String>.from(response['Liked'] ?? []);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No ViewerProfile data found.")),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching ViewerProfile data: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: Scaffold(
        backgroundColor: Colors.grey[100],
        body: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    Stack(
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
                                    : const AssetImage("lib/assets/ViewerProfile.jpeg")
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
                            backgroundColor:
                                const Color.fromARGB(45, 255, 255, 255),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.black),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                            ),
                          ),
                        ),
                        // Positioned(
                        //   top: 10,
                        //   right: 16,
                        //   child: CircleAvatar(
                        //     backgroundColor:
                        //         const Color.fromARGB(224, 102, 114, 103),
                        //     // child: IconButton(
                        //     //     onPressed: () {
                        //     //       Navigator.push(
                        //     //           context,
                        //     //           MaterialPageRoute(
                        //     //             builder: (context) =>
                        //     //                 Personal(email: widget.email),
                        //     //           ));
                        //     //     },
                        //     //     icon:
                        //     //         const Icon(Icons.edit, color: Colors.black)),
                        //   ),
                        // ),
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
                    ),
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
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Contact: $contact")),
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
                          "Contact",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget buildCard({required String title, required Widget child}) {
    return Container(
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
        // crossAxisAlignment: CrossAxisAlignment.start,
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
}
