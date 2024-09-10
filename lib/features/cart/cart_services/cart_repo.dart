import 'dart:convert';
import 'dart:developer';

import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartRepo {
  Future placeOrder(
      BuildContext context, String address, double totalPrice) async {
    Dio dio = Dio();
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.post('$uri/amazon/v1/cart/place-order',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'token': t,
          }),
          data: jsonEncode({
            'address': address,
            'totalPrice': totalPrice,
            'cart': userProvider.user.cart
          }));

      UserModel user = userProvider.user.copyWith(
        cart: [],
      );
      userProvider.setUserFromModel(user);
    } on DioException catch (e) {
      log('OrderPlacingERROR: ${e.toString()}');
    }
  }
}
