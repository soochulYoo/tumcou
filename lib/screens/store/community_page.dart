import 'package:tumcou1/models/cafe.dart';
import 'package:flutter/material.dart';
import 'package:tumcou1/screens/store/community_detail_page.dart';
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/shared/loading.dart';
import 'package:tumcou1/shared/styles.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rating_bar/rating_bar.dart';

class CommunityPage extends StatelessWidget {
  const CommunityPage({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: <Widget>[Icon(Icons.search)],
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
                        itemCount: amountOfCafe,
                        itemBuilder: (BuildContext context, int index) {
                          return GridItem(index, constraints.maxHeight);
                        },
                      );
                    }
                  });
            })));
  }
}

class GridItem extends StatelessWidget {
  final index;
  final maxHeight;
  GridItem(this.index, this.maxHeight);

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
                              Container(
                                  margin: EdgeInsets.symmetric(vertical: 8.0),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8.0))),
                                  child: Column(children: <Widget>[
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 12),
                                      height: maxHeight / 2.5,
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: NetworkImage(
                                                  '${cafeUrl.cafeImageUrl}'),
                                              fit: BoxFit.cover),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(12.0))),

//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(15.0),
//                                  border: Border.all(color: Colors.red)),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 12.0),
                                      child: Column(
                                        children: <Widget>[
                                          Row(
                                            children: <Widget>[
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 4.0,
                                                    top: 8.0,
                                                    right: 8.0),
                                                child: Text(
                                                  '${cafeData.name}',
                                                  style: GoogleFonts.notoSans(
                                                    textStyle: TextStyle(
                                                      fontSize: 32,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                  maxLines: 1,
                                                ),
                                              ),
                                              Expanded(
                                                child: FutureBuilder(
                                                    future: DatabaseService(
                                                            cafeId: index,
                                                            amountOfReview:
                                                                amountOfReview)
                                                        .reviewMean,
                                                    builder:
                                                        (context, snapshot) {
                                                      reviewMean =
                                                          snapshot.data;
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                top: 12.0),
                                                        child: Row(
                                                          children: <Widget>[
                                                            RatingBar.readOnly(
                                                              maxRating: 1,
                                                              initialRating: 1,
                                                              filledIcon:
                                                                  Icons.star,
                                                              halfFilledIcon:
                                                                  Icons
                                                                      .star_half,
                                                              emptyIcon: Icons
                                                                  .star_border,
                                                              filledColor: Theme
                                                                      .of(context)
                                                                  .accentColor,
                                                              halfFilledColor:
                                                                  Colors.amber,
                                                              emptyColor:
                                                                  Colors.amber,
                                                              size: 20,
                                                              isHalfAllowed:
                                                                  true,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(4.0),
                                                              child: Text(
                                                                "$reviewMean",
                                                                style: TextStyle(
                                                                    fontSize:
                                                                        16.0,
                                                                    color: Theme.of(
                                                                            context)
                                                                        .accentColor),
                                                              ),
                                                            ),
                                                            Text("(",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                )),
                                                            Icon(
                                                              Icons.edit,
                                                              size: 16,
                                                            ),
                                                            Text(
                                                                "$amountOfReview)",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                )),
                                                          ],
                                                        ),
                                                      );
                                                    }),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 4.0,
                                                top: 8.0,
                                                bottom: 8.0),
                                            child: Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  '${cafeData.introduction}',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                    color: Theme.of(context)
                                                        .accentColor,
                                                  ),
                                                )),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0),
                                            child: Row(
                                              children: <Widget>[
                                                Icon(
                                                  Icons.location_on,
                                                  size: 24.0,
                                                ),
                                                Text(
                                                  '${cafeData.location}',
                                                  style: TextStyle(
                                                    fontSize: 16.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ])),
                              Positioned.fill(
                                  child: Material(
                                color: Colors.transparent,
                                child: InkWell(onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            CommunityDetailPage(cafeData,
                                                cafeUrl, amountOfReview)),
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
