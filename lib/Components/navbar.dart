import 'package:flutter/material.dart';
import 'package:pixel/Screens/Calender.dart';
import 'package:pixel/Screens/club.dart';
import 'package:pixel/Screens/event.dart';
import 'package:pixel/Screens/friends_screen.dart';
import 'package:pixel/Screens/updatespage.dart';
// import 'package:pixel/Screens/main.dart';
import 'package:pixel/admin/Admin_home.dart';
import 'package:pixel/admin/admin_specs.dart';
import 'package:pixel/admin/adminevent.dart';
import 'package:pixel/main.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
class Navbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  final String email;


  const Navbar({

    Key? key,
    required this.currentIndex,
    required this.onTap,
    required this.email,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) async {
        if(index==0){
        
            Navigator.push(context,MaterialPageRoute(builder: (context)=>MainScreen(email:email)));
          
        
        
          
        }
        else if(index==1){
          
            Navigator.push(context,MaterialPageRoute(builder: (context)=>FriendsScreen(email: email,)));
          
        }
        else if(index==2){
          
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Updates_Screen(email: email,)));
          
        }
        else if(index==3){
          
            Navigator.push(context,MaterialPageRoute(builder: (context)=>Clubs_Screen(email:email)));
          
        }
        
      },
      // backgroundColor: Colors.transparent,
      backgroundColor: Colors.white,
      selectedItemColor: Colors.purple,
      // selectedItemColor: Colors.orange,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const[
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
          
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.comment_bank_outlined),
          label: 'Specs',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.tips_and_updates_sharp),
          label: 'Updates',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.group),
          label: 'Clubs',
        ),
        
      ]
    );
  }
}