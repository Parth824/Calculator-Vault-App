import 'dart:io';

import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/helpers/AppLifecycleReactor%20.dart';
import 'package:calculator_vault_app/src/views/screens/password_page.dart';
import 'package:calculator_vault_app/src/views/screens/security_question.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:math_expressions/math_expressions.dart';

import '../../../colors.dart';
import '../../../main.dart';
import '../../helpers/AppOpenAdManager.dart';
import 'options_page.dart';
import 'widgets/input_button.dart';

InterstitialAd? interstitialAd;

final String adUnitIdInterstitital = Platform.isAndroid
    ? 'ca-app-pub-3940256099942544/1033173712'
    : 'ca-app-pub-3940256099942544/4411468910';

 loadInterstitialAd() {
  InterstitialAd.load(
      adUnitId: adUnitIdInterstitital,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        // Called when an ad is successfully received.
        onAdLoaded: (InterstitialAd ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            // Called when the ad showed the full screen content.
              onAdShowedFullScreenContent: (ad) {},
              // Called when an impression occurs on the ad.
              onAdImpression: (ad) {},
              // Called when the ad failed to show full screen content.
              onAdFailedToShowFullScreenContent: (ad, err) {
                ad.dispose();
              },
              // Called when the ad dismissed full screen content.
              onAdDismissedFullScreenContent: (ad) {
                ad.dispose();
              },
              // Called when a click is recorded for an ad.
              onAdClicked: (ad) {});

          // Keep a reference to the ad so you can show it later.
          interstitialAd = ad;
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (LoadAdError error) {
          // ignore: avoid_print
          print('InterstitialAd failed to load: $error');
        },
      ));
}


class HomePage extends StatefulWidget {
  final String appPassword;

  const HomePage({super.key, required this.appPassword});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Parser parser = Parser();
  final ContextModel contextModel = ContextModel();
  String calculationString = "", resultString = "";

late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    
    loadInterstitialAd();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondColor,
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              reverse: true,
              children: [
                Text(
                  resultString,
                  style: const TextStyle(
                    fontSize: 24,
                    fontFamily: "Gilroy",
                    color: Colors.white70,
                  ),
                  textAlign: TextAlign.right,
                ),
                Text(
                  formatString(calculationString),
                  style: const TextStyle(
                    fontFamily: "Gilroy",
                    fontSize: 48,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.right,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: const BoxDecoration(
              color: firstColor,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            child: InputBoard(
              onBackspace: onBackspace,
              onClear: () => setState(() {
                calculationString = resultString = "";
              }),
              onChange: (v) {
                setState(() => calculationString = calculationString + v);
                final result = calculate();
                if (result != null) {
                  setState(() => resultString = result);
                }
              },
              onModuloPress: () {
                try {
                  double number = double.parse(resultString);
                  resultString = (number / 100).toString();
                  setState(() {});
                } catch (e) {
                  // print(e);
                }
              },
              onSubmit: () {
                if (calculationString == widget.appPassword) {
                  interstitialAd?.show();
                  return Get.off(
                    () => OptionPage(),
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                    transition: Transition.fade,
                  );
                }
                if (calculationString == "11223344") {
                  return showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: secondColor,
                        title: Text(
                          "Security Question",
                          style: TextStyle(
                            fontSize: getProportionateScreenHeight(22),
                            fontFamily: "Gilroy",
                            color: Colors.white,
                          ),
                        ),
                        content: Container(
                          height: SizeConfig.screenHeight * 0.24,
                          width: SizeConfig.screenWidth,
                          decoration: BoxDecoration(
                            color: secondColor,
                          ),
                          child: Form(
                            key: formKey,
                            child: Column(
                              children: [
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
                                      fontSize:
                                          getProportionateScreenHeight(16),
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
                                      // prefs.getString("security");
                                    },
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontFamily: "Gilroy",
                                      color: Colors.white,
                                      fontSize:
                                          getProportionateScreenHeight(16),
                                    ),
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      filled: true,
                                      contentPadding: EdgeInsets.only(
                                          top:
                                              getProportionateScreenHeight(07)),
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
                                        fontSize:
                                            getProportionateScreenHeight(16),
                                      ),
                                    ),
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: SizeConfig.screenHeight * 0.06,
                                  width: SizeConfig.screenWidth * 0.8,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      backgroundColor:
                                          MaterialStateProperty.all(
                                        fourthColor.withOpacity(0.7),
                                      ),
                                    ),
                                    onPressed: () {
                                      formKey.currentState!.save();
                                      var securityPrefs =
                                          prefs.getString("security");
                                      print(securityPrefs);
                                      if (securityPrefs == security) {
                                        Get.offAll(
                                          () => PasswordPage(),
                                          curve: Curves.easeInOut,
                                          transition: Transition.fade,
                                          duration: Duration(milliseconds: 500),
                                        );

                                      } else {
                                        Get.back();
                                      }
                                    },
                                    child: Text(
                                      "Next",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Gilroy",
                                        color: Colors.white,
                                        fontSize:
                                            getProportionateScreenHeight(16),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: SizeConfig.screenHeight * 0.01,
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                  //   Get.to(
                  //       () => PasswordPage(),
                  //   // duration: Duration(milliseconds: 500),
                  //   // curve: Curves.easeInOut,
                  //   // transition: Transition.fade,
                  // );
                }
                if (resultString.isNotEmpty) {
                  setState(() {
                    calculationString = resultString;
                    resultString = "";
                  });
                }
              },
            ),
          ),
        ],
      ),
      // floatingActionButton: FloatingActionButton(onPressed: () async {
      //   final box = await Hive.openBox<String>('gallery');
      //   box.deleteAll(box.keys);
      // }),
    );
  }

  String? calculate() {
    try {
      Expression expression = parser.parse(calculationString);
      var result = expression.evaluate(EvaluationType.REAL, contextModel);
      String string = result.toString();
      return string.endsWith('.0')
          ? string.substring(0, string.length - 2)
          : string;
    } catch (e) {
      // print(e);
      return null;
    }
  }

  void onBackspace() {
    if (calculationString.isNotEmpty) {
      calculationString =
          calculationString.substring(0, calculationString.length - 1);
      resultString = calculate() ?? '';
      setState(() {});
    } else {
      setState(() => calculationString = resultString = '');
    }
  }
}

String formatString(String string) {
  if (string.isEmpty) {
    return '0';
  } else {
    string = string.replaceAll('*', 'x').replaceAll('/', '÷');
    return string;
  }
}
