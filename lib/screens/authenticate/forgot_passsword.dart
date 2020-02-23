import 'package:flutter/material.dart';

class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: RaisedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text('forgot password')
        )
    );
  }
}