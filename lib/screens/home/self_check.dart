import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/home/check_list.dart';
import 'package:tumcou1/shared/constants.dart';

class SelfCheckPage extends StatefulWidget {
  final UserData userData;
  SelfCheckPage(this.userData);
  @override
  _SelfCheckPageState createState() => _SelfCheckPageState();
}

class _SelfCheckPageState extends State<SelfCheckPage> {
  List<String> _sections = [
    '외출시\n12%',
    '장보기 및 쇼핑\n    30%',
    '주방/욕실\n  24%',
    '일상생활 속\n 32%'
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                      style: TextStyle(color: Colors.black),
                      children: <TextSpan>[
                        TextSpan(
                            text: '환영합니다!\n',
                            style: Theme.of(context).textTheme.headline1),
                        TextSpan(
                            text: widget.userData.name + '님\n\n\n',
                            style: Theme.of(context).textTheme.headline1),
                        TextSpan(
                            text: '이번주 당성률은 28%입니다',
                            style: Theme.of(context).textTheme.headline1),
                      ]),
                ),
              ],
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _sections.length,
            itemBuilder: (BuildContext context, int index) {
              return Column(
                children: <Widget>[
                  MySeparator(),
                  InkWell(
                    child: Container(
                        padding: EdgeInsets.only(
                            left: 8.0, top: 8.0, right: 8.0, bottom: 8.0),
                        height: 100,
                        child: Row(
                          children: <Widget>[
                            Expanded(
                                flex: 1,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Image(
                                    image: AssetImage(
                                        'assets/self/self$index.png'),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                            Expanded(
                              flex: 2,
                              child: Center(
                                child: Text(
                                  _sections[index],
                                  style: GoogleFonts.nanumPenScript(
                                      fontSize: 28, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        )),
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckList(index),
                          ));
                    },
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
