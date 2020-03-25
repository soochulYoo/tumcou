import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tumcou1/models/user.dart';

class ReviewWritingPage extends StatefulWidget {
  final int cafeId;
  final int amountOfReview;
  final UserData userData;
  ReviewWritingPage(this.cafeId, this.amountOfReview, this.userData);

  @override
  _ReviewWritingPageState createState() => _ReviewWritingPageState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _ReviewWritingPageState extends State<ReviewWritingPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _myController = TextEditingController();
  double _rating = 5;
  FocusNode _focusNode = new FocusNode();
  File _image0;
  File _image1;
  File _image2;
  List<bool> _image = [false, false, false];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _rating = 5.0;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: <Widget>[
            Spacer(),
            Text(
              '리뷰 작성',
              style: Theme.of(context)
                  .textTheme
                  .display2
                  .copyWith(fontWeight: FontWeight.bold),
            ),
            Spacer(),
            ButtonTheme(
              minWidth: 50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18.0)),
              child: RaisedButton(
                elevation: 5.0,
                color: Colors.white,
                child: Container(
                  child: Text(
                    '등록',
                    style: Theme.of(context)
                        .textTheme
                        .display3
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  String time = generateDbTimeKey();
                  uploadReview(
                      widget.cafeId, _rating, _myController.text, time);
                  _myController.clear();
                  if (_image[0] == true) {
                    uploadImage0(time);
                    if (_image[1] == true) {
                      uploadImage1(time);
                      if (_image[2] == true) {
                        uploadImage2(time);
                      }
                    }
                  }
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        ),
      ),
      body: GestureDetector(
        onTap: () {
          _focusNode.unfocus(); //3 - call this method here
        },
        child: ListView(children: <Widget>[
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 28.0, bottom: 4.0),
              child: Text(
                '카페는 어떠셨나요? 별점을 입력해주세요',
                style: Theme.of(context)
                    .textTheme
                    .display3
                    .copyWith(color: Colors.black87),
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: RatingBar(
                initialRating: 5,
                minRating: 1,
                itemCount: 5,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 4),
                itemBuilder: (context, _) => Stack(children: <Widget>[
                  Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                  Icon(
                    Icons.star_border,
                    color: Colors.black12,
                  ),
                ]),
                onRatingUpdate: (rating) {
                  _rating = rating;
                },
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Container(height: 20, color: Colors.grey[300])),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                '카페에 대한 리뷰를 남겨주세요',
                style: Theme.of(context)
                    .textTheme
                    .display3
                    .copyWith(color: Colors.black87),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: TextField(
              focusNode: _focusNode,
              keyboardType: TextInputType.multiline,
              minLines: 8,
              maxLines: 20,
              controller: _myController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: ' 여기를 눌러 글을 작성할 수 있습니다.',
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 18),
              child: Container(height: 20, color: Colors.grey[300])),
          Align(
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 12.0),
              child: Text(
                '원하는 사진을 골라주세요 (최대 3장)',
                style: Theme.of(context)
                    .textTheme
                    .display3
                    .copyWith(color: Colors.black87),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[300])),
                    height: width / 3 - 16,
                    width: width / 3 - 16,
                    child: Center(
                      child: _image0 == null
                          ? Icon(Icons.camera)
                          : Image.file(_image0),
                    ),
                  ),
                  onTap: () {
                    getImage0();
                  },
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[300])),
                    height: width / 3 - 16,
                    width: width / 3 - 16,
                    child: Center(
                      child: _image1 == null
                          ? Icon(Icons.camera)
                          : Image.file(_image1),
                    ),
                  ),
                  onTap: () {
                    getImage1();
                  },
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey[300])),
                    height: width / 3 - 16,
                    width: width / 3 - 16,
                    child: Center(
                      child: _image2 == null
                          ? Icon(Icons.camera)
                          : Image.file(_image2),
                    ),
                  ),
                  onTap: () {
                    getImage2();
                  },
                ),
              ],
            ),
          ),
        ]),
      ),
    );
  }

  String generateDbTimeKey() {
    var dbTimeKey = DateTime.now();
    var formatDate = DateFormat('MMM d, ');
    var formatTime = DateFormat('hh:mm aaa ss, EEEE, yyyy');

    String date = formatDate.format(dbTimeKey);
    String time = formatTime.format(dbTimeKey);

    return date + time;
  }

  Future uploadReview(
    int cafeNum,
    double rating,
    String text,
    var time,
  ) async {
    Firestore.instance
        .collection('Cafe')
        .document('cafe$cafeNum')
        .collection('review')
        .document('$time')
        .setData({
      'rating': rating,
      'text': text,
      'time_key': time,
      'name': widget.userData.name,
      'uid': widget.userData.uid,
    });
  }

  Future getImage0() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image0 = image;
        _image[0] = true;
      });
    });
  }

  Future getImage1() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image1 = image;
        _image[1] = true;
      });
    });
  }

  Future getImage2() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image2 = image;
        _image[2] = true;
      });
    });
  }

  Future uploadImage0(String time) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('reviewimage/cafe${widget.cafeId}/$time/');
    StorageUploadTask uploadTask =
        storageReference.child("0.jpg").putFile(_image0);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = imageUrl.toString();
    print("Image Url = " + url);
  }

  Future uploadImage1(String time) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('reviewimage/cafe${widget.cafeId}/$time/');
    StorageUploadTask uploadTask =
        storageReference.child("1.jpg").putFile(_image1);
    var imageUrl = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url = imageUrl.toString();
    print("Image Url = " + url);
  }

  Future uploadImage2(String time) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('reviewimage/cafe${widget.cafeId}/$time/');
    StorageUploadTask uploadTask =
        storageReference.child("2.jpg").putFile(_image2);
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
