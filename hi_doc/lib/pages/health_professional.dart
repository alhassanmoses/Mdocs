import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hi_doc/widgets/ui_elements/build_name.dart';

// import '../scoped_models/main.dart';
import '../models/user.dart';

class HealthProfessionalPage extends StatelessWidget {
  final User healthProfessional;
  HealthProfessionalPage(this.healthProfessional);

  Widget _buildProfessionExperienceRow(String profession, String experience) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        GestureDetector(
          onTap: () {},
          child: Text(
            profession,
            style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
          ),
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 5.0),
          child: Text(
            '|',
            style: TextStyle(color: Colors.grey),
          ),
        ),
        Text(
          '$experience',
          style: TextStyle(fontFamily: 'Oswald', color: Colors.grey),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        // print('Back button pressed!');
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
              '${healthProfessional.firstName} ${healthProfessional.lastName} ${healthProfessional.otherName}'),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            FadeInImage(
              image: NetworkImage(healthProfessional.image),
              height: 300.0,
              fit: BoxFit.cover,
              placeholder: AssetImage('assets/loading_icon.png'),
            ),
            Container(
              padding: EdgeInsets.all(10.0),
              child: BuildName(
                  '${healthProfessional.firstName} ${healthProfessional.lastName} ${healthProfessional.otherName}'),
            ),
            _buildProfessionExperienceRow(
                healthProfessional.profession, healthProfessional.experience),
            Container(
              padding: EdgeInsets.all(10.0),
              child: Text(
                healthProfessional.shortDescription,
                textAlign: TextAlign.center,
              ),
            )
          ],
        ),
      ),
    );
  }
}
