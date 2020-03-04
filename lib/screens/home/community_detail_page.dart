import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart'; // For File Upload To Firestore
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For Image Picker
import 'package:tumcou1/screens/home/googleMap.dart';
import 'package:tumcou1/screens/home/review_page.dart';
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/models/cafe.dart';
import 'package:tumcou1/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class UserReviewPage extends StatefulWidget {
  final CafeData cafeData;
  final CafeUrl cafeUrl;
  final int amountOfReview;
  UserReviewPage(this.cafeData, this.cafeUrl, this.amountOfReview);

  @override
  _UserReviewPageState createState() => _UserReviewPageState();
}

class _UserReviewPageState extends State<UserReviewPage> {
  Completer<GoogleMapController> _controller = Completer();
  static final gwanghwamun = CameraPosition(
    target: LatLng(36.0953103, -115.1992098),
    zoom: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ReviewPage(widget.cafeData)),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 1 / 10,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  StreamBuilder(
                      stream:
                          DatabaseService(index: widget.cafeData.id).reviewData,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Loading();
                        } else {
                          int amountOfReview = snapshot.data.documents.length;
                          return FutureBuilder(
                              future: DatabaseService(
                                      index: widget.cafeData.id,
                                      amountOfReview: amountOfReview)
                                  .reviewMean,
                              builder: (context, snapshot) {
                                double reviewMean = snapshot.data;
                                if (!snapshot.hasData) {
                                  return Loading();
                                } else {
                                  return Row(
                                    children: <Widget>[
                                      RatingBar.readOnly(
                                        maxRating: 1,
                                        initialRating: 1,
                                        filledIcon: Icons.star,
                                        halfFilledIcon: Icons.star_half,
                                        emptyIcon: Icons.star_border,
                                        filledColor: Colors.amber,
                                        halfFilledColor: Colors.amber,
                                        emptyColor: Colors.amber,
                                        size: 16,
                                        isHalfAllowed: true,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "$reviewMean",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(4.0),
                                        child: Text(
                                          "($amountOfReview)",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ],
                                  );
                                }
                              });
                        }
                      }),
                  Text(
                    '리뷰',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )),
      ),
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'TUMCOU',
          style: GoogleFonts.cambay(
            textStyle: TextStyle(
              color: Colors.blueGrey[700],
              fontSize: 40,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constrains) {
        return ListView(
          children: <Widget>[
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                height: MediaQuery.of(context).size.height * 1 / 3,
                child: Column(children: <Widget>[
                  Container(
                    height: constrains.maxHeight * 1 / 4,
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image:
                                NetworkImage('${widget.cafeUrl.cafeImageUrl}'),
                            fit: BoxFit.cover),
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),

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
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(widget.cafeUrl.cafeLogoUrl),
                            minRadius: 20,
                            maxRadius: 40,
                          ),
                        ),
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
                                        textStyle: TextStyle(fontSize: 16))),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ])),
            Divider(),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                width: constrains.maxWidth,
                child: Column(children: <Widget>[
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
                  Divider(),
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
                ])),
            Divider(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Container(
                    height: 200,
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: CameraPosition(
                        target: LatLng(37.565954, 126.938540),
                        zoom: 15.0,
                      ),
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                      },
                      compassEnabled: true,
                      zoomGesturesEnabled: true,
                      rotateGesturesEnabled: true,
                      scrollGesturesEnabled: true,
                      tiltGesturesEnabled: true,
                    ),
                  ),
                ],
              ),
            )
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
  final int cafeId;
  final int amountOfReview;
  final double reviewMean;
  MyCustomForm(this.cafeId, this.amountOfReview, this.reviewMean);

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
        Column(
          children: <Widget>[
            Text("평점: ${widget.reviewMean}"),
            RatingBar.readOnly(
              initialRating: widget.reviewMean,
              filledIcon: Icons.star,
              halfFilledIcon: Icons.star_half,
              emptyIcon: Icons.star_border,
              filledColor: Colors.amber,
              halfFilledColor: Colors.amber,
              emptyColor: Colors.amber,
              size: 20,
              isHalfAllowed: true,
            ),
          ],
        ),
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
                uploadImage(widget.cafeId);
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
