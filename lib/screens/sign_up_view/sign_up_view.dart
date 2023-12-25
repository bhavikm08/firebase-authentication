import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauthentication/Common/load_status/load_status.dart';
import 'package:firebaseauthentication/custom_widget/custom_widgets.dart';
import 'package:firebaseauthentication/screens/login_view/login_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:tuple/tuple.dart';

import '../login_view/sign_in_with_contact/sign_in_with_contact.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  bool isSecure = true;


  Future<void> signUpWithEmailAndPassword() async {
    if (formKey.currentState!.validate()) {
      final firebaseAuth = FirebaseAuth.instance;
      EasyLoading.show(status: LoadStatus.loading.toString());
      final email = emailController.text.toLowerCase();
      final password = passwordController.text.trim();
      try {
        await firebaseAuth.createUserWithEmailAndPassword(
            email: email, password: password);
        final User? user = firebaseAuth.currentUser;
        print('FIREBASE_AUTH_CURRENT_USER::::::::::>>>>>> $user');
        print('FIREBASE_AUTH_CURRENT_USER::::::::::>>>>>> ${user!.uid}');
      } on FirebaseException catch (e) {
        print('Sign_Up_Firebase_Exception $e');
      } finally {
        EasyLoading.dismiss();
      }
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: CustomWidget.commonText(commonText: "Sign Up"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
            key: formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: CustomWidget.commonTextFormField(
                    context: context,
                    textFieldController: emailController,
                    prefixIcon: const Icon(CupertinoIcons.person,
                        color: Colors.blue),
                    validationRules: [
                      const Tuple2('^', ''),
                      const Tuple2('[a-z0-9]+', 'email must be in small'),
                      const Tuple2('@', 'Matches the "@" symbol.'),
                      const Tuple2('@[a-z]{4}', 'Specify sub-domain after (@) like (gmail).'),
                      const Tuple2('\\.', 'Matches the dot (.) character in the domain.'),
                      const Tuple2('\\.[a-z]{2,}.', 'Specify domain name after (.) like (.com).'),
                      const Tuple2('\$', ''),
                    ],
                    hintText: 'email',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: CustomWidget.commonTextFormField(
                      context: context,
                      hintText: "password",
                      obscureText: isSecure,
                      validationRules: [
                        const Tuple2('^(?=.*[A-Z])',
                            'Password must be contain uppercase letters'),
                        const Tuple2('(?=.*[a-z])',
                            'Password must be contain lowercase letters'),
                        const Tuple2('(?=.*[@#\$%^&+=!])',
                            'Password must be contain least one special character'),
                        const Tuple2(
                            '(?=.{8,})', 'Password must be 8 length'),
                      ],
                      prefixIcon: const Icon(
                        CupertinoIcons.lock,
                        color: Colors.blue,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isSecure = !isSecure;
                          });
                          print('isSecure:--> $isSecure');
                        },
                        child: Icon(
                            color: Colors.blue,
                            isSecure
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye),
                      ),
                      textFieldController: passwordController),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: CustomWidget.commonTextFormField(
                      context: context,
                      hintText: "confirm password",
                      obscureText: isSecure,
                      prefixIcon: const Icon(
                        CupertinoIcons.lock,
                        color: Colors.blue,
                      ),
                      suffixIcon: InkWell(
                        onTap: () {
                          setState(() {
                            isSecure = !isSecure;
                          });
                          print('isSecure:--> $isSecure');
                        },
                        child: Icon(
                            color: Colors.blue,
                            isSecure
                                ? CupertinoIcons.eye_slash
                                : CupertinoIcons.eye),
                      ),
                      comparisonController: passwordController,
                      textFieldController: confirmPasswordController),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: CustomWidget.commonElevatedButton(
                      context: context,
                      buttonText: 'Sign Up',
                      onTap: () {
                        signUpWithEmailAndPassword();
                      }),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Row(
                    children: [
                      const Expanded(child: Divider(
                        color: Colors.black,
                        endIndent: 10,
                        indent: 20,
                      )),
                      CustomWidget.commonText(commonText: 'Or'),
                      const Expanded(child: Divider(
                        color: Colors.black,
                        endIndent: 20,
                        indent: 10,
                      ))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    RichText(
                        softWrap: true,
                        textDirection: TextDirection.rtl,
                        textAlign: TextAlign.end,
                        text: TextSpan(
                            text: 'Sign In with? ',
                            style: const TextStyle(
                                fontSize: 17, color: Colors.black),
                            children: [
                              TextSpan(
                                  text: 'Number',
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.of(context)
                                          .pushReplacement(MaterialPageRoute(
                                        builder: (context) =>
                                        const SignInWithContact(),
                                      ));
                                    },
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 17,
                                      color: Colors.purple))
                            ])),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RichText(
                          softWrap: true,
                          textDirection: TextDirection.rtl,
                          textAlign: TextAlign.end,
                          // overflow: TextOverflow.clip,
                          // maxLines: 1,
                          text: TextSpan(
                              text: 'have an account? ',
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              children: [
                                TextSpan(
                                    text: 'Login',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) => const LoginView(),
                                        ));
                                      },
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 17,
                                        color: Colors.purple))
                              ])),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
