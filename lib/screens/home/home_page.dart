import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/home/posting/posting_screen.dart';
import 'package:tumcou1/screens/home/self_check.dart';
import 'package:tumcou1/shared/loading.dart';

class HomePage extends StatefulWidget {
  final UserData userData;
  const HomePage({Key key, this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<QuerySnapshot>(
          stream: Firestore.instance.collection("Posting").snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Container(
                    color: Colors.white,
                    height: MediaQuery.of(context).size.height / 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                style: TextStyle(color: Colors.black),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: '"제로 웨이스트"\n',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                  TextSpan(
                                      text: '어떻게 실천할까요?',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline1),
                                ]),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          child: Container(
                              padding: EdgeInsets.all(8),
                              child: Text(
                                '자기진단 하러가기',
                                style: Theme.of(context).textTheme.headline2,
                              ),
                              decoration:
                                  BoxDecoration(border: Border.all(width: 1))),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      SelfCheckPage(widget.userData)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: getPost(snapshot, context),
                  ),
                ],
              );
            } else {
              return Loading();
            }
          }),
    );
  }

  getPost(AsyncSnapshot<QuerySnapshot> snapshot, BuildContext context) {
    return snapshot.data.documents
        .map(
          (doc) => InkWell(
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => PostingScreen(doc)));
            },
            child: PostItem(doc),
          ),
        )
        .toList();
  }
}

class PostItem extends StatelessWidget {
  final DocumentSnapshot doc;
  PostItem(this.doc);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          image: DecorationImage(
              image: NetworkImage(
                '${doc['thumbnail']}',
              ),
              fit: BoxFit.fill)),
    );
  }
}
