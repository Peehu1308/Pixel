import 'package:flutter/material.dart';
import 'package:pixel/Components/rec.dart';
import 'package:pixel/Components/rec_email.dart';

class Recommendation extends StatelessWidget {
  final String email;
  const Recommendation({Key?key,
    required this.email,
  }):super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Recommendation',
        textAlign: TextAlign.start,),
        
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body:
      SingleChildScrollView(
        
        child: Center(
          child: Column(
            children: [
              // UserCardFromEmail(email: 'E23CSEU2289@bennett.edu.in'),
              RecommendationsFromEmail(email:email),
              // UserCardFromEmail(email: 'E23CSEU2289@bennett.edu.in'),
              // UserCardFromEmail(email: 'E23CSEU2289@bennett.edu.in'),
              // UserCardFromEmail(email: 'E23CSEU2289@bennett.edu.in'),
              // UserCardFromEmail(email: 'E23CSEU2289@bennett.edu.in'),
        
            ],
          )
        ),
      ),
    );
  }
}
