import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumcou1/screens/wrapper.dart';
import 'package:tumcou1/services/auth.dart';
import 'package:tumcou1/models/user.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense(
      "NT8mJyc2IWhiZH1nfWN9YGpoYmF8YGJ8ampqanNiYmlmamlmanMDHmg7ODsTKjw9IDY6fTIwfTgh");

  runApp(MaterialApp(
    title: 'My app', // used by the OS task switcher
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        home: Wrapper(),
      ),
    );
  }
}
