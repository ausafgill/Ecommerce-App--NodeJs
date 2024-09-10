import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/account/account_services/account_repo.dart';
import 'package:amazon/features/account/models/order_model.dart';
import 'package:amazon/features/admin/admin%20services/admin_repo.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/order%20details/screens/order_details.dart';
import 'package:flutter/material.dart';

class AccountScreen extends StatefulWidget {
  AccountScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  UserModel? _user;
  bool isLoading = true;
  final AccountRepo accountRepo = AccountRepo();
  List<Order>? orders;

  void fetchAllOrders() async {
    List<Order>? o = await accountRepo.fetchAllOrders();
    setState(() {
      orders = o;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUser();
    fetchAllOrders();
  }

  Future<void> _loadUser() async {
    final user = await SharedPreferencesManager.getUser();
    setState(() {
      _user = user;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
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
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        child: Image.asset(
                          'assets/amazon_in.png',
                          // color: Colors.black,
                          height: 50,
                          width: 50,
                        ),
                      ),
                      const Row(
                        children: [
                          Icon(
                            Icons.notifications,
                            color: Colors.black,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Icon(
                            Icons.search,
                            color: Colors.black,
                          )
                        ],
                      )
                    ],
                  ),
                )),
            body: isLoading == true
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                            gradient: GlobalVariables.appBarGradient),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 8),
                              child: Text(
                                'Hello, ${_user!.name}',
                                style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TopButtons(
                            name: 'Your Orders',
                          ),
                          TopButtons(name: 'Turn Seller'),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          TopButtons(
                            name: 'Logout',
                          ),
                          TopButtons(name: 'Your WishList'),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Your Orders",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 20),
                            ),
                            TextButton(
                                onPressed: () {},
                                child: Text(
                                  "See All",
                                  style: TextStyle(
                                      color:
                                          GlobalVariables.selectedNavBarColor),
                                ))
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 170,
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: orders!.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, OrderDetails.routeName,
                                      arguments: orders![index]);
                                },
                                child: Container(
                                  height: 160,
                                  width: 160,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                          color: GlobalVariables
                                              .greyBackgroundCOlor)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.network(
                                      orders![index].products[0].images[0],
                                      height: 150,
                                      width: 150,
                                    ),
                                  ),
                                ),
                              );
                            }),
                      )
                    ],
                  ),
          );
  }
}

class TopButtons extends StatelessWidget {
  final String name;
  const TopButtons({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AdminRepo().logout(context);
      },
      child: Container(
        width: 200,
        decoration: BoxDecoration(
            color: GlobalVariables.greyBackgroundCOlor,
            borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 35),
          child: Center(
            child: Text(
              name,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ),
      ),
    );
  }
}
