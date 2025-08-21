class HighlightModel {
  final String imagePath;
  final String label;
  final List<String> storyImages;

  HighlightModel({
    required this.imagePath,
    required this.label,
    required this.storyImages,
  });

  factory HighlightModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> images = json['images'] ?? [];

    final List<String> paths = images
        .map((e) => e.toString())
        .where((url) =>
            url.isNotEmpty &&
            Uri.tryParse(url)?.hasAbsolutePath == true &&
            url.startsWith('http'))
        .toList();

    return HighlightModel(
      imagePath: paths.isNotEmpty ? paths[0] : '',
      label: json['club_name'] ?? '',
      storyImages: paths,
    );
  }
}
