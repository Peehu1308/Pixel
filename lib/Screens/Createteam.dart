import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Screens/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UniqueCode extends StatefulWidget {
  final String email;
  final String hackathontitle;
  const UniqueCode({super.key, required this.email, required this.hackathontitle});

  @override
  State<UniqueCode> createState() => _UniqueCodeState();
}

class _UniqueCodeState extends State<UniqueCode> {
  late String _uniqueCode;
  final TextEditingController _teamnamecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _generateUniqueCode();
  }

  void _generateUniqueCode() {
    const uuid = Uuid();
    setState(() {
      _uniqueCode = uuid.v4().substring(0, 8).toUpperCase(); // shorter & cleaner
    });
  }

  void _copytoClipboard() {
    Clipboard.setData(ClipboardData(text: _uniqueCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Code copied to clipboard!')),
    );
  }

  Future<void> _createTeam() async {
    final supabase = Supabase.instance.client;
    final teamname = _teamnamecontroller.text.trim();
    if (teamname.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("⚠️ Team name is required")),
      );
      return;
    }
    try {
      final response = await supabase
          .from('Hackathon')
          .select()
          .eq('Name', widget.hackathontitle)
          .single();

      final hackathonid = response['hackathon_id'];
      final teamsize = response['team_size'];

      await supabase.from('Hackathon_User').insert({
        'unique_id': _uniqueCode,
        'Leader': widget.email,
        'Members': [widget.email],
        'hackathon_id': hackathonid,
        'size': teamsize,
        'Team_name': teamname,
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => Event_Screen(email: widget.email)),
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('🎉 Team created successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('❌ Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Create Team",
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontWeight: FontWeight.w600,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Your Unique Team Code",
                style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Code Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    _uniqueCode,
                    style: GoogleFonts.poppins(
                      fontSize: 26,
                      color: Colors.white,
                      letterSpacing: 2,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // Team name input
              TextField(
                controller: _teamnamecontroller,
                decoration: InputDecoration(
                  labelText: 'Enter your team name',
                  labelStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.grey.shade100,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
              ),
              const SizedBox(height: 25),

              // Buttons
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _generateUniqueCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Generate New Code",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _copytoClipboard,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Copy Code", style: TextStyle(fontSize: 16)),
                ),
              ),
              const SizedBox(height: 14),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _createTeam,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Create Team",
                      style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
