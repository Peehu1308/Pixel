// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class DemoPage extends StatefulWidget {
//   const DemoPage({super.key});

//   @override
//   State<DemoPage> createState() => _DemoPageState();
// }

// class _DemoPageState extends State<DemoPage> {
//   final supabase = Supabase.instance.client;
//   Map<String, dynamic>? user;
//   bool loading = true;
//   String error = '';

//   @override
//   void initState() {
//     super.initState();
//     fetchUserByEmail();
//   }

//   Future<void> fetchUserByEmail() async {
//     try {
//       final response = await supabase
//           .from('Users')
//           .select('*')
//           .eq('Email', 'peek@bennett.edu.in')
//           .maybeSingle();  // will return a single Map or null

//       setState(() {
//         user = response;
//         loading = false;
//       });
//     } catch (e) {
//       setState(() {
//         error = e.toString();
//         loading = false;
//       });
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Supabase User Data'),
//       ),
//       body: loading
//           ? const Center(child: CircularProgressIndicator())
//           : error.isNotEmpty
//               ? Center(child: Text('Error: $error'))
//               : user != null
//                   ? Card(
//                       margin: const EdgeInsets.all(16),
//                       child: ListTile(
//                         title: Text(user!['Email'] ?? 'No Email'),
//                         subtitle: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text('University: ${user!['University'] ?? 'N/A'}'),
//                             Text('Tech Stack: ${user!['Tech_Stack'] ?? 'N/A'}'),
//                             Text('Semester: ${user!['Semester']?.toString() ?? 'N/A'}'),
//                             Text('Year: ${user!['Year']?.toString() ?? 'N/A'}'),
//                             Text('Project: ${user!['Project'] ?? 'N/A'}'),
//                           ],
//                         ),
//                         isThreeLine: true,
//                       ),
//                     )
//                   : const Center(
//                       child: Text('No user found with this email.'),
//                     ),
//     );
//   }
// }
