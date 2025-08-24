import 'package:flutter/material.dart';
import 'package:pixel/Components/highlight_manager.dart';
// import 'highlight_model.dart'; // import this!
import 'story.dart';

class Highlight extends StatelessWidget {
  final HighlightModel model;

  const Highlight({required this.model, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (model.storyImages.isNotEmpty) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => StoryViewer(
  stories: model.storyImages.map((url) => StoryItems(url: url, likes: 0)).toList(),
)
,
            ),
          );
        }
      },
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              // gradient: const LinearGradient(
              //   colors: [Colors.blue, Colors.purple],
              //   begin: Alignment.topLeft,
              //   end: Alignment.bottomRight,
              // ),


              color: Colors.purple.withOpacity(0.6),
              // Color choice
              // color: Color.fromARGB(255, 81, 59, 245)
              //             .withOpacity(0.4),
                      // spreadRadius: 2,
                      // blurRadius: 2,
            ),
            child: ClipRRect(borderRadius: BorderRadius.circular(8),
            child: Container(
              width: 60,
              height: 60,
              color: Colors.grey.shade200,
              child: (model.imagePath.isNotEmpty &&
                      model.imagePath.startsWith('http'))
                  ? Image.network(model.imagePath, fit: BoxFit.cover)
                  : Image.asset('lib/assets/club.jpeg', fit: BoxFit.cover),
            ),
            )
          ),
          const SizedBox(height: 8),
          Text(
            model.label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
