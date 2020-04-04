import 'package:flutter/material.dart';
import 'package:tumcou1/models/user.dart';
import 'package:tumcou1/screens/home/self_check.dart';

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
      body: Column(
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
                              style: Theme.of(context).textTheme.headline1),
                          TextSpan(
                              text: '어떻게 실천할까요?',
                              style: Theme.of(context).textTheme.headline1),
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
                      decoration: BoxDecoration(border: Border.all(width: 1))),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => SelfCheckPage()),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
