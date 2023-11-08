import 'package:calculator_vault_app/colors.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/helpers/AppOpenAdManager.dart';
import 'package:calculator_vault_app/src/views/screens/home_page.dart';
import 'package:calculator_vault_app/src/views/screens/splashpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  final String pass;
  const SplashScreen({super.key, required this.pass});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with WidgetsBindingObserver {
  AppOpenAdManager appOpenAdManager = AppOpenAdManager();

  bool isPaused = false;

  @override
  void initState() {
    super.initState();
    //Load AppOpen Ad
    appOpenAdManager.loadAd();
    WidgetsBinding.instance.addObserver(this);
    Future.delayed(Duration(milliseconds: 7000), () {
      appOpenAdManager.showAdIfAvailableForSplash();
      getdata();
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // TODO: implement didChangeAppLifecycleState
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.paused) {
      isPaused = true;
    }
    if (state == AppLifecycleState.resumed && isPaused) {
      print("Resumed==========================");
      appOpenAdManager.showAdIfAvailableForSplash();
      isPaused = false;
    }
  }

  getdata() {
    // Future.delayed(
    //   Duration(milliseconds: 7000),
    //   () {
        SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        if (widget.pass.isNotEmpty) {
          Get.off(() => HomePage(appPassword: widget.pass));
        } else {
          Get.off(() => SplashPage());
        }
    //   },
    // );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: firstColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.3,
            ),

            Image.asset(
              "assets/images/icon.png",
              height: SizeConfig.screenHeight * 0.12,
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.24,
            ),
            // LoadingAnimationWidget.hexagonDots(
            //   color: fourthColor,
            //   size: getProportionateScreenHeight(45),
            // )
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
