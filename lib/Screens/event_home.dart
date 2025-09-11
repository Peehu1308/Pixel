import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pixel/Screens/Createteam.dart';
import 'package:pixel/Screens/Jointeam.dart';
import 'package:pixel/Screens/recommendation.dart';

class EventHome extends StatelessWidget {
  final String title;
  final String clubName;
  final String date;
  final String imageUrl;
  final String description;
  final String email;
  final String time;

  const EventHome({
    super.key,
    required this.title,
    required this.clubName,
    required this.date,
    required this.imageUrl,
    required this.description,
    required this.email,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Pixel",
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          // Background image + dark overlay
          Positioned.fill(
            child: Image.network(imageUrl, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(color: Colors.grey)),
          ),
          Positioned.fill(child: Container(color: Colors.black.withOpacity(0.75))),

          // Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 40), // bottom padding added
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 32,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Date and time row
                  Row(
                    children: [
                      _InfoChip(icon: Icons.calendar_today, label: date),
                      const SizedBox(width: 8),
                      _InfoChip(icon: Icons.access_time, label: time),
                    ],
                  ),
                  const SizedBox(height: 8),

                  // Organizer
                  Text(
                    "Organized by: ${clubName.toUpperCase()}",
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.white70,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Description card
                  if (description.isNotEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.04),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.white.withOpacity(0.06)),
                      ),
                      child: Text(
                        description,
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 15,
                          height: 1.4,
                        ),
                      ),
                    ),

                  const SizedBox(height: 26),

                  // Buttons container (feels like a card)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.03),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Find Teammates -> primary dark button
                        _buildActionButton(
                          context,
                          label: "Find Teammates",
                          icon: Icons.person_search,
                          dark: true,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Recommendation(email: email)),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // Create Team -> white button with border
                        _buildActionButton(
                          context,
                          label: "Create Team",
                          icon: Icons.add,
                          dark: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UniqueCode(email: email, hackathontitle: title),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 12),

                        // Join Team -> white button with subtle icon
                        _buildActionButton(
                          context,
                          label: "Join Team",
                          icon: Icons.group,
                          dark: false,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => JoinTeam(email: email)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context,
      {required String label, required IconData icon, required VoidCallback onTap, required bool dark}) {
    final textStyle = GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w600);
    if (dark) {
      return SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.white),
          label: Text(label, style: textStyle.copyWith(color: Colors.white)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      );
    } else {
      return SizedBox(
        height: 52,
        child: ElevatedButton.icon(
          onPressed: onTap,
          icon: Icon(icon, color: Colors.black87),
          label: Text(label, style: textStyle.copyWith(color: Colors.black87)),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            padding: const EdgeInsets.symmetric(horizontal: 16),
          ),
        ),
      );
    }
  }
}

// small reusable info chip for date/time
class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: Colors.white70),
          const SizedBox(width: 6),
          Text(label, style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }
}
