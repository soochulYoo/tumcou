import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:tumcou1/models/customer.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/services/auth.dart';
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/services/manager_database.dart';

class ManagerPage extends StatefulWidget {
  @override
  _ManagerPageState createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  String barcode = "";
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          UserData userData = snapshot.data;
          return Scaffold(
            appBar: AppBar(),
            drawer: Drawer(
              child: Column(
                mainAxisAlignment: MainAxisAlignment
                    .spaceBetween, // place the logout at the end of the drawer
                children: <Widget>[
                  Flexible(
                    child: ListView(
                      padding: EdgeInsets.zero,
                      children: <Widget>[
                        Container(
                          height: 150,
                          child: DrawerHeader(
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColorDark,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  '${userData.name}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                  ),
                                ),
                                Text(
                                  '${userData.grade}',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(Icons.account_circle),
                          title: Text('계정관리'),
                        ),
                        ListTile(
                          leading: Icon(Icons.notifications),
                          title: Text('알림설정'),
                        ),
                        ListTile(
                          leading: Icon(Icons.info),
                          title: Text('정보'),
                          onTap: () {},
                        ),
                        ListTile(
                          leading: Icon(Icons.question_answer),
                          title: Text('고객센터'),
                          onTap: () {},
                        ),
                        ListTile(
                            onTap: () async {
                              Navigator.pop(context);
                              await AuthService().signOut();
                            },
                            dense: true,
                            title: Text("SignOut"),
                            leading: Icon(Icons.exit_to_app)),
                      ],
                    ),
                  ),
                  ListTile(
                    leading: Icon(Icons.home),
                    title: Text('Home'),
                    onTap: () {
                      // change app state...
                      Navigator.pop(context); // close the drawer
                    },
                  ),
                ],
              ),
            ),
            body: Center(
              child: Column(
                children: <Widget>[
                  RaisedButton(
                    color: Colors.lightGreen,
                    onPressed: scan,
                    child: Row(
                      children: <Widget>[
                        Icon(Icons.camera_alt),
                        Text('Barcode Scan'),
                      ],
                    ),
                  ),
                  Text(barcode),
                  StreamBuilder<CustomerData>(
                      stream:
                          ManagerDatabaseService(barcode: barcode).barcodeData,
                      builder: (context, snapshot) {
                        CustomerData customerData = snapshot.data;
                        return FlatButton(
                          child: Text('적립'),
                          onPressed: () {
                            pointAlert(context, barcode, customerData);
                          },
                        );
                      }),
                  SizedBox(height: 200),
                  Container(
                    height: 200,
                    width: 200,
                    color: Colors.lightBlue,
                    child: Center(
                      child: Text('username'),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'Camera permission denied';
        });
      } else {
        setState(() {
          this.barcode = 'Unknown error: $e';
        });
      }
    } on FormatException {
      setState(() {
        this.barcode = 'null (Try again)';
      });
    } catch (e) {
      setState(() {
        this.barcode = 'exeption error: $e';
      });
    }
  }
}

void pointAlert(
    BuildContext context, String barcode, CustomerData customerData) async {
  await showDialog(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('포인트를 적립하시겠습니까?'),
        content: Text(customerData.point.toString()),
        actions: <Widget>[
          FlatButton(
            child: Text('OK'),
            onPressed: () {
              ManagerDatabaseService(barcode: barcode)
                  .setPoint(customerData.point);
              Navigator.pop(context, "Cancel");
            },
          ),
        ],
      );
    },
  );
}
