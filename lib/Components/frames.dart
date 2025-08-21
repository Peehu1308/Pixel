import 'package:flutter/material.dart';
import 'package:pixel/Components/frames_manager.dart';
import 'package:pixel/Components/story.dart';

class Frames extends StatelessWidget {
  final FramesModel model;
  const Frames({
    required this.model,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if (model.storyImage.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => StoryViewer(
  stories: model.storyImage.map((url) => StoryItems(url: url, likes: 0)).toList(),
)
,
              ),
            );
          }
        },
        child: Column(
          children:[ Container(
            padding: const EdgeInsets.only(top:2,left:2,right:2),
            decoration:BoxDecoration(shape:BoxShape.circle,
            gradient: LinearGradient(colors:[const Color.fromARGB(255, 240, 70, 138),const Color.fromARGB(255, 232, 234, 218),const Color.fromARGB(255, 218, 237, 13)],
            )),
            child:CircleAvatar(
              radius:30,
              backgroundColor: Colors.green,
              backgroundImage: (model.imagePath.isNotEmpty &&
                      model.imagePath.startsWith('http'))
                      ?NetworkImage(model.imagePath)
                      :AssetImage('lib/assets/club.jpeg') as ImageProvider,
            ),

          ),
          const SizedBox(height:8),
          Text(model.label,
          style:TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          overflow:TextOverflow.ellipsis
          )
          ],
        ));
  }
}
