import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/account/screens/account_screen.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/cart/screens/cart_home.dart';
import 'package:amazon/features/home/screens/home.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:provider/provider.dart';

class BottomNavBar extends StatefulWidget {
  static const routeName = 'bottom-nav';
  const BottomNavBar({super.key});

  @override
  State<BottomNavBar> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int currIndex = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> pages = [
    Home(),
    AccountScreen(),
    CartHome(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartLen = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body: pages[currIndex],
      bottomNavigationBar: BottomNavigationBar(
          onTap: (int index) {
            setState(() {
              currIndex = index;
            });
          },
          currentIndex: currIndex,
          items: [
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: currIndex == 0
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.home_outlined,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                width: bottomBarWidth,
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(
                      color: currIndex == 1
                          ? GlobalVariables.selectedNavBarColor
                          : GlobalVariables.backgroundColor,
                      width: bottomBarBorderWidth,
                    ),
                  ),
                ),
                child: const Icon(
                  Icons.person_outline_outlined,
                ),
              ),
              label: '',
            ),
            BottomNavigationBarItem(
              icon: Container(
                  width: bottomBarWidth,
                  decoration: BoxDecoration(
                    border: Border(
                      top: BorderSide(
                        color: currIndex == 2
                            ? GlobalVariables.selectedNavBarColor
                            : GlobalVariables.backgroundColor,
                        width: bottomBarBorderWidth,
                      ),
                    ),
                  ),
                  child: badges.Badge(
                    badgeContent: Text(cartLen.toString()),
                    badgeStyle: badges.BadgeStyle(badgeColor: Colors.white),
                    child: Icon(Icons.shopping_cart_outlined),
                  )),
              label: '',
            ),
          ]),
    );
  }
}
