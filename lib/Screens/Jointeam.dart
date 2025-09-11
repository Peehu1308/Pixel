import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Screens/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class JoinTeam extends StatefulWidget {
  final String email;
  const JoinTeam({super.key, required this.email});

  @override
  State<JoinTeam> createState() => _JoinTeamState();
}

class _JoinTeamState extends State<JoinTeam> {
  final TextEditingController _uniquecode = TextEditingController();

  Future<void> jointeam() async {
    final supabase = Supabase.instance.client;
    final inputcode = _uniquecode.text.trim();

    try {
      final response = await supabase
          .from('Hackathon_User')
          .select()
          .eq('unique_id', inputcode)
          .single();

      if (response.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('❌ Invalid team code')),
        );
        return;
      }

      List<dynamic> currentMember = response['Members'];
      if (currentMember.contains(widget.email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('⚠️ You are already in the team')),
        );
        return;
      }

      currentMember.add(widget.email);

      await supabase
          .from('Hackathon_User')
          .update({'Members': currentMember}).eq('unique_id', inputcode);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Successfully joined the team')),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Event_Screen(email: widget.email)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Join Team",
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Enter your team's unique code to join",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Input field
              TextField(
                controller: _uniquecode,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  labelText: "Team Code",
                  labelStyle: GoogleFonts.poppins(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),

              const SizedBox(height: 25),

              // Join Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: jointeam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Join Team",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
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
