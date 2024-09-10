import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/features/account/screens/account_screen.dart';
import 'package:amazon/features/admin/screens/order.dart';
import 'package:amazon/features/admin/screens/post_screen.dart';
import 'package:amazon/features/home/screens/home.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int currIndex = 0;
  double bottomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  List<Widget> pages = [
    PostScreen(),
    AdminOrderDetails(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: AppBar(
            flexibleSpace: Container(
              decoration:
                  const BoxDecoration(gradient: GlobalVariables.appBarGradient),
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
                const Text(
                  "Admin",
                  style: TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          )),
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
                  Icons.post_add,
                ),
              ),
              label: '',
            ),
          ]),
      body: pages[currIndex],
    );
  }
}
