import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
  contentPadding: EdgeInsets.all(8.0),
  //prefixIcon: Icon(Icons.account_circle),
  //hintText: 'Email',
  fillColor: Colors.white,
  filled: true,
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Colors.white, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(20.0)),
  ),
);
