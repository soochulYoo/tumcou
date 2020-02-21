import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

abstract class Styles {
  static Text appBarText = Text('TUMCOU',
      style: GoogleFonts.anton(
          textStyle: TextStyle(
        color: Colors.blueGrey[700],
        fontSize: 36,
        fontWeight: FontWeight.bold,
      )));

  static const TextStyle cafeRowItemName = TextStyle(
    color: Color.fromRGBO(1, 0, 1, 0.9),
    fontSize: 19,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle cafeRowTotal = TextStyle(
    color: Color.fromRGBO(1, 0, 1, 0.9),
    fontSize: 19,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle cafeRowItemValue = TextStyle(
    color: Color.fromRGBO(1, 0, 1, 0.9),
    fontSize: 19,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const TextStyle searchText = TextStyle(
    color: Color.fromRGBO(1, 0, 1, 0.9),
    fontSize: 19,
    fontStyle: FontStyle.normal,
    fontWeight: FontWeight.normal,
  );

  static const Color cafeRowDivider = Color(0xFFd9d9d9);

  static const Color scaffoldBackground = Color(0xfff0f0f0);

  static const Color searchBackground = Color(0xffe0e0e0);

  static const Color searchCursorColor = Color.fromRGBO(0, 122, 255, 1);

  static const Color searchIconColor = Color.fromRGBO(128, 128, 128, 1);
}
