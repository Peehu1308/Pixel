import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pixel/Screens/event.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class UniqueCode extends StatefulWidget {
  final String email;
  final String hackathontitle;
  const UniqueCode(
      {super.key, required this.email, required this.hackathontitle});

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
      _uniqueCode = uuid.v4();
    });
  }

  void _copytoClipboard() {
    Clipboard.setData(ClipboardData(text: _uniqueCode));
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Unique code has been copied to your clipboard')),
    );
  }

  Future<void> _createTeam() async {
    final supabase = Supabase.instance.client;
    final teamname = _teamnamecontroller.text.trim();
    if (teamname.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Teamname is required")));
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
        'Team_name':teamname
      });
      if (mounted){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Event_Screen(email: widget.email)));

      }
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Team created successfully')),
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
        backgroundColor: Colors.white,
        appBar:
            AppBar(backgroundColor: Colors.white, title: Text('Create Team')),
        body: Center(
            child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              
              Text("Unique Team code",style: TextStyle(fontSize: 30),),
              SizedBox(
                height: 20,
              ),
              Text(
                _uniqueCode,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: 20,
              ),TextField(
                controller: _teamnamecontroller,
                decoration: InputDecoration(
                  labelText: 'Enter your team name',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 50,
                width: 600,
                child: ElevatedButton(
                  onPressed: _generateUniqueCode,
                  child: Text(
                    'New Code',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              SizedBox(
                height: 50,
                width: 600,
                child: ElevatedButton(
                  onPressed: _copytoClipboard,
                  child: Text(
                    "Copy Code",
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(Colors.black),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)))),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _createTeam,
                child: const Text('Create Team',
                    style: TextStyle(color: Colors.white)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              )
            ],
          ),
        )));
  }
}
