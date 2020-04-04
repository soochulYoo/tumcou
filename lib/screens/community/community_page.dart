import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/community/writing_page.dart';
import 'package:tumcou1/shared/loading.dart';

class CommunityPage extends StatefulWidget {
  final UserData userData;
  const CommunityPage({Key key, this.userData}) : super(key: key);
  @override
  _CommunityPageState createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder(
          stream: Firestore.instance.collection("Board").snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Loading();
            } else {
              int amountOfCafe = snapshot.data.documents.length;
              return ListView.builder(
                padding: EdgeInsets.only(top: 10),
                itemCount: amountOfCafe,
                itemBuilder: (BuildContext context, int index) {
                  return GridItem(snapshot.data.documents[index]);
                },
              );
            }
          }),
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WritingPage(widget.userData)),
              );
            },
            child: Container(
              height: MediaQuery.of(context).size.height * 1 / 15,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(Icons.edit),
                  Text(
                    ' 글 쓰기',
                    style: TextStyle(fontSize: 20),
                  ),
                ],
              ),
            )),
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
}

class GridItem extends StatelessWidget {
  final DocumentSnapshot doc;
  GridItem(this.doc);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            FutureBuilder(
              future: _getImage(context, 'user/user_image.jpeg'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done)
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                      width: 50,
                      height: 50,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: snapshot.data,
                      ),
                    ),
                  );
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    child: Container(
                        width: 50,
                        height: 50,
                        child: Icon(
                          Icons.person,
                          size: 40,
                        )),
                  );
                return Container();
              },
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: Text(
                doc['name'],
                style: GoogleFonts.notoSans(
                  textStyle: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                maxLines: 2,
              ),
            ),
          ],
        ),
        Container(
            margin: EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(doc['image0']), fit: BoxFit.fill),
              ),
            )),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 8.0, right: 8.0),
          child: Text(
            doc['text'],
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.black,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
          child: Container(height: 2, color: Colors.grey[300]),
        ),
      ],
    );
  }
}

Future<Widget> _getImage(BuildContext context, String image) async {
  Widget m;
  await FireStorageService.loadImage(context, image).then((downloadUrl) {
    m = Image.network(downloadUrl.toString(), fit: BoxFit.fill);
  });
  return m;
}

class FireStorageService extends ChangeNotifier {
  FireStorageService();
  static Future<dynamic> loadImage(BuildContext context, String image) async {
    return await FirebaseStorage.instance.ref().child(image).getDownloadURL();
  }
}
