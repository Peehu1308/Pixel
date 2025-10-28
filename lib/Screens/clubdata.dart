import 'package:flutter/material.dart';
import 'package:pixel/Components/chatbox_club.dart';
import 'package:pixel/Components/eventsbox_small.dart';
// import 'package:pixel/Components/eventsbox_small.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClubData extends StatefulWidget {
  final String clubId;
  final String clubName;
  final String imageUrl;
  final String description_club;

  const ClubData({
    super.key,
    required this.clubName,
    required this.imageUrl,
    required this.description_club,
    required this.clubId,
  });

  @override
  State<ClubData> createState() => _ClubDataState();
}

class _ClubDataState extends State<ClubData> {
  int selectedIndex = 0;
  List<dynamic> members = [];
  List<dynamic> project = [];

  final List<String> options = ["Active Members", "Live Events", "Past Events"];

  @override
  void initState() {
    super.initState();
    fetchMembers();
    // fetchliveevents();
  }

// Future<void> fetchliveevents() async {
//   try {
//     final data = await Supabase.instance.client
//         .from('Projects')

//         .select(
//           'project_title, project_description, club_id'
//         )
//         .eq('club_id', int.parse(widget.clubId)); // ✅ ensures correct filter type

//     print('Fetched projects for club ${widget.clubId}: $data');
//     print('Projects response: $data');
// print('Project count: ${data.length}');


//     if (data.isEmpty) {
//       print('No projects found for this club.');
//     } else {
//       setState(() {
//         project = data;
//       });
//     }
//   } catch (error, stack) {
//     print('Error fetching projects: $error');
//     print(stack);
//   }
// }

  Future<void> fetchMembers() async {
    final response = await Supabase.instance.client
        .from('Club_members')
        .select('members')
        .eq('club_id', widget.clubId);

    if (response.isNotEmpty) {
      setState(() {
        members = response[0]['members'] ?? [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Row(
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Icon(
                  Icons.arrow_back_outlined,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            /// Top section with image + overlays
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.6,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Stack(
                    children: [
                      Image.network(
                        widget.imageUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black.withOpacity(0.6),
                      ),
                      Positioned(
                        bottom: 80,
                        left: 10,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.clubName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.description_club,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /// Floating buttons on image
                Positioned(
                  bottom: 20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          side: const BorderSide(color: Colors.white, width: 2),
                        ),
                        child: const Text(
                          "Join Club",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      const SizedBox(width: 20),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => ChatBoxClub(
                                        clubname: widget.clubName,
                                        image: widget.imageUrl,
                                      )));
                        },
                        child: const Text(
                          "Join Chat",
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            ToggleButtons(
              isSelected: List.generate(
                options.length,
                (index) => index == selectedIndex,
              ),
              onPressed: (index) {
                setState(() {
                  selectedIndex = index;
                });
              },
              borderRadius: BorderRadius.circular(30),
              borderColor: Colors.white70,
              selectedBorderColor: Colors.transparent,
              fillColor: Colors.white,
              color: Colors.white70,
              selectedColor: Colors.black,
              constraints: const BoxConstraints(
                minHeight: 40,
                minWidth: 120,
              ),
              children: options.map((text) => Text(text)).toList(),
            ),

            SizedBox(
              height: 20,
            ),

            if (selectedIndex == 0) ...[
              Column(
                children: [
                  members.isEmpty
                      ? const Center(
                          child: Text(
                            "No Active Users",
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      : Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: members.length,
                            itemBuilder: (context, index) {
                              final member = members[index].toString().trim();
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.grey[800],
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 2,
                                    horizontal: 7,
                                  ),
                                  alignment: Alignment.centerLeft,
                                  height: 40,
                                  width: 20,
                                  child: Text(
                                    member,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        )
                ],
              )
            ] else if (selectedIndex == 1) ...[
              Column(
                children: [

                  Column(
        children: [
          
            EventsboxSmall(clubId: int.parse(widget.clubId))
        ],
      )

                ],
              )
            ] else if (selectedIndex == 2) ...[
              Column(
                children: [
                  
                  const Center(
                    child: Text(
                      "No past events",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                ],
              )
            ]
          ],
        ),
      ),
    );
  }
}