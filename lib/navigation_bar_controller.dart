import 'package:flutter/material.dart';
import 'screens/home/event_page/event_page.dart';
import 'screens/home/home_page.dart';
import 'screens/home/community_page.dart';

class BottomNavigationBarController extends StatefulWidget {
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  final List<Widget> pages = [
    HomePage(
      key: PageStorageKey('Page1'),
    ),
    CommunityPage(
      key: PageStorageKey('Page2'),
    ),
    EventPage(
      key: PageStorageKey('Page3'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.people), title: Text('Community')),
          BottomNavigationBarItem(
              icon: Icon(Icons.card_giftcard), title: Text('Event')),
        ],
        selectedItemColor: Colors.blueGrey[700],
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
