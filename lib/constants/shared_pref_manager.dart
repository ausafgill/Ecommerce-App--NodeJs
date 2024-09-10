import 'dart:convert';

import 'package:amazon/features/auth/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static const String _tokenKey = 'token';
  static const _userKey = 'user';
  static const _cartKey = 'cart';

  static Future<void> saveTokenId(String token) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String> getTokenId() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? "";
  }

  static Future<void> saveUser(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert UserModel to JSON string
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  static Future<void> saveCart(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // Convert UserModel to JSON string
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_cartKey, userJson);
  }

  static Future<UserModel?> getCartUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_cartKey);
    if (userString != null) {
      // Convert JSON string to UserModel
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }

  static Future<UserModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userString = prefs.getString(_userKey);
    if (userString != null) {
      // Convert JSON string to UserModel
      return UserModel.fromJson(jsonDecode(userString));
    }
    return null;
  }
}
