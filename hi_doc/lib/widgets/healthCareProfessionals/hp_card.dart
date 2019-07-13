import 'package:flutter/material.dart';
import 'package:hi_doc/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

import '../ui_elements/age_tag.dart';
import '../ui_elements/build_name.dart';
import '../ui_elements/address_tag.dart';
// import '../../models/user.dart';
import '../../scoped_models/main.dart';

class HpCard extends StatelessWidget {
  final User user;
  final int healthProfessionalIndex;

  HpCard(this.user, this.healthProfessionalIndex);

  Widget _buildNameAgeRow() {
    return Container(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            BuildName('${user.firstName}  ${user.lastName}  ${user.otherName}'),
            SizedBox(
              width: 8.0,
            ),
            AgeTag(user.age.toString())
          ],
        ));
  }

  Widget _buildActionButtons(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return ButtonBar(
        alignment: MainAxisAlignment.center,
        children: <Widget>[
          IconButton(
              color: Theme.of(context).accentColor,
              icon: Icon(Icons.info),
              onPressed: () => Navigator.pushNamed<bool>(
                  context,
                  '/user/' +
                      model
                          .allHealthProfessionals[healthProfessionalIndex].id)),
          IconButton(
            color: Colors.red,
            icon: Icon(model.allHealthProfessionals[healthProfessionalIndex]
                    .isFavoriteHp
                ? Icons.favorite
                : Icons.favorite_border),
            onPressed: () {
              model.selectUser(
                  model.allHealthProfessionals[healthProfessionalIndex].id);
              model.favoriteStatusToggler();
            },
          ),
        ],
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          FadeInImage(
            image: NetworkImage(user.image),
            height: 300.0,
            fit: BoxFit.cover,
            placeholder: AssetImage('assets/loading_icon.png'),
          ),
          _buildNameAgeRow(),
          AddressTag(user.address),
          Text(user.email),
          _buildActionButtons(context),
        ],
      ),
    );
  }
}
