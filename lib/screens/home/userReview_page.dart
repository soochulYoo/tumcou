import 'dart:ffi';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:path/path.dart' as Path;
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/models/cafe.dart';
import 'package:tumcou1/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class UserReviewPage extends StatefulWidget {
  final int index;
  UserReviewPage(this.index);

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
            ///constraints 빌더로 화면의 크기 제한
            return Column(
              children: <Widget>[
                StreamBuilder<CafeData>(
                    stream: DatabaseService(index: widget.index).cafeData,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Text('Error: ${snapshot.error}');
                      } else {
                        CafeData cafeData = snapshot.data;
                        return FutureBuilder<String>(
                            future: DatabaseService().getCafeImageUrl(widget.index),
                            builder: (context, snapshot) {
                              if (snapshot.hasData)
                                return Column(
                                  children: <Widget>[
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 10, top: 15, right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        height: constrains.maxHeight * 1 / 3,
                                        child: Column(children: <Widget>[
                                          Container(
                                            height: constrains.maxHeight / 5,
                                            width:
                                            MediaQuery.of(context).size.width,
                                            decoration: BoxDecoration(
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        '${snapshot.data}'),
                                                    fit: BoxFit.cover),
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12.0))),

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
                                                          widget.index),
                                                      builder: (context, snapshot) {
                                                        if (snapshot.hasData)
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: NetworkImage(
                                                                        '${snapshot.data}'),
                                                                    fit: BoxFit
                                                                        .cover),
                                                                borderRadius:
                                                                BorderRadius.all(
                                                                    Radius.circular(
                                                                        4.0))),
                                                            height: constrains
                                                                .maxHeight /
                                                                10,
                                                            padding:
                                                            EdgeInsets.all(8.0),
                                                          );
                                                        else if (snapshot.hasError)
                                                          return Text(
                                                              snapshot.error);
                                                        return Text(
                                                            "Await for data");
                                                      }),
                                                ),
                                                Flexible(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                    const EdgeInsets.all(8.0),
                                                    child: Column(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                      crossAxisAlignment:
                                                      CrossAxisAlignment.start,
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
                                                            style: GoogleFonts
                                                                .notoSans(
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
                                        ])),
                                    Container(
                                        margin: EdgeInsets.only(
                                            left: 10, top: 8, right: 10),
                                        decoration: BoxDecoration(
                                            color: Colors.yellow,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(8.0))),
                                        width: constrains.maxWidth,
                                        child: Column(children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 8.0, bottom: 4.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 1,
                                                      child: Icon(
                                                        Icons.location_on,
                                                        size: 20.0,
                                                      )),
                                                  Expanded(
                                                    flex: 10,
                                                    child: Text(
                                                        '${cafeData.location}'),
                                                  ),
                                                ],
                                              )),
                                          Divider(),
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 4.0, bottom: 8.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Expanded(
                                                      flex: 1,
                                                      child: Icon(
                                                        Icons.access_time,
                                                        size: 20.0,
                                                      )),
                                                  Expanded(
                                                    flex: 10,
                                                    child: Text(
                                                        '${cafeData.openingHours}'),
                                                  ),
                                                ],
                                              )),
                                        ])),
                                  ],
                                );
                              else if (snapshot.hasError)
                                return Text(snapshot.error);
                              return Loading();
                            });
                      }
                    }),
                Container(
                    margin: EdgeInsets.only(left: 10, top: 8, right: 10),
                    decoration: BoxDecoration(
                        color: Colors.yellow,
                        borderRadius: BorderRadius.all(Radius.circular(8.0))),
                    height: constrains.maxHeight * 1 / 2,
                    child: Column(
                      children: <Widget>[
                        MyCustomForm(widget.index),
//                    RaisedButton(
//                      child: Text('Choose Image'),
//                      onPressed: () {
//                        getReview(widget.index);
//                      },
//                      color: Colors.cyan,
//                    )
                      ],
                    )),
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
  final int index;
  MyCustomForm(this.index);

  @override
  _MyCustomFormState createState() => _MyCustomFormState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _MyCustomFormState extends State<MyCustomForm> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _myController = TextEditingController ();
  double _rating;
  File _image;
  String _uploadedFileURL;

  @override
  void dispose () {
    // Clean up the controller when the widget is disposed.
    _myController.dispose ();
    super.dispose ();
  }

  @override
  Widget build (BuildContext context) {
    return Column (
      children: <Widget>[
        Padding (
          padding: const EdgeInsets.all(4.0),
          child: Align (
            alignment: Alignment.centerLeft,
            child: RatingBar (
              itemSize: 30,
              initialRating: 5,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric (horizontal: 0.0),
              itemBuilder: (context, _) =>
                  Icon (
                    Icons.star,
                    color: Colors.amber,
                  ),
              onRatingUpdate: (rating) {
                setState (() {
                  if (rating == null)
                    _rating = 5;
                  else
                    _rating = rating;
                });
              },
            ),
          ),
        ),
        Divider (),
        TextField (
          controller: _myController,
          decoration: InputDecoration (
            border: OutlineInputBorder (),
            labelText: '이 장소의 어떤 점이 만족스러웠나요?',
          ),
        ),
        Row (
          children: <Widget>[
            Text ('Selected image'),
            _image != null
                ? Image.asset (
              _image.path,
              height: 50,
            )
                : Container (height: 150),
            _image == null
                ? RaisedButton (
              child: Text ('Choose Image'),
              onPressed: chooseFile,
              color: Colors.cyan,
            )
                : Container (),
            Padding (
              padding: const EdgeInsets.all(4.0),
              child: Align (
                alignment: Alignment.centerRight,
                child: RaisedButton (
                  child: Text ('등록'),
                  onPressed: () {
                    String time = generateDbTimeKey ();
                    uploadImage (widget.index);
                    uploadReview (
                        widget.index, 0, _rating, _myController.text, time);
                    _myController.clear ();
                  },
                  color: Colors.cyan,
                ),
              ),
            ),
          ],
        )
      ],
    );
//                Text(myController.text),
  }

  String generateDbTimeKey () {
    var dbTimeKey = DateTime.now ();
    var formatDate = DateFormat ('yyyy, MMM d, ');
    var formatTime = DateFormat ('hh:mm aaaa, EEEE');

    String date = formatDate.format (dbTimeKey);
    String time = formatTime.format (dbTimeKey);

    return date + time;
  }

  Future uploadReview (int cafeNum,
      int reviewNum,
      double rating,
      String text,
      var time,) async {
    return await Firestore.instance
        .collection ('Cafe')
        .document ('cafe$cafeNum')
        .collection ('review')
        .document ('review$reviewNum')
        .setData ({
      'rating': rating,
      'text': text,
      'time': time,
    });
  }

  Future chooseFile () async {
    await ImagePicker.pickImage (source: ImageSource.gallery).then ((image) {
      setState (() {
        _image = image;
      });
    });
  }

  Future uploadImage (int cafeNum) async {
    StorageReference storageReference =
    FirebaseStorage.instance.ref ().child ('reviewimage/cafe$cafeNum/');
    var timeKey = DateTime.now ();
    StorageUploadTask uploadTask =
    storageReference.child (timeKey.toString () + ".jpg").putFile (_image);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL ();
    String url = imageUrl.toString ();
    print ("Image Url = " + url);
  }

  Future getReviewImageUrl (int cafeNum) async {
    StorageReference storageReference =
    FirebaseStorage.instance.ref ().child ('reviewimage/cafe$cafeNum/');
    String imageUrl = await storageReference.getPath ();
    return imageUrl;
  }
}