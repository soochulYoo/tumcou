import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostingScreen extends StatefulWidget {
  /// 홈화면에서 눌렀을 때 뜨는 새 창
  ///
  final DocumentSnapshot doc;
  PostingScreen(this.doc);
  @override
  _PostingScreenState createState() => _PostingScreenState();
}

class _PostingScreenState extends State<PostingScreen> {
  /// 홈화면에서 눌렀을 때 뜨는 새
  ///

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return SafeArea(
      bottom: false,
      child: Scaffold(
          body: Stack(
        ///이미지와 텍스트를 적절히 배치해야한다
        ///일단은 이미지만!!
        ///블로그처럼 제일 위에 대표이미지를 보여주고 밑에는 내용을 적자
        ///
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(vertical: 5.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4.0)),
            ),
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.doc['image']),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  height: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        image: NetworkImage(widget.doc['thumbnail']),
                        fit: BoxFit.cover),
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                )
              ],
            ),
          )
        ],
      )),
    );
  }
}
