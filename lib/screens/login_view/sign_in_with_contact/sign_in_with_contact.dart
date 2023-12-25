import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauthentication/custom_widget/custom_widgets.dart';
import 'package:firebaseauthentication/screens/home_view/home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Common/constants/string_constant.dart';

class SignInWithContact extends StatefulWidget {
  const SignInWithContact({super.key});

  @override
  State<SignInWithContact> createState() => _SignInWithContactState();
}

class _SignInWithContactState extends State<SignInWithContact> {
  TextEditingController numberController = TextEditingController();
  TextEditingController smsCode = TextEditingController();
  String phoneCode = "";
  String verificationId = '';

  // Future<void> signInWithNumber() async {
  //   FirebaseAuth auth = FirebaseAuth.instance;
  //   EasyLoading.show();
  //   try {
  //     await auth.verifyPhoneNumber(
  //       phoneNumber: "$phoneCode ${numberController.text.trim()}",
  //       verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
  //         print("VERIFICATION COMPLETE :::>>>");
  //       },
  //       verificationFailed: (FirebaseAuthException e) {
  //         if (e.code == 'invalid-phone-number') {
  //           print('The provided phone number is not valid.');
  //           EasyLoading.showToast('The provided phone number is not valid.',
  //               maskType: EasyLoadingMaskType.clear,
  //               dismissOnTap: true,
  //               duration: const Duration(seconds: 5),
  //               toastPosition: EasyLoadingToastPosition.top);
  //         }
  //       },
  //       timeout: const Duration(seconds: 60),
  //       codeSent: (String verificationId, int? forceResendingToken) {
  //         setState(() {
  //           this.verificationId = verificationId;
  //         });
  //         print("Verification Id ${this.verificationId}");
  //       },
  //       codeAutoRetrievalTimeout: (String verificationId) {},
  //     );
  //     EasyLoading.dismiss();
  //   } on FirebaseException catch (e) {
  //     EasyLoading.dismiss();
  //     EasyLoading.showToast("$e",
  //         duration: const Duration(seconds: 5),
  //         toastPosition: EasyLoadingToastPosition.top);
  //     print("Firebase Exception In Generating OTP $e");
  //   }
  // }
  Future<void> signInWithNumber() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    EasyLoading.show();
    try {
      await auth.verifyPhoneNumber(
        phoneNumber: "$phoneCode ${numberController.text.trim()}",
        verificationCompleted: (PhoneAuthCredential phoneAuthCredential) {
          print("VERIFICATION COMPLETE :::>>>");
          EasyLoading.dismiss(); // Dismiss the loading indicator upon verification completion
          // Perform any additional tasks after successful verification if needed
        },
        verificationFailed: (FirebaseAuthException e) {
          EasyLoading.dismiss(); // Dismiss the loading indicator on verification failure
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
            EasyLoading.showToast(
              'The provided phone number is not valid.',
              maskType: EasyLoadingMaskType.clear,
              dismissOnTap: true,
              duration: const Duration(seconds: 5),
              toastPosition: EasyLoadingToastPosition.top,
            );
          }
        },
        timeout: const Duration(seconds: 60),
        codeSent: (String verificationId, int? forceResendingToken) {
          setState(() {
            this.verificationId = verificationId;
          });
          print("Verification Id ${this.verificationId}");
          // Perform actions after code is sent if needed
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Handle auto-retrieval timeout if needed
        },
      );
    } on FirebaseException catch (e) {
      EasyLoading.dismiss(); // Dismiss the loading indicator on Firebase exception
      EasyLoading.showToast(
        "$e",
        duration: const Duration(seconds: 5),
        toastPosition: EasyLoadingToastPosition.top,
      );
      print("Firebase Exception In Generating OTP $e");
    }
  }

  Future<void> verifyCode() async {
    EasyLoading.show(status: "Verifying..");
    try {
      PhoneAuthCredential phoneAuthCredential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: smsCode.text.trim(),
      );
      await FirebaseAuth.instance
          .signInWithCredential(phoneAuthCredential)
          .then((_) {
        EasyLoading.showToast(
          "SignIn With Number SuccessFull",
          toastPosition: EasyLoadingToastPosition.top,
          duration: const Duration(seconds: 5),
        );
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool(StringConstant.isLogin, true);
      print("Is Login ${StringConstant.isLogin}");
    } on FirebaseException catch (e) {
      EasyLoading.showToast(
        "$e",
        toastPosition: EasyLoadingToastPosition.top,
        duration: const Duration(seconds: 5),
      );
      print("Verify Code Firebase Exception $e");
    } finally {
      EasyLoading.dismiss();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomWidget.commonText(commonText: "Sign In With Contact"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30, left: 20, right: 20),
            child: IntlPhoneField(
              // focusNode: controller.mobileNumberNode,
              controller: numberController,
              decoration: InputDecoration(
                hintStyle: const TextStyle(color: Colors.black),
                enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                // fillColor: Colors.white,
                // filled: true,
                hintText: 'Enter Mobile Number',
                border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
              ),
              flagsButtonMargin: EdgeInsets.only(left: 2),
              showCountryFlag: false,
              onCountryChanged: (phone) {
                setState(() {
                  String countryCodeWithPlus = '+${phone.dialCode}';
                  phoneCode = countryCodeWithPlus;
                });
                print('countryCode: $phoneCode');
              },
              onChanged: (phone) {
                setState(() {
                  String countryCodeWithPlus = phone.countryCode;
                  phoneCode = countryCodeWithPlus;
                });
                print('countryCode: $phoneCode');
              },
              autovalidateMode: AutovalidateMode.onUserInteraction,
              // onSubmitted: (value) {
              //   FocusScope.of(context)
              //       .requestFocus(controller.passwordNode);
              // },
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 30),
          //   child: CustomWidget.commonTextFormField(
          //     context: context,
          //     textFieldController: numberController,
          //     keyboardType: TextInputType.number,
          //     hintText: "number",
          //     lengthMessage: "Number Length Must be 10.",
          //     // maxLength: 10,
          //     length: 10,
          //   ),
          // ),
          Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              width: double.infinity,
              child: CustomWidget.commonElevatedButton(
                  context: context,
                  buttonText: 'Get Otp',
                  onTap: () {
                    signInWithNumber();
                  })),
          verificationId != ""
              ? CustomWidget.commonText(commonText: "Enter OTP")
              : SizedBox(),
          verificationId != ""
              ? Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: CustomWidget.commonTextFormField(
                    context: context,
                    textFieldController: smsCode,
                    keyboardType: TextInputType.number,
                    length: 6,
                    maxLength: 6,
                  ),
                )
              : SizedBox(),
          verificationId != ""
              ? Container(
                  width: double.infinity,
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                  child: CustomWidget.commonElevatedButton(
                      context: context,
                      buttonText: "Submit Otp",
                      onTap: () {
                        verifyCode();
                      }),
                )
              : SizedBox()
        ],
      ),
    );
  }
}
