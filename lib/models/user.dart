
import 'package:tumcou1/screens/authenticate/sign_in.dart';

class User {

  final String uid;

  User({ this.uid });

}

class UserData {

  final String uid;
  final String name;
  final String grade;
  final int xp;
  final String barcode;
  final int age;
  final String gender;

  UserData({ this.uid, this.name, this.grade, this.xp, this.barcode, this.age, this.gender });
}

class BarcodeData {
  final String uid;
  final String barcode;

  BarcodeData({ this.uid, this.barcode});
}

//class UserEmailPassword {
//  final String email;
//  final String password;
//
//  UserEmailPassword(this.email, this.password);
//}