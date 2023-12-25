import 'dart:async';

import 'package:firebaseauthentication/Common/constants/string_constant.dart';
import 'package:firebaseauthentication/screens/login_view/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home_view/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    whereToGO();
    super.initState();
  }


  void whereToGO() async {
    var sharedPrf = await SharedPreferences.getInstance();
    var isLoggedIn = sharedPrf.getBool(StringConstant.isLogin);
    print('isLoggedIn:----------> $isLoggedIn');
    Timer(const Duration(seconds: 3), () {
      if (isLoggedIn != null) {
        if (isLoggedIn) {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Home(),
          ));
        } else {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const LoginView(),
          ));
        }
      } else {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginView(),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: CupertinoColors.activeBlue,
      body: Center(
        child: Text("Firebase Authentication ",
            style: TextStyle(
              fontSize: 30,
            )),
      ),
    );
  }
}
