import 'package:flutter/material.dart';
import 'package:urbanheight/tab/profile.dart';
import 'package:urbanheight/tab/home.dart';
import 'package:urbanheight/tab/settings.dart';

class MainHome extends StatefulWidget {
  static String tag = 'mainhome';
  @override
  State<StatefulWidget> createState() {
    return _MainHomeState();
  }
}

class _MainHomeState extends State<MainHome> {
  int _currentIndex = 0;
  final List<Widget> _children = [Home(), Setting(), Profile()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: onTabTapped,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            title: Text('Histori'),
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.person), 
              title: Text('Profile'))
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
