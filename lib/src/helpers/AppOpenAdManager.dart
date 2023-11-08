import 'package:calculator_vault_app/src/views/screens/home_page.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  static bool isLoaded = false;
  static String pass = "";

  /// Load an AppOpenAd.
  static String appOpenId = "ca-app-pub-3940256099942544/3419835294";
  static String interstitialId = "";
  static String nativeId = "";
  void loadAd() {
    AppOpenAd.load(
      adUnitId: appOpenId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          print("Ad Loadede.................................");
          _appOpenAd = ad;
          isLoaded = true;
        },
        onAdFailedToLoad: (error) {
          // Handle the error.
        },
      ),
    );
  }

  // Whether an ad is available to be shown.
  bool get isAdAvailable {
    return _appOpenAd != null;
  }

  void showAdIfAvailable() {
    print(
        "Called=====================================================================");
    if (_appOpenAd == null) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
        Future.delayed(Duration(milliseconds: 500), () {
          SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
          // Get.off(
          //       () => VPNHomePage(),
          //   transition: Transition.fade,
          //   duration: Duration(milliseconds: 1000),
          // );
        });
      },
    );
    _appOpenAd!.show();
  }

  void showAdIfAvailableForSplash() {
    print(
        "Called=====================================================================");
    if (_appOpenAd == null) {
      print('Tried to show ad before available.');
      loadAd();
      return;
    }
    if (_isShowingAd) {
      print('Tried to show ad while already showing an ad.');
      return;
    }
    // Set the fullScreenContentCallback and show the ad.
    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAd = true;
        print('$ad onAdShowedFullScreenContent');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
      },
      onAdDismissedFullScreenContent: (ad) {
        print('$ad onAdDismissedFullScreenContent');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAd();
        // Future.delayed(Duration(milliseconds: 500), () {
        //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
        //   Get.off(
        //     () => HomePage(
        //       appPassword: pass,
        //     ),
        //     transition: Transition.fade,
        //     duration: Duration(milliseconds: 1000),
        //   );
        // });
      },
    );
    _appOpenAd!.show();
  }
}
