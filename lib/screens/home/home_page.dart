import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:barcode_flutter/barcode_flutter.dart';
import 'package:tumcou1/membership_page.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/manager_home/manager_page.dart';
import 'package:tumcou1/services/auth.dart';
import 'package:tumcou1/services/database.dart';
import 'package:provider/provider.dart';
import 'package:tumcou1/screens/home/setting_page.dart';
import 'package:tumcou1/services/database.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumcou1/shared/loading.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key key}) : super(key: key);
  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageValue;
  final PageController controller = PageController();

  void getChangedPageAndMoveBar(int page) {
    currentPageValue = page;
    setState(() {});
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
            if (userData.manager == false) {
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
                body: Column(
                  children: <Widget>[
                    Flexible(
                        flex: 6,
                        child: Container(
                          color: Theme.of(context).primaryColor,
                          child: Column(
                            children: <Widget>[
                              Flexible(
                                flex: 1,
                                child: Container(
                                  color: Theme.of(context).secondaryHeaderColor,
                                  child: Center(
                                      child: Text(
                                    "#텀블러  #친환경  #텀쿠  #플라스틱프리",
                                    style: TextStyle(fontSize: 18),
                                  )),
                                ),
                              ),
                              Flexible(
                                flex: 8,
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Flexible(
                                        flex: 3,
                                        child: PageView.builder(
                                          physics: ClampingScrollPhysics(),
                                          itemCount: introWidgetsList.length,
                                          onPageChanged: (int page) {
                                            getChangedPageAndMoveBar(page);
                                          },
                                          controller: controller,
                                          itemBuilder: (context, index) {
                                            return introWidgetsList[index];
                                          },
                                        ),
                                      ),
                                      Flexible(
                                        flex: 1,
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            for (int i = 0;
                                                i < introWidgetsList.length;
                                                i++)
                                              if (i == currentPageValue)
                                                circleBar(true)
                                              else
                                                circleBar(false),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )),
                    Flexible(
                        flex: 3,
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
                            child: Center(
                              child: BarCodeImage(
                                params: Code39BarCodeParams(
                                  "${userData.barcode}",
                                  lineWidth: 2.5,
                                  // width for a single black/white bar (default: 2.0)
                                  barHeight: 130.0,
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
            } else {
              return ManagerPage();
            }
          } else if (snapshot.hasError) return Text(snapshot.error);
          //스트림빌더 부분으로 랩
          return Loading();
        });
  }

  List<Widget> introWidgetsList = <Widget>[
    Padding(
      padding: const EdgeInsets.only(left: 24, top: 12, right: 24, bottom: 12),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(16)),
            border: Border(
                top: BorderSide(width: 2.0, color: Colors.black),
                bottom: BorderSide(width: 2.0, color: Colors.black),
                left: BorderSide(width: 2.0, color: Colors.black),
                right: BorderSide(width: 2.0, color: Colors.black))),
        child: GestureDetector(
          child: Center(
            child: Icon(
              Icons.add,
              size: 40,
            ),
          ),
        ),
      ),
    ),
    Container(
      child: Center(
        child: Text('second one'),
      ),
    ),
    Container(
      child: Center(
        child: Text('third one'),
      ),
    ),
  ];
//  getBarcode(AsyncSnapshot<QuerySnapshot> snapshot) {
//    return snapshot.data.documents
//        .map((doc) => new ListTile(title: new Text(doc["name"]), subtitle: new Text(doc["amount"].toString())))
//        .toList();
//  }
  Widget circleBar(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8),
      height: isActive ? 12 : 8,
      width: isActive ? 12 : 8,
      decoration: BoxDecoration(
          color: isActive ? Colors.green[700] : Colors.grey,
          borderRadius: BorderRadius.all(Radius.circular(12))),
    );
  }
}
