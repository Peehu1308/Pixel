import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pixel/Components/comment_fetch.dart';
import 'package:pixel/Screens/profile.dart';
import 'package:pixel/Screens/viewer_profile.dart';
import 'package:pixel/utils/encrypt.dart';
import 'package:share_plus/share_plus.dart';
import 'comment_model.dart';

class Commentbox extends StatefulWidget {
  final cryto = CryptoHelper();
  Commentbox({Key? key}) : super(key: key);

  @override
  State<Commentbox> createState() => _CommentboxState();
}

class _CommentboxState extends State<Commentbox> {
  late Future<List<CommentModel>> _futureComments;
  final Set<int> _likedComments = {}; // Track liked comment indices

  @override
  void initState() {
    super.initState();
    _futureComments = fetchComments();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<CommentModel>>(
      future: _futureComments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No comments yet.'));
        }

        final comments = snapshot.data!;
        return SizedBox(
          width: MediaQuery.of(context).size.width,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(2),
            itemCount: comments.length,
            itemBuilder: (context, index) {
              final comment = comments[index];
              final isliked = _likedComments.contains(index);

              return Container(
                margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  // gradient: const LinearGradient(
                  //   colors: [
                  //     Color.fromARGB(255, 238, 28, 143),
                  //     Color.fromARGB(255, 240, 240, 240),
                  //   ],
                  //   begin: Alignment.topLeft,
                  //   end: Alignment.bottomRight,
                  // ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 81, 59, 245)
                          .withOpacity(0.4),
                      spreadRadius: 2,
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,MaterialPageRoute(builder: (context)=>ViewerProfile(email: comment.email,)
                          ));
                        },
                        child: CircleAvatar(
                          
                          radius: 20,
                          backgroundImage: comment.imageUrl != null
                              ? NetworkImage(comment.imageUrl!)
                              : const AssetImage('assets/default_avatar.png')
                                  as ImageProvider,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (comment.username),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  DateFormat.yMMMd()
                                      .add_jm()
                                      .format(comment.datetime),
                                  style: const TextStyle(
                                      fontSize: 8, color: Colors.grey),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(comment.comment),
                            if (comment.image != null &&
                                comment.image!.isNotEmpty)
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Wrap(
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: comment.image!.map((image) {
                                    return Container(
                                      width: 100,
                                      height: 100,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          image,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            Row(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    setState(() {
                                      if (_likedComments.contains(index)) {
                                        _likedComments.remove(index);
                                      } else {
                                        _likedComments.add(index);
                                      }
                                    });
                                  },
                                  icon: Icon(
                                    isliked
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                    color: isliked ? Colors.red : Colors.grey,
                                    size: 20,
                                  ),
                                ),
                                IconButton(onPressed: (){

                                }, icon: Icon(Icons.reply, color: Colors.black, size: 20)),
                                IconButton(
                                  onPressed: () {
                                    Share.share(
                                      'Check out this comment by ${comment.username}:\n${comment.comment}\n${comment.imageUrl ?? ""}\nShared via Eventra app.',
                                    );
                                  },
                                  icon: const Icon(Icons.share,
                                      color: Colors.black, size: 20),
                                ),
                                IconButton(
                                  onPressed: () {
                                  
                                  },
                                  icon: const Icon(Icons.report_problem,
                                      color: Colors.black, size: 20),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
