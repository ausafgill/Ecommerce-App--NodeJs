import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/cart/cart_services/cart_repo.dart';
import 'package:amazon/features/product%20details/product_services/product_services.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:amazon/features/search/screens/search_screen.dart';
import 'package:amazon/shared/widgets/helper_button.dart';
import 'package:amazon/shared/widgets/helper_textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartHome extends StatefulWidget {
  const CartHome({super.key});

  @override
  State<CartHome> createState() => _CartHomeState();
}

class _CartHomeState extends State<CartHome> {
  TextEditingController searchController = TextEditingController();
  final ProductServices productServices = ProductServices();
  final CartRepo cartRepo = CartRepo();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  void increaseQuantity(Product product) {
    productServices.addToCart(product, context);
  }

  void decreaseQuantity(Product product) {
    productServices.removefromCart(product, context);
  }

  @override
  Widget build(BuildContext context) {
    final _user = context.watch<UserProvider>().user;
    int sum = 0;

    _user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(70),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
            ),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 10, bottom: 10),
                    child: HelperTextField(
                        onChanged: (val) {
                          Navigator.pushNamed(context, SearchScreen.routeName,
                              arguments: searchController.text);
                        },
                        htxt: 'Search',
                        controller: searchController,
                        keyboardType: TextInputType.name),
                  ),
                ),
                const Row(
                  children: [
                    Icon(
                      Icons.mic,
                      color: Colors.black,
                    ),
                  ],
                )
              ],
            ),
          )),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 40,
              decoration: const BoxDecoration(
                  gradient: LinearGradient(colors: [
                Color.fromARGB(255, 114, 226, 221),
                Color.fromARGB(255, 162, 236, 233)
              ], stops: [
                0.5,
                1.0
              ])),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    const Icon(Icons.location_pin),
                    const SizedBox(
                      width: 15,
                    ),
                    Text(
                      "Delivering to ${_user.email}, ${_user.address} ",
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Row(
              children: [
                const Text(
                  "Subtotal ",
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  '\$$sum',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                )
              ],
            ),
            const SizedBox(
              height: 8,
            ),
            HelperButton(
                name: 'Proceed to Buy ${_user.cart.length} items',
                onTap: () {
                  cartRepo.placeOrder(context, _user.address, sum.toDouble());
                }),
            Row(
              children: [
                Expanded(
                    child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: 150,
                  child: ListView.builder(
                      itemCount: _user.cart.length,
                      itemBuilder: (context, index) {
                        Product product = Product.fromMap(
                          _user.cart[index]['product'],
                        );

                        int quantity = _user.cart[index]['quantity'];
                        return Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Container(
                                  child: Image.network(
                                    product.images[0],
                                    fit: BoxFit.contain,
                                    height: 135,
                                    width: 135,
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product.name,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      product.description,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16),
                                    ),
                                    Text(
                                      '\$${product.price.toString()}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    ),
                                    const Text(
                                      "Eligible for FREE Shipping",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    Text(
                                      "In Stock",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: GlobalVariables
                                              .selectedNavBarColor),
                                    )
                                  ],
                                )
                              ],
                            ),
                            Container(
                              margin: const EdgeInsets.all(10),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Colors.black12,
                                            width: 1.5,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          color: Colors.black12,
                                        ),
                                        child: Row(children: [
                                          InkWell(
                                            onTap: () =>
                                                decreaseQuantity(product),
                                            child: Container(
                                              width: 35,
                                              height: 32,
                                              alignment: Alignment.center,
                                              child: const Icon(
                                                Icons.remove,
                                                size: 18,
                                              ),
                                            ),
                                          ),
                                          DecoratedBox(
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: Colors.black12,
                                                  width: 1.5),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                            ),
                                            child: Container(
                                              width: 35,
                                              height: 32,
                                              alignment: Alignment.center,
                                              child: Text(
                                                quantity.toString(),
                                              ),
                                            ),
                                          ),
                                          InkWell(
                                              onTap: () =>
                                                  increaseQuantity(product),
                                              child: Container(
                                                  width: 35,
                                                  height: 32,
                                                  alignment: Alignment.center,
                                                  child: const Icon(
                                                    Icons.add,
                                                    size: 18,
                                                  )))
                                        ]))
                                  ]),
                            )
                          ],
                        );
                      }),
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
