import 'package:flutter/material.dart';

class BuildName extends StatelessWidget {
  final String name;

  BuildName(this.name);
  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      style: TextStyle(
          fontSize: 26.0, fontWeight: FontWeight.bold, fontFamily: 'Oswald'),
    );
  }
}
