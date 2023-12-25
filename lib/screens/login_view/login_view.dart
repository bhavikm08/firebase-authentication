import 'package:firebaseauthentication/custom_widget/custom_widgets.dart';
import 'package:firebaseauthentication/screens/login_view/login_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

import '../sign_up_view/sign_up_view.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LoginProvider>(builder: (context, provider, child) {
      return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: CustomWidget.commonText(commonText: "Login"),
          centerTitle: true,
        ),
        body: Form(
            key: provider.formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: CustomWidget.commonTextFormField(
                      context: context,
                      textFieldController: provider.emailController,
                      prefixIcon:
                      const Icon(CupertinoIcons.person, color: Colors.blue),
                      validationRules: [
                        const Tuple2('^', ''),
                        const Tuple2('[a-z0-9]+', 'email must be in small'),
                        const Tuple2('@', 'Matches the "@" symbol.'),
                        const Tuple2('@[a-z]{4}',
                            'Specify sub-domain after (@) like (gmail).'),
                        const Tuple2('\\.',
                            'Matches the dot (.) character in the domain.'),
                        const Tuple2('\\.[a-z]{2,}.',
                            'Specify domain name after (.) like (.com).'),
                        const Tuple2('\$', ''),
                      ],
                      hintText: "email"),
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomWidget.commonTextFormField(
                    context: context,
                    textFieldController: provider.passwordController,
                    obscureText: provider.isSecure,
                    prefixIcon: const Icon(
                      CupertinoIcons.lock,
                      color: Colors.blue,
                    ),
                    suffixIcon: InkWell(
                      onTap: () {
                        setState(() {
                          provider.isSecure = !provider.isSecure;
                        });
                        print('isSecure:--> ${provider.isSecure}');
                      },
                      child: Icon(
                          color: Colors.blue,
                          provider.isSecure
                              ? CupertinoIcons.eye_slash
                              : CupertinoIcons.eye),
                    ),
                    validationRules: [
                      const Tuple2('^(?=.*[A-Z])',
                          'Password must be contain uppercase letters'),
                      const Tuple2('(?=.*[a-z])',
                          'Password must be contain lowercase letters'),
                      const Tuple2('(?=.*[@#\$%^&+=!])',
                          'Password must be contain least one special character'),
                      const Tuple2('(?=.{8,})', 'Password must be 8 length'),
                    ],
                    textInputAction: TextInputAction.done,
                    hintText: "password"),
                Padding(
                  padding: const EdgeInsets.only(top: 50, left: 20, right: 20),
                  child: CustomWidget.commonElevatedButton(
                      context: context,
                      buttonText: "Login",
                      onTap: () {
                        provider.checkEmailAndPassword(context: context);
                      }),
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
                          text: TextSpan(
                              text: 'Don\'t have an account? ',
                              style: const TextStyle(
                                  fontSize: 17, color: Colors.black),
                              children: [
                                TextSpan(
                                    text: 'Sign Up',
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.of(context)
                                            .pushReplacement(MaterialPageRoute(
                                          builder: (context) =>
                                          const SignUpView(),
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
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: CustomWidget.commonElevatedButton(
                      context: context,
                      buttonText: 'Sign In With FaceBook',
                      onTap: () async {
                        provider.signInWithFacebook(context: context);
                        // provider.signInFB();
                        // provider.loginWithFacebook();
                        print("FaceBook");
                        // try {
                        //   final result =
                        //   await FacebookAuth.i.login(permissions: ['public_profile', 'email']);
                        //   if (result.status == LoginStatus.success) {
                        //     final userData = await FacebookAuth.i.getUserData();
                        //     print("User Data $userData");
                        //   }
                        // } catch (error) {
                        //   print(error);
                        // }
                      }),
                ),
                Container(
                  margin: EdgeInsets.only(top: 30, left: 20, right: 20),
                  child: CustomWidget.commonElevatedButton(
                      context: context,
                      buttonText: 'Sign In With Google',
                      onTap: () async {
                          provider.signInWithGoogle(context: context);
                      }),

                ),
              ],
            )),
      );
    },);
  }
}

