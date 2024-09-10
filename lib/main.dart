import 'dart:developer';

import 'package:amazon/app.dart';
import 'package:amazon/constants/gloabal_variable.dart';
import 'package:amazon/features/auth/model/user_model.dart';
import 'package:amazon/features/auth/repo/auth_repo.dart';
import 'package:amazon/features/auth/screens/auth_screen.dart';
import 'package:amazon/features/home/screens/home.dart';
import 'package:amazon/features/product%20details/product_services/product_services.dart';
import 'package:amazon/features/providers/user.dart';
import 'package:amazon/router.dart';
import 'package:amazon/shared/widgets/bottomnav.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(
      create: (context) => UserProvider(),
    ),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final ProductServices productServices = ProductServices();
  final AuthRepo authRepo = AuthRepo();
  @override
  void initState() {
    super.initState();
    authRepo.getUserData(context);
    productServices.fetchUserData(context);
  }

  @override
  Widget build(BuildContext context) {
    //log(Provider.of<UserProvider>(context).user.token);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Amazon Clone',
      theme: ThemeData(
        scaffoldBackgroundColor: GlobalVariables.backgroundColor,
        colorScheme: const ColorScheme.light(
          primary: GlobalVariables.secondaryColor,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        useMaterial3: true, // can remove this line
      ),
      onGenerateRoute: (settings) => generateRoute(settings),
      home: Decider(),
    );
  }
}
