import 'dart:convert';
import 'dart:developer';

import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/account/models/order_model.dart';
import 'package:dio/dio.dart';

class AccountRepo {
  Future<List<Order>?> fetchAllOrders() async {
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.get('$uri/amazon/v1/cart/fetch-orders',
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'token': t,
          }));
      log(res.data.toString());
      // Directly use the res.data as a list of maps
      List<dynamic> data = res.data;

      // Map the response to a list of Order objects
      List<Order> orders = data.map((order) => Order.fromMap(order)).toList();

      return orders;
    } on DioException catch (e) {
      log('Fetch Order Error:${e.toString()}');
      return null;
    }
  }
}
