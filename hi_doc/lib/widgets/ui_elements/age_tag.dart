import 'package:flutter/material.dart';

class AgeTag extends StatelessWidget {
  final String age;

  AgeTag(this.age);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 6.0, vertical: 2.5),
        decoration: BoxDecoration(
            color: Theme.of(context).accentColor,
            borderRadius: BorderRadius.circular(5.0)),
        child: Text(
          '$age',
          style: TextStyle(color: Colors.white),
        ));
  }
}
