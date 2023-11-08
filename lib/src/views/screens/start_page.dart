import 'package:calculator_vault_app/colors.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/helpers/AppLifecycleReactor%20.dart';
import 'package:calculator_vault_app/src/helpers/AppOpenAdManager.dart';
import 'package:calculator_vault_app/src/views/screens/password_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    firstColor,
                    secondColor,
                    thirdColor,
                  ],
                ),
              ),
            ),
            Column(
              children: [
                SizedBox(height: SizeConfig.screenHeight * 0.1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome",
                      style: TextStyle(
                          fontSize: getProportionateScreenHeight(70),
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: "Gilroy"),
                    ),
                  ],
                ),
                SizedBox(height: getProportionateScreenHeight(08),),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hide all your photos in a secret calculator!",
                      style: TextStyle(
                        color: Colors.white70,
                        fontFamily: "Gilroy",
                        fontSize: getProportionateScreenHeight(16),
                      ),
                    ),
                  ],
                ),
                Spacer(),
                startButton(context),
                SizedBox(height: getProportionateScreenHeight(15),),
                Padding(
                  padding: EdgeInsets.all(getProportionateScreenHeight(08)),
                  child: privacyPolicyText(),
                ),
              ],
            ),
          ],
        ),
    );
  }

  ElevatedButton startButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () => Get.off(
        () => PasswordPage(),
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 500),
        transition: Transition.fadeIn,
      ),
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: secondColor,
        fixedSize: Size(MediaQuery.of(context).size.width - 64, 48),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            getProportionateScreenHeight(10),
          ),
        ),
        elevation: 2,
      ),
      child: Text(
        'Create Password',
        style: TextStyle(
          fontFamily: "Gilroy",
          fontSize: getProportionateScreenHeight(16),
        ),
      ),
    );
  }

  Text privacyPolicyText() {
    return Text.rich(
      TextSpan(
        text: "By continuing, you agree to our ",
        style: TextStyle(color: Colors.white, fontFamily: "Gilroy"),
        children: [
          TextSpan(
            text: "Privacy Policy",
            style: TextStyle(
              color: firstColor,
              fontWeight: FontWeight.bold,
              fontFamily: "Gilroy",
            ),
            // recognizer:
          ),
          TextSpan(text: " and \n"),
          TextSpan(
            text: "Terms of Service",
            style: TextStyle(
              color: firstColor,
              fontWeight: FontWeight.bold,
              fontFamily: "Gilroy",
            ),
          ),
        ],
      ),
      style: TextStyle(
        fontSize: getProportionateScreenHeight(12),
      ),
      textAlign: TextAlign.center,
    );
  }
}
