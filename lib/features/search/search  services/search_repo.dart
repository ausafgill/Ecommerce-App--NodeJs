import 'dart:developer';

import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:dio/dio.dart';

class SearchRepo {
  Future<List<dynamic>> searchProductRepo(String searchQuery) async {
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();

    try {
      final res = await dio.get(
        '$uri/amazon/v1/product/get-search-product/$searchQuery',
        options: Options(headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'token': t,
        }),
      );
      log(res.data.toString());
      return res.data as List<dynamic>;
    } on DioException catch (e) {
      log('Search Error:${e.toString()}');
      throw e;
    }
  }
}
