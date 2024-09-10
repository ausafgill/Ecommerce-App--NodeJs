import 'dart:async';

import 'package:amazon/constants/shared_pref_manager.dart';
import 'package:amazon/features/admin/screens/admin_screen.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/auth/repo/auth_repo.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/features/home/screens/home.dart';
import 'package:amazon/features/product%20details/product_services/product_services.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:amazon/shared/widgets/bottomnav.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Decider extends StatefulWidget {
  static StreamController<String> authStream = StreamController.broadcast();
  static const routeName = '/decider-screen';
  const Decider({super.key});

  @override
  State<Decider> createState() => _DeciderState();
}

class _DeciderState extends State<Decider> {
  final ProductServices productServices = ProductServices();
  @override
  final AuthRepo auth = AuthRepo();
  UserModel? _user;
  bool isLoading = true;

  void initState() {
    super.initState();
    gettokenId();

    //auth.getUserData(context);
    _loadUser();
    // Provider.of<UserProvider>(context).user;
  }

  Future<void> _loadUser() async {
    final user = await SharedPreferencesManager.getUser();
    setState(() {
      _user = user;
      isLoading = false;
      // productServices.fetchUserData(user!.id.toString(), context);
    });
  }

  gettokenId() async {
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = await SharedPreferencesManager.getTokenId();
    if (token.isEmpty) {
      Decider.authStream.add("");
    } else {
      Decider.authStream.add(token);
    }
  }

  @override
  Widget build(BuildContext context) {
    // return isLoading
    //     ? Scaffold(
    //         body: Center(
    //           child:
    //               CircularProgressIndicator(), // Show a loading indicator while fetching data
    //         ),
    //       )
    //     :

    return StreamBuilder(
        stream: Decider.authStream.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return AuthScreen();
          } else if (_user == null || isLoading == true) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (_user!.type == 'user') {
              return BottomNavBar();
            } else {
              return AdminScreen();
            }
          }
        });
  }
}
