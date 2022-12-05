import 'package:eventit_mobile/pages/account.dart';
import 'package:eventit_mobile/pages/add_event.dart';
import 'package:eventit_mobile/pages/home.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _MainState();
}

class _MainState extends State<Main> {
  var _index = 0;

  @override
  Widget build(BuildContext context) {
    const routes = [
      Home(),
      AddEvent(),
      Account(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: routes,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (index) {
          if (index == 2) {
            FirebaseAuth.instance.signOut();
            return;
          }

          setState(() {
            _index = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add Event"),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: "Log out",
          ),
        ],
      ),
    );
  }
}
