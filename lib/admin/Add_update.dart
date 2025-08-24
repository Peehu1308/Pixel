import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
      'Image': imageUrl, // make column text[] if multiple images
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
      appBar: AppBar(title: const Text("Add Update")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _headingController,
              decoration: const InputDecoration(
                labelText: "Heading",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _updateController,
              decoration: const InputDecoration(
                labelText: "Write an update...",
                border: OutlineInputBorder(),
              ),
              maxLines: null,
            ),
            const SizedBox(height: 12),
            if (_selectedImage != null) Image.file(_selectedImage!, height: 120),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.image),
                  onPressed: _pickImage,
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: _isUploading ? null : _submitUpdate,
                  icon: const Icon(Icons.send),
                  label: _isUploading
                      ? const Text("Posting...")
                      : const Text("Post"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
