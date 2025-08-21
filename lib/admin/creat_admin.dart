import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:pixel/admin/Admin_home.dart';
import 'package:pixel/admin/create_event.dart';

class Createadmin extends StatefulWidget {
  final String email;
  const Createadmin({super.key, required this.email});

  @override
  State<Createadmin> createState() => _CreateadminState();
}

class _CreateadminState extends State<Createadmin> {
  final adminNameController = TextEditingController();
  final clubNameController = TextEditingController();
  // final createdEventsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    checkIfAdminExists();
  }

  Future<void> checkIfAdminExists() async {
    final supabase = Supabase.instance.client;
    final email = widget.email.trim();

    try {
      final response = await supabase
          .from('admin')
          .select()
          .eq('admin_email', email)
          .maybeSingle();

      if (response != null) {
        adminNameController.text = response['admin_name'] ?? '';
        clubNameController.text = response['Club_name'] ?? '';
        print("updated the data");
      }
    } catch (e) {
      print("Error checking admin existence: $e");
    }
  }

  Future<void> createAdminProfile() async {
    final supabase = Supabase.instance.client;
    final email = widget.email.trim();
    final name = adminNameController.text.trim();
    final club = clubNameController.text.trim();
    

    final data = {
      'admin_email': email,
      'admin_name': name,
      'Club_name': club,
      
    };

    try {
      print("📤 Sending admin data to Supabase: $data");

      final response = await supabase
          .from('admin')
          .upsert(data, onConflict: 'admin_email')
          .select();

      print("Admin created: $response");

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CreateEvent(email: widget.email),
          ),
        );
      }
    } catch (e) {
      print("Error creating admin: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to create admin profile.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Admin Profile"),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            buildInputField(adminNameController, "Admin Name"),
            buildInputField(clubNameController, "Club Name"),
            // buildInputField(createdEventsController, "Created Events (optional)")
            ElevatedButton(
              onPressed: createAdminProfile,
              child: const Text("Submit"),
            ),
          ],
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
