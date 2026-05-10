import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixel/utils/encrypt.dart';
import 'package:pixel/admin/adminevent.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddingFrames extends StatefulWidget {
  final String email;
  const AddingFrames({super.key, required this.email});

  @override
  State<AddingFrames> createState() => _AddingFramesState();
}

class _AddingFramesState extends State<AddingFrames> {
  File? _image;
  bool _isLoading = false;
  String? _username;
  final cryto = CryptoHelper();

  @override
  void initState() {
    super.initState();
    getName(); // fetch username on load
  }

  /// Get Name from Users table
  Future<void> getName() async {
    final supabase = Supabase.instance.client;
    final emailToUse = widget.email.trim();

    try {
      final userResponse = await supabase
          .from('Users')
          .select('Name')
          .eq('Email', emailToUse)
          .single();

      setState(() {
        _username = cryto.decryptText(userResponse['Name']) ?? 'Anonymous';
      });
    } catch (e) {
      // print("❌ Failed to fetch user name: $e");
      setState(() {
        _username = 'Anonymous';
      });
    }
  }

  /// Pick image from gallery
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _image = File(image.path);
      });
    }
  }

  /// Upload image to Supabase Storage
  Future<String?> uploadImage() async {
    if (_image == null) return null;

    final supabase = Supabase.instance.client;
    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'upload/$fileName.jpg';

    try {
      await supabase.storage.from('images').upload(path, _image!);
      final imageUrl = supabase.storage.from('images').getPublicUrl(path);
      // print("✅ Uploaded image url: $imageUrl");
      return imageUrl;
    } catch (e) {
      // print("❌ Upload failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Upload failed: $e")),
      );
      return null;
    }
  }

  /// Save data to frames table
  Future<void> saveData() async {
    final supabase = Supabase.instance.client;

    if (_username == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("User not loaded yet")),
      );
      return;
    }

    if (_image == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please select an image")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Upload image
      String? newImageUrl = await uploadImage();

      if (newImageUrl == null) return;

      // Insert into frames table
      final updates = {
        'user': _username,
        'Images': [newImageUrl], // array of images
        'likes': 0,
      };

      await supabase.from('frames').insert(updates);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Frame added successfully")),
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
      // print("❌ Save failed: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving frame")),
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
              // Profile Image Picker
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

              // Done button
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
}
