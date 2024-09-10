import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/product%20details/screens/product_details.dart';
import 'package:amazon/features/search/search%20%20services/search_repo.dart';
import 'package:amazon/shared/widgets/helper_textfield.dart';
import 'package:amazon/shared/widgets/rating_stars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class SearchScreen extends StatefulWidget {
  static const String routeName = '/search-screen';
  String searchQuery;
  SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchController = TextEditingController();
  SearchRepo searchRepo = SearchRepo();
  List<Product>? product;
  UserModel? _user;

  getSearchProduct() async {
    final res = await searchRepo.searchProductRepo(widget.searchQuery);
    List<dynamic> plist = res;
    setState(() {
      product = plist.map((p) {
        return Product.fromMap(p as Map<String, dynamic>);
      }).toList();
    });
  }

  Future<void> _loadUser() async {
    final user = await SharedPreferencesManager.getUser();
    setState(() {
      _user = user;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSearchProduct();
    _loadUser();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return product == null
        ? const Center(child: CircularProgressIndicator())
        : Scaffold(
            appBar: PreferredSize(
                preferredSize: const Size.fromHeight(70),
                child: AppBar(
                  flexibleSpace: Container(
                    decoration: const BoxDecoration(
                        gradient: GlobalVariables.appBarGradient),
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
                                Navigator.pushNamed(
                                    context, SearchScreen.routeName,
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
            body: Column(
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
                          "Delivering to ${_user!.name}, ${_user!.address} ",
                        )
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                Expanded(
                    child: ListView.builder(
                        itemCount: product!.length,
                        itemBuilder: (context, index) {
                          var p = product![index];
                          double totalRating = 0;

                          double avgRating = 0;
                          for (int i = 0; i < p.ratings!.length; i++) {
                            totalRating += p.ratings![i].rating;
                          }

                          if (totalRating != 0) {
                            avgRating = totalRating / p.ratings!.length;
                          }
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(
                                    context, ProductDetail.routeName,
                                    arguments: p);
                              },
                              child: Container(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    SizedBox(
                                      height: 130,
                                      child: DecoratedBox(
                                        decoration: const BoxDecoration(),
                                        child: Padding(
                                          padding: const EdgeInsets.all(0),
                                          child: Image.network(
                                            p.images[0],
                                          ),
                                        ),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p.name,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          p.description,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(fontSize: 16),
                                        ),
                                        RatingStars(
                                          rating: avgRating,
                                        ),
                                        Text(
                                          '\$${p.price.toString()}',
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
                              ),
                            ),
                          );
                        }))
              ],
            ),
          );
  }
}
