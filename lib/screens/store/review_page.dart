import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:tumcou1/models/cafe.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/store/alert.dart';
import 'package:tumcou1/screens/store/review_writing_page.dart';
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/shared/loading.dart';

class ReviewPage extends StatefulWidget {
  final CafeData cafeData;
  final UserData userData;
  ReviewPage(this.cafeData, this.userData);

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  int amountOfReview;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.cafeData.name + ' 리뷰 페이지'),
        ),
        floatingActionButton: FloatingActionButton.extended(
            backgroundColor: Colors.white,
            onPressed: () {
              if (widget.userData == null) {
                return writingAlert(context);
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ReviewWritingPage(
                      widget.cafeData.id, amountOfReview, widget.userData);
                }));
              }
            },
            label: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: Icon(Icons.edit, color: Theme.of(context).accentColor),
                ),
                Text(
                  '리뷰 작성하기',
                  style: Theme.of(context).textTheme.display2.copyWith(
                      color: Theme.of(context).accentColor,
                      fontWeight: FontWeight.bold),
                )
              ],
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        body: StreamBuilder(
            stream: DatabaseService(cafeId: widget.cafeData.id).reviewData,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Loading();
              } else {
                amountOfReview = snapshot.data.documents.length;
                return Column(
                  children: <Widget>[
                    FutureBuilder(
                        future: DatabaseService(
                                cafeId: widget.cafeData.id,
                                amountOfReview: amountOfReview)
                            .reviewMean,
                        builder: (context, snapshot) {
                          double reviewMean = snapshot.data;
                          if (!snapshot.hasData) {
                            return Loading();
                          } else {
                            return Container(
                                margin: EdgeInsets.only(
                                    left: 10, top: 8, right: 10),
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(8.0))),
                                child: Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Align(
                                        alignment: Alignment.centerLeft,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              'Reviews',
                                              style: TextStyle(fontSize: 40.0),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8.0),
                                              child: VerticalDivider(
                                                thickness: 2,
                                              ),
                                            ),
                                            RatingBar.readOnly(
                                              maxRating: 1,
                                              initialRating: 1,
                                              filledIcon: Icons.star,
                                              halfFilledIcon: Icons.star_half,
                                              emptyIcon: Icons.star_border,
                                              filledColor: Colors.amber,
                                              halfFilledColor: Colors.amber,
                                              emptyColor: Colors.amber,
                                              size: 28,
                                              isHalfAllowed: true,
                                            ),
                                            Text(
                                              '$reviewMean',
                                              style: TextStyle(fontSize: 28.0),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ));
                          }
                        }),
                    StreamBuilder(
                        stream: DatabaseService(cafeId: widget.cafeData.id)
                            .reviewData,
                        builder: (context, snapshot) {
                          if (!snapshot.hasData) {
                            return Loading();
                          } else {
                            return Expanded(
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: amountOfReview,
                                  padding: const EdgeInsets.only(top: 5.0),
                                  itemBuilder: (context, index) {
                                    DocumentSnapshot ds =
                                        snapshot.data.documents[index];
                                    return Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: RatingBar.readOnly(
                                                  initialRating: ds['rating'],
                                                  filledIcon: Icons.star,
                                                  emptyIcon: Icons.star_border,
                                                  filledColor: Colors.amber,
                                                  emptyColor: Colors.amber,
                                                  size: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Text(ds['text']),
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    );
                                  }),
                            );
                          }
                        }),
                  ],
                );
              }
            }),
      ),
    );
  }
}
