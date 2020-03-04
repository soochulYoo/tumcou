import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:tumcou1/models/cafe.dart';
import 'package:tumcou1/services/database.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumcou1/shared/loading.dart';

class ReviewPage extends StatefulWidget {
  final CafeData cafeData;

  ReviewPage(
    this.cafeData,
  );

  @override
  _ReviewPageState createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TUMCOU',
            style: GoogleFonts.cambay(
                textStyle: TextStyle(
              color: Colors.blueGrey[700],
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ))),
        centerTitle: true,
      ),
      body: StreamBuilder(
          stream: DatabaseService(index: widget.cafeData.id).reviewData,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              int amountOfReview = snapshot.data.documents.length;
              return Column(
                children: <Widget>[
                  FutureBuilder(
                      future: DatabaseService(
                              index: widget.cafeData.id,
                              amountOfReview: amountOfReview)
                          .reviewMean,
                      builder: (context, snapshot) {
                        double reviewMean = snapshot.data;
                        if (!snapshot.hasData) {
                          return Loading();
                        } else {
                          return Container(
                              margin:
                                  EdgeInsets.only(left: 10, top: 8, right: 10),
                              decoration: BoxDecoration(
                                  color: Colors.yellow,
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
                                            'Reviews |',
                                            style: TextStyle(fontSize: 40.0),
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
                                  MyCustomForm(
                                      widget.cafeData.id, amountOfReview),
                                ],
                              ));
                        }
                      }),
                  StreamBuilder(
                      stream:
                          DatabaseService(index: widget.cafeData.id).reviewData,
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
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
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
    );
  }
}

class MyCustomForm extends StatefulWidget {
  final int cafeId;
  final int amountOfReview;
  MyCustomForm(this.cafeId, this.amountOfReview);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _myController = TextEditingController();
  double _rating = 5;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        RaisedButton(
          child: Text('평가하기'),
          onPressed: () {
            showAlertDialog();
          },
        ),
      ],
    );
  }

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('평가해주세요!!'),
          content: SingleChildScrollView(
              child: Column(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: RatingBar(
                    initialRating: 5,
                    maxRating: 5,
                    filledIcon: Icons.star,
                    emptyIcon: Icons.star_border,
                    filledColor: Colors.amber,
                    emptyColor: Colors.amber,
                    size: 25,
                    onRatingChanged: (rating) {
                      setState(() {
                        if (rating == null)
                          _rating = 5;
                        else
                          _rating = rating;
                      });
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            TextField(
              controller: _myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: '이 장소의 어떤 점이 만족스러웠나요?',
              ),
            ),
          ])),
          actions: <Widget>[
            FlatButton(
              child: Text('취소'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            FlatButton(
              child: Text('등록'),
              onPressed: () {
                String time = generateDbTimeKey();
                uploadReview(widget.cafeId, widget.amountOfReview, _rating,
                    _myController.text, time);
                _myController.clear();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String generateDbTimeKey() {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('yyyy, MMM d, ');
    var formatTime = DateFormat('hh:mm aaaa, EEEE');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    return date + time;
  }

  // case (cafenum < 10 > 00x)
  // case (10<= cafenum < 100 : 0x)
  // case (100= cafenum : x)
  Future uploadReview(
    int cafeNum,
    int reviewNum,
    double rating,
    String text,
    var time,
  ) async {
    return await Firestore.instance
        .collection('Cafe')
        .document('cafe$cafeNum')
        .collection('review')
        .document('review$reviewNum')
        .setData({
      'rating': rating,
      'text': text,
      'time': time,
    });
  }
}
