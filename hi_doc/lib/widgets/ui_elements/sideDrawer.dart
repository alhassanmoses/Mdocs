import 'package:flutter/material.dart';

import './logout_list_tile.dart';

class SideDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            automaticallyImplyLeading: false,
            title: Text(
              'Hi_Doc',
              style: TextStyle(fontFamily: "Oswald", fontSize: 14),
            ),
          ),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Manage Profile'),
            onTap: () {},
          ),
          Divider(),
          LogoutListTile()
        ],
      ),
    );
  }
}
