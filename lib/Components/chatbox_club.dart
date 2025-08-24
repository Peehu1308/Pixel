import 'package:flutter/material.dart';

class ChatBoxClub extends StatefulWidget {
  final String clubname;
  final String image;
  const ChatBoxClub({super.key, required this.clubname, required this.image});

  @override
  State<ChatBoxClub> createState() => _ChatBoxClubState();
}

class _ChatBoxClubState extends State<ChatBoxClub> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      // backgroundColor: Colors.black,
      body: Material(
        color: Colors.black,
        child: Center(
          child: Container(
            width: MediaQuery.of(context).size.width * 0.9,
            height: MediaQuery.of(context).size.height * 0.75,
            decoration: BoxDecoration(
              // color: Colors.black,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
            ),
            child: Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  height: 60,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blueAccent, Colors.lightBlueAccent],
                    ),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Image.network(
                            widget.image,
                            width: 40,
                            height: 40,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 10),
                          Text(
                            "${widget.clubname}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.close,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ),
      
                // Messages
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(12),
                    children: [
                      _botMessage(
                          " Meet Pixel — your all-in-one event companion!From discovering the hottest hackathons to finding your perfect teammate with built-in AI, Pixel does it all.Post quick updates with Frames, share bites like tweets via Specs, and stay in the loop on everything that matters.Events. Teams. Updates. All in one place. That’s Pixel. ✨"),
                      _userMessage("Tell me More"),
                      _botMessage(
                          "Pixel is your smart social toolkit for everything related to events, hackathons, and building connections. It’s not just another event app — it’s a creative space powered by AI, helping you discover, connect, and express."),
                      SizedBox(height: 8),
                      Wrap(
                        spacing: 10,
                        children: [
                          _quickReply("Go To Events"),
                          _quickReply("Go to Specs"),
                        ],
                      ),
                    ],
                  ),
                ),
      
                // Input bar
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(16)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _controller,
                          decoration: InputDecoration.collapsed(
                            hintText: "Type your message...",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: Colors.blue),
                        onPressed: () {
                          // TODO: Add message send logic
                          print("Send: ${_controller.text}");
                          _controller.clear();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _botMessage(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(text),
        ),
      );

  Widget _userMessage(String text) => Align(
        alignment: Alignment.centerRight,
        child: Container(
          margin: EdgeInsets.only(bottom: 10),
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(16),
          ),
          child: Text(text),
        ),
      );

  Widget _quickReply(String label) => OutlinedButton(
        onPressed: () {
          print("Quick reply: $label");
        },
        style: OutlinedButton.styleFrom(
          shape: StadiumBorder(),
          side: BorderSide(color: Colors.blueAccent),
        ),
        child: Text(label),
      );
}
