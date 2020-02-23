import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:tumcou1/membership_page.dart';
import 'package:tumcou1/models/user.dart';
//
import 'package:tumcou1/services/auth.dart';
import 'package:tumcou1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:tumcou1/screens/home/setting_page.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:tumcou1/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumcou1/shared/loading.dart';

class HomePage extends StatelessWidget {
  HomePage({Key key}) : super(key: key);

  // const HomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primaryColor: Colors.green[50],
        primaryColorDark: Color.fromRGBO(182, 194, 183, 50),
        // secondary color
        secondaryHeaderColor: Colors.lightGreen[400],
        textTheme: TextTheme(
          headline6: TextStyle(
              color: Colors.green, fontSize: 40.0, fontWeight: FontWeight.bold),
          headline5: TextStyle(
              color: Colors.blueGrey[700],
              fontSize: 24.0,
              fontStyle: FontStyle.italic),
          bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
        ),
      ),
      home: MyHomePage(title: 'TUMCOU'),
      routes: <String, WidgetBuilder>{
        // Set named routes
        SettingPage.routeName: (BuildContext context) => SettingPage(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return StreamBuilder<UserData>(
        stream: DatabaseService(uid: user.uid).userData,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserData userData = snapshot.data;
            return Scaffold(
              appBar: AppBar(
                // Here we take the value from the MyHomePage object that was created by
                // the App.build method, and use it to set our appbar title.
                title: Text(
                  widget.title,
                  style: GoogleFonts.cambay(
                    textStyle: Theme.of(context).textTheme.headline6,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[700],
                  ),
                ),
                centerTitle: true,
              ),
              drawer: Drawer(
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
                                color: Colors.blueGrey[700],
                                fontSize: 24,
                              ),
                            ),
                            Text(
                              '${userData.grade}',
                              style: TextStyle(
                                color: Colors.blueGrey[700],
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
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
                    ListTile(
                      leading: Icon(Icons.message),
                      title: Text('Messages'),
                    ),
                    ListTile(
                      leading: Icon(Icons.account_circle),
                      title: Text('Profile'),
                    ),
                    ListTile(
                      leading: Icon(Icons.settings),
                      title: Text('Settings'),
                      onTap: () {
                        // https://stackoverflow.com/questions/44978216/flutter-remove-back-button-on-appbar
                        Navigator.pushNamedAndRemoveUntil(
                            context, '/settingPage', (_) => false);
                      },
                    ),
                  ],
                ),
              ),
              body: Column(
                children: <Widget>[
                  Flexible(
                      flex: 5,
                      child: Container(
                        color: Theme.of(context).primaryColor,
                        child: Column(
                          children: <Widget>[
                            Flexible(
                              flex: 1,
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                color: Theme.of(context).secondaryHeaderColor,
                                height: 40,
                                child: Center(
                                    child: Text(
                                  "#텀블러  #친환경  #텀쿠  #플라스틱프리",
                                  style: TextStyle(fontSize: 18),
                                )),
                              ),
                            ),
                            Flexible(
                              flex: 6,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.green[50],
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Flexible(
                                        flex: 2,
                                        child: Padding(
                                          padding: EdgeInsets.all(20.0),
                                          child: Container(
                                              child: Image.asset(
                                                  'assets/icon/cafe.png')),
                                        ),
                                      ),
                                      Flexible(
                                          flex: 1,
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: <Widget>[
                                                Spacer(flex: 2),
                                                RotationTransition(
                                                  turns: AlwaysStoppedAnimation(
                                                      -30 / 360),
                                                  child: Container(
                                                      height: 60,
                                                      child: Image.asset(
                                                          "assets/icon/right-arrow.png")),
                                                ),
                                                Spacer(flex: 1),
                                                RotationTransition(
                                                  turns: AlwaysStoppedAnimation(
                                                      30 / 360),
                                                  child: Container(
                                                      height: 60,
                                                      child: Image.asset(
                                                          "assets/icon/right-arrow.png")),
                                                ),
                                                Spacer(flex: 2),
                                              ],
                                            ),
                                          )),
                                      Flexible(
                                          flex: 2,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: <Widget>[
                                              Container(
                                                height: 90,
                                                child: Stack(children: <Widget>[
                                                  Center(
                                                    child: FittedBox(
                                                      child: Image.asset(
                                                          'assets/icon/straw.png'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: 70,
                                                      child: Image.asset(
                                                          'assets/icon/stop.png'),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                              Container(
                                                height: 110,
                                                child: Stack(children: <Widget>[
                                                  Center(
                                                    child: FittedBox(
                                                      child: Image.asset(
                                                          'assets/icon/tumbler_icon.png'),
                                                      fit: BoxFit.fill,
                                                    ),
                                                  ),
                                                  Center(
                                                    child: Container(
                                                      height: 30,
                                                      child: Image.asset(
                                                          'assets/icon/check.png'),
                                                    ),
                                                  ),
                                                ]),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  Flexible(
                    flex: 5,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: FittedBox(
                        child: Image.asset('assets/card/card1.png'),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Flexible(
                      flex: 2,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MembershipPage()),
                          );
                        },
                        child: Container(
                          constraints: BoxConstraints.expand(),
                          color: Theme.of(context).primaryColorDark,
                          child: Center(
                            child: BarCodeImage(
                              params: Code39BarCodeParams(
                                "${userData.barcode}",
                                lineWidth: 2,
                                // width for a single black/white bar (default: 2.0)
                                barHeight: 100.0,
                                // height for the entire widget (default: 100.0)
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
                      )),
                ],
              ),
            );
          } else if (snapshot.hasError) return Text(snapshot.error);
          //스트림빌더 부분으로 랩
          return Loading();
        });
  }
//  getBarcode(AsyncSnapshot<QuerySnapshot> snapshot) {
//    return snapshot.data.documents
//        .map((doc) => new ListTile(title: new Text(doc["name"]), subtitle: new Text(doc["amount"].toString())))
//        .toList();
//  }
}
