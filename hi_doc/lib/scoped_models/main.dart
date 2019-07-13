import 'package:scoped_model/scoped_model.dart';

import './all_models.dart';

class MainModel extends Model
    with
        ConnectedModels,
        HealthProfessionalModel,
        ClientModel,
        UtilityModel,
        UserModel {}
