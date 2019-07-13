import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';

class HpListPage extends StatefulWidget {
  final MainModel model;
  HpListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _HpListPageState();
  }
}

class _HpListPageState extends State<HpListPage> {
  @override
  void initState() {
    widget.model.fetchUsers(onlyForUser: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectHp(model.allHealthProfessionals[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Container(
                child: Text('hp_list'),
              ) /* HpEditPage() */;
            },
          ),
        ).then((_) {
          model.selectHp(null);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return ListView.builder(
          itemBuilder: (BuildContext context, int index) {
            return Dismissible(
              key: Key(model.allHealthProfessionals[index].id),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectHp(model.allHealthProfessionals[index].id);
                  model.deleteProfile();
                }
              },
              background: Container(
                color: Colors.red,
              ),
              child: Column(children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      backgroundImage: NetworkImage(
                          model.allHealthProfessionals[index].image)),
                  title: Text(
                      '${model.allHealthProfessionals[index].firstName} | ${model.allHealthProfessionals[index].profession}'),
                  subtitle: Text(
                      '${model.allHealthProfessionals[index].age.toString()}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider()
              ]),
            );
          },
          itemCount: model.allHealthProfessionals.length,
        );
      },
    );
  }
}
