import 'package:flutter/material.dart';
import 'package:pixel/Components/chatbox_club.dart';
import 'package:pixel/Components/eventsbox_small.dart';
import 'package:pixel/Screens/showcase_box.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClubData extends StatefulWidget {
  final int clubId;
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
  }

  Future<void> fetchMembers() async {
    final response = await Supabase.instance.client
        .from('Club_members')
        .select('members, Image, Position, Description, club_id')
        .eq('club_id', widget.clubId);

    print('Raw Supabase response: $response');

    if (response.isNotEmpty) {
      setState(() {
        members = response;
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
      // -------------------- JOIN CLUB BUTTON --------------------
      ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: const Text(
                  "Coming Soon",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  "Club joining forms will open soon! Stay tuned for updates.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // Close modal
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              );
            },
          );
        },
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

      // -------------------- JOIN CHAT BUTTON --------------------
      ElevatedButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                title: const Text(
                  "Feature Coming Soon",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                content: const Text(
                  "Chat feature coming soon! To access chat, please download the app.",
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.pop(dialogContext); // Close modal
                    },
                    child: const Text(
                      "OK",
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
        ),
        child: const Text(
          "Join Chat",
          style: TextStyle(color: Colors.black),
        ),
      ),
    ],
  ),
)

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

            // const SizedBox(height: 10),

            if (selectedIndex == 0) ...[
              Column(
                children: [
                  members.isEmpty
                      ? const Center(
                          child: Text(
                            "No Active Members",
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
                              final member = members[index];
                              final memberName = member['members'] ?? '';
                              final imageUrl = member['Image'] ?? '';
                              final position = member['Position'] ?? '';
                              final description = member['Description'] ?? '';

                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 6, horizontal: 12),
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return Dialog(
                                          backgroundColor:
                                              const Color(0xFF121212),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: LayoutBuilder(
                                            builder: (context, constraints) {
                                              final isWide =
                                                  constraints.maxWidth > 500;
                                              return Container(
                                                width: isWide
                                                    ? 500
                                                    : MediaQuery.of(context)
                                                            .size
                                                            .width *
                                                        0.9,
                                                padding:
                                                    const EdgeInsets.all(20),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    CircleAvatar(
                                                      radius: isWide ? 50 : 40,
                                                      backgroundImage: (imageUrl !=
                                                                  null &&
                                                              imageUrl
                                                                  .isNotEmpty)
                                                          ? NetworkImage(
                                                              imageUrl)
                                                          : const AssetImage(
                                                                  "assets/pixel.png")
                                                              as ImageProvider,
                                                    ),
                                                    const SizedBox(height: 15),
                                                    Text(
                                                      memberName,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 8),
                                                    Text(
                                                      position,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: const TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                    const SizedBox(height: 16),
                                                    // Text(
                                                    //   description.isNotEmpty
                                                    //       ? description
                                                    //       : "No description available.",
                                                    //   textAlign:
                                                    //       TextAlign.center,
                                                    //   style: const TextStyle(
                                                    //     color: Colors.white60,
                                                    //     fontSize: 14,
                                                    //   ),
                                                    // ),
                                                    const SizedBox(height: 20),
                                                    Align(
                                                      alignment:
                                                          Alignment.bottomRight,
                                                      child: TextButton(
                                                        onPressed: () =>
                                                            Navigator.pop(
                                                                context),
                                                        style: TextButton
                                                            .styleFrom(
                                                          foregroundColor:
                                                              Colors.white,
                                                        ),
                                                        child:
                                                            const Text("Close"),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 250),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 14),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF1A1A1A),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: Colors.white10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.6),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                                color: Colors.white24,
                                                width: 1.5),
                                          ),
                                          child: CircleAvatar(
                                            radius: 25,
                                            backgroundImage:
                                                (imageUrl != null &&
                                                        imageUrl.isNotEmpty)
                                                    ? NetworkImage(imageUrl)
                                                    : const AssetImage(
                                                            "assets/pixel.png")
                                                        as ImageProvider,
                                          ),
                                        ),
                                        const SizedBox(width: 14),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                memberName,
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w600,
                                                  letterSpacing: 0.3,
                                                ),
                                              ),
                                              const SizedBox(height: 3),
                                              Text(
                                                position,
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                  fontSize: 13,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        const Icon(Icons.info_outline,
                                            color: Colors.white38),
                                      ],
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
                      ShowcaseBox(clubId: widget.clubId),
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
