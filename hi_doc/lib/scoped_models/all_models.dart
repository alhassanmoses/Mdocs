// import 'package:flutter/material.dart';

import 'dart:async';
import 'dart:convert';

// import 'package:flutter/rendering.dart';
import 'package:hi_doc/models/userMode.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rxdart/subjects.dart';

//import '../models/clients.dart';
import '../models/user.dart';
import '../models/auth.dart';
import '../models/persona.dart';

mixin ConnectedModels on Model {
  bool _isLoading = false;

  AuthMode mode;
  UserMode _usermode /* = UserMode.Client */;
  bool _showFavorites = false;

  List<User> _users = [];

  String authedUserToken;
  String _authedUserId;

  Persona _authenticatedPersona;

  String _selUserId;
  String _selHpId;
  String _selClientId;

  // User _authenticatedUser;

}

mixin UserModel on ConnectedModels {
  PublishSubject<bool> _userSubject = PublishSubject();
  Timer _authTimer;

  User get authedUser {
    return _users.firstWhere((User user) {
      return user.userId == persona.id;
    });
  }

  get authedUserId {
    return _authedUserId;
  }

  List<User> get allUsers {
    return List.from(_users);
  }

  get usermode {
    return _usermode;
  }

  PublishSubject<bool> get userSubject {
    return _userSubject;
  }

  String get selectedUserId {
    return _selUserId;
  }

  User get selectedUser {
    if (selectedUserId == null) {
      return null;
    }
    return _users.firstWhere((User user) {
      return user.id == _selUserId;
    });
  }

  void toggleDisplayMode() {
    _showFavorites = !_showFavorites;
    notifyListeners();
  }

  void selectUser(String userId) {
    _selUserId = userId;
    if (userId != null) {
      notifyListeners();
    }
  }

  Persona get persona {
    return _authenticatedPersona;
  }

  int get selectedUserIndex {
    return _users.indexWhere((User user) {
      return user.id == _selUserId;
    });
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

  Future<Map<String, dynamic>> authenticate(String email, String password,
      [mode, UserMode umode]) async {
    _usermode = umode;
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };
    http.Response response;
    if (mode == AuthMode.Login) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyDJNUzhNKhQjNurRR5b__64K0pOILjB1QU',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    } else if (mode == AuthMode.Signup) {
      response = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyDJNUzhNKhQjNurRR5b__64K0pOILjB1QU',
          body: json.encode(authData),
          headers: {'Content-Type': 'application/json'});
    }

    final Map<String, dynamic> responseData = json.decode(response.body);
    bool hasError = true;
    String message = 'Sorry, an error occured.';
    // print(json.decode(response.body));
    if (responseData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeeded!';

      _authenticatedPersona = Persona(
          id: responseData['localId'],
          email: email,
          token: responseData['idToken']);

      _authedUserId = responseData['localId'];
      authedUserToken = _authenticatedPersona.token;

      setAuthTimeout(int.parse(responseData['expiresIn']));
      _userSubject.add(true);
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(responseData['expiresIn'])));
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', responseData['idToken']);
      prefs.setString('userEmail', email);
      prefs.setString('userId', persona.id);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
      prefs.setBool('isClient', usermode == UserMode.Client ? true : false);
    } else if (responseData['error']['message'] == 'EMAIL_EXISTS') {
      message = 'Sorry, this E-mail already exist.';
    } else if (responseData['error']['message'] == 'EMAIL_NOT_FOUND') {
      message = 'Sorry, this E-mail was not found.';
    } else if (responseData['error']['message'] == 'INVALID_PASSWORD') {
      message = 'Sorry, the given password is invaid.';
    }

    _isLoading = false;
    notifyListeners();

    return {'success': !hasError, 'message': message};
  }

  void autoAuthenticate() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');
    final bool isClient = prefs.getBool('isClient');

    if (token != null) {
      final DateTime now = DateTime.now();
      print("Date time is : $expiryTimeString");
      final parsedExpiryTime = DateTime.parse(expiryTimeString);
      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedPersona = null;
        notifyListeners();
        return;
      }
      final String userEmail = prefs.getString('userEmail');
      final String userId = prefs.getString('userId');
      final int tokenLifespan = parsedExpiryTime.difference(now).inSeconds;
      isClient == true
          ? _usermode = UserMode.Client
          : _usermode = UserMode.HealthProfessional;
      _authenticatedPersona =
          Persona(id: userId, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifespan);
      _authedUserId = userId;

      notifyListeners();
    }
  }

  void logout() async {
    _authenticatedPersona = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  Future<bool> addUser(
      String firstName,
      String lastName,
      String otherName,
      int age,
      String image,
      String profession,
      String experience,
      String shortDescription,
      String address,
      String email,
      bool isFavoriteHp,
      bool isFavoriteClient,
      bool isHealthProfessional) async {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> userData = {
      'firstName': firstName,
      'lastName': lastName,
      'otherName': otherName,
      'age': age,
      'image':
          'https://media.istockphoto.com/photos/we-offer-our-patients-premium-healthcare-here-picture-id638647058?k=6&m=638647058&s=612x612&w=0&h=adSyOTqz2KIwTPznuaP3g1fkv01dxxXnAm2ZbXtuV4M=',
      'userId': persona.id,
      'profession': profession,
      'experience': experience,
      'shortDescription': shortDescription,
      'address': address,
      'email': persona.email,
      'isFavoriteHp': isFavoriteHp,
      'isFavoriteClient': isFavoriteClient,
      'isHealthProfessional': isHealthProfessional
    };
    try {
      final http.Response response = await http.post(
          'https://hidoc-ms.firebaseio.com/users.json?auth=${persona.token}',
          body: json.encode(userData));

      if (response.statusCode != 200 && response.statusCode != 201) {
        _isLoading = false;
        notifyListeners();
        return false;
      }
      final Map<String, dynamic> responseData = json.decode(response.body);
      // print(responseData);
      final User newUser = User(
          firstName: firstName,
          lastName: lastName,
          otherName: otherName,
          age: age,
          image: image,
          id: responseData['name'],
          userId: persona.id,
          // token: persona.token,
          profession: profession,
          experience: experience,
          shortDescription: shortDescription,
          address: address,
          email: persona.email,
          isFavoriteHp: isFavoriteClient,
          isFavoriteClient: isFavoriteClient,
          isHealthProfessional: isHealthProfessional);
      _users.add(newUser);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (error) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchUsers({onlyForUser = false}) {
    _isLoading = true;
    notifyListeners();
    return http
        .get(
      'https://hidoc-ms.firebaseio.com/users.json?auth=${persona.token}',
    )
        .then<Null>((http.Response response) {
      final List<User> fetchedUserList = [];
      final Map<String, dynamic> userListData = json.decode(response.body);
      // print('the problem is not $userListData');
      if (userListData == null) {
        // debugPrint('the bad code run');
        _isLoading = false;
        notifyListeners();
        return;
      }
      // print('the problem really is not $userListData');

      userListData.forEach((String userid, dynamic userData) {
        // print('I am running $userid');
        final User user = User(
          firstName: userData['firstName'],
          lastName: userData['lastName'],
          otherName: userData['otherName'],
          age: userData['age'],
          image: userData['image'],
          id: userid,
          userId: userData['userId'],
          token: userData['token'],
          profession: userData['profession'],
          experience: userData['experience'],
          shortDescription: userData['shortDescription'],
          address: userData['address'],
          email: userData['email'],
          // isFavoriteHp: userData['isFavoriteHp'] == null
          //     ? false
          //     : userData['isFavoriteHp'].toString() == 'false' ? false : true,
          // isFavoriteClient: userData['isFavoriteClient'] == null
          //     ? false
          //     : userData['isFavoriteClient'].toString() == 'false'
          //         ? false
          //         : true,
          isFavoriteHp: userData['favoritelistUsers'] == null
              ? false
              : (userData['favoritelistUsers'] as Map<String, dynamic>)
                  .containsKey(persona.id),
          isFavoriteClient: userData['favoritelistUsers'] == null
              ? false
              : (userData['favoritelistUsers'] as Map<String, dynamic>)
                  .containsKey(persona.id),
          isHealthProfessional: userData['isHealthProfessional'],
        );
        // print('the first one worked $fetchedUserList');
        fetchedUserList.add(user);
      });
      // print('the second one worked $fetchedUserList');
      _users = onlyForUser
          ? fetchedUserList.where((User user) {
              return user.userId == persona.id;
            }).toList()
          : fetchedUserList;

      // print('the magic number is ${fetchedUserList.length}');

      // displayedHp= fetchedUserList.where((User user) {
      //   return user.isHealthProfessional == true;
      // }).toList();
      // displayedClients = fetchedUserList.where((User user) {
      //   return user.isHealthProfessional == false;
      // }).toList();
      _isLoading = false;
      notifyListeners();
      _selUserId = null;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return;
    });
  }

  Future<bool> updateUser(
      {String firstName,
      String lastName,
      String otherNmae,
      int age,
      String image,
      String id,
      String profession,
      String experience,
      String shortDescription,
      String address,
      String email,
      bool isHealthProfessional}) {
    _isLoading = true;
    notifyListeners();
    final Map<String, dynamic> updateData = {
      'firstName': firstName,
      'lastName': lastName,
      'otherName': otherNmae,
      'age': selectedUser.age,
      'image':
          'https://www.google.com/url?sa=i&source=images&cd=&ved=2ahUKEwj0i6_our_iAhVV6uAKHfKpAFwQjRx6BAgBEAU&url=https%3A%2F%2Fwww.dreamstime.com%2Fphotos-images%2Fdoctor.html&psig=AOvVaw0pkJj8r_pJcTmGSqBCGCnm&ust=1559175314861112',
      'userId': selectedUser.userId,
      'profession': profession,
      'experience': experience,
      'shortDescription': shortDescription,
      'address': address,
      'email': selectedUser.email,
      'isHealthProfessional': selectedUser.isHealthProfessional
    };
    return http
        .put(
            'https://hidoc-ms.firebaseio.com/users/${selectedUser.id}.json?auth=${persona.token}',
            body: json.encode(updateData))
        .then((http.Response response) {
      _isLoading = false;
      final User updatedUser = User(
          firstName: firstName,
          lastName: lastName,
          otherName: otherNmae,
          age: selectedUser.age,
          image: image,
          id: selectedUser.id,
          userId: selectedUser.userId,
          token: selectedUser.token,
          profession: profession,
          experience: experience,
          shortDescription: shortDescription,
          email: selectedUser.email,
          isHealthProfessional: isHealthProfessional);

      _users[selectedUserIndex] = updatedUser;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }

  void favoriteStatusToggler() async {
    bool favorite;
    if (usermode ==
        UserMode.Client /* loggedInUser.isHealthProfessional == false */) {
      favorite = selectedUser.isFavoriteHp;
    } else {
      favorite = selectedUser.isFavoriteClient;
    }
    final bool isCurrentlyFavorite = favorite;
    final bool newfavoriteStatus = !isCurrentlyFavorite;
    final User updatedUser = User(
      firstName: selectedUser.firstName,
      lastName: selectedUser.lastName,
      otherName: selectedUser.otherName,
      age: selectedUser.age,
      image: selectedUser.image,
      id: selectedUser.id,
      userId: selectedUser.userId,
      token: selectedUser.token,
      profession: selectedUser.profession,
      experience: selectedUser.experience,
      shortDescription: selectedUser.shortDescription,
      address: selectedUser.address,
      email: selectedUser.email,
      isFavoriteHp: newfavoriteStatus,
      isFavoriteClient: newfavoriteStatus,
      isHealthProfessional: selectedUser.isHealthProfessional,
    );
    _users[selectedUserIndex] = updatedUser;

    notifyListeners();
    http.Response response;
    if (selectedUser.isHealthProfessional) {
      // print('I ran as hp _ fafavirites status function');
      response = await http.put(
          'https://hidoc-ms.firebaseio.com/users/${selectedUser.id}/favoritelistUsers/${persona.id}.json?auth=${persona.token}',
          body: json.encode(true));
    } else {
      response = await http.delete(
          'https://hidoc-ms.firebaseio.com/users/${selectedUser.id}/favoritelistUsers/${persona.id}.json?auth=${persona.token}');
    }

    if (response.statusCode != 200 && response.statusCode != 201) {
      final User updatedUser = User(
          firstName: selectedUser.firstName,
          lastName: selectedUser.lastName,
          otherName: selectedUser.otherName,
          age: selectedUser.age,
          image: selectedUser.image,
          id: selectedUser.id,
          userId: selectedUser.id,
          token: selectedUser.token,
          profession: selectedUser.profession,
          experience: selectedUser.experience,
          shortDescription: selectedUser.shortDescription,
          address: selectedUser.address,
          email: selectedUser.email,
          isHealthProfessional: selectedUser.isHealthProfessional,
          isFavoriteHp: !newfavoriteStatus,
          isFavoriteClient: selectedUser.isFavoriteClient);
      _users[selectedUserIndex] = updatedUser;

      notifyListeners();
    }
  }

  Future<bool> deleteProfile([int userIndex]) {
    _isLoading = true;

    // int selectindex;
    // if (userIndex != null) {
    //   selectindex = userIndex;
    // }

    final deletedUserId = selectedUser.id;
    _users.removeAt(selectedUserIndex);
    _selUserId = null;
    notifyListeners();
    return http
        .delete(
            'https://hidoc-ms.firebaseio.com/users/$deletedUserId.json?auth=${persona.token}')
        .then((http.Response response) {
      _isLoading = false;

      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }
}

mixin ClientModel on ConnectedModels {
  void selectClient(String clientId) {
    _selClientId = clientId;
    if (clientId != null) {
      notifyListeners();
    }
  }

  List<User> get displayedClients {
    if (_showFavorites) {
      return allClients
          .where((User client) => client.isFavoriteClient)
          .toList();
    }
    return _users
        .where((User client) => client.isHealthProfessional == false)
        .toList();
  }

  String get selectedClientId {
    return _selClientId;
  }

  bool get displayFavoritesOnly {
    return _showFavorites;
  }

  List<User> get allClients {
    return List.from(_users
        .where((User user) => user.isHealthProfessional == false)
        .toList());
  }

  int get selectedClientIndex {
    return allClients.indexWhere((User client) {
      return client.id == _selClientId;
    });
  }
}

mixin HealthProfessionalModel on ConnectedModels {
  void selectHp(String hpId) {
    _selHpId = hpId;
    if (hpId != null) {
      notifyListeners();
    }
  }

  List<User> get displayedHp {
    if (_showFavorites) {
      return allHealthProfessionals
          .where((User hp) => hp.isFavoriteHp)
          .toList();
    }
    return List.from(allHealthProfessionals);
  }

  String get selectedHpId {
    return _selHpId;
  }

  User get selectedHealthProfessional {
    if (selectedHpId == null) {
      return null;
    }

    return _users.firstWhere((User user) {
      return user.id == _selHpId;
    });
  }

  List<User> get allHealthProfessionals {
    return List.from(
        _users.where((User user) => user.isHealthProfessional).toList());
  }

  int get selectedHpIndex {
    return allHealthProfessionals.indexWhere((User healthProfessional) {
      return healthProfessional.id == _selHpId;
    });
  }
}

mixin UtilityModel on ConnectedModels {
  bool get isLoading {
    return _isLoading;
  }
}
