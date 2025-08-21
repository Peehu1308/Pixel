import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Check/data.dart';
import 'package:pixel/Components/event_box.dart';
import 'package:pixel/Components/feedback_box.dart';
import 'package:pixel/Screens/Calender.dart';
import 'package:pixel/Screens/Sign_up.dart';
import 'package:pixel/Screens/cal.dart';
import 'package:pixel/Screens/event.dart';
import 'package:pixel/Screens/feedback_list.dart';
import 'package:pixel/Screens/profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class Home_Screen extends StatefulWidget {
  final String email;

  const Home_Screen({super.key, required this.email});

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  List<dynamic> Events = [];
  List<dynamic> Hackathons = [];
  List<dynamic> Calenders = [];
  String profileImage = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchEventsData();
    fetchHackathonData();
    updateCalender();
    fetchProfileImage();
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

  Future<void> updateCalender() async {
    final response = await Supabase.instance.client.from('Calender').select();
    setState(() {
      Calenders = response;
    });
  }

  Future<void> fetchProfileImage() async {
    final response = await Supabase.instance.client
        .from('Users')
        .select('Image')
        .eq('Email', widget.email)
        .maybeSingle();

    if (response != null && mounted) {
      setState(() {
        profileImage = response['Image'] ?? '';
      });
    }
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
          const SnackBar(content: Text("You are registered!")),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("You're already registered.")),
        );
      }
    } catch (e) {
      print("Error: \$e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Registration failed.")),
      );
    }
  }

  void _showHalfDialog(BuildContext context) {
    showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: 'Menu',
        transitionDuration: const Duration(milliseconds: 100),
        pageBuilder: (context, animation1, animation2) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.8,
                height: MediaQuery.of(context).size.height,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                        margin: const EdgeInsets.only(top: 10),
                        child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.arrow_back),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'Menu',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 24),
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      leading: const Icon(Icons.person),
                      title: const Text('Profile'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  Profile(email: widget.email)),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.event),
                      title: const Text('Events'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Event_Screen(email: widget.email)));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.event),
                      title: const Text('My Events'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Event_Screen(email: widget.email)));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.feedback_rounded),
                      title: const Text('Feedback'),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Feedback_List(email: widget.email)));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_today_rounded),
                      title: const Text('Calendar'),
                      onTap: () {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => Calender(
                        //               email: widget.email,
                        //             )));
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Calendar()));
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.logout_rounded),
                      title: const Text('Logout'),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpScreen()));
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        // shape: const RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        // ),
        // isScrollControlled: true,
        // backgroundColor: Colors.white,
        //   builder: (context) {
        //     return FractionallySizedBox(
        //       widthFactor:0.5,
        //       // heightFactor: 0.5,

        //       child: Align(
        //         alignment: Alignment.topLeft,
        //         child: Column(

        //           children: [
        //             const SizedBox(height: 16),
        //             Center(
        //               child: Container(

        //                 width: 40,
        //                 height: 4,
        //                 decoration: BoxDecoration(
        //                   color: Colors.grey[400],
        //                   borderRadius: BorderRadius.circular(2),
        //                 ),
        //               ),
        //             ),
        //             const SizedBox(height: 20),
        //             Padding(
        //               padding: const EdgeInsets.symmetric(horizontal: 16.0),
        //               child: const Text(
        //                 'Navigate To',
        //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        //               ),
        //             ),
        //             const Divider(),
        //             ListTile(
        //               leading: const Icon(Icons.person),
        //               title: const Text('Profile'),
        //               onTap: () {
        //                 Navigator.pop(context);
        //                 Navigator.push(
        //                   context,
        //                   MaterialPageRoute(
        //                       builder: (context) => Profile(email: widget.email)),
        //                 );
        //               },
        //             ),
        //             ListTile(
        //               leading: const Icon(Icons.event),
        //               title: const Text('Events'),
        //               onTap: () {
        //                 Navigator.pop(context);
        //                 // Optionally navigate to a dedicated Events screen
        //               },
        //             ),
        //             ListTile(
        //               leading: const Icon(Icons.code),
        //               title: const Text('Hackathons'),
        //               onTap: () {
        //                 Navigator.pop(context);
        //                 // Optionally navigate to a dedicated Hackathons screen
        //               },
        //             ),
        //           ],
        //         ),
        //       ),
        //     );
        //   },
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Pixel",
          style: GoogleFonts.recursive(color: Colors.black, fontSize: 30),
        ),
        backgroundColor: Colors.white,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {
                if (widget.email.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Profile(email: widget.email)),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content:
                            Text("You need to be logged in to view profile")),
                  );
                }
              },
              child: CircleAvatar(
                radius: 20,
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : const AssetImage("lib/assets/profile.jpeg")
                        as ImageProvider,
              ),
            ),
          )
        ],
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '',
                  prefixIcon: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => _showHalfDialog(context),
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.search),
                    onPressed: () {
                      final query = _searchController.text.trim();
                      if (query.isNotEmpty) {
                        // Optionally handle search logic
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Searching for '\$query'...")),
                        );
                      }
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: SizedBox(
                height: 140,
                width: double.infinity,
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
                          Text("Connect with your community and join exciting hackathons,workshops, and more!",
                              style: GoogleFonts.recursive(
                                  fontSize: 17, color: Colors.white)),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              
                               ElevatedButton(onPressed: (){
                                  Navigator.push(context,MaterialPageRoute(builder: (_)=>Event_Screen(email: widget.email)));
                                }, child: Text("Explore Events",style: GoogleFonts.recursive(fontSize:15,color: Colors.white)),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 11, vertical:3),
                                  backgroundColor: Colors.orange,
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
            ),
            sectionTitle("Upcoming Non-Technical Events"),
            EventscrollView(
              Events.map((event) {
                return EventCard(
                  title: event['Name'],
                  clubName: event['Club_name'],
                  date: event['Date'],
                  imageUrl: event['Image'] ?? "",
                  email: widget.email,
                  onRegister: () => toggleRegister(
                      'Events', event['id'].toString(), widget.email),
                  description: event['Description'],
                  type: event['Type'],
                  time: event['Time'],
                );
              }).toList(),
            ),
            sectionTitle("Upcoming Technical Events"),
            EventscrollView(
              Hackathons.map((hackathon) {
                return EventCard(
                  title: hackathon['Name'],
                  clubName: hackathon['Club_Name'],
                  date: hackathon['date'],
                  imageUrl: hackathon['Image_url'] ?? "",
                  email: widget.email,
                  onRegister: () => toggleRegister(
                      'Hackathon', hackathon['id'].toString(), widget.email),
                  description: hackathon['Description'],
                  type: hackathon['Type'],
                  time: hackathon['Time'],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.only(left:10.0),
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
