import 'package:scoped_model/scoped_model.dart';

import './connected_products.dart';

class MainModel extends Model
    with ConnectedProductsModel, UserModel, ProductsModel, UtilityModel, StaticMaps, {}

// gs://first-flutter-app-4aab6.appspot.com
