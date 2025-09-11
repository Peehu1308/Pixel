import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pixel/admin/Admin_home.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CreateEvent extends StatefulWidget {
  final String email;
  const CreateEvent({super.key, required this.email});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  final TextEditingController eventName = TextEditingController();
  final TextEditingController date = TextEditingController();
  final TextEditingController description = TextEditingController();
  final TextEditingController teamSize = TextEditingController();
  final TextEditingController time = TextEditingController();
  final TextEditingController clubName = TextEditingController();
  final TextEditingController type = TextEditingController();
  final TextEditingController category = TextEditingController();

  String? selectedCategory;
  String? selectedEvent;

  final Map<String, List<String>> eventTypeOptions = {
    'Technical': [
      'Webinar',
      'Seminar',
      'Workshop',
      'Hackathon',
      'Tech Talk',
      'Panel Discussion',
      'Code Jam',
      'Tech Exhibition',
      'Bootcamp',
      'Ideathon',
      'Robotics'
    ],
    'Non-Technical': [
      'Talent Show',
      'Movie Night',
      'Jam Session',
      'Treasure Hunt',
      'GD',
      'Sports',
      'Poetry',
      'Law'
    ],
  };

  File? _image;

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _image = File(pickedImage.path);
      });
    }
  }

  File getDefaultImage() {
    return File('lib/assets/club.jpeg');
  }

  Future<void> uploadImage(String eventType, dynamic id) async {
    final supabase = Supabase.instance.client;
    final imageToUpload = _image ?? getDefaultImage();

    final fileName = DateTime.now().millisecondsSinceEpoch.toString();
    final path = 'upload/$fileName.jpg';

    try {
      await supabase.storage.from('images').upload(path, imageToUpload);
      final imageUrl = supabase.storage.from('images').getPublicUrl(path);

      final tableName = eventType == 'non-tech' ? 'Events' : 'Hackathon';
      final columnName = tableName == 'Events' ? 'Image' : 'Image_url';

      await supabase
          .from(tableName)
          .update({columnName: imageUrl})
          .eq('id', id)
          .select();
    } catch (e) {
      print("❌ Error uploading image: $e");
    }
  }

  Future<void> updateEvent() async {
    final supabase = Supabase.instance.client;
    final emailToUse = widget.email.trim();
    final categoryType = category.text.trim().toLowerCase();
    final tableName = categoryType == 'non-technical' ? 'Events' : 'Hackathon';

    try {
      final updates = categoryType == 'non-technical'
          ? {
              'Name': eventName.text.trim(),
              'Date': date.text.trim(),
              'Description': description.text.trim(),
              'Team_size': int.tryParse(teamSize.text.trim()) ?? 0,
              'Time': time.text.trim(),
              'Club_name': clubName.text.trim(),
              'Admin_email': emailToUse,
              'Type': type.text.trim(),
            }
          : {
              'Name': eventName.text.trim(),
              'date': date.text.trim(),
              'Description': description.text.trim(),
              'team_size': int.tryParse(teamSize.text.trim()) ?? 0,
              'Time': time.text.trim(),
              'Club_Name': clubName.text.trim(),
              'Admin_email': emailToUse,
              'Type': type.text.trim(),
            };

      final result =
          await supabase.from(tableName).upsert(updates, onConflict: 'Name').select();

      dynamic newId;
      if (result.isNotEmpty) {
        newId = result[0]['id'];
      }

      await uploadImage(categoryType, newId);

      final adminRecord = await supabase
          .from('admin')
          .select('Created_events')
          .eq('admin_email', emailToUse)
          .single();

      final List<dynamic> currentEvents =
          List.from(adminRecord['Created_events'] ?? []);

      if (result.isNotEmpty) {
        currentEvents.add(result[0]['id']);
      }

      await supabase
          .from('admin')
          .update({'Created_events': currentEvents}).eq('admin_email', emailToUse);

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminHome(email: widget.email)),
        );
      }
    } catch (e) {
      print("❌ Error saving event: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Create Event",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontSize: 22,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            buildImagePicker(),
            const SizedBox(height: 20),
            buildCategoryDropdown(),
            if (selectedCategory != null) buildEventDropdown(),
            buildInputField(eventName, 'Event Name'),
            buildDateSelector(date, 'Date'),
            buildInputField(description, 'Description'),
            buildInputField(teamSize, 'Team Size'),
            buildTimeSelector(time, 'Time'),
            buildInputField(clubName, 'Club Name'),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: updateEvent,
              child: Text(
                "Create Event",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget buildImagePicker() {
    return GestureDetector(
      onTap: pickImage,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: _image != null
                ? Image.file(_image!, height: 150, width: double.infinity, fit: BoxFit.cover)
                : Image.asset('lib/assets/club.jpeg',
                    height: 150, width: double.infinity, fit: BoxFit.cover),
          ),
          const SizedBox(height: 10),
          Text(
            "Tap to pick an image",
            style: GoogleFonts.poppins(color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget buildInputField(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: TextField(
        controller: controller,
        style: GoogleFonts.poppins(),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget buildCategoryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: DropdownButtonFormField<String>(
        value: selectedCategory,
        decoration: InputDecoration(
          labelText: "Select Category",
          labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        items: eventTypeOptions.keys
            .map((category) => DropdownMenuItem(
                  value: category,
                  child: Text(category, style: GoogleFonts.poppins()),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedCategory = value;
            selectedEvent = null;
            category.text = value!;
          });
        },
      ),
    );
  }

  Widget buildEventDropdown() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: DropdownButtonFormField<String>(
        value: selectedEvent,
        decoration: InputDecoration(
          labelText: "Select Event Type",
          labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
        items: eventTypeOptions[selectedCategory]!
            .map((type) => DropdownMenuItem(
                  value: type,
                  child: Text(type, style: GoogleFonts.poppins()),
                ))
            .toList(),
        onChanged: (value) {
          setState(() {
            selectedEvent = value;
            type.text = value!;
          });
        },
      ),
    );
  }

  Widget buildDateSelector(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () async {
          DateTime? pickedDate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(2000),
            lastDate: DateTime(2100),
          );
          if (pickedDate != null) {
            controller.text =
                "${pickedDate.year}-${pickedDate.month.toString().padLeft(2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildTimeSelector(TextEditingController controller, String label) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: GestureDetector(
        onTap: () async {
          TimeOfDay? pickedTime =
              await showTimePicker(context: context, initialTime: TimeOfDay.now());
          if (pickedTime != null) {
            controller.text = pickedTime.format(context);
          }
        },
        child: AbsorbPointer(
          child: TextField(
            controller: controller,
            style: GoogleFonts.poppins(),
            decoration: InputDecoration(
              labelText: label,
              labelStyle: GoogleFonts.poppins(color: Colors.grey[600]),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
