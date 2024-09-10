import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/admin/models/product.dart';
import 'package:amazon/features/auth/bloc/auth_bloc.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/home/home%20services/home_repo.dart';
import 'package:amazon/features/home/screens/category.dart';
import 'package:amazon/features/product%20details/screens/product_details.dart';
import 'package:amazon/features/search/screens/search_screen.dart';
import 'package:amazon/shared/widgets/helper_textfield.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  static const String routeName = '/home-screen';

  Home({
    Key? key,
  }) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController searchController = TextEditingController();
  UserModel? _user;
  bool isLoading = true;
  HomeRepo homeRepo = HomeRepo();
  Product? p;

  @override
  void initState() {
    super.initState();
    _loadUser();
    fetchDealofDay();
  }

  fetchDealofDay() async {
    p = await homeRepo.fetchDealofDay();
    setState(() {});
  }

  Future<void> _loadUser() async {
    final user = await SharedPreferencesManager.getUser();
    setState(() {
      _user = user;
      isLoading = false;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Future.delayed(Duration(seconds: 2));
    return p == null
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : p!.name.isEmpty
            ? const SizedBox()
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
                              margin:
                                  const EdgeInsets.only(top: 10, bottom: 10),
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
                body: isLoading
                    ? const Center(
                        child:
                            CircularProgressIndicator()) // Show loading indicator while fetching data
                    : SingleChildScrollView(
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
                                      "Delivering to ${_user!.name}, ${_user!.address} ",
                                    )
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Categories(),
                            CarouselSlider(
                              items: GlobalVariables.carouselImages.map((i) {
                                return Builder(builder: (context) {
                                  return Image.network(
                                    i.toString(),
                                    fit: BoxFit.cover,
                                  );
                                });
                              }).toList(),
                              options: CarouselOptions(
                                  viewportFraction: 1,
                                  height: 200,
                                  autoPlay: true),
                            ),
                            DealofDay(
                              product: p!,
                            )
                          ],
                        ),
                      ),
              );
  }

  SizedBox Categories() {
    return SizedBox(
        height: 120,
        child: ListView.builder(
            itemExtent: 80,
            scrollDirection: Axis.horizontal,
            itemCount: GlobalVariables.categoryImages.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, CategoryScreen.routeName,
                      arguments: GlobalVariables.categoryImages[index]
                          ['title']);
                },
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: Image.asset(
                        GlobalVariables.categoryImages[index]['image']
                            .toString(),
                        height: 50,
                        width: 50,
                      ),
                    ),
                    Text(GlobalVariables.categoryImages[index]['title']
                        .toString())
                  ],
                ),
              );
            }));
  }
}

class DealofDay extends StatelessWidget {
  Product product;
  DealofDay({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, ProductDetail.routeName,
            arguments: product);
      },
      child: Container(
        padding: const EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Deal of the Day",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Image.network(
                product.images[0],
                height: 215,
                fit: BoxFit.fitHeight,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text("${product.price.toString()}\$"),
            Container(
              child: Text(
                product.name,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: product.images
                    .map(
                      (i) => Image.network(
                        i,
                        height: 100,
                        width: 100,
                        fit: BoxFit.fitHeight,
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(
              height: 12,
            ),
            Text(
              'See All',
              style: TextStyle(color: GlobalVariables.selectedNavBarColor),
            )
          ],
        ),
      ),
    );
  }
}
