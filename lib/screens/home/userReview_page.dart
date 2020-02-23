import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/models/cafe.dart';
import 'package:tumcou1/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rating_bar/rating_bar.dart';

class UserReviewPage extends StatefulWidget {
  final CafeData cafeData;
  final String cafeImageUrl;
  final String cafeLogoImageUrl;
  UserReviewPage(this.cafeData, this.cafeImageUrl, this.cafeLogoImageUrl);

  @override
  _UserReviewPageState createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text('Firestore File Upload'),
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constrains) {
        return Column(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                    margin: EdgeInsets.only(left: 10, top: 15, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    height: constrains.maxHeight * 1 / 3,
                    child: Column(children: <Widget>[
                      Container(
                        height: constrains.maxHeight * 1 / 5,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage('${widget.cafeImageUrl}'),
                                fit: BoxFit.cover),
                            borderRadius:
                                BorderRadius.all(Radius.circular(12.0))),

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
                                child: Container(
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: NetworkImage(
                                              '${widget.cafeLogoImageUrl}'),
                                          fit: BoxFit.cover),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(4.0))),
                                  height: constrains.maxHeight / 10,
                                  padding: EdgeInsets.all(8.0),
                                )),
                            Flexible(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${widget.cafeData.name}',
                                        style: GoogleFonts.notoSans(
                                            textStyle: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w600,
                                        ))),
                                    Text('"${widget.cafeData.introduction}"',
                                        style: GoogleFonts.notoSans(
                                            textStyle:
                                                TextStyle(fontSize: 16))),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ])),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 8, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    width: constrains.maxWidth,
                    child: Column(children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.location_on,
                                    size: 20.0,
                                  )),
                              Expanded(
                                flex: 10,
                                child: Text('${widget.cafeData.location}'),
                              ),
                            ],
                          )),
                      Divider(),
                      Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Icon(
                                    Icons.access_time,
                                    size: 20.0,
                                  )),
                              Expanded(
                                flex: 10,
                                child: Text('${widget.cafeData.openingHours}'),
                              ),
                            ],
                          )),
                    ])),
              ],
            ),
            StreamBuilder(
              stream: Firestore.instance
                  .collection("Cafe")
                  .document('cafe${widget.cafeData.id}')
                  .collection('review')
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  int _reviewNum = snapshot.data.documents.length;
                  return Column(
                    children: <Widget>[
                      Container(
                          margin: EdgeInsets.only(left: 10, top: 8, right: 10),
                          decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(8.0))),
                          height: constrains.maxHeight * 1 / 4,
                          child: Column(
                            children: <Widget>[
                              MyCustomForm(widget.cafeData.id, _reviewNum),
//                    RaisedButton(
//                      child: Text('Choose Image'),
//                      onPressed: () {
//                        getReview(widget.index);
//                      },
//                      color: Colors.cyan,
//                    )
                            ],
                          )),
                      Container(
                        margin: EdgeInsets.only(left: 10, top: 8, right: 10),
                        decoration: BoxDecoration(
                            color: Colors.yellow,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0))),
                        height: constrains.maxHeight * 1 / 5,
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: _reviewNum,
                            padding: const EdgeInsets.only(top: 5.0),
                            itemBuilder: (context, index) {
                              DocumentSnapshot ds =
                                  snapshot.data.documents[index];
                              double _rating = ds["rating"];
                              return Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: RatingBar.readOnly(
                                            initialRating: _rating,
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
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(ds["text"]),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  );
                }
              },
            ),
//            Container(
//                margin: EdgeInsets.only(left: 10, top: 8, right: 10),
//                decoration: BoxDecoration(
//                    color: Colors.yellow,
//                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
//                height: constrains.maxHeight * 1 / 6,
//                child: FutureBuilder<dynamic>(
////                    future: getReviewImageUrl(widget.index),
//                    builder: (context, snapshot) {
//                  if (snapshot.hasData)
//                    return ListView(
//                      children: <CustomReviewListItem>[
//                        CustomReviewListItem(
//                          username: 'test',
//                          rating: 5,
//                          text: 'halleluyah',
//                          imageUrl: snapshot.data,
//                          date: '2020.02.19',
//                        )
//                      ],
//                    );
//                  else if (snapshot.hasError) return Text(snapshot.error);
//                  return Loading();
//                })),
          ],
        );
      }),
    );
  }
}

class CustomReviewListItem extends StatelessWidget {
  const CustomReviewListItem({
    this.username,
    this.rating,
    this.text,
    this.imageUrl,
    this.date,
  });

  final String username;
  final int rating;
  final String text;
  final dynamic imageUrl;
  final String date;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
              flex: 4,
              child: Column(
                children: <Widget>[Container(), Text(''), Row()],
              )),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ],
      ),
    );
  }

  Future countReview(int cafeNum) async {}
}

class MyCustomForm extends StatefulWidget {
  final int cafeIndex;
  final int reviewIndex;
  MyCustomForm(this.cafeIndex, this.reviewIndex);

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
  File _image;
  String _uploadedFileURL;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RaisedButton(
        child: Text('Show AlertDialog'),
        onPressed: () {
          showAlertDialog();
        },
      ),
    );
  }

  Future<void> showAlertDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('평가해주세요'),
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
                uploadImage(widget.cafeIndex);
                uploadReview(widget.cafeIndex, widget.reviewIndex, _rating,
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

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }

  Future uploadImage(int cafeNum) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('reviewimage/cafe$cafeNum/');
    var timeKey = DateTime.now();
    StorageUploadTask uploadTask =
        storageReference.child(timeKey.toString() + ".jpg").putFile(_image);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = imageUrl.toString();
    print("Image Url = " + url);
  }

  Future getReviewImageUrl(int cafeNum) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('reviewimage/cafe$cafeNum/');
    String imageUrl = await storageReference.getPath();
    return imageUrl;
  }
}
