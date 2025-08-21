import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixel/utils/encrypt.dart';
// import 'package:pixel/utils/encryptText.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pixel/Info/preference.dart';

class Personal extends StatefulWidget {
  final String email;
  final cryto = CryptoHelper();

  Personal({super.key, required this.email});

  @override
  State<Personal> createState() => _PersonalState();
}

class _PersonalState extends State<Personal> {
  final nameController = TextEditingController();
  final semesterController = TextEditingController();
  final universityController = TextEditingController();
  final contactController = TextEditingController();
  final techStackController = TextEditingController();
  final descriptionController = TextEditingController();
  final projectController = TextEditingController();

  File? _image;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<void> uploadImage() async {
    if (_image == null) return;

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'upload/$fileName.jpg';
    final supabase = Supabase.instance.client;

    try {
      // Upload the file
      await supabase.storage.from('images').upload(path, _image!);

      // Get public URL
      final imageUrl = supabase.storage.from('images').getPublicUrl(path);
      print("🌐 Uploaded image URL: $imageUrl");

      // Update the 'Image' column in the Users table
      await supabase
          .from('Users')
          .update({'Image': imageUrl})
          .eq('Email', widget.email)
          .select();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Image uploaded and profile updated successfully")),
      );
    } catch (e) {
      print("❌ Upload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
    }
  }

  Future<void> saveProfile() async {
    final supabase = Supabase.instance.client;
    final emailToUse = widget.email.trim();
    final crypto = CryptoHelper();

    print("📧 Attempting to save profile for email: $emailToUse");

    try {
      final updates = {
        'Email': emailToUse,
        'Name': crypto.encryptText(nameController.text.trim()),
        'Semester': int.tryParse(semesterController.text.trim()) ?? 0,
        'University': crypto.encryptText(universityController.text.trim()),
        'Contact': crypto.encryptText(contactController.text.trim()),
        'Tech_Stack': techStackController.text.trim().isNotEmpty
            ? techStackController.text
                .trim()
                .split(',')
                .map((e) => e.trim())
                .toList()
            : null,
        'Description': crypto.encryptText(descriptionController.text.trim()),
        'Project': projectController.text.trim().isNotEmpty
            ? projectController.text
                .trim()
                .split(',')
                .map((e) => e.trim())
                .toList()
            : null,
      };

      print("📝 Data to update: $updates");

      final result = await supabase
          .from('Users')
          .upsert(updates, onConflict: 'Email')
          .select();

      print("✅ Data saved to Supabase: $result");

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Preference(email: widget.email)),
        );
      }
    } catch (e) {
      print("❌ Save failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile for $emailToUse: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Profile',
            style: GoogleFonts.recursive(color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 150,
                height: 150,
                decoration: const BoxDecoration(shape: BoxShape.circle),
                child: ClipOval(
                  child: _image != null
                      ? Image.file(_image!,
                          fit: BoxFit.cover, width: 150, height: 150)
                      : Image.asset("lib/assets/profile.jpeg",
                          fit: BoxFit.cover, width: 150, height: 150),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: pickImage,
                child: const Text('Select Image'),
              ),
              ElevatedButton(
                onPressed: uploadImage,
                child: const Text('Upload Image'),
              ),
              const SizedBox(height: 20),
              buildInputField(nameController, 'Full Name'),
              buildInputField(semesterController, 'What semester are you in?'),
              buildInputField(universityController, 'University'),
              buildInputField(contactController, 'Phone Number'),
              buildInputField(
                  techStackController, 'Tech Stack (comma separated)'),
              buildInputField(descriptionController, 'Description'),
              buildInputField(projectController,
                  'Projects you have worked on? (comma separated)'),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: ElevatedButton(
                  onPressed: () {
                    saveProfile();
                    uploadImage();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text("Next", style: TextStyle(color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          fillColor: const Color.fromARGB(62, 238, 238, 238),
          filled: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 10),
        ),
      ),
    );
  }
}
