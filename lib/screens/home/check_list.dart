import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tumcou1/shared/constants.dart';

class CheckList extends StatefulWidget {
  final int num;
  CheckList(this.num);
  @override
  _CheckListState createState() => _CheckListState();
}

class _CheckListState extends State<CheckList> {
  List<String> _title = [
    '외출할 때 실천하셨나요?',
    '지구를 지키는 장보기',
    '플라스틱 없는 주방/욕실\n만들기에 도전해보세요',
    '일상생활 속에서\n 제로 웨이스트를 실천해봐요'
  ];
  List<List<String>> _checkList = [
    ['텀블러 사용하기', '손수건 사용하기', '일회용 빨대 거절하기/\n다회용 빨대 사용하기'],
    ['장바구니 사용하기', '플라스틱 대체품 구매하기', '필요한 만큼만 구매하기', '포장 없는 벌크 제품 구입하기'],
    [
      '유리/스테인리스 용기에 담기',
      '천연수세미로 설거지하기',
      '티슈 줄이기',
      '샴푸바, 천연비누 쓰기',
      '대나무 칫솔, 천연 치약 사용하기'
    ],
    [
      '재활용 분리수거',
      '라벨 제거해서 배출하기',
      '배달, 인스턴트 포장 줄이기',
      '일회용 식기 거절하고 개인 식기 사용하기',
    ]
  ];
  List<bool> _checkBox;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 4,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(52.0),
                child: Text(
                  _title[widget.num],
                  style: GoogleFonts.nanumPenScript(
                      fontSize: 40, color: Colors.black),
                ),
              ),
            ),
          ),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _checkList[widget.num].length,
            itemBuilder: (BuildContext context, int index) {
              _checkBox = List<bool>(_checkList[widget.num].length);
              for (int i = 0; i < _checkBox.length; i++) {
                _checkBox[i] = false;
              }
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
                            Flexible(
                              flex: 1,
                              child: Checkbox(
                                value: _checkBox[index],
                                onChanged: (bool value) {
                                  setState(() {
                                    _checkBox[index] = value;
                                  });
                                },
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Center(
                                child: Text(
                                  _checkList[widget.num][index],
                                  style: GoogleFonts.nanumPenScript(
                                      fontSize: 28, color: Colors.black),
                                ),
                              ),
                            ),
                          ],
                        )),
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
