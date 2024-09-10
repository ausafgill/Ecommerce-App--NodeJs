import 'package:amazon/features/auth/model/user_model.dart';

import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  UserModel _user = UserModel(
    id: '',
    name: '',
    email: '',
    password: '',
    address: '',
    type: '',
    token: '',
    cart: [],
  );

  UserModel get user => _user;

  void setUser(Map<String, dynamic> user) {
    _user = UserModel.fromMap(user);
    notifyListeners();
  }

  void setUserFromModel(UserModel user) {
    _user = user;
    notifyListeners();
  }
}
