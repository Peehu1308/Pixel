import 'package:flutter/material.dart';
import 'package:pixel/Screens/event_detail_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// import 'event_detail_screen.dart';

class ShowcaseBox extends StatefulWidget {
  final int clubId;

  const ShowcaseBox({super.key, required this.clubId});

  @override
  State<ShowcaseBox> createState() => _ShowcaseBoxState();
}

class _ShowcaseBoxState extends State<ShowcaseBox> {
  List<dynamic> events = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchEvents();
  }

  Future<void> fetchEvents() async {
  try {
    final response = await Supabase.instance.client
        .from('Events')
        .select()
        .eq('club_id', widget.clubId)
        .order('Date', ascending: false);

    // ✅ Filter out Business Bazaar
    final filtered = response.where((e) =>
        (e['Name']?.toString().toLowerCase() ?? '') !=
        'business bazaar'.toLowerCase()).toList();

    setState(() {
      events = filtered;
      isLoading = false;
    });
  } catch (e) {
    print('Error fetching events');
    setState(() => isLoading = false);
  }
  print('DEBUG ShowcaseBox.clubId type = ${widget.clubId.runtimeType}');
}


  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator(color: Colors.white));
    }

    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text(
          "No events to showcase yet.",
          style: TextStyle(color: Colors.white70, fontSize: 16),
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(12.0),
            child: Text(
              "Showcase Events",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Event list preview
          ...events.take(3).map((e) => _eventCard(context, e)).toList(),
          if (events.length > 3)
            Padding(
              padding: const EdgeInsets.only(right: 16, bottom: 12),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EventDetailScreen(event: events[1], clubId: widget.clubId,),
                      ),
                    );
                  },
                  child: const Text("View All"),
                ),
              ),
            )
        ],
      ),
    );
  }

  Widget _eventCard(BuildContext context, Map<String, dynamic> event) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => EventDetailScreen(event: event, clubId: widget.clubId,),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[900],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                bottomLeft: Radius.circular(12),
              ),
              child: event['Image'] != null
                  ? Image.network(
                      event['Image'],
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 90,
                      height: 90,
                      color: Colors.grey[800],
                      child: const Icon(Icons.image_not_supported,
                          color: Colors.white54),
                    ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['Name'] ?? 'Untitled',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "${event['Date'] ?? ''} • ${event['Time'] ?? ''}",
                      style: const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EventDetailScreen(event: event, clubId: widget.clubId,),
                            ),
                          );
                        },
                        child: const Text(
                          "View Details",
                          style: TextStyle(fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}