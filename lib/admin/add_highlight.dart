import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixel/admin/adminevent.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddingFrames extends StatefulWidget {
  final String email;
  const AddingFrames({super.key, required this.email});

  @override
  State<AddingFrames> createState() => _AddingFramesState();
}

class _AddingFramesState extends State<AddingFrames> {
  final clubcontroller = TextEditingController();
  File? _image;
  bool _isLoading = false;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  Future<String?> uploadImage() async {
    if (_image == null) return null;

    final supabase = Supabase.instance.client;
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'upload/$fileName.jpg';

    try {
      await supabase.storage.from('images').upload(path, _image!);
      final imageUrl = supabase.storage.from('images').getPublicUrl(path);
      print("✅ Uploaded image url: $imageUrl");
      return imageUrl;
    } catch (e) {
      print("❌ Upload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
      return null;
    }
  }

  Future<void> saveData() async {
    final supabase = Supabase.instance.client;
    final emailToUse = widget.email.trim();
    final clubName = clubcontroller.text.trim().toUpperCase();

    if (clubName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter the club name")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final updates = {
        'admin_email': emailToUse,
        'club_name': clubName,
      };
      print("Saving data: $updates");

      await supabase
          .from('Highlights')
          .upsert(updates, onConflict: 'admin_email')
          .select();

      // Step 1: Get existing images
      final existingData = await supabase
          .from('Highlights')
          .select('images')
          .eq('admin_email', emailToUse)
          .maybeSingle();

      List<dynamic> existingImages = existingData?['images'] ?? [];

      // Step 2: Upload new image
      String? newImageUrl = await uploadImage();

      // Step 3: Append and update array
      if (newImageUrl != null) {
        existingImages.add(newImageUrl);

        await supabase
            .from('Highlights')
            .update({'images': existingImages})
            .eq('admin_email', emailToUse)
            .select();
        print("✅ Image URL updated in database with multiple images");
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile saved successfully")),
      );

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Adminevent(email: widget.email),
          ),
        );
      }
    } catch (e) {
      print("❌ Save failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving profile: $e")),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          'Add Frames',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              GestureDetector(
                onTap: _isLoading ? null : pickImage,
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black.withOpacity(0.2),
                      width: 2,
                      style: BorderStyle.solid,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: _image != null
                        ? Image.file(_image!, fit: BoxFit.cover)
                        : Image.asset("lib/assets/profile.jpeg",
                            fit: BoxFit.cover),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Club name field
              buildInputField(clubcontroller, 'Enter your Club name'),

              const SizedBox(height: 24),

              // Next button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : saveData,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Done",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
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
    return TextField(
      controller: controller,
      style: GoogleFonts.poppins(fontSize: 15),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          color: Colors.black54,
          fontSize: 14,
        ),
        filled: true,
        fillColor: Colors.grey.shade100,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
