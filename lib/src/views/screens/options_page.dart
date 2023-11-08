import 'package:calculator_vault_app/colors.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/helpers/AppLifecycleReactor%20.dart';
import 'package:calculator_vault_app/src/helpers/AppOpenAdManager.dart';
import 'package:calculator_vault_app/src/views/screens/home_page.dart';
import 'package:calculator_vault_app/src/views/screens/options/browser_page.dart';
import 'package:calculator_vault_app/src/views/screens/options/image/image_page.dart';
import 'package:calculator_vault_app/src/views/screens/options/notes/notes_page.dart';
import 'package:calculator_vault_app/src/views/screens/options/recyclebin/recyclebin_page.dart';
import 'package:calculator_vault_app/src/views/screens/options/video/video_page.dart';
import 'package:calculator_vault_app/src/views/screens/placeholder.dart';
import 'package:calculator_vault_app/src/views/screens/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:lottie/lottie.dart';
import 'package:shimmer/shimmer.dart';

class OptionPage extends StatefulWidget {
  const OptionPage({super.key});

  @override
  State<OptionPage> createState() => _OptionPageState();
}

class _OptionPageState extends State<OptionPage> {
  NativeAd? nativeAd;
  bool isNativeAdLoaded = false;

  void loadNativeAd() async {
    print("k======================");
    nativeAd = NativeAd(
      adUnitId: "ca-app-pub-3940256099942544/2247696110",
      factoryId: "listTileMedium",
      listener: NativeAdListener(onAdLoaded: (ad) {
        print("Parth====================");
        setState(() {
          isNativeAdLoaded = true;
        });
      }, onAdFailedToLoad: (ad, error) {
        print("Parth1====================");
        nativeAd!.dispose();
      }),
      request: const AdRequest(),
    );
    await nativeAd!.load();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    loadNativeAd();
  }

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
      backgroundColor: firstColor,
      appBar: AppBar(
        backgroundColor: secondColor,
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () async {
              await loadInterstitialAd();
              interstitialAd!.show();
              Get.to(
                () => SettingsPage(),
                curve: Curves.easeInOut,
                transition: Transition.fade,
                duration: Duration(milliseconds: 500),
              );
            },
            icon: const Icon(Icons.settings),
          ),
        ],
        title: Text(
          "Calculator Lock",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: getProportionateScreenHeight(14),
        ),
        child: Column(
          children: [
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            GestureDetector(
              onTap: () async {
                // Navigator.push(context, MaterialPageRoute(
                //   builder: (context) {
                //     return Scaffold(
                //       body: Center(
                //         child: CircularProgressIndicator(),
                //       ),
                //     );
                //   },
                // ));
                await loadInterstitialAd();
                interstitialAd!.show();
                Get.to(
                  () => BrowserPage(),
                  transition: Transition.fade,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 500),
                );
              },
              child: Container(
                height: SizeConfig.screenHeight * 0.06,
                width: SizeConfig.screenWidth,
                padding: EdgeInsets.symmetric(
                  horizontal: getProportionateScreenHeight(12),
                ),
                decoration: BoxDecoration(
                  color: secondColor,
                  borderRadius:
                      BorderRadius.circular(getProportionateScreenHeight(200)),
                ),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      "assets/icons/earth.svg",
                      height: getProportionateScreenHeight(32),
                      width: getProportionateScreenHeight(32),
                    ),
                    SizedBox(
                      width: getProportionateScreenHeight(15),
                    ),
                    Text(
                      "Private Web Browser",
                      style: TextStyle(
                        fontSize: getProportionateScreenHeight(16),
                        fontFamily: "Gilroy",
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.025,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildOptionsContainer(
                  onTap: () async {
                    await loadInterstitialAd();
                    interstitialAd!.show();
                    Get.to(
                      () => ImagePage(),
                      transition: Transition.fade,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 
                      500),
                    );
                  },
                  SizeConfig.screenHeight * 0.1,
                  imagepath: "assets/icons/image.svg",
                  text: "Image",
                ),
                buildOptionsContainer(
                  onTap: () async {
                    await loadInterstitialAd();
                    interstitialAd!.show();
                    Get.to(
                      () => VideoPage(),
                      transition: Transition.fade,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                  SizeConfig.screenHeight * 0.1,
                  imagepath: "assets/icons/video.svg",
                  text: "Video",
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.02,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                buildOptionsContainer(
                  onTap: () async {
                    await loadInterstitialAd();
                    interstitialAd!.show();
                    Get.to(
                      () => NotesPage(),
                      transition: Transition.fade,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                  SizeConfig.screenHeight * 0.1,
                  imagepath: "assets/icons/notes.svg",
                  text: "Notes",
                ),
                buildOptionsContainer(
                  onTap: () async {
                    await loadInterstitialAd();
                    interstitialAd!.show();
                    Get.to(
                      () => RecyclePage(),
                      transition: Transition.fade,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 500),
                    );
                  },
                  SizeConfig.screenHeight * 0.085,
                  imagepath: "assets/icons/recyclebin.svg",
                  text: "Recycle Bin",
                ),
              ],
            ),
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
                : Container(
                    height: SizeConfig.screenHeight * 0.29,
                    width: SizeConfig.screenWidth,
                    color: Colors.grey.shade200,
                    child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade300,
                        highlightColor: Colors.grey.shade100,
                        enabled: true,
                        child: SingleChildScrollView(
                          physics: NeverScrollableScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Container(
                                width: double.infinity,
                                height: SizeConfig.screenHeight * 0.13,
                                margin: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.white,
                                ),
                              ),
                              TitlePlaceholder(width: double.infinity),
                              Container(
                                width: double.infinity,
                                height: SizeConfig.screenHeight * 0.055,
                                margin: const EdgeInsets.all(16.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        )),
                  ),
            Lottie.asset("assets/json/restore_loading_animation.json",
                height: 100),
          ],
        ),
      ),
    );
  }

  Widget buildOptionsContainer(double height,
      {required Function()? onTap,
      required String imagepath,
      required String text}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: SizeConfig.screenHeight * 0.15,
        width: SizeConfig.screenWidth * 0.44,
        decoration: BoxDecoration(
          color: secondColor,
          borderRadius: BorderRadius.circular(
            getProportionateScreenHeight(14),
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SvgPicture.asset(
              imagepath,
              height: height,
            ),
            Text(
              text,
              style: TextStyle(
                color: Colors.white,
                fontSize: getProportionateScreenHeight(18),
                fontFamily: "Gilroy",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
