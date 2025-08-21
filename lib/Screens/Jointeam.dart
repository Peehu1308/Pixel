import 'package:flutter/material.dart';
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
          const SnackBar(content: Text('Invalid team code')),
        );
        return;
      }

      List<dynamic> currentMember = response['Members'];
      if (currentMember.contains(widget.email)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are already in the team')),
        );
        return;
      }

      currentMember.add(widget.email);

      await supabase
          .from('Hackathon_User')
          .update({'Members': currentMember}).eq('unique_id', inputcode);

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: const Text('Successfully joined the team')));
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Event_Screen(email: widget.email)),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error:${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Join Team'),
      ),
      body: Padding(padding: 
      EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _uniquecode,
            decoration: const InputDecoration(
                labelText: "Enter Team's Unique Code",
                border: OutlineInputBorder(),
              ),
          ),
          const SizedBox(height:20),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(onPressed: jointeam, 
            child:Text('Join Team'),
            style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),),
          )
        ],
      ),),
    );
  }
}
