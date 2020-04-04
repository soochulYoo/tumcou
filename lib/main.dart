import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:tumcou1/screens/manager_home/manager_page.dart';
import 'package:tumcou1/screens/wrapper.dart';
import 'package:tumcou1/services/auth.dart';
import 'package:tumcou1/models/user.dart';

void main() {
  runApp(
    MyApp(),
  );
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
          theme: ThemeData(
              primaryColor: Color(0xffEFEEEE),
              accentColor: Color(0xff999999),
              buttonColor: Colors.grey[400],
              textTheme: TextTheme(
                headline1: GoogleFonts.nanumPenScript(
                    fontSize: 44, color: Colors.black),
                headline2: GoogleFonts.nanumPenScript(
                    fontSize: 20, color: Colors.black),
                bodyText1:
                    GoogleFonts.nanumGothic(fontSize: 16, color: Colors.black),
                button:
                    GoogleFonts.nanumGothic(fontSize: 14, color: Colors.black),
              )),
          home: Wrapper()),
    );
  }
}
