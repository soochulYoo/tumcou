import 'package:tumcou1/screens/authenticate/sign_in.dart';

class User {
  final String uid;

  User({this.uid});
}

class UserData {
  final String uid;
  final String name;
  final String grade;
  final String barcode;

  UserData({
    this.uid,
    this.name,
    this.grade,
    this.barcode,
  });
}

class BarcodeData {
  final String uid;
  final String barcode;

  BarcodeData({this.uid, this.barcode});
}

//class UserEmailPassword {
//  final String email;
//  final String password;
//
//  UserEmailPassword(this.email, this.password);
//}
