import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Common/constants/string_constant.dart';
import '../home_view/home.dart';

class LoginProvider extends ChangeNotifier{

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isSecure = true;

  Future<void> checkEmailAndPassword({required BuildContext context}) async {
    final instance = FirebaseAuth.instance;
    if (formKey.currentState!.validate()) {
      EasyLoading.show(status: 'Login User');
      try {
        await instance.signInWithEmailAndPassword(
            email: emailController.text.toLowerCase(),
            password: passwordController.text.trim());
        final User? user = instance.currentUser;
        print('FIREBASE_AUTH_CURRENT_USER::::::::::>>>>>> $user');
        print('FIREBASE_AUTH_CURRENT_USER::::::::::>>>>>> ${user!.uid}');
        if (user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          prefs.setBool(StringConstant.isLogin, true);
          EasyLoading.showToast('Login Successfully',
              maskType: EasyLoadingMaskType.clear,
              dismissOnTap: true,
              duration: const Duration(seconds: 5),
              toastPosition: EasyLoadingToastPosition.bottom);
          print('trueeee');
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => const Home(),
          ));
        }
      } on FirebaseAuthException catch (e) {
        print("Login Firebase Exception $e");
        EasyLoading.showToast('$e',
            maskType: EasyLoadingMaskType.clear,
            dismissOnTap: true,
            duration: const Duration(seconds: 5),
            toastPosition: EasyLoadingToastPosition.top);
      } finally {
        EasyLoading.dismiss();
      }
    }
  }
  Future<void> signInWithFacebook({required BuildContext context}) async {
    print('out try Part ');
    try {
      final loginResult = await FacebookAuth.instance.login(permissions: ['email']);
      if (loginResult.status == LoginStatus.success) {
        final userData = await FacebookAuth.instance.getUserData();
        print("User Data: $userData");
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setBool(StringConstant.isLogin, true);
        final oAuthCredential =
        FacebookAuthProvider.credential(loginResult.accessToken!.token);
        final authResult = await FirebaseAuth.instance.signInWithCredential(oAuthCredential);
        EasyLoading.showToast("Success Facebook Login.",
            toastPosition: EasyLoadingToastPosition.top);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
        print('try Part ');
        print('Auth Results ::: > $authResult');
        notifyListeners();
      } else {
        EasyLoading.showToast("${loginResult.message}",
            toastPosition: EasyLoadingToastPosition.top);
        print("Login Error Message ${loginResult.message}");
      }
    } catch (e) {
      EasyLoading.showToast("$e", toastPosition: EasyLoadingToastPosition.top);
      print("Error during Facebook login: $e");
    }
  }
  Future<void> signInWithGoogle1({required BuildContext context}) async {
    EasyLoading.show(status: 'Signing in...'); // Show loading indicator
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser != null) {
      try {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(StringConstant.isLogin, true);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));
        print("GoogleUser :: > $googleUser");
        print("credential :: > ${credential.signInMethod}");
        print("AccessToken :: > ${googleSignInAuthentication.accessToken}");
        print("idToken :: > ${googleSignInAuthentication.idToken}");
        notifyListeners();
        EasyLoading.dismiss();
        await FirebaseAuth.instance.signInWithCredential(credential);
      } catch (e) {
        EasyLoading.dismiss();
        print("Error during sign-in: $e");
      }
    } else {
      EasyLoading.dismiss();
      throw "Google sign-in failed";
    }
  }
  Future<void> signInWithGoogle({required BuildContext context}) async {
    EasyLoading.show(status: 'Signing in...');

    final GoogleSignIn googleSignIn = GoogleSignIn(
        scopes: ['email', 'profile', 'openid'],
        forceCodeForRefreshToken: true,
      signInOption: SignInOption.standard
    );

    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken, // Ensure ID token is retrieved
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setBool(StringConstant.isLogin, true);

        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => const Home(),
        ));

        print("GoogleUser :: > $googleUser");
        print("credential :: > ${credential.signInMethod}");
        print("AccessToken :: > ${googleSignInAuthentication.accessToken}");
        print("idToken :: > ${googleSignInAuthentication.idToken}");

        await FirebaseAuth.instance.signInWithCredential(credential);
      } else {
        throw "Google sign-in failed";
      }
    } catch (e) {
      EasyLoading.dismiss();
      print("Error during sign-in: $e");
    } finally {
      EasyLoading.dismiss(); // Ensure loading indicator is dismissed
    }
  }

  Future<void>signInFB()async{
    final FacebookLogin fb = FacebookLogin();

    // Log in the user with their Facebook account.
    final FacebookLoginResult result = await fb.logIn();

    if (result.status == FacebookLoginStatus.success) {
      // The user is logged in successfully.
      final FacebookAccessToken? accessToken = result.accessToken;

      // Get the user's profile information.
      final FacebookUserProfile? profile = await fb.getUserProfile();

      // Print the user's name.
      print("Profile NAME :: ${profile?.name}");
    } else {
      // The login failed.
      print('Login failed: ${result.error}');
    }
  }
  Future<void> loginWithFacebook() async {
    // Create a new FacebookAuth instance.
    final FacebookAuth facebookAuth = FacebookAuth.i;

    // Login the user to Facebook.
    final LoginResult loginResult = await facebookAuth.login();

    // Check if the login was successful.
    if (loginResult.status == LoginStatus.success) {
      // The user has logged in successfully.
      // Access the user's Facebook profile information.
      final AccessToken? accessToken = loginResult.accessToken;
      final  facebookUser = await facebookAuth.getUserData();
      print("Fab USer $facebookUser");
    } else {
      // An error occurred while logging in.
    }
  }
}