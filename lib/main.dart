import 'package:firebase_core/firebase_core.dart';
import 'package:firebaseauthentication/screens/login_view/login_provider.dart';
import 'package:firebaseauthentication/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyByqoPL50mNJ1ev3z2cdpVlsrnCVxbH888",
          appId: "1:687977066398:android:dd1472f4d9a01bc534b08f",
          messagingSenderId: "687977066398",
          projectId: "fir-authentication-4ba29",
      ));
  await FacebookAuth.i.webAndDesktopInitialize(
    appId: '249018721512636',
    cookie: true,
    xfbml: true,
    version: 'v14.0',
  );
  configLoading();
  runApp(const MyApp());
}
void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.chasingDots
    ..loadingStyle = EasyLoadingStyle.custom
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.blueAccent
    ..backgroundColor = Colors.blueAccent
    ..indicatorColor = Colors.white
    ..textColor = Colors.white
    ..maskColor = Colors.deepOrange.withOpacity(0.5)
    ..userInteractions = false
    ..dismissOnTap = true;
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return  MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginProvider>(create: (context) => LoginProvider(),),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        builder: EasyLoading.init(),
        home: const SplashScreen(),
      ),
    );
  }
}
