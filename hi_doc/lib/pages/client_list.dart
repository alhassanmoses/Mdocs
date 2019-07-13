import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';
// import './product_edit.dart';

class ClientListPage extends StatefulWidget {
  final MainModel model;
  ClientListPage(this.model);
  @override
  State<StatefulWidget> createState() {
    return _ClientListPageState();
  }
}

class _ClientListPageState extends State<ClientListPage> {
  @override
  void initState() {
    widget.model.fetchUsers(onlyForUser: true);
    super.initState();
  }

  Widget _buildEditButton(BuildContext context, int index, MainModel model) {
    return IconButton(
      icon: Icon(Icons.edit),
      onPressed: () {
        model.selectClient(model.allClients[index].id);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) {
              return Container(
                child: Text('icon button pressed'),
              ) /* ClientEditPage() */;
            },
          ),
        ).then((_) {
          model.selectClient(null);
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
              key: Key(model.allClients[index].firstName),
              onDismissed: (DismissDirection direction) {
                if (direction == DismissDirection.endToStart) {
                  model.selectClient(model.allClients[index].id);
                  model.deleteProfile();
                }
              },
              background: Container(
                color: Colors.red,
              ),
              child: Column(children: <Widget>[
                ListTile(
                  leading: CircleAvatar(
                      backgroundImage:
                          NetworkImage(model.allClients[index].image)),
                  title: Text(model.allClients[index].firstName),
                  subtitle: Text('${model.allClients[index].age.toString()}'),
                  trailing: _buildEditButton(context, index, model),
                ),
                Divider()
              ]),
            );
          },
          itemCount: model.allClients.length,
        );
      },
    );
  }
}
