import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';

class UpdateCommet extends StatefulWidget {
  final String userEmail; // Pass the user's email here

  const UpdateCommet({Key? key, required this.userEmail}) : super(key: key);

  @override
  State<UpdateCommet> createState() => _UpdateCommetState();
}

class _UpdateCommetState extends State<UpdateCommet> {
  final TextEditingController _commentController = TextEditingController();
  File? _selectedImage;
  bool _isUploading = false;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => _selectedImage = File(picked.path));
    }
  }

  Future<void> _submitComment() async {
    final supabase = Supabase.instance.client;
    final commentText = _commentController.text.trim();
    if (commentText.isEmpty) return;

    setState(() => _isUploading = true);

    String? imageUrl;
    if (_selectedImage != null) {
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final path = 'images/${widget.userEmail}/$fileName';
      final bytes = await _selectedImage!.readAsBytes();

      // Upload to Supabase Storage
      await supabase.storage.from('images').uploadBinary(
        path,
        bytes,
        fileOptions: const FileOptions(contentType: 'image/jpeg'),
      );

      imageUrl = supabase.storage.from('images').getPublicUrl(path);
    }
    final email=widget.userEmail;
    final UserResponse=await supabase
    .from('Users')
    .select('Name')
    .eq('Email', email)
    .single();
    final String Username = UserResponse['Name'] ?? 'Anonymous';

    // Insert into Supabase
    await supabase.from('Comments').insert({
      'email': widget.userEmail,
      'comment': commentText,
      'image': [imageUrl],
      'Username':Username,
    });

    // Reset state
    _commentController.clear();
    setState(() {
      _selectedImage = null;
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: _commentController,
          decoration: InputDecoration(
            labelText: 'Write a comment...',
            border: OutlineInputBorder(),
          ),
          maxLines: null,
        ),
        const SizedBox(height: 10),
        if (_selectedImage != null)
          Image.file(_selectedImage!, height: 120),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.image),
              onPressed: _pickImage,
            ),
            const Spacer(),
            IconButton(
              onPressed: _isUploading ? null : _submitComment,
              icon: Icon(Icons.send), color: Colors.black,
            ),
          ],
        ),
      ],
    );
  }
}
