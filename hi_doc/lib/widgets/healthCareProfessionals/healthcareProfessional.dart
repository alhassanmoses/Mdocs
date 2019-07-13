import 'package:flutter/material.dart';
import 'package:hi_doc/models/user.dart';

import 'package:scoped_model/scoped_model.dart';

import './hp_card.dart';
import '../../models/user.dart';
import '../../scoped_models/main.dart';

class HealthProfessionals extends StatelessWidget {
  Widget _buildHpList(List<User> healthProfessionals) {
    Widget hpCards;

    if (healthProfessionals.length >= 0) {
      hpCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            HpCard(healthProfessionals[index], index),
        itemCount: healthProfessionals.length,
      );
    } else {
      print('the hp ${healthProfessionals.length}');

      hpCards = Center(
        child: Text(
            'No health professionals found... ${healthProfessionals.length} '),
      );
    }

    return hpCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildHpList(model.displayedHp);
      },
    );
  }
}
