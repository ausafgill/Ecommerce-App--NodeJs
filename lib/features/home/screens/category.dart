import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/home/home%20services/home_repo.dart';
import 'package:amazon/features/product%20details/screens/product_details.dart';
import 'package:flutter/material.dart';

class CategoryScreen extends StatefulWidget {
  static const String routeName = '/category-screen';
  final String title;
  const CategoryScreen({super.key, required this.title});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final homerepo = HomeRepo();
  List<Product>? products = [];
  getCategory() async {
    final res = await homerepo.getCategoryProdRepo(widget.title);
    List<dynamic> productList = res;
    setState(() {
      products = productList.map((productJson) {
        return Product.fromMap(productJson as Map<String, dynamic>);
      }).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCategory();
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(50),
                child: AppBar(
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                        gradient: GlobalVariables.appBarGradient),
                  ),
                  title: Text(widget.title),
                  centerTitle: true,
                )),
            body: Column(
              children: [
                SizedBox(
                  height: 170,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.only(left: 15),
                    itemCount: products!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.4,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final product = products![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, ProductDetail.routeName,
                              arguments: product);
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 130,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: Colors.black12,
                                    width: 0.5,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Image.network(
                                    product.images[0],
                                  ),
                                ),
                              ),
                            ),
                            Container(
                              alignment: Alignment.topLeft,
                              padding: const EdgeInsets.only(
                                left: 0,
                                top: 5,
                                right: 15,
                              ),
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
  }
}
