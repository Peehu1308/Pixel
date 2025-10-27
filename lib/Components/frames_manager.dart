import 'package:pixel/utils/encrypt.dart';

class FramesModel {
  final String imagePath;
  final String label;
  final List<String> storyImage;

  FramesModel({
    required this.imagePath,
    required this.label,
    required this.storyImage,
  });

  factory FramesModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> images = json['Images'] ?? [];
    final cryto = CryptoHelper();

    final List<String> paths = images
        .map((e) => e.toString())
        .where((url) =>
            url.isNotEmpty &&
            Uri.tryParse(url)?.hasAbsolutePath == true &&
            url.startsWith('http'))
        .toList();

    final String decryptedUser = cryto.decryptText(json['user']) ?? 'Unknown';

    return FramesModel(
      imagePath: paths.isNotEmpty ? paths[0] : '',
      label: decryptedUser,
      storyImage: paths,
    );
  }
}
