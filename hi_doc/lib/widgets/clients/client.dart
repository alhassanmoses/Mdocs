import 'package:flutter/material.dart';
import 'package:hi_doc/models/user.dart';

import 'package:scoped_model/scoped_model.dart';

// import './pages/product.dart';
import './client_card.dart';
import '../../models/user.dart';
import '../../scoped_models/main.dart';

class Clients extends StatelessWidget {
  Widget _buildClientList(List<User> clients) {
    Widget clientCards;

    if (clients.length > 0) {
      clientCards = ListView.builder(
        itemBuilder: (BuildContext context, int index) =>
            ClientCard(clients[index], index),
        itemCount: clients.length,
      );
    } else {
      clientCards = Center(
        child: Text('No clients found...'),
      );
    }

    return clientCards;
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return _buildClientList(model.displayedClients);
      },
    );
  }
}
