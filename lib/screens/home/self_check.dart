import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelfCheckPage extends StatefulWidget {
  @override
  _SelfCheckPageState createState() => _SelfCheckPageState();
}

class _SelfCheckPageState extends State<SelfCheckPage> {
  List<String> _sections = ['외출시', '장보기 및 쇼핑', '주방/욕실', '생활 속'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 3,
          ),
          Flexible(
            child: ListView.builder(
              itemCount: _sections.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                    decoration: BoxDecoration(
                        border:
                            Border.symmetric(vertical: BorderSide(width: 0.5))),
                    height: 80,
                    child: Center(
                      child: Text(
                        _sections[index],
                        style: GoogleFonts.nanumPenScript(
                            fontSize: 28, color: Colors.black),
                      ),
                    ));
              },
            ),
          ),
        ],
      ),
    );
  }
}
