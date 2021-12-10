import 'package:firebase_auth/firebase_auth.dart';
import 'package:blips/services/shared_prefs.dart';
import 'package:flutter/cupertino.dart';

class AuthProvider with ChangeNotifier {
  late User _currentUser;
  void setUser(User user) {
    _currentUser = user;
    print('SETTING USER');
    sharedPrefs.uid = _currentUser.uid;

    notifyListeners();
  }

  User get currentUser => _currentUser;

}