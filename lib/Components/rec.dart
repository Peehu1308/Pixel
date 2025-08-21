import 'package:flutter/material.dart';
import 'package:pixel/Screens/viewer_profile.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserCardFromEmail extends StatefulWidget {
  final String email;

  const UserCardFromEmail({Key? key, required this.email}) : super(key: key);

  @override
  State<UserCardFromEmail> createState() => _UserCardFromEmailState();
}

class _UserCardFromEmailState extends State<UserCardFromEmail> {
  late Future<Map<String, dynamic>?> userDataFuture;

  @override
  void initState() {
    super.initState();
    userDataFuture = fetchUserData(widget.email);
  }

  Future<Map<String, dynamic>?> fetchUserData(String email) async {
    final response = await Supabase.instance.client
        .from('Users')
        .select()
        .eq('Email', email)
        .single();
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>?>(
      future: userDataFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError || snapshot.data == null) {
          return const Center(child: Text('User not found'));
        }

        final userData = snapshot.data!;
        final imageUrl = userData['Image'] ?? '';
        final name = userData['Name'] ?? 'No Name';
        final semester = userData['Semester']?.toString() ?? 'No Semester';



        final rawLikedItems = (userData['Liked'] as List<dynamic>?)
        ?.map((item) => item.toString())
        .toList() ?? [];

final likedItems = rawLikedItems.length > 2
    ? [...rawLikedItems.take(2), 'etc']
    : rawLikedItems;


        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 4,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: imageUrl.isNotEmpty
                          ? Image.network(
                              imageUrl,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            )
                          : Container(
                              width: 70,
                              height: 70,
                              color: Colors.grey[300],
                              child: const Icon(Icons.person, size: 40),
                            ),
                    ),
                    const SizedBox(width: 12),
          
                    
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text(semester, style: const TextStyle(color: Colors.grey)),
                          const SizedBox(height: 6),
                          SizedBox(
                            width: 200,
                            child: Wrap(
                              spacing: 6,
                              runSpacing: 4,
                              children: likedItems.map((item) => Chip(
                                label: Text(item),
                                backgroundColor: Colors.white,
                              )).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),
          
                    const SizedBox(width: 12),
          
                    
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ViewerProfile(email: widget.email)));
                      },
                      child: const Text('Know More', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
