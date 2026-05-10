// import 'package:flutter/material.dart';
// import 'package:pixel/Components/Club_box.dart';
// import 'package:pixel/Components/event_box.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// // Fetch Names from both Hackathon and Events tables
// Future<List<Map<String, dynamic>>> fetchData() async {
//   final supabase = Supabase.instance.client;
//   final hackathonResponse = await supabase.from('Hackathon').select('id, Name, Club_Name, date, Image_url, Description');
//   final eventsResponse = await supabase.from('Events').select('id, Name, Club_name, Date, Image, Description');

//   List<Map<String, dynamic>> combined = [];

//   combined.addAll(hackathonResponse.map((e) => {...e, 'type': 'hackathon'}));
//   combined.addAll(eventsResponse.map((e) => {...e, 'type': 'event'}));

//   return combined;
// }

// class Searchbar extends StatefulWidget {
//   final String email;
//   const Searchbar({Key? key, required this.email}) : super(key: key);

//   @override
//   _SearchbarState createState() => _SearchbarState();
// }

// class _SearchbarState extends State<Searchbar> {
//   List<Map<String, dynamic>> allData = [];
//   List<Map<String, dynamic>> filteredData = [];
//   TextEditingController searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     loadData();
//   }

//   void loadData() async {
//     final data = await fetchData();
//     setState(() {
//       allData = data;
//       filteredData = data;
//     });
//   }

//   void _filterData(String query) {
//     final results = allData.where((item) =>
//       item['Name'].toString().toLowerCase().contains(query.toLowerCase())
//     ).toList();

//     setState(() {
//       filteredData = results;
//     });
//   }

//   void _navigateToBox(Map<String, dynamic> item) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) {
//           if (item['type'] == 'hackathon') {
//             return Scaffold(
//               appBar: AppBar(title: Text(item['Name'])),
//               body: ClubBox(
//                 title: item['Name'] ?? '',
//                 clubName: item['Club_Name'] ?? '',
//                 date: item['date'] ?? '',
//                 imageUrl: item['Image_url'] ?? '',
//                 description: item['Description'] ?? '',
//                 email: widget.email,
//                 time:item['Time']

//               ),
//             );
//           } else {
//             return Scaffold(
//               appBar: AppBar(title: Text(item['Name'])),
//               body: EventCard(
//                 title: item['Name'] ?? '',
//                 clubName: item['Club_name'] ?? '',
//                 date: item['Date'] ?? '',
//                 imageUrl: item['Image'] ?? '',
//                 email: widget.email,
//                 onRegister: () => toggleRegister('Events', item['id'].toString(), widget.email),
//                 type: item['Type'],
//                 description: item['Description'],
//                 time:item['Time']

//               ),

//             );
//           }
//         },
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Search", style: TextStyle(color: Colors.black)),
//         backgroundColor: Colors.white,
//         leading:IconButton(
//           icon:Icon(Icons.menu,color:Colors.black),
//           onPressed:()=>_openSideDialog(context),
//         )
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search events or hackathons...',
//                 prefixIcon: Icon(Icons.search),
//                 border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
//               ),
//               onChanged: _filterData,
//             ),
//           ),
//           Expanded(
//             child: ListView.builder(
//               itemCount: filteredData.length,
//               itemBuilder: (context, index) {
//                 final item = filteredData[index];
//                 return ListTile(
//                   title: Text(item['Name']),
//                   subtitle: Text(item['type']),
//                   onTap: () => _navigateToBox(item),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// // Dummy toggleRegister (replace this with your actual function)
// void toggleRegister(String tableName, String id, String email) {
//   print('Registering $email for $tableName id: $id');
// }

// // ClubBox and EventCard are assumed already created in your project.
// void _openSideDialog(BuildContext context) {
//   showGeneralDialog(
//     context: context,
//     barrierDismissible: true,
//     barrierLabel: "Menu",
//     transitionDuration: Duration(milliseconds: 300),
//     pageBuilder: (context, animation, secondaryAnimation) {
//       return Align(
//         alignment: Alignment.centerLeft,
//         child: Material(
//           child: Container(
//             height: MediaQuery.of(context).size.height,
//             width: MediaQuery.of(context).size.width * 0.5, // Half the screen
//             color: Colors.white,
//             child: Column(
//               children: [
//                 ListTile(
//                   leading: Icon(Icons.home),
//                   title: Text('Home'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate or trigger action
//                   },
//                 ),
//                 ListTile(
//                   leading: Icon(Icons.account_circle),
//                   title: Text('Profile'),
//                   onTap: () {
//                     Navigator.pop(context);
//                     // Navigate or trigger action
//                   },
//                 ),
//               ],
//             ),
//           ),
//         ),
//       );
//     },
//     transitionBuilder: (context, animation, secondaryAnimation, child) {
//       return SlideTransition(
//         position: Tween<Offset>(
//           begin: Offset(-1, 0),
//           end: Offset(0, 0),
//         ).animate(animation),
//         child: child,
//       );
//     },
//   );
// }
