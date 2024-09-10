import 'dart:async';
import 'dart:developer';

import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/product%20details/product_services/product_services.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:amazon/features/search/screens/search_screen.dart';
import 'package:amazon/shared/widgets/helper_button.dart';
import 'package:amazon/shared/widgets/helper_textfield.dart';
import 'package:amazon/shared/widgets/rating_stars.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';

class ProductDetail extends StatefulWidget {
  static const String routeName = 'product-screen';
  Product product;
  ProductDetail({super.key, required this.product});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  UserModel? _user;
  bool isLoading = true;

  Future<void> _loadUser() async {
    final user = await SharedPreferencesManager.getUser();
    setState(() {
      _user = user;
      isLoading = false;
    });
  }

  TextEditingController searchController = TextEditingController();
  ProductServices productServices = ProductServices();

  double avgRating = 0;
  double myRating = 0;

  @override
  void initState() {
    super.initState();

    double totalRating = 0;

    log(Provider.of<UserProvider>(context, listen: false).user.id);
    for (int i = 0; i < widget.product.ratings!.length; i++) {
      totalRating += widget.product.ratings![i].rating;
      if (widget.product.ratings![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRating = widget.product.ratings![i].rating;
      }
    }

    if (totalRating != 0) {
      avgRating = totalRating / widget.product.ratings!.length;
    }
  }

  @override
  Widget build(BuildContext context) {
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
                  child:
                      // alignment: Alignment.topLeft,
                      Container(
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
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(widget.product.id.toString()),
                  RatingStars(
                    rating: avgRating,
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                widget.product.name,
                style: TextStyle(fontSize: 20),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: CarouselSlider(
                  items: widget.product.images.map((i) {
                    return Builder(builder: (context) {
                      return Image.network(
                        i.toString(),
                        fit: BoxFit.cover,
                      );
                    });
                  }).toList(),
                  options: CarouselOptions(
                      viewportFraction: 1, height: 300, autoPlay: false),
                ),
              ),
              Container(
                height: 5,
                color: Colors.black12,
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Text(
                    "Deal Price:",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    "\$${widget.product.price}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Colors.red),
                  ),
                ],
              ),
              Text(widget.product.description),
              Container(
                height: 5,
                color: Colors.black12,
              ),
              const SizedBox(
                height: 10,
              ),
              HelperButton(name: "Buy Now", onTap: () {}),
              HelperButton(
                  name: "Add to Cart",
                  onTap: () {
                    productServices.addToCart(widget.product, context);
                  }),
              Container(
                height: 5,
                color: Colors.black12,
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Rate this Product",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
              ),
              RatingBar.builder(
                initialRating: myRating,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemBuilder: (context, _) => const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                onRatingUpdate: (rating) {
                  productServices.rateProducts(
                      widget.product.id.toString(), rating);
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
