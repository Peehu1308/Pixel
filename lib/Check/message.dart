// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ChatScreen extends StatefulWidget {
//   final String senderEmail;
//   final String receiverEmail;

//   ChatScreen({required this.senderEmail, required this.receiverEmail});

//   @override
//   _ChatScreenState createState() => _ChatScreenState();
// }

// class _ChatScreenState extends State<ChatScreen> {
//   final supabase = Supabase.instance.client;
//   final TextEditingController _controller = TextEditingController();
//   List<Map<String, dynamic>> _messages = [];

//   String? senderId;
//   String? receiverId;

//   @override
//   void initState() {
//     super.initState();
//     _initializeChat();
//   }

//   Future<void> _initializeChat() async {
//     final sender = await _getUserByEmail(widget.senderEmail);
//     final receiver = await _getUserByEmail(widget.receiverEmail);

//     if (sender != null && receiver != null) {
//       setState(() {
//         senderId = sender['id'];
//         receiverId = receiver['id'];
//       });
//       _fetchMessages();
//     } else {
//       print("❌ Error: Could not find one or both users.");
//     }
//   }

//   Future<Map<String, dynamic>?> _getUserByEmail(String email) async {
//     final response = await supabase
//         .from('Users')
//         .select('id')
//         .eq('Email', email) // Ensure 'Email' matches your Supabase column exactly
//         .maybeSingle();

//     return response;
//   }

//   Future<void> _fetchMessages() async {
//     if (senderId == null || receiverId == null) return;

//     print('Fetching messages between $senderId and $receiverId');
// final response = await supabase
//     .from('Messages')
//     .select('Message, created_at, sender_id, receiver_id')
//     .or('and(sender_id.eq.$senderId,receiver_id.eq.$receiverId)%2Cand(sender_id.eq.$receiverId,receiver_id.eq.$senderId)')

//     .order('created_at', ascending: true);


// print('Messages response: $response');

//     setState(() {
//       _messages = List<Map<String, dynamic>>.from(response);
//     });
//   }

//   Future<void> _sendMessage(String text) async {
//   if (text.trim().isEmpty || senderId == null || receiverId == null) return;

//   try {
//     final response = await supabase.from('Messages').insert({
//       'Message': text.trim(),
//       'sender_id': senderId,
//       'receiver_id': receiverId,
//     }).select();

//     print("✅ Inserted message: $response");
//   } catch (e) {
//     print("❌ Error inserting message: $e");
//   }

//   _controller.clear();
//   _fetchMessages();
// }


//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Supabase Chat")),
//       body: Column(
//         children: [
//           Expanded(
//             child: ListView.builder(
//               itemCount: _messages.length,
//               itemBuilder: (_, index) {
//                 final msg = _messages[index];
//                 final senderEmail = msg['sender']?['Email'] ?? 'Unknown';
//                 return ListTile(
//                   title: Text(msg['Message']),
//                   subtitle: Text("From: $senderEmail"),
//                 );
//               },
//             ),
//           ),
//           Row(
//             children: [
//               Expanded(
//                 child: TextField(
//                   controller: _controller,
//                   decoration: InputDecoration(
//                     hintText: "Enter your message",
//                   ),
//                 ),
//               ),
//               IconButton(
//                 icon: Icon(Icons.send),
//                 onPressed: () => _sendMessage(_controller.text),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
