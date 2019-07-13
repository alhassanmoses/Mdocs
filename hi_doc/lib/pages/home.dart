import 'package:flutter/material.dart';
import 'package:hi_doc/models/userMode.dart';
import 'package:hi_doc/pages/hp_list.dart';
// import 'package:hi_doc/models/userMode.dart';

import 'package:scoped_model/scoped_model.dart';

import '../scoped_models/main.dart';
import '../widgets/ui_elements/sideDrawer.dart';
// import '../widgets/healthCareProfessionals/healthcareProfessional.dart';
// import '../widgets/clients/client.dart';
import './client_list.dart';

class HomePage extends StatefulWidget {
  final MainModel model;
  HomePage(this.model);

  @override
  State<StatefulWidget> createState() {
    return _HomePageState();
  }
}

class _HomePageState extends State<HomePage> {
  Widget content;
  @override
  initState() {
    widget.model.fetchUsers();
    print(
        'just a test for allHp ${widget.model.allHealthProfessionals} and allclients ${widget.model.allClients} and all users ${widget.model.allUsers}');
    // print(
    //     'the authed id is ${widget.model.authedUserId} and authed persona ${widget.model.persona.id} and authedpersona email is: ${widget.model.persona.email}');
    super.initState();
  }

  Widget _buildDisplayList() {
    // ScopedModelDescendant(builder: ,)

    content = Center(
        // child: Text(
        //     "Sorry, no users found... /* ${model.allUsers.length} ${model.allHealthProfessionals.length} ${model.allClients.length} */"),
        );
    print('my legnth is ${widget.model.allUsers.length}');
    if (widget.model.allUsers.length > 0 && !widget.model.isLoading) {
      content = widget.model.usermode == UserMode.HealthProfessional
          ? ClientListPage(widget.model)
          : HpListPage(widget.model);
      print('I am running');
    } else if (widget.model.isLoading) {
      print('am stuck on loop');
      content = Center(
        child: CircularProgressIndicator(),
      );
    }
    return content;
    // print(
    //     'the number is ${widget.model.allUsers.length} ${widget.model.allClients.length} and thats not all, the  authed persona id is ${widget.model.persona.id}');
    // print('the authed id is ${widget.model.authedUserId}');
    // return RefreshIndicator(
    //   onRefresh: widget.model.fetchUsers,
    // child: content,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: SideDrawer(),
      appBar: AppBar(
        title: Text('Home'),
        actions: <Widget>[
          ScopedModelDescendant<MainModel>(
            builder: (BuildContext context, Widget child, MainModel model) {
              return IconButton(
                icon: Icon(model.displayFavoritesOnly
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () {
                  model.toggleDisplayMode();
                },
              );
            },
          )
        ],
      ),
      body: _buildDisplayList(),
    );
  }
}
