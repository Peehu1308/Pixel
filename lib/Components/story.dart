import 'dart:async';
import 'package:flutter/material.dart';

class StoryItems {
  final String url;
  final int likes;
  StoryItems({required this.url, required this.likes});
}

class StoryViewer extends StatefulWidget {
  final List<StoryItems> stories;

  const StoryViewer({required this.stories, Key? key}) : super(key: key);

  @override
  State<StoryViewer> createState() => _StoryViewerState();
}

class _StoryViewerState extends State<StoryViewer> {
  late final PageController _controller;
  late List<StoryItems> sortedStories;

  Timer? _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController();
    sortedStories = List.from(widget.stories)..sort((a, b) => b.likes.compareTo(a.likes));
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (_currentPage < sortedStories.length) {
        _currentPage++;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      } else {
        _timer?.cancel();
        Navigator.pop(context);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final extendedStories = [
      sortedStories[0], // most liked
      StoryItems(url: '', likes: -1), // divider placeholder
      ...sortedStories.sublist(1),
    ];

    return Scaffold(
      backgroundColor: Colors.black,
      body: PageView.builder(
        controller: _controller,
        itemCount: extendedStories.length,
        itemBuilder: (context, index) {
          final story = extendedStories[index];

          if (story.likes == -1) {
            // Divider screen
            return Center(
              child: Container(
                width: 200,
                height: 2,
                color: const Color.fromARGB(255, 24, 1, 1),
              ),
            );
          }

          return Center(
            child: Image.network(
              story.url,
              fit: BoxFit.contain,
              loadingBuilder: (context, child, progress) {
                if (progress == null) return child;
                return const Center(child: CircularProgressIndicator());
              },
              errorBuilder: (context, error, stackTrace) {
                return const Center(child: Text('Failed to load image'));
              },
            ),
          );
        },
      ),
    );
  }
}
