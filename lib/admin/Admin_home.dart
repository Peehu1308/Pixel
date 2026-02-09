import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Check/data.dart';
import 'package:pixel/Components/event_box.dart';
import 'package:pixel/Components/navbar.dart';
import 'package:pixel/Screens/profile.dart';
import 'package:pixel/admin/choice.dart';
import 'package:pixel/admin/creat_admin.dart';
import 'package:pixel/admin/create_event.dart';
import 'package:pixel/admin/navbar_admin.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AdminHome extends StatefulWidget {
  final String email;
  const AdminHome({super.key, required this.email});

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  List<dynamic> Events = [];
  List<dynamic> Hackathons = [];
  List<dynamic> Calenders = [];

  @override
  void initState() {
    super.initState();
    fetchEventsData();
    fetchHackathonData();
    updatecalender();
  }

  Future<void> fetchEventsData() async {
    final response = await Supabase.instance.client.from('Events').select();
    setState(() {
      Events = response;
    });
  }

  Future<void> fetchHackathonData() async {
    final response = await Supabase.instance.client.from('Hackathon').select();
    setState(() {
      Hackathons = response;
    });
  }

  Future<void> updatecalender() async {
    final response = await Supabase.instance.client.from('Calender').select();
    setState(() {
      Calenders = response;
    });
  }

  Future<void> toggleRegister(
      String table, String itemId, String userEmail) async {
    final supabase = Supabase.instance.client;

    try {
      final response = await supabase
          .from(table)
          .select('Participants')
          .eq('id', itemId)
          .single();

      if (response == null) throw Exception("Item not found");

      List<dynamic> participants = response['Participants'] ?? [];

      if (!participants.contains(userEmail)) {
        participants.add(userEmail);

        await supabase
            .from(table)
            .update({'Participants': participants}).eq('id', itemId);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You are registered!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You're already registered.")),
        );
      }
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Registration failed.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Eventra",
            style: GoogleFonts.recursive(color: Colors.black, fontSize: 30)),
        backgroundColor: Colors.white,
        actions: [
          _profileButton(),
          _createEventButton(),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _searchBar(),
            _introBanner(),
            sectionTitle("Upcoming Non-Technical Events"),
            EventscrollView(
              Events.map((event) {
                return EventCard(
                  title: event['Name'] ?? 'Untitled Event',
                  clubName: event['Club_name'] ?? 'Unknown Club',
                  date: event['Date'] ?? 'Date TBD',
                  imageUrl: event['Image'] ?? '',
                  email: widget.email,
                  onRegister: () => toggleRegister(
                      'Events', event['id']?.toString() ?? '', widget.email),
                  description: event['Description'],
                  type: event['Type'],
                  time: event['Time'],
                  venue: event['Venue'],
                );
              }).toList(),
            ),
            sectionTitle("Upcoming Technical Events"),
            EventscrollView(
              Hackathons.map((hackathon) {
                return EventCard(
                  title: hackathon['Name'] ?? 'Untitled Hackathon',
                  clubName: hackathon['Club_Name'] ?? 'Unknown Host',
                  date: hackathon['date'] ?? 'Date TBD',
                  imageUrl: hackathon['Image_url'] ?? '',
                  email: widget.email,
                  onRegister: () => toggleRegister(
                      'Hackathon',
                      hackathon['id']?.toString() ?? '',
                      widget.email),
                  description: hackathon['Description'],
                  type: hackathon['Type'],
                  time:hackathon['Time'],
                  venue: hackathon['Venue'],
                );
              }).toList(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Navbar_Admin(currentIndex: 0, onTap: (index) {}, email: widget.email,),
    );
  }
  Widget _createEventButton() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: CircleAvatar(
        radius: 20,
        child: IconButton(
          onPressed: () {
            if (widget.email.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        Choice_Admin(email: widget.email)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("You need to be logged in to view profile")),
              );
            }
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("lib/assets/club.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _profileButton() {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      child: CircleAvatar(
        radius: 20,
        child: IconButton(
          onPressed: () {
            if (widget.email.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Profile(email: widget.email)),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text("You need to be logged in to view profile")),
              );
            }
          },
          icon: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage("lib/assets/profile.jpeg"),
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }

  
  Widget _searchBar() {
    return Container(
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        border: Border.all(color: Colors.black, width: 1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu, color: Colors.black),
          ),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.search, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _introBanner() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        
        width: 500,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.black,
          ),
          child: Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top:16.0,left: 16,right: 16),
                      child: Column(
                        children: [
                          // Text(
                          //   "Discover Amazing Events",
                          //   style: GoogleFonts.recursive(
                          //       fontSize: 21, color: Colors.white),
                          // ),
                          Text("Host hackathons, workshops, and more — create and manage your community events with ease.",
                              style: GoogleFonts.recursive(
                                  fontSize: 14, color: Colors.white)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              
                               ElevatedButton(onPressed: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (_)=>Choice_Admin(email: widget.email)));
                                }, child: Text("Create",style: GoogleFonts.recursive(fontSize:12,color: Colors.black)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical:3),
                                  backgroundColor: Colors.white,
                                  minimumSize: Size(8, 8),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  
                                ),
                                ),
                              
                              //  ElevatedButton(onPressed: (){
                              //     Navigator.push(context,MaterialPageRoute(builder: (_)=>Event_Screen(email: widget.email)));
                              //   }, child: Text("Explore Events",style: GoogleFonts.recursive(fontSize:8,color: Colors.white)),
                              //   style: ElevatedButton.styleFrom(
                              //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical:1),
                              //     backgroundColor: Colors.grey,
                              //     minimumSize: Size(8, 8),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(30),
                              //     ),
                                  
                              //   ),
                                
                              // ),
                              // ElevatedButton(onPressed: (){
                              //     Navigator.push(context,MaterialPageRoute(builder: (_)=>Event_Screen(email: widget.email)));
                              //   }, child: Text("Explore Events",style: GoogleFonts.recursive(fontSize:8,color: Colors.white)),
                              //   style: ElevatedButton.styleFrom(
                              //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical:1),
                              //     backgroundColor: Colors.grey,
                              //     minimumSize: Size(8, 8),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(30),
                              //     ),
                                  
                              //   ),
                                
                              // ),
                              // ElevatedButton(onPressed: (){
                              //     Navigator.push(context,MaterialPageRoute(builder: (_)=>Event_Screen(email: widget.email)));
                              //   }, child: Text("Explore Events",style: GoogleFonts.recursive(fontSize:8,color: Colors.white)),
                              //   style: ElevatedButton.styleFrom(
                              //     padding: const EdgeInsets.symmetric(horizontal: 4, vertical:1),
                              //     backgroundColor: Colors.grey,
                              //     minimumSize: Size(8, 8),
                              //     shape: RoundedRectangleBorder(
                              //       borderRadius: BorderRadius.circular(30),
                              //     ),
                                  
                              //   ),
                                
                              // ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Text(
          title,
          style: GoogleFonts.recursive(fontSize: 20, color: Colors.black),
        ),
      ),
    );
  }

  Widget EventscrollView(List<Widget> cards) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 1.0, vertical: 8.0),
        child: Row(children: cards),
      ),
    );
  }
}
