import 'package:flutter/material.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/community/community_page.dart';
import 'package:tumcou1/screens/home/home_page.dart';
import 'package:tumcou1/screens/profile/profile_page.dart';
import 'package:tumcou1/screens/store/store_page.dart';

class BottomNavigationBarController extends StatefulWidget {
  final UserData userData;
  BottomNavigationBarController(this.userData);
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  List<Widget> _pages() => [
        HomePage(
          key: PageStorageKey('Page1'),
          userData: widget.userData,
        ),
        CommunityPage(
          key: PageStorageKey('Page2'),
          userData: widget.userData,
        ),
        StorePage(
          key: PageStorageKey('Page3'),
          userData: widget.userData,
        ),
        ProfilePage(
          key: PageStorageKey('Page4'),
          userData: widget.userData,
        ),
      ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget _bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Theme.of(context).buttonColor,
              ),
              title: Text('Home', style: Theme.of(context).textTheme.button),
              activeIcon: Icon(
                Icons.home,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.chat,
                color: Theme.of(context).buttonColor,
              ),
              title:
                  Text('Community', style: Theme.of(context).textTheme.button),
              activeIcon: Icon(
                Icons.chat,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.location_on,
                color: Theme.of(context).buttonColor,
              ),
              title: Text(
                'Store',
                style: Theme.of(context).textTheme.button,
              ),
              activeIcon: Icon(
                Icons.location_on,
                color: Colors.black,
              )),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Theme.of(context).buttonColor,
              ),
              title: Text(
                'Profile',
                style: Theme.of(context).textTheme.button,
              ),
              activeIcon: Icon(
                Icons.person,
                color: Colors.black,
              ))
        ],
      );

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = _pages();
    return Scaffold(
      bottomNavigationBar: _bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
