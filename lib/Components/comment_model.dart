import 'package:pixel/utils/encrypt.dart';

class CommentModel {
  final String username;
  final String comment;
  final DateTime datetime;
  final String? imageUrl;
  final String email;
  final List<String>? image;

  CommentModel({
    required this.username,
    required this.comment,
    required this.datetime,
    this.imageUrl,
    required this.email,
    this.image,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
  final crypto = CryptoHelper();

  // Safely handle Username (null / encrypted / plain)
  final rawUsername = json['Username'] as String?;
  final safeUsername = crypto.safeDecrypt(rawUsername) ;
  print("DEBUG Comment JSON: $json");

  return CommentModel(
    username: safeUsername.isEmpty ? 'Anonymous' : safeUsername,
    comment: json['comment'] as String? ?? '',
    datetime: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    email: json['email'] as String? ?? '',
    imageUrl: json['Users']?['Image'] as String?,
    image: (json['image'] as List<dynamic>?)
    ?.where((e) => e != null)     // remove nulls
    .map((e) => e.toString())     // safe conversion
    .toList(),

  );
}

}
