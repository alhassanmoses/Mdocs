import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:hi_doc/pages/signup.dart';

import '../scoped_models/main.dart';
import '../widgets/helpers/socialicons.dart';
import '../models/custom_icons.dart';
import '../widgets/helpers/13.2 ensure_visible.dart.dart';
import 'package:scoped_model/scoped_model.dart';
import '../models/auth.dart';

class AuthPage extends StatefulWidget {
  // final MainModel model;
  // AuthPage(this.model);
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _passwordFocusNode = FocusNode();
  final _emailFocusNode = FocusNode();
  bool _isSelected = false;

  void _radio() {
    setState(() {
      _isSelected = !_isSelected;
    });
  }

  final Map<String, dynamic> _formData = {
    'email': null,
    'password': null,
    'acceptTerms': false
  };
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordTextController = TextEditingController();
  AuthMode _authMode = AuthMode.Login;

  DecorationImage _buildBackgroundImage() {
    return DecorationImage(
      fit: BoxFit.cover,
      colorFilter:
          ColorFilter.mode(Colors.black.withOpacity(0.5), BlendMode.dstATop),
      image: AssetImage('assets/auth_background.jpg'),
    );
  }

  Widget _buildRadioButton(bool isSelected) {
    return Container(
      width: 18.0,
      height: 18.0,
      padding: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 2.0, color: Colors.black)),
      child: isSelected
          ? Container(
              width: double.infinity,
              height: double.infinity,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: Colors.black))
          : Container(),
    );
  }

  Widget _buildHorizontalLine() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: Container(
        width: ScreenUtil.getInstance().setWidth(120),
        height: 1.0,
        color: Colors.black26.withOpacity(.2),
      ),
    );
  }

  Widget _buildSocialIconsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        SocialIcon(
          colors: [
            Color(0xFF102397),
            Color(0xFF187adf),
            Color(0xFF00eaf8),
          ],
          iconData: CustomIcons.facebook,
          onPressed: () {},
        ),
        SocialIcon(
          colors: [
            Color(0xFFff4f38),
            Color(0xFFff355d),
          ],
          iconData: CustomIcons.googlePlus,
          onPressed: () {},
        ),
        SocialIcon(
          colors: [
            Color(0xFF17ead9),
            Color(0xFF6078ea),
          ],
          iconData: CustomIcons.twitter,
          onPressed: () {},
        ),
        SocialIcon(
          colors: [
            Color(0xFF00c6fb),
            Color(0xFF005bea),
          ],
          iconData: CustomIcons.linkedin,
          onPressed: () {},
        )
      ],
    );
  }

  Widget _buildEmailTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _emailFocusNode,
      child: TextFormField(
        focusNode: _emailFocusNode,
        decoration: InputDecoration(
          hintText: 'E-mail',
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
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
      ),
    );
  }

  Widget _buildPasswordTextField() {
    return EnsureVisibleWhenFocused(
      focusNode: _passwordFocusNode,
      child: TextFormField(
        focusNode: _passwordFocusNode,
        decoration: InputDecoration(
          hintText: 'PassWord',
          filled: true,
          fillColor: Colors.white,
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
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
      ),
    );
  }

  Widget _buildForgottenPasswordLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Text(
          "Forgot Password?",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "Oswald",
            fontSize: ScreenUtil.getInstance().setSp(28),
          ),
        )
      ],
    );
  }

  Widget _buildRadioAndSignupButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Row(
          children: <Widget>[
            SizedBox(
              width: 12.0,
            ),
            GestureDetector(
              onTap: _radio,
              child: _buildRadioButton(_isSelected),
            ),
            SizedBox(
              width: 8.0,
            ),
            Text(
              "Remember me",
              style: TextStyle(fontSize: 12, fontFamily: "Oswald"),
            )
          ],
        ),
        InkWell(
          child: Container(
            width: ScreenUtil.getInstance().setWidth(330),
            height: ScreenUtil.getInstance().setHeight(100),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF17ead9), Color(0xFF6078ea)]),
                borderRadius: BorderRadius.circular(6.0),
                boxShadow: [
                  BoxShadow(
                      offset: Offset(0.0, 8.0),
                      color: Color(0xFF6078ea).withOpacity(.3),
                      blurRadius: 8.0)
                ]),
            child: Material(
              color: Colors.transparent,
              child: ScopedModelDescendant<MainModel>(
                builder: (BuildContext context, Widget child, MainModel model) {
                  return InkWell(
                    onTap: () => _submitSigninForm(model.authenticate),
                    child: Center(
                      child: model.isLoading
                          ? CircularProgressIndicator()
                          : Text(
                              "SIGNIN",
                              style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Oswald",
                                fontSize: 18,
                                letterSpacing: 1.0,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ),
          ),
        )
      ],
    );
  }

  Widget _buildLoginForm() {
    final double deviceHeight = MediaQuery.of(context).size.height;
    final double targetHeight = deviceHeight > 550 ? 520 : deviceHeight * 2.5;

    return Container(
      padding: EdgeInsets.all(10.0),
      width: double.infinity,
      height: ScreenUtil.getInstance().setHeight(targetHeight),
      decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: [
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, 15.0),
                blurRadius: 15.0),
            BoxShadow(
                color: Colors.black12,
                offset: Offset(0.0, -10.0),
                blurRadius: 10.0)
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Login",
            style: TextStyle(
                fontFamily: "Poppins-Bold",
                fontSize: ScreenUtil.getInstance().setSp(45),
                letterSpacing: .6),
          ),
          SizedBox(
            height: ScreenUtil.getInstance().setHeight(30),
          ),
          Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Email-Address",
                    style: TextStyle(
                        fontFamily: "Oswald",
                        fontSize: ScreenUtil.getInstance().setSp(26)),
                  ),
                  _buildEmailTextField(),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(30),
                  ),
                  Text(
                    "Password",
                    style: TextStyle(
                        fontFamily: "Oswald",
                        fontSize: ScreenUtil.getInstance().setSp(26)),
                  ),
                  _buildPasswordTextField(),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(35),
                  ),
                  _buildForgottenPasswordLink(),
                ],
              )),
        ],
      ),
    );
  }

  void _submitSigninForm(Function authenticate) async {
    if (!_formKey.currentState.validate()) {
      return;
    }
    _formKey.currentState.save();
    Map<String, dynamic> successInformation;

    successInformation = await authenticate(
        _formData['email'], _formData['password'], _authMode);

    if (successInformation['success']) {
      Navigator.of(context).pushReplacementNamed('/home_page');
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
    ScreenUtil.instance = ScreenUtil.getInstance()..init(context);
    ScreenUtil.instance =
        ScreenUtil(width: 750, height: 1334, allowFontScaling: false);

    return Scaffold(
      backgroundColor: Colors.white,
      // resizeToAvoidBottomPadding: false,
      body: Container(
        decoration: BoxDecoration(image: _buildBackgroundImage()),
        child: ListView(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 28.0, right: 28.0, top: 60.0),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Image.asset(
                        "assets/logo.png",
                        width: ScreenUtil.getInstance().setWidth(110),
                        height: ScreenUtil.getInstance().setHeight(110),
                      ),
                      Text(
                        "HiDoc",
                        style: TextStyle(
                            fontFamily: "Oswald",
                            fontSize: ScreenUtil.getInstance().setSp(46),
                            letterSpacing: .6,
                            fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(140),
                  ),
                  _buildLoginForm(),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  _buildRadioAndSignupButtons(),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _buildHorizontalLine(),
                      Text("Social login",
                          style:
                              TextStyle(fontSize: 16.0, fontFamily: "Oswald")),
                      _buildHorizontalLine()
                    ],
                  ),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  _buildSocialIconsRow(),
                  SizedBox(
                    height: ScreenUtil.getInstance().setHeight(40),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "New User?",
                        style: TextStyle(fontFamily: "Oswald"),
                      ),
                      ScopedModelDescendant<MainModel>(
                        builder: (BuildContext context, Widget child,
                            MainModel model) {
                          return InkWell(
                            onTap: () =>
                                Navigator.pushNamed(context, '/signUp'),
                            child: Text(
                              "SignUp",
                              style: TextStyle(
                                  color: Color(0xFF5d74e3),
                                  fontFamily: "Oswald"),
                            ),
                          );
                        },
                      )
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
