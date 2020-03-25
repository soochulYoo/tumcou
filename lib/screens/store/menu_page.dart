import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tumcou1/models/cafe.dart';
import 'package:tumcou1/services/database.dart';

class MenuPage extends StatelessWidget {
  final int cafeId;
  MenuPage(this.cafeId);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
              child: Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Column(
                children: <Widget>[
                  Text('Menu',
                      style: Theme.of(context).textTheme.display1.copyWith(
                            decoration: TextDecoration.underline,
                          )),
                ],
              ),
            ),
          )),
          FutureBuilder(
              future: DatabaseService(cafeId: cafeId).menuLength,
              builder: (context, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: Text('Loading...'),
                  );
                else {
                  List<DocumentSnapshot> menuDocuments =
                      snapshot.data.documents;
                  int menuLength = menuDocuments.length;
                  return Flexible(
                    child: ListView.builder(
                        itemCount: menuLength - 1,
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemBuilder: (context, i) {
                          return menuList(i);
                        }),
                  );
                }
              })
        ],
      ),
    );
  }

  Widget menuList(int menuNum) {
    CafeMenu cafeMenu;
    return StreamBuilder(
        stream: DatabaseService(cafeId: cafeId, menuNum: menuNum).menuList,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: Text('loading'));
          } else {
            cafeMenu = snapshot.data;
            return Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    left: 36,
                    top: 24,
                    right: 36,
                  ),
                  child: Container(
                    child: Row(
                      children: <Widget>[
                        Padding(
                            padding: EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              cafeMenu.title,
                              style: Theme.of(context).textTheme.display2,
                            )),
                      ],
                    ),
                    decoration: BoxDecoration(
                        border: Border(
                      top: BorderSide(width: 2.0, color: Colors.grey),
                      bottom: BorderSide(width: 2.0, color: Colors.grey),
                    )),
                  ),
                ),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: cafeMenu.menuName.length,
                    itemBuilder: (context, i) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: Row(
                              children: <Widget>[
                                Text('${cafeMenu.menuName[i]}',
                                    style: TextStyle(fontSize: 18)),
                                cafeMenu.menuRecommend[i]
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 4.0),
                                        child: Icon(
                                          Icons.thumb_up,
                                          size: 18,
                                          color: Theme.of(context).accentColor,
                                        ),
                                      )
                                    : SizedBox(),
                                Spacer(),
                                Text(
                                  '${cafeMenu.menuPrice[i]}',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ],
            );
          }
        });
  }
}
