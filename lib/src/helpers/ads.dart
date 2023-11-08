// import 'dart:io';
//
// import 'package:google_mobile_ads/google_mobile_ads.dart';
//
// class AdsHelper {
//   InterstitialAd? interstitialAd;
//
//   final String _adUnitId = Platform.isAndroid
//       ? 'ca-app-pub-3940256099942544/1033173712'
//       : 'ca-app-pub-3940256099942544/4411468910';
//
//   void loadInterstitialAd() {
//     InterstitialAd.load(
//         adUnitId: _adUnitId,
//         request: const AdRequest(),
//         adLoadCallback: InterstitialAdLoadCallback(
//           // Called when an ad is successfully received.
//           onAdLoaded: (InterstitialAd ad) {
//             ad.fullScreenContentCallback = FullScreenContentCallback(
//               // Called when the ad showed the full screen content.
//                 onAdShowedFullScreenContent: (ad) {},
//                 // Called when an impression occurs on the ad.
//                 onAdImpression: (ad) {},
//                 // Called when the ad failed to show full screen content.
//                 onAdFailedToShowFullScreenContent: (ad, err) {
//                   ad.dispose();
//                 },
//                 // Called when the ad dismissed full screen content.
//                 onAdDismissedFullScreenContent: (ad) {
//                   ad.dispose();
//                 },
//                 // Called when a click is recorded for an ad.
//                 onAdClicked: (ad) {});
//
//             // Keep a reference to the ad so you can show it later.
//             interstitialAd = ad;
//           },
//           // Called when an ad request failed.
//           onAdFailedToLoad: (LoadAdError error) {
//             // ignore: avoid_print
//             print('InterstitialAd failed to load: $error');
//           },
//         ));
//   }
//
// }
