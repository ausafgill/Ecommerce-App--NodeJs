import 'dart:convert';
import 'dart:developer';

import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:dio/dio.dart';

class HomeRepo {
  Future<List<dynamic>> getCategoryProdRepo(String category) async {
    String t = await SharedPreferencesManager.getTokenId();
    Dio dio = Dio();
    try {
      final res = await dio.get(
        '$uri/amazon/v1/product/get-category-product?category=$category',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': t,
        }),
      );
      log(res.data.toString());

      return res.data as List<dynamic>;
    } on DioException catch (e) {
      log('Category Data Error: $e');
      throw e;
    }
  }

  Future<Product> fetchDealofDay() async {
    Dio dio = Dio();
    Product product = Product(
        name: '',
        description: '',
        price: 0,
        quantity: 0,
        category: '',
        images: []);
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.get(
        '$uri/amazon/v1/product/get-dealofday',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': t,
        }),
      );
      log(res.data['data']['p'].toString());
      product = Product.fromMap(res.data['data']['p']);
      return product;
    } on DioException catch (e) {
      log("DEAL FETCH ERROR: ${e.toString()}");
      return product;
    }
  }
}
