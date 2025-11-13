import 'package:flutter/material.dart';

class UpdateBox extends StatelessWidget {
  final String heading;
  final String update;
  final String? image;

  const UpdateBox({
    Key? key,
    required this.heading,
    required this.update,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Heading
            Text(
              heading,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            // Update text
            Text(
              update,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black87,
              ),
            ),

            const SizedBox(height: 10),

            // Image (only show if not null/empty)
            if (image != null && image!.isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  image!,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 180,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.broken_image, size: 80, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
