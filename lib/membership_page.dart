import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:tumcou1/models/user.dart';
import 'services/database.dart';
import 'package:provider/provider.dart';

class MembershipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return Center(
      child: StreamBuilder<UserData>(
          stream: DatabaseService(uid: user.uid).userData,
          builder: (context, snapshot) {
            UserData userData = snapshot.data;
            return RaisedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: RotationTransition(
                turns: AlwaysStoppedAnimation(90 / 360),
                child: Center(
                  child: BarCodeImage(
                    params: Code39BarCodeParams(
                      "${userData.barcode}",
                      lineWidth:
                          3.0, // width for a single black/white bar (default: 2.0)
                      barHeight:
                          150.0, // height for the entire widget (default: 100.0)
                      withText:
                          true, // Render with text label or not (default: false)
                    ),
                    onError: (error) {
                      // Error handler
                      print('error = $error');
                    },
                  ),
                ),
              ),
            );
          }),
    );
  }
}
