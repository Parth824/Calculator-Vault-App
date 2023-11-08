import 'package:calculator_vault_app/colors.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/models/gallery_model.dart';
import 'package:calculator_vault_app/src/models/restor_model.dart';
import 'package:calculator_vault_app/src/views/screens/splash_page1.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'src/helpers/AppOpenAdManager.dart';

late SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  MobileAds.instance.initialize();
  prefs = await SharedPreferences.getInstance();
  Hive.registerAdapter(GalleryAdapter());
  Hive.registerAdapter(RestorAdapter());
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDWTQaSnfQb1ROimGrGzWN5_dCR9mGMqoo",
      appId: "1:136800098805:android:1f887e7d0952cce83e28bc",
      messagingSenderId: "136800098805",
      projectId: "calculator-app-357b0",
    ),
  );

  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]).then((v) {
    runApp(const MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder<Box<String>>(
        future: Hive.openBox('appPassword'),
        builder: (context, boxSnapshot) {
          if (boxSnapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              backgroundColor: firstColor,
              body: Center(
                  child: CircularProgressIndicator(
                color: fourthColor,
              )),
            );
          } else if (boxSnapshot.hasData && boxSnapshot.data != null) {
            return ValueListenableBuilder<Box<String>>(
              valueListenable: boxSnapshot.data!.listenable(),
              builder: (context, box, _) {
                final String password = box.get('password') ?? '';
                AppOpenAdManager.pass = password;
                if (password.isNotEmpty) {
                  return SplashScreen(pass: password);
                } else {
                  return SplashScreen(pass: password);
                }
              },
            );
          } else {
            return const SplashScreen(pass: '');
          }
        },
      ),
    );
  }
}
