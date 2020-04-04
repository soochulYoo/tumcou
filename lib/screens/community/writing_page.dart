import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:tumcou1/models/user.dart';

class WritingPage extends StatefulWidget {
  final UserData userData;
  WritingPage(this.userData);

  @override
  _WritingPageState createState() => _WritingPageState();
}

// Define a corresponding State class.
// This class holds the data related to the Form.
class _WritingPageState extends State<WritingPage> {
  // Create a text controller and use it to retrieve the current value
  // of the TextField.
  final _myController = TextEditingController();
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
                  .bodyText1
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
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                onPressed: () {
                  String time = generateDbTimeKey();
                  uploadReview(_myController.text, time);
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
                    .bodyText1
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
                    .bodyText1
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
    String text,
    var time,
  ) async {
    Firestore.instance
        .collection('Board')
        .document('$time' + widget.userData.uid)
        .setData({
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
        .child('reviewimage/$time + ${widget.userData.uid}/');
    StorageUploadTask uploadTask =
        storageReference.child("0.jpg").putFile(_image0);
    var imageUrl0 = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url0 = imageUrl0.toString();
    Firestore.instance
        .collection('Board')
        .document('$time' + widget.userData.uid)
        .updateData({'image0': url0});
  }

  Future uploadImage1(String time) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('reviewimage/$time + ${widget.userData.uid}/');
    StorageUploadTask uploadTask =
        storageReference.child("1.jpg").putFile(_image1);
    var imageUrl1 = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url1 = imageUrl1.toString();
    Firestore.instance
        .collection('Board')
        .document('$time' + widget.userData.uid)
        .updateData({'image1': url1});
  }

  Future uploadImage2(String time) async {
    StorageReference storageReference = FirebaseStorage.instance
        .ref()
        .child('reviewimage/$time + ${widget.userData.uid}/');
    StorageUploadTask uploadTask =
        storageReference.child("2.jpg").putFile(_image2);
    var imageUrl2 = await (await uploadTask.onComplete).ref.getDownloadURL();
    String url2 = imageUrl2.toString();
    Firestore.instance
        .collection('Board')
        .document('$time' + widget.userData.uid)
        .updateData({'image2': url2});
  }

  Future getReviewImageUrl(int cafeNum) async {
    StorageReference storageReference =
        FirebaseStorage.instance.ref().child('reviewimage/cafe$cafeNum/');
    String imageUrl = await storageReference.getPath();
    return imageUrl;
  }
}
