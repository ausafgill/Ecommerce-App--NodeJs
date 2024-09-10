import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:amazon/constants/gloabal_variable.dart';
//import 'package:amazon/constants/global_variable.dart'; // Ensure correct import path
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/account/models/order_model.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:cloudinary_public/cloudinary_public.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminRepo {
  Future<bool> sellProduct({
    required String name,
    required String description, // Fixed typo
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    String t = await SharedPreferencesManager.getTokenId();
    try {
      log("Inside sellProduct");
      final cloudinary = CloudinaryPublic('dhi2znue2', 'gzrttyeu');
      List<String> imgUrls = []; // Initialize imgUrls
      for (File image in images) {
        try {
          CloudinaryResponse res = await cloudinary.uploadFile(
            CloudinaryFile.fromFile(image.path, folder: name),
          );
          imgUrls.add(res.secureUrl); // Add the URL to imgUrls list
          log('Image uploaded: ${res.secureUrl}');
        } catch (e) {
          log('Error uploading image: ${e.toString()}');
        }
      }

      Product product = Product(
        name: name,
        description: description,
        price: price,
        quantity: quantity,
        category: category,
        images: imgUrls,
      );
      bool success = await addProductApiCall(product); // Await the API call
      log("Product added successfully: $success");
      return true;
    } catch (e) {
      log("Error in sellProduct: ${e.toString()}");
      return false;
    }
  }

  static Future<bool> addProductApiCall(Product product) async {
    String t = await SharedPreferencesManager.getTokenId();

    Dio dio = Dio();
    try {
      log("Inside addProductApiCall");
      final res = await dio.post(
        '$uri/amazon/v1/admin/add-product',
        data: product.toJson(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'token': t,
          },
        ),
      );
      if (res.statusCode! >= 200 && res.statusCode! < 300) {
        return true;
      } else {
        log("API call failed with status code: ${res.statusCode}");
        return false;
      }
    } catch (e) {
      log("Error in addProductApiCall: ${e.toString()}");
      return false;
    }
  }

  Future<Map<String, dynamic>> getAllProducts() async {
    String t = await SharedPreferencesManager.getTokenId();

    Dio dio = Dio();
    try {
      final res = await dio.get(
        '$uri/amazon/v1/admin/getAll-product',
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'token': t,
          },
        ),
      );
      return res.data as Map<String, dynamic>; // Ensure it returns a Map
    } on DioException catch (e) {
      log('DioException: ${e.toString()}');
      throw e;
    } catch (e) {
      log('Exception: ${e.toString()}');
      throw e;
    }
  }

  static Future<bool> deleteProduct(String id) async {
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.post("$uri/amazon/v1/admin/delete-product",
          data: jsonEncode(
            {"id": id},
          ),
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'token': t,
          }));
      if (res.statusCode! >= 200 && res.statusCode! <= 300) {
        return true;
      } else {
        return false;
      }
    } on DioException catch (e) {
      log("Delete Error:$e");
      return false;
    }
  }

  Future<List<Order>?> fetchAllOrders() async {
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.get('$uri/amazon/v1/admin/fetchAllOrders',
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

  Future changeOrderStatus(
    BuildContext context,
    int status,
    Order order,
  ) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    Dio dio = Dio();
    String t = await SharedPreferencesManager.getTokenId();
    try {
      final res = await dio.post('$uri/amazon/v1/admin/change-order-status',
          data: jsonEncode({
            'id': order.id,
            'status': status,
          }),
          options: Options(headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'token': t,
          }));
    } on DioException catch (e) {
      log('Change Status${e.toString()}');
    }
  }

  void logout(BuildContext context) {
    SharedPreferencesManager.saveTokenId('');
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => AuthScreen()),
      (route) => false,
    );
  }
}
