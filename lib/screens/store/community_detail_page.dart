import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/store/menu_page.dart';
import 'package:tumcou1/screens/store/review_page.dart';
import 'package:tumcou1/services/database.dart';
import 'package:tumcou1/models/cafe.dart';
import 'package:tumcou1/shared/loading.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';

class CommunityDetailPage extends StatefulWidget {
  final CafeData cafeData;
  final CafeUrl cafeUrl;
  final int amountOfReview;
  CommunityDetailPage(this.cafeData, this.cafeUrl, this.amountOfReview);

  @override
  _CommunityDetailPageState createState() => _CommunityDetailPageState();
}

class _CommunityDetailPageState extends State<CommunityDetailPage> {
  Completer<GoogleMapController> _controller = Completer();
  static final gwanghwamun = CameraPosition(
    target: LatLng(36.0953103, -115.1992098),
    zoom: 10.0,
  );

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      bottomNavigationBar: BottomAppBar(
        color: Colors.white,
        child: StreamBuilder<UserData>(
            stream: DatabaseService(uid: user.uid).userData,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('loading...');
              } else {
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                ReviewPage(widget.cafeData, snapshot.data)),
                      );
                    },
                    child: Container(
                      height: MediaQuery.of(context).size.height * 1 / 15,
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          StreamBuilder(
                              stream:
                                  DatabaseService(cafeId: widget.cafeData.id)
                                      .reviewData,
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return Loading();
                                } else {
                                  int amountOfReview =
                                      snapshot.data.documents.length;
                                  return FutureBuilder(
                                      future: DatabaseService(
                                              cafeId: widget.cafeData.id,
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
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  "$reviewMean",
                                                  style:
                                                      TextStyle(fontSize: 16),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(4.0),
                                                child: Text(
                                                  "($amountOfReview)",
                                                  style:
                                                      TextStyle(fontSize: 16),
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
                    ));
              }
            }),
      ),
      resizeToAvoidBottomPadding: false,
      body: SafeArea(
        child: ListView(
          children: <Widget>[
            Column(children: <Widget>[
              Stack(children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height * 1 / 3.5,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: NetworkImage('${widget.cafeUrl.cafeImageUrl}'),
                          fit: BoxFit.cover),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(12.0),
                          bottomRight: Radius.circular(12.0))),

//                              decoration: BoxDecoration(
//                                  borderRadius: BorderRadius.circular(15.0),
//                                  border: Border.all(color: Colors.red)),
                ),
                Positioned(
                    top: 1,
                    left: 1,
                    child: GestureDetector(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24.0, top: 28.0),
                          child: Icon(Icons.arrow_back,
                              color: Colors.white, size: 32),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                        })),
                Positioned(
                    top: 1,
                    right: 1,
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 28.0, right: 24.0),
                          child:
                              Icon(Icons.share, color: Colors.white, size: 32),
                        ),
                        Padding(
                          padding:
                              const EdgeInsets.only(right: 24.0, top: 28.0),
                          child: Icon(Icons.favorite_border,
                              color: Colors.white, size: 32),
                        ),
                      ],
                    ))
              ]),
              //slider? 점
              Container(
                padding: EdgeInsets.all(4),
                child: Row(
                  children: <Widget>[
                    Flexible(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundImage:
                              NetworkImage(widget.cafeUrl.cafeLogoUrl),
                          minRadius: 20,
                          maxRadius: 40,
                        ),
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
                                  fontSize: 32,
                                  fontWeight: FontWeight.w600,
                                ))),
                            Padding(
                              padding: const EdgeInsets.only(top: 4.0),
                              child: Text('${widget.cafeData.introduction}',
                                  style: GoogleFonts.notoSans(
                                      textStyle: TextStyle(
                                          fontSize: 16,
                                          color:
                                              Theme.of(context).accentColor))),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ]),
            Divider(),
            CafeMenu(widget.cafeData.id),
            Divider(),
            Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(8.0))),
                width: MediaQuery.of(context).size.width,
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
        ),
      ),
    );
  }
}

class CafeMenu extends StatelessWidget {
  final int cafeId;
  CafeMenu(this.cafeId);
  @override
  Widget build(BuildContext context) {
    final Map<dynamic, dynamic> _menu = {};
    return Container(
      child: StreamBuilder(
          stream: DatabaseService(cafeId: cafeId).representativeMenu,
          builder: (context, snapshot) {
            _menu.addAll(snapshot.data);
            var menuList = _menu.entries.toList();
            return Column(
              children: <Widget>[
                Text('Menu', style: TextStyle(fontSize: 18)),
                ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: menuList.length,
                    itemBuilder: (context, i) {
                      return Container(
                        child: Row(
                          children: <Widget>[
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16.0, top: 16.0),
                              child: Text('${menuList[i].key}',
                                  style: TextStyle(fontSize: 18)),
                              //데이터 없으면 loading 뜨도록 조건문
                            ),
                            Spacer(),
                            Padding(
                              padding:
                                  const EdgeInsets.only(right: 16.0, top: 16.0),
                              child: Text(
                                '${menuList[i].value}',
                                style: TextStyle(fontSize: 18),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuPage(cafeId)),
                    );
                  },
                  child: Text('상세보기', style: TextStyle(fontSize: 18)),
                ),
              ],
            );
          }),
    );
  }
}
