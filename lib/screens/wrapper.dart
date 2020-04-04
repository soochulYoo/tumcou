import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumcou1/screens/authenticate/authenticae.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/navigation_bar_controller.dart';
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/shared/loading.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return Authenticate();
    } else {
      return StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              return BottomNavigationBarController(snapshot.data);
            }
          });
    }
  }
}
