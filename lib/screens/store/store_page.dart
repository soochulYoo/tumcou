import 'package:tumcou1/models/cafe.dart';
import 'package:flutter/material.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/store/store_detail_page.dart';
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StorePage extends StatelessWidget {
  final UserData userData;
  const StorePage({Key key, this.userData}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Icon(Icons.map),
            ),
          ),
        ),
        body: Container(
            color: Colors.white,
            child: LayoutBuilder(builder: (context, constraints) {
              return StreamBuilder(
                  stream: Firestore.instance.collection("Cafe").snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return Loading();
                    } else {
                      int amountOfCafe = snapshot.data.documents.length;
                      return ListView.builder(
                        padding: EdgeInsets.only(top: 10),
                        itemCount: amountOfCafe,
                        itemBuilder: (BuildContext context, int index) {
                          return GridItem(index, constraints.maxWidth);
                        },
                      );
                    }
                  });
            })));
  }
}

class GridItem extends StatelessWidget {
  final index;
  final maxWidth;
  GridItem(this.index, this.maxWidth);

  @override
  Widget build(BuildContext context) {
    double reviewMean = 0;
    return StreamBuilder<CafeData>(
        stream: DatabaseService(cafeId: index).cafeData,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Loading();
//                          return Text('Error: ${snapshot.error}');
          } else {
            CafeData cafeData = snapshot.data;
            return FutureBuilder<CafeUrl>(
                future: DatabaseService(cafeId: index).getCafeUrl,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Loading();
                  } else {
                    CafeUrl cafeUrl = snapshot.data;
                    return StreamBuilder(
                        stream: DatabaseService(cafeId: index).reviewData,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Loading();
                          } else {
                            int amountOfReview = snapshot.data.documents.length;
                            return Stack(children: <Widget>[
                              Column(
                                children: <Widget>[
                                  Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 4.0),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(8.0))),
                                      child: Row(children: <Widget>[
                                        Flexible(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            child: Container(
                                              width: maxWidth / 3,
                                              height: maxWidth / 4,
                                              decoration: BoxDecoration(
                                                  image: DecorationImage(
                                                      image: NetworkImage(
                                                          '${cafeUrl.cafeImageUrl}'),
                                                      fit: BoxFit.fill),
                                                  borderRadius:
                                                      BorderRadius.all(
                                                          Radius.circular(
                                                              12.0))),
                                            ),
                                          ),
                                        ),
                                        Flexible(
                                          flex: 2,
                                          child: Container(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 4.0),
                                                  child: Text(
                                                    '${cafeData.name}',
                                                    style: GoogleFonts.notoSans(
                                                      textStyle: TextStyle(
                                                        fontSize: 24,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                    maxLines: 2,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 8.0),
                                                  child: Text(
                                                    '${cafeData.introduction}',
                                                    textAlign: TextAlign.left,
                                                    style: TextStyle(
                                                      fontSize: 14.0,
                                                      color: Theme.of(context)
                                                          .accentColor,
                                                    ),
                                                  ),
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons.location_on,
                                                      size: 12.0,
                                                    ),
                                                    Text(
                                                      '${cafeData.location}',
                                                      style: TextStyle(
                                                        fontSize: 12.0,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ])),
                                  Divider(
                                    thickness: 1,
                                  )
                                ],
                              ),
                              Positioned.fill(
                                  child: Material(
                                color: Colors.transparent,
                                child: InkWell(onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => StoreDetailPage(
                                            cafeData, cafeUrl, amountOfReview)),
                                  );
                                }),
                              )),
                            ]);
                          }
                        });
                  }
                });
          }
        });
  }
}
