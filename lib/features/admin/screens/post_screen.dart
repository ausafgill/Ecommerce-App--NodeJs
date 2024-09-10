import 'dart:developer';

import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/features/admin/admin%20services/admin_repo.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/admin/screens/add_product_screen.dart';
import 'package:flutter/material.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final AdminRepo adminRepo = AdminRepo();
  bool isLoading = true;
  List<Product>? products;

  @override
  void initState() {
    super.initState();
    getAllProducts();
  }

  Future<void> getAllProducts() async {
    try {
      final res = await adminRepo.getAllProducts();

      if (res is Map<String, dynamic> && res.containsKey('allProducts')) {
        List<dynamic> productList = res['allProducts'];

        setState(() {
          products = productList.map((productJson) {
            return Product.fromMap(productJson as Map<String, dynamic>);
          }).toList();
          isLoading = false;
        });

        log('Products fetched successfully: ${products?.length}');
      } else {
        log('Unexpected response format: ${res}');
        setState(() {
          isLoading = false;
          products = [];
        });
      }
    } catch (e) {
      log('Error fetching products: $e');
      setState(() {
        isLoading = false;
        products = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: GridView.builder(
                itemCount: products!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      SizedBox(
                        height: 140,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.black12,
                                width: 1.5,
                              ),
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                            ),
                            child: Container(
                              width: 180,
                              padding: const EdgeInsets.all(10),
                              child: Image.network(
                                products![index].images[0],
                                fit: BoxFit.fitHeight,
                                width: 180,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            products![index].name,
                            overflow: TextOverflow.ellipsis,
                          ),
                          IconButton(
                              onPressed: () {
                                AdminRepo.deleteProduct(
                                        products![index].id.toString())
                                    .then((_) {
                                  setState(() {
                                    products!.removeAt(index);
                                  });
                                });
                              },
                              icon: Icon(Icons.delete_outline))
                        ],
                      )
                    ],
                  );
                }),
            floatingActionButton: FloatingActionButton(
              backgroundColor: GlobalVariables.selectedNavBarColor,
              onPressed: () {
                Navigator.pushNamed(context, AddProduct.routeName);
              },
              tooltip: 'Add a Product',
              child: Icon(
                Icons.add,
              ),
            ),
          );
  }
}
