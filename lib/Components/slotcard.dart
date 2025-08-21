import 'package:flutter/material.dart';

Widget buildSlotCard({
  required String name,
  required String location,
  required Color color,
  required List<String> avatars,
}) {
  return Container(
    width: 140,
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.only(bottom: 8),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 30,
              color: color,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(name,
                  style: const TextStyle(
                      fontSize: 14, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.location_on, size: 14, color: Colors.grey),
            const SizedBox(width: 4),
            Expanded(
                child: Text(location, style: const TextStyle(fontSize: 12))),
          ],
        ),
        const SizedBox(height: 8),
        if (avatars.isNotEmpty)
          Row(
            children: avatars
                .map((a) => Padding(
                      padding: const EdgeInsets.only(right: 4.0),
                      child: CircleAvatar(
                        radius: 10,
                        child: Text(a,
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white)),
                        backgroundColor: Colors.blue.shade300,
                      ),
                    ))
                .toList(),
          ),
      ],
    ),
  );
}
