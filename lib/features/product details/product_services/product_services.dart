import 'dart:convert';
import 'dart:developer';

import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProductServices {
  Future rateProducts(String id, double rating) async {
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.post('$uri/amazon/v1/product/rate-product',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'token': t,
          }),
          data: jsonEncode({"id": id, "rating": rating}));
      log(res.data.toString());
    } on DioException catch (e) {
      log(e.toString());
    }
  }

  Future addToCart(Product product, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.post('$uri/amazon/v1/cart/add-to-cart',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'token': t,
          }),
          data: jsonEncode({"id": product.id}));
      var cartList = res.data['cart'] as List<dynamic>; // Expecting a List
      List<Map<String, dynamic>> cartData =
          cartList.map((item) => item as Map<String, dynamic>).toList();

      UserModel user = userProvider.user
          .copyWith(cart: cartData); // Use the list to update the user model
      //SharedPreferencesManager.saveCart(user);
      userProvider.setUserFromModel(user);
    } on DioException catch (e) {
      log(e.toString());
    }
  }

  Future removefromCart(Product product, BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.delete(
        '$uri/amazon/v1/cart/remove-from-cart/${product.id}',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': t,
        }),
      );
      var cartList = res.data['cart'] as List<dynamic>; // Expecting a List
      List<Map<String, dynamic>> cartData =
          cartList.map((item) => item as Map<String, dynamic>).toList();

      UserModel user = userProvider.user
          .copyWith(cart: cartData); // Use the list to update the user model
      //SharedPreferencesManager.saveCart(user);
      userProvider.setUserFromModel(user);
    } on DioException catch (e) {
      log(e.toString());
    }
  }

  Future fetchUserData(BuildContext context) async {
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.get(
        '$uri/amazon/v1/cart/fetchUser',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': t,
        }),
      );
      UserModel user = UserModel.fromMap(res.data);
      Provider.of<UserProvider>(context, listen: false).setUser(user.toMap());
    } on DioException catch (e) {
      log('FETCH USER ERROR: ${e.toString()}');
    }
  }
}
