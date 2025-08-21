import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedbackScreen extends StatefulWidget {
  final String title;
  final String clubName;

  const FeedbackScreen({
    Key? key,
    required this.title,
    required this.clubName,
  }) : super(key: key);

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _ratingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Text(
            'Feedback for ${widget.title}',
            style: GoogleFonts.recursive(
              fontSize: 15,
              color: Colors.black,
            ),
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [Text("Rate you experience:",
              style: GoogleFonts.poppins(fontSize: 18),
              ),
              SizedBox(height: 5,),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemSize: 40.0,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  _ratingController.text = rating.toString();
                },
              ),
              SizedBox(height: 30,),
              Text("Feedback:",
            style: GoogleFonts.poppins(fontSize: 18)
            ,),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.only(left:10,right:10,bottom: 10),
              child: TextField(
                controller: _feedbackController,
                maxLines: 5,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter your feedback here',
                ),
              ),
            ),
            Center(
              child: ElevatedButton(onPressed: (){
                      
              }, child:Text("Submit",
              style: GoogleFonts.poppins(fontSize: 18,),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          
            )
            ],
          ),
        ),
      ),
    );
  }
}
