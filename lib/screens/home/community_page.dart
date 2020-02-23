import 'package:tumcou1/models/cafe.dart';
import 'package:flutter/material.dart';
import 'package:tumcou1/screens/home/userReview_page.dart';
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/shared/loading.dart';
import 'package:tumcou1/shared/styles.dart';
import 'package:google_fonts/google_fonts.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
            primaryColor: Colors.green[50],
            primaryColorDark: Color.fromRGBO(182, 194, 183, 50),
            // secondary color
            secondaryHeaderColor: Colors.lightGreen[400],
            textTheme: TextTheme(
              headline6: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: 36.0,
                  fontWeight: FontWeight.bold),
              headline5: TextStyle(
                  color: Colors.blueGrey[700],
                  fontSize: 24.0,
                  fontStyle: FontStyle.italic),
              bodyText2: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
            )),
        home: MainPage());
  }
}

class MainPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Center(
              child: Text('TUMCOU',
                  style: GoogleFonts.cambay(
                      textStyle: TextStyle(
                    color: Colors.blueGrey[700],
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  )))),
        ),
        body: Container(
          color: Colors.green[50],
          child: LayoutBuilder(
              builder: (BuildContext context, BoxConstraints constrains) {
            return ListView.builder(
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return StreamBuilder<CafeData>(
                      stream: DatabaseService(index: index).cafeData,
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return Text('Error: ${snapshot.error}');
                        } else {
                          CafeData cafeData = snapshot.data;
                          return FutureBuilder<String>(
                              future: DatabaseService().getCafeImageUrl(index),
                              builder: (context, snapshot) {
                                if (snapshot.hasError)
                                  return Text(snapshot.error);
                                else {
                                  String _cafeImageUrl = snapshot.data;
                                  String _cafeLogoImageUrl;
                                  return Container(
                                      margin: EdgeInsets.only(
                                          left: 10, top: 15, right: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      height: constrains.maxHeight * 1 / 2,
                                      child: Column(children: <Widget>[
                                        Container(
                                          height: constrains.maxHeight / 4,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          decoration: BoxDecoration(
                                              image: DecorationImage(
                                                  image: NetworkImage(
                                                      '$_cafeImageUrl'),
                                                  fit: BoxFit.cover),
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(8.0))),

//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(15.0),
//                                  border: Border.all(color: Colors.red)),
                                        ),
                                        Container(
                                          padding: EdgeInsets.all(4),
                                          child: Row(
                                            children: <Widget>[
                                              Flexible(
                                                flex: 1,
                                                child: FutureBuilder<String>(
                                                    future: DatabaseService()
                                                        .getCafeLogoImageUrl(
                                                            index),
                                                    builder:
                                                        (context, snapshot) {
                                                      if (snapshot.hasError)
                                                        return Text(
                                                            snapshot.error);
                                                      else {
                                                        _cafeLogoImageUrl =
                                                            snapshot.data;
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                              image: DecorationImage(
                                                                  image: NetworkImage(
                                                                      '$_cafeLogoImageUrl'),
                                                                  fit: BoxFit
                                                                      .cover),
                                                              borderRadius: BorderRadius
                                                                  .all(Radius
                                                                      .circular(
                                                                          4.0))),
                                                          height: constrains
                                                                  .maxHeight /
                                                              8,
                                                          padding:
                                                              EdgeInsets.all(
                                                                  8.0),
                                                        );
                                                      }
                                                    }),
                                              ),
                                              Flexible(
                                                flex: 3,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text('${cafeData.name}',
                                                          style: GoogleFonts
                                                              .notoSans(
                                                                  textStyle:
                                                                      TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ))),
                                                      Text(
                                                          '"${cafeData.introduction}"',
                                                          style: GoogleFonts.notoSans(
                                                              textStyle:
                                                                  TextStyle(
                                                                      fontSize:
                                                                          16))),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Expanded(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        UserReviewPage(
                                                            cafeData,
                                                            _cafeImageUrl,
                                                            _cafeLogoImageUrl)),
                                              );
                                            },
                                            child: Container(
                                              color: Colors.lightGreen,
                                              child: Center(
                                                  child: Text(
                                                'Review',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 36),
                                              )),
                                            ),
                                          ),
                                        )
                                      ]));
                                }
                              });
                        }
                      });
                });
          }),
        ));
  }
}
