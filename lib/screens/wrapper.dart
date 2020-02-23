import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumcou1/screens/authenticate/authenticae.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/navigation_bar_controller.dart';


class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return BottomNavigationBarController();
    }
  }
}
