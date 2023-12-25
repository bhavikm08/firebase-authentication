import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaseauthentication/custom_widget/custom_widgets.dart';
import 'package:firebaseauthentication/screens/login_view/login_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Common/constants/string_constant.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<void> signOut() async {
    final instance = FirebaseAuth.instance;
    EasyLoading.show(status: "Sign Out");
    try {
      await instance.signOut().then((_) async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(StringConstant.isLogin, false);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const LoginView(),
        ));
      });
    } on FirebaseException catch (e) {
      print("Sign Out Firebase Exception $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: CustomWidget.commonText(commonText: "Welcome To Home"),
      ),
      body: Center(
          child: Container(
            width: double.infinity,
            margin: const EdgeInsets.only(left: 20,right: 20),
            child: CustomWidget.commonElevatedButton(
                context: context,
                buttonText: 'LogOut',
                onTap: () {
                  signOut();
                }),
          )),
    );
  }
}
