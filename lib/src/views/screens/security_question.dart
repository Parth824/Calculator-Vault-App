import 'package:calculator_vault_app/main.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/helpers/AppLifecycleReactor%20.dart';
import 'package:calculator_vault_app/src/helpers/AppOpenAdManager.dart';
import 'package:calculator_vault_app/src/views/screens/home_page.dart';
import 'package:calculator_vault_app/src/views/screens/options_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../colors.dart';

TextEditingController securityController = TextEditingController();
String security = "";
GlobalKey<FormState> formKey = GlobalKey<FormState>();

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  NativeAd? nativeAd;
  bool isNativeAdLoaded = false;

  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadNativeAd();
  }

  void loadNativeAd() {
    nativeAd = NativeAd(
      adUnitId: "ca-app-pub-3940256099942544/2247696110",
      factoryId: "listTile",
      listener: NativeAdListener(onAdLoaded: (ad) {
        print("Parth----------------------");
        setState(() {
          isNativeAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        // loadNativeAd2();
        print("Parth1----------------------");
        nativeAd!.dispose();
      }),
      request: const AdRequest(),
    );
    nativeAd!.load();
  }

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
      backgroundColor: firstColor,
      appBar: AppBar(
        backgroundColor: secondColor,
        centerTitle: true,
        leading: Container(),
        // actions: [
        //   IconButton(
        //     onPressed: () => Get.offAll(
        //           () => OptionPage(),
        //       curve: Curves.easeInOut,
        //       transition: Transition.fade,
        //       duration: Duration(milliseconds: 500),
        //     ),
        //     icon: const Icon(Icons.settings),
        //   ),
        // ],
        title: Text(
          "Security Question",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
      ),
      body: Center(
        child: Form(
          key: formKey,
          child: Column(
            children: [
              SizedBox(
                height: SizeConfig.screenHeight * 0.1,
              ),
              Container(
                height: SizeConfig.screenHeight * 0.058,
                width: SizeConfig.screenWidth * 0.8,
                decoration: BoxDecoration(
                    color: fourthColor.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(
                      getProportionateScreenHeight(12),
                    ),
                    border: Border.all(color: Colors.white)),
                alignment: Alignment.center,
                child: Text(
                  "What is your Birth Year?",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Gilroy",
                    color: Colors.white,
                    fontSize: getProportionateScreenHeight(16),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.018,
              ),
              Container(
                height: SizeConfig.screenHeight * 0.06,
                width: SizeConfig.screenWidth * 0.8,
                child: TextFormField(
                  cursorColor: fourthColor,
                  controller: securityController,
                  onSaved: (val) {
                    security = val!;
                    prefs.setString("security", security);
                  },
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontFamily: "Gilroy",
                    color: Colors.white,
                    fontSize: getProportionateScreenHeight(16),
                  ),
                  textAlign: TextAlign.center,
                  decoration: InputDecoration(
                    filled: true,
                    contentPadding:
                        EdgeInsets.only(top: getProportionateScreenHeight(07)),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        getProportionateScreenHeight(12),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        getProportionateScreenHeight(12),
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.white,
                      ),
                      borderRadius: BorderRadius.circular(
                        getProportionateScreenHeight(12),
                      ),
                    ),
                    fillColor: fourthColor.withOpacity(0.5),
                    hintText: "Your Answer",
                    hintStyle: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontFamily: "Gilroy",
                      color: Colors.white54,
                      fontSize: getProportionateScreenHeight(16),
                    ),
                  ),
                ),
              ),
              Spacer(),
              isNativeAdLoaded
                  ? Container(
                      decoration: const BoxDecoration(
                        color: Colors.white,
                      ),
                      height: 265,
                      child: AdWidget(
                        ad: nativeAd!,
                      ),
                    )
                  : CircularProgressIndicator(),
              Spacer(),
              Container(
                height: SizeConfig.screenHeight * 0.06,
                width: SizeConfig.screenWidth * 0.8,
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                      fourthColor.withOpacity(0.7),
                    ),
                  ),
                  onPressed: () async {
                    formKey.currentState!.save();
                    interstitialAd!.show();
                    Get.offAll(
                      () => OptionPage(),
                      curve: Curves.easeInOut,
                      transition: Transition.fade,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                  child: Text(
                    "Next",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Gilroy",
                      color: Colors.white,
                      fontSize: getProportionateScreenHeight(16),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: SizeConfig.screenHeight * 0.03,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
