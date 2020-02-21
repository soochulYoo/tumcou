import 'package:flutter/material.dart';
import 'package:tumcou1/services/auth.dart';

class SettingPage extends StatelessWidget {
  static const String routeName = "/settingPage";
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(
            '설정',
            style: TextStyle(color: Colors.blueGrey, fontSize: 36),
          ),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.home,
                color: Colors.red,
              ),
              // Execute when pressed
              onPressed: () {
                // use the navigator to goto a named route
                Navigator.of(context).pushNamed('/');
              },
              // Setting the size of icon
            )
          ],
        ),
        body: ListView(
          children: <Widget>[
            Container(
              height: 60,
              child: Row(
                children: <Widget>[
                  Text('Entry A'),
                ],
              ),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
            ),
            Container(
              height: 60,
              child: const Center(child: Text('Entry B')),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
            ),
            Container(
              height: 60,
              child: Center(
                  child: FlatButton.icon(
                icon: Icon(Icons.person),
                label: Text('logout'),
                onPressed: () async {
                  await _auth.signOut();
                },
              )),
              decoration:
                  BoxDecoration(border: Border.all(color: Colors.white)),
            ),
          ],
        ));
  }
}

//import 'package:tumcou1/models/user.dart';
//import 'package:tumcou1/navigation_bar_controller.dart';
//import 'package:tumcou1/services/database.dart';
//import 'package:tumcou1/shared/constants.dart';
//import 'package:provider/provider.dart';
//import 'package:tumcou1/shared/loading.dart';
//
//
//class SettingsForm extends StatefulWidget {
//
//  @override
//  _SettingsFormState createState() => _SettingsFormState();
//}
//
//class _SettingsFormState extends State<SettingsForm> {
//
//  final _formKey = GlobalKey<FormState>();
//  final List<String> sugars = ['0','1','2','3','4'];
//
//  // form values
//  String _currentName;
//  String _currentSugars;
//  int _currentStrength;
//
//  @override
//  Widget build(BuildContext context) {
//
//
//
//    final user = Provider.of<User>(context);
//
//    return StreamBuilder<UserData>(
//        stream: DatabaseService(uid: user.uid).userData,
//        builder: (context, snapshot) {
//          if(snapshot.hasData){
//
//            UserData userData = snapshot.data;
//
//            return Scaffold(
//              key: _formKey,
//              body: Column(
//                children: <Widget>[
//                  Text(
//                    'Update your brew settings.',
//                    style: TextStyle(fontSize: 18.0),
//                  ),
//                  SizedBox(height: 20.0),
//                  TextFormField(
//                    initialValue: userData.name,
//                    decoration: textInputDecoration,
//                    validator: (val) => val.isEmpty ? 'Please enter a name' : null,
//                    onChanged: (val) => setState(() => _currentName = val),
//                  ),
//                  SizedBox(height: 20.0),
//                  // dropdown
//                  DropdownButtonFormField(
//                    decoration: textInputDecoration,
//                    value: _currentSugars ?? userData.sugars,
//                    items: sugars.map((sugar) {
//                      return DropdownMenuItem(
//                          value: sugar,
//                          child: Text('$sugar sugars')
//                      );
//                    }).toList(),
//                    onChanged: (val) => setState(() => _currentSugars = val),
//                  ),
//                  // slider
//                  Slider(
//                    value: (_currentStrength ?? userData.strength).toDouble(),
//                    activeColor: Colors.brown[_currentStrength ?? userData.strength],
//                    inactiveColor: Colors.brown[_currentStrength ?? userData.strength],
//                    min: 100.0,
//                    max: 900.0,
//                    divisions: 8,
//                    onChanged: (val) => setState(() => _currentStrength = val.round()),
//                  ),
//                  RaisedButton(
//                    color: Colors.pink[400],
//                    child: Text(
//                      'Update',
//                      style: TextStyle(color: Colors.white),
//                    ),
//                    onPressed: () async {
//                      if(_formKey.currentState.validate()){
//                        await DatabaseService(uid: user.uid).updateUserData(
//                          _currentSugars ?? userData.sugars,
//                          _currentName ?? userData.name,
//                          _currentStrength ?? userData.strength,
//                        );
//                        Navigator.push(context, MaterialPageRoute(
//                            builder: (
//                                context) => (BottomNavigationBarController())));
//                      }
//                    },
//                  )
//                ],
//              ),
//            );
//          } else {
//            return Loading();
//          }
//
//        }
//    );
//  }
//}
