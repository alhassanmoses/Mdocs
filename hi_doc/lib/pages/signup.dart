import 'dart:async';

import 'package:flutter/material.dart';
import 'package:hi_doc/models/userMode.dart';
import 'package:scoped_model/scoped_model.dart';

import '../models/auth.dart';
import '../scoped_models/main.dart';

class SignUpPage extends StatefulWidget {
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final Map<String, dynamic> _formData = {
    'fname': null,
    'lname': null,
    'oname': null,
    'age': null,
    'image': 'assets/food-dinner-lunch.jpg',
    'profession': null,
    'experience': null,
    'shortDescription': null,
    'address': null,
    'email': null,
    'isFavoriteHp': false,
    'isFavoriteClient': false,
    'isHealthProfessional': false,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Signup;
  UserMode _umode = UserMode.Client;
  int _radioValue = 1;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/auth_background.jpg'),
    );
  }

  Widget _buildEmailTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'E-Mail', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.emailAddress,
      validator: (String value) {
        if (value.isEmpty ||
            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                .hasMatch(value)) {
          return 'Please enter a valid email address';
        }
      },
      onSaved: (String value) {
        _formData['email'] = value;
      },
    );
  }

  Widget _buildAddressTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Address...', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['address'] = value;
      },
    );
  }

  Widget _buildFirstNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'First Name...', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty ||
            RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
          return 'Please enter a first name';
        }
      },
      onSaved: (String value) {
        _formData['fname'] = value;
      },
    );
  }

  Widget _buildLastNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Last Name...', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isEmpty ||
            RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
          return 'Please enter a last name';
        }
      },
      onSaved: (String value) {
        _formData['lname'] = value;
      },
    );
  }

  Widget _buildOtherNameTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Other Name, if any...',
          filled: true,
          fillColor: Colors.white),
      keyboardType: TextInputType.text,
      validator: (String value) {
        if (value.isNotEmpty &&
            RegExp(r'[!@#<>?":_`~;[\]\\|=+)(*&^%0-9-]').hasMatch(value)) {
          return 'Invalid name entered';
        }
      },
      onSaved: (String value) {
        _formData['oname'] = value;
      },
    );
  }

  Widget _buildAgeTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Your Age...', filled: true, fillColor: Colors.white),
      keyboardType: TextInputType.number,
      validator: (String value) {
        if (value.isEmpty ||
            RegExp(r'[.!@#<>?":_`~;[\]\\|=+)(*&^%\s-]').hasMatch(value) ||
            int.parse(value) > 120) {
          return 'Please enter a valid age';
        }
      },
      onSaved: (String value) {
        _formData['age'] = int.parse(value);
      },
    );
  }

  Widget _buildProfessionTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Please specify profession...',
          filled: true,
          fillColor: Colors.white),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['profession'] = value;
      },
    );
  }

  Widget _buildExperienceTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Please indicate years of profession if (Optional)..',
          filled: true,
          fillColor: Colors.white),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['experience'] = value;
      },
    );
  }

  Widget _buildShortDescriptionTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Short professional discrition of you (optional)...',
          filled: true,
          fillColor: Colors.white),
      keyboardType: TextInputType.text,
      onSaved: (String value) {
        _formData['shortDescription'] = value;
      },
    );
  }

  Widget _buildPasswordTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      controller: _passwordTextController,
      validator: (String value) {
        if (value.isEmpty || value.length < 6) {
          return 'Invalid password';
        }
      },
      onSaved: (String value) {
        _formData['password'] = value;
      },
    );
  }

  Widget _buildPasswordConfirmTextField() {
    return TextFormField(
      decoration: InputDecoration(
          labelText: 'Confirm Password', filled: true, fillColor: Colors.white),
      obscureText: true,
      validator: (String value) {
        if (_passwordTextController.text != value) {
          return 'Sorry, the passwords do not match. Try Again...';
        }
      },
    );
  }

  Widget _buildUserTypeRadioButtons() {
    return ScopedModelDescendant<MainModel>(
        builder: (BuildContext context, Widget child, MainModel model) {
      return Container(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Signup as:',
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio(
                  value: 0,
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                      _umode = UserMode.HealthProfessional;
                      _formData['isHealthProfessional'] = true;
                      // print('try 1 firtst radio $_radioValue');
                    });
                  },
                ),
                Text(
                  'Health Professional',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 40.0,
                ),
                Radio(
                  value: 1,
                  groupValue: _radioValue,
                  onChanged: (value) {
                    setState(() {
                      _radioValue = value;
                      _umode = UserMode.Client;
                      _formData['isHealthProfessional'] = false;
                      // print('try 2 second radio $_radioValue');
                    });
                  },
                ),
                Text(
                  'Client',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  Widget _buildAcceptTermsSwitch() {
    return SwitchListTile(
      value: _formData['acceptTerms'],
      onChanged: (bool value) {
        setState(() {
          _formData['acceptTerms'] = value;
        });
      },
      title: Text('Accept Terms'),
    );
  }

  void _submitForm(Function authenticate, Function addUser, Function updateUser,
      Function setSelectedUser, Function deleteUserProfile,
      [int selectedUserIndex]) async {
    if (!_formKey.currentState.validate() || !_formData['acceptTerms']) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;
    // Map<String, dynamic> successPostInfo; //allready handled below

    // successPostInfo = await addUser(); // handled by authenticate

    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode, _umode);

    if (successInformation['success']) {
      addUser(
              _formData['fname'],
              _formData['lname'],
              _formData['oname'],
              _formData['age'],
              _formData['image'],
              _formData['profession'],
              _formData['experience'],
              _formData['shortDescription'],
              _formData['address'],
              _formData['email'],
              _formData['isFavoriteHp'],
              _formData['IsFavoriteClient'],
              _formData['isHealthProfessional'])
          .then((bool success) {
        if (success) {
          Navigator.pushReplacementNamed(context, '/home_page')
              .then((_) => setSelectedUser(null));
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Oops!!, Something went wrong'),
                  content: Text('Please try again!'),
                  actions: <Widget>[
                    FlatButton(
                      onPressed: () {
                        deleteUserProfile(selectedUserIndex);
                        Navigator.of(context).pop();
                      },
                      child: Text('Okay'),
                    )
                  ],
                );
              });
        }
      });

      // updateUser(
      //   _formData['firstName'],
      //   _formData['lastName'],
      //   _formData['otherName'],
      //   _formData['age'],
      //   _formData['image'],
      //   _formData['id'],
      //   _formData['profession'],
      //   _formData['experience'],
      //   _formData['shortDescription'],
      //   _formData['address'],
      //   _formData['email'],
      //   _formData['isHealthProfessional'],
      // ).then((_) => Navigator.pushReplacementNamed(context, '/home_page')
      //     .then((_) => setSelectedUser(null)));

      // Navigator.pushReplacementNamed(context, '/home_page');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('An Error Occurred'),
            content: Text(successInformation['message']),
            actions: <Widget>[
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final double deviceWidth = MediaQuery.of(context).size.width;
    final double targetWidth = deviceWidth > 550.0 ? 500.0 : deviceWidth * 0.95;

    return WillPopScope(
      onWillPop: () {
        Navigator.pop(context, false);
        return Future.value(false);
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('SignUp'),
        ),
        body: Container(
          decoration: BoxDecoration(image: _buildBackgroundImage()),
          padding: EdgeInsets.all(10.0),
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: targetWidth,
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      _buildFirstNameTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildLastNameTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildOtherNameTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildAgeTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _radioValue == 0
                          ? _buildProfessionTextField()
                          : Container(),
                      _radioValue == 0
                          ? SizedBox(
                              height: 10.0,
                            )
                          : Container(),
                      _radioValue == 0
                          ? _buildExperienceTextField()
                          : Container(),
                      _radioValue == 0
                          ? SizedBox(
                              height: 10.0,
                            )
                          : Container(),
                      _radioValue == 0
                          ? _buildShortDescriptionTextField()
                          : Container(),
                      _radioValue == 0
                          ? SizedBox(
                              height: 10.0,
                            )
                          : Container(),
                      _buildAddressTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildEmailTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordTextField(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildPasswordConfirmTextField(),
                      SizedBox(
                        height: 30.0,
                      ),
                      _buildUserTypeRadioButtons(),
                      SizedBox(
                        height: 10.0,
                      ),
                      _buildAcceptTermsSwitch(),
                      SizedBox(
                        height: 10.0,
                      ),
                      ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return model.isLoading
                              ? CircularProgressIndicator()
                              : RaisedButton(
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  child: Text(' Signup'),
                                  onPressed: () {
                                    _authMode = AuthMode.Signup;
                                    if (_formData['isHealthProfessional'] ==
                                        false) {
                                      _umode = UserMode.Client;
                                    } else if (_formData[
                                            'isHealthProfessional'] ==
                                        true) {
                                      _umode = UserMode.HealthProfessional;
                                    }

                                    _submitForm(
                                      model.authenticate,
                                      model.addUser,
                                      model.updateUser,
                                      model.selectUser,
                                      model.deleteProfile,
                                      _formData['isHealthProfessional'] == true
                                          ? model.selectedHpIndex
                                          : model.selectedClientIndex,
                                    );
                                  });
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
