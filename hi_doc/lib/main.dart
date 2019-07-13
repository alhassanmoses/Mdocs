import 'package:flutter/material.dart';
import 'package:hi_doc/models/user.dart';
import 'package:hi_doc/pages/signup.dart';
// import 'package:hi_doc/widgets/ui_elements/address_tag.dart';
// import 'package:hi_doc/widgets/ui_elements/age_tag.dart';
// import 'package:hi_doc/widgets/ui_elements/build_name.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:scoped_model/scoped_model.dart';
// import 'package:rxdart/subjects.dart';

import './pages/auth.dart';
import './scoped_models/main.dart';
import './pages/home.dart';
import './pages/health_professional.dart';
import './pages/signup.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final MainModel _model = MainModel();
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model.autoAuthenticate();
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
        _model.usermode;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
        model: _model,
        child: MaterialApp(
          theme: ThemeData(
            accentColor: Colors.orange,
            primarySwatch: Colors.orange,
            buttonColor: Colors.deepOrange,
          ),
          routes: {
            '/': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : HomePage(_model),
            '/home_page': (BuildContext context) =>
                !_isAuthenticated ? AuthPage() : HomePage(_model),
            '/signUp': (BuildContext context) => SignUpPage(),
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_isAuthenticated) {
              return MaterialPageRoute<bool>(
                builder: (BuildContext context) => AuthPage(),
              );
            }

            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1] == 'healthProfessional') {
              final String healthpId = pathElements[2];
              final User healthProfessional = _model.allHealthProfessionals
                  .firstWhere((User healthProfessional) {
                return healthProfessional.id == healthpId;
              });

              return MaterialPageRoute(
                builder: (BuildContext context) =>
                    HealthProfessionalPage(healthProfessional),
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) =>
                    !_isAuthenticated ? AuthPage() : HomePage(_model));
          },
        ));
  }
}
