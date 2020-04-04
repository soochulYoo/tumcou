import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/profile/membership_page.dart';
import 'package:tumcou1/services/auth.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfilePage extends StatefulWidget {
  final UserData userData;
  const ProfilePage({Key key, this.userData}) : super(key: key);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
            'TUMCOU',
            style: GoogleFonts.cambay(
              textStyle: Theme.of(context).textTheme.display1,
              fontWeight: FontWeight.bold,
              color: Colors.blueGrey[700],
            ),
          ),
          centerTitle: true,
        ),
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
                              '${widget.userData.name}',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              '${widget.userData.grade}',
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
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => MembershipPage(widget.userData)),
            );
          },
          label: BarCodeImage(
            params: Code39BarCodeParams(
              "${widget.userData.barcode}",
              lineWidth: 1,
              // width for a single black/white bar (default: 2.0)
              barHeight: 20.0,
              // height for the entire widget (default: 100.0)
              withText: false, // Render with text label or not (default: false)
            ),
            onError: (error) {
              // Error handler
              print('error = $error');
            },
          ),
        ),
        body: Center());
  }
}
