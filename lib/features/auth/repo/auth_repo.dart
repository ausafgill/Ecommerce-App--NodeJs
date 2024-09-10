import 'dart:convert';
import 'dart:developer';
import 'package:amazon/features/home/screens/home.dart';
import 'package:amazon/shared/widgets/snackbar.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'package:amazon/app.dart';
import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepo {
  static Future<bool> signupUser(UserModel user) async {
    Dio dio = Dio();
    try {
      final res =
          await dio.post(uri + '/amazon/v1/user/signup', data: user.toMap());
      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        // SharedPreferencesManager.saveUser(res.data as Map<String, dynamic>);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      log(e.toString());
      return false;
    }
  }

  static Future<String> signinUser(
      String email, var password, BuildContext context) async {
    Dio dio = Dio();
    try {
      final res = await dio.post(uri + '/amazon/v1/user/signin',
          data: jsonEncode({'email': email, 'password': password}),
          options: Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
            },
          ));
      log('Response data: ${res.data}');
      log('Status code: ${res.statusCode}');

      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        final responseData = res.data as Map<String, dynamic>;
        UserModel user = UserModel.fromMap(responseData);
        final token = responseData['token'];

        // SharedPreferences prefs = await SharedPreferences.getInstance();

        // await prefs.setString('token', token);
        Provider.of<UserProvider>(context, listen: false).setUser(responseData);
        SharedPreferencesManager.saveTokenId(token);
        Decider.authStream.add(token);
        SharedPreferencesManager.saveUser(user);

        log(responseData.toString());
        return 'Success';
      } else {
        switch (res.statusCode) {
          case 400:
            return jsonDecode(res.data)['error'];

          case 500:
            return jsonDecode(res.data)['error'];

          default:
            return jsonDecode(res.data)['error'];
        }
      }
    } on DioException catch (e) {
      return e.response.toString();
    }
  }

  void getUserData(
    BuildContext context,
  ) async {
    try {
      Dio dio = Dio();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('token');

      if (token == null) {
        prefs.setString('token', '');
      }

      var tokenRes = await dio.post(
        uri + 'tokenIsValid',
        options: (Options(headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'token': token!
        })),
      );

      var response = jsonDecode(tokenRes.data);

      if (response == true) {
        Response userRes = await dio.get(
          uri + '/',
          options: (Options(
            headers: <String, String>{
              'Content-Type': 'application/json; charset=UTF-8',
              'x-auth-token': token
            },
          )),
        );

        var userProvider = Provider.of<UserProvider>(context, listen: false);
        userProvider.setUser(userRes.data);
      }
    } catch (e) {
      showSnackbar(context: context, content: e.toString());
    }
  }
}
