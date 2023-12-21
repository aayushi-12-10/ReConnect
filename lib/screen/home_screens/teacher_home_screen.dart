import 'package:call_app/constants/enum.dart';
import 'package:call_app/constants/routes.dart';
import 'package:call_app/screen/firebase_chat_screens/firebase_chat_list_page.dart';
import 'package:call_app/screen/firebase_chat_screens/firebase_user_list_page.dart';
import 'package:call_app/screen/firebase_chat_screens/firebase_user_search_page.dart';
import 'package:call_app/screen/verify_student_screens/teacher_verify_student_screen.dart';
import 'package:call_app/screen/post_screens/post_page.dart';
import 'package:call_app/screen/profile_screens/profile_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class TeacherHomePage extends StatefulWidget {
  const TeacherHomePage({super.key});

  @override
  State<TeacherHomePage> createState() => _TeacherHomePageState();
}

class _TeacherHomePageState extends State<TeacherHomePage> {
  final _auth = FirebaseAuth.instance;
  int _selectedIndex = 0;
  final _pages = [
    const TeacherVerifyStudentPage(),
    const FirebaseUserListPage(),
    const FirebaseChatListPage(),
    const PostPage(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text('ReConnect'),
        centerTitle: true,
        titleTextStyle: const TextStyle(color: Colors.white, fontSize: 23),
        actions: [
          PopupMenuButton<MenuAction>(
            iconColor: Colors.white,
            onSelected: (value) async {
              switch (value) {
                case MenuAction.search:
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const FirebaseUsersSearchPage(),
                    ),
                  );
                case MenuAction.logout:
                  signout();
              }
            },
            itemBuilder: (context) {
              return [
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.search,
                  child: Text("Search"),
                ),
                const PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text("Logout"),
                ),
              ];
            },
          )
        ],
      ),
      body: Center(
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: const Color.fromARGB(255, 208, 47, 240),
        backgroundColor: Colors.grey[900],
        unselectedItemColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        currentIndex: _selectedIndex,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            activeIcon: Icon(
              Icons.home,
              color: Color.fromARGB(255, 208, 47, 240),
            ),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.connect_without_contact),
            activeIcon: Icon(
              Icons.connect_without_contact,
              color: Color.fromARGB(255, 208, 47, 240),
            ),
            label: "Connect",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble),
            activeIcon: Icon(
              Icons.chat_bubble,
              color: Color.fromARGB(255, 208, 47, 240),
            ),
            label: 'Chats',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.post_add_rounded),
            activeIcon: Icon(
              Icons.post_add_rounded,
              color: Color.fromARGB(255, 208, 47, 240),
            ),
            label: 'Feed',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_2),
            activeIcon: Icon(
              Icons.person_2,
              color: Color.fromARGB(255, 208, 47, 240),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  void signout() async {
    try {
      await _auth.signOut();
      if (context.mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil(
          loginRoute,
          (route) => false,
        );
      }
    } on FirebaseAuthException catch (e) {
      //TODO: Implement popup for each error
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      } else {
        print(e.code);
      }
    }
  }
}
