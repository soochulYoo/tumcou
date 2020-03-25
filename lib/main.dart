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
              primaryColor: Colors.white,
              accentColor: Color(0xff00AD65),
              textTheme: TextTheme(
                  display1: GoogleFonts.nanumGothic(
                    fontSize: 44,
                  ),
                  display2: GoogleFonts.nanumGothic(
                    fontSize: 22,
                  ),
                  display3: GoogleFonts.nanumGothic(
                    fontSize: 18,
                  ))),
          home: Wrapper()),
    );
  }
}
