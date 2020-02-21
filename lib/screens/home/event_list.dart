import 'package:flutter/material.dart';

class EventList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Card(
          margin: EdgeInsets.fromLTRB(20.0, 6.0, 20.0, 0.0),
          child: ListTile(
            leading: CircleAvatar(
              radius: 25.0,
              backgroundColor: Colors.lightGreen,
              backgroundImage: AssetImage('assets/coffee_icon.png'),
            ),
            title: Text('이벤트!!!!'),
            subtitle: Text('진행중인 이벤트'),
          ),
        )
    );
  }
}
