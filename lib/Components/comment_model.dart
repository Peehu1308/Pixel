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
    return CommentModel(
      username: json['Username'] ?? 'Anonymous',
      comment: json['comment'],
      datetime: DateTime.parse(json['created_at']),
      email: json['email'],
      imageUrl: json['Users']?['Image'],
      image:(json['image'] as List<dynamic>?)
          ?.map((e)=>e as String)
          .toList(),

    );
  }
}
