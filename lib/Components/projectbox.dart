import 'package:flutter/material.dart';


class Projectbox extends StatefulWidget {
  final String title;
  final String description;
  const Projectbox({super.key,required this.title,required this.description});

  @override
  State<Projectbox> createState() => _ProjectboxState();
}

class _ProjectboxState extends State<Projectbox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.2,
      width: MediaQuery.of(context).size.width * 0.9,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ]
      )
    );
  }
}