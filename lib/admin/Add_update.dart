import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';

class AddUpdateScreen extends StatefulWidget {
  final String userEmail;

  const AddUpdateScreen({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<AddUpdateScreen> createState() => _AddUpdateScreenState();
}

class _AddUpdateScreenState extends State<AddUpdateScreen> {
  final TextEditingController _headingController = TextEditingController();
  final TextEditingController _updateController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submitUpdate() async {
    final supabase = Supabase.instance.client;
    final heading = _headingController.text.trim();
    final updateText = _updateController.text.trim();

    if (heading.isEmpty || updateText.isEmpty) return;

    setState(() => _isUploading = true);

    String? imageUrl;
    if (_selectedImage != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'images/${widget.userEmail}/$fileName';
      final bytes = await _selectedImage!.readAsBytes();

      await supabase.storage.from('images').uploadBinary(
            path,
            bytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      imageUrl = supabase.storage.from('images').getPublicUrl(path);
    }

    await supabase.from('Updates').insert({
      'admin_id': widget.userEmail,
      'heading': heading,
      'Update': updateText,
      'Image': imageUrl,
    });

    _headingController.clear();
    _updateController.clear();
    setState(() {
      _selectedImage = null;
      _isUploading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("✅ Update posted successfully")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Add Update",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading Field
            TextField(
              controller: _headingController,
              decoration: InputDecoration(
                labelText: "Heading",
                labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.poppins(fontSize: 16),
            ),
            const SizedBox(height: 16),

            // Update Field
            TextField(
              controller: _updateController,
              decoration: InputDecoration(
                labelText: "Write an update...",
                labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
                filled: true,
                fillColor: Colors.grey[100],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              style: GoogleFonts.poppins(fontSize: 16),
              maxLines: null,
            ),
            const SizedBox(height: 20),

            // Preview Image
            if (_selectedImage != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  _selectedImage!,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            if (_selectedImage != null) const SizedBox(height: 20),

            // Actions Row
            Row(
              children: [
                // Pick Image
                IconButton(
                  icon: const Icon(Icons.image, color: Colors.black87),
                  onPressed: _pickImage,
                ),
                const Spacer(),

                // Post Button
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  onPressed: _isUploading ? null : _submitUpdate,
                  child: Text(
                    _isUploading ? "Posting..." : "Post",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
