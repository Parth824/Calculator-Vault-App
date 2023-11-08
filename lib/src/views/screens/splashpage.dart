import 'package:calculator_vault_app/colors.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/helpers/AppLifecycleReactor%20.dart';
import 'package:calculator_vault_app/src/helpers/AppOpenAdManager.dart';
import 'package:calculator_vault_app/src/views/screens/start_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UnbordingContent {
  String image;
  String title;

  UnbordingContent({required this.image, required this.title});
}

List<UnbordingContent> contents = [
  UnbordingContent(
    title: 'Set a 4-digit password',
    image: 'assets/images/CreateAPassword.png',
  ),
  UnbordingContent(
    title: 'Type \'11223344=\' when you forgot password',
    image: 'assets/images/ResetPassword.png',
  ),
  UnbordingContent(
    title: 'Let\'s start hiding your photos, videos',
    image: 'assets/images/Calculation.png',
  ),
];

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  PageController pageController = PageController();

  int currentIndex = 0;
  late PageController controller;

  late AppLifecycleReactor _appLifecycleReactor;

  @override
  void initState() {
    // TODO: implement initState
    controller = PageController(initialPage: 0);
    super.initState();
    AppOpenAdManager appOpenAdManager = AppOpenAdManager()..loadAd();
    _appLifecycleReactor =
        AppLifecycleReactor(appOpenAdManager: appOpenAdManager);
    _appLifecycleReactor.listenToAppStateChanges();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: firstColor,
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              controller: controller,
              itemCount: contents.length,
              onPageChanged: (int index) {
                setState(() {
                  currentIndex = index;
                });
              },
              itemBuilder: (_, i) {
                return Padding(
                  padding: const EdgeInsets.all(40),
                  child: Column(
                    children: [
                      Image.asset(
                        contents[i].image,
                        height: SizeConfig.screenHeight * 0.6,
                      ),
                      SizedBox(
                        height: SizeConfig.screenHeight * 0.03,
                      ),
                      Text(
                        contents[i].title,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Gilroy",
                          color: Colors.white,
                          fontSize: getProportionateScreenHeight(26),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                contents.length,
                (index) => buildDot(index, context),
              ),
            ),
          ),
          Container(
            height: SizeConfig.screenHeight * 0.06,
            margin: EdgeInsets.all(40),
            width: double.infinity,
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  fourthColor.withOpacity(0.7),
                ),
              ),
              child: Text(
                currentIndex == contents.length - 1 ? "Continue" : "Next",
                style: TextStyle(
                  fontFamily: "Gilroy",
                  fontSize: getProportionateScreenHeight(18),
                ),
              ),
              onPressed: () {
                if (currentIndex == contents.length - 1) {
                  Get.to(
                    () => StartPage(),
                    transition: Transition.fade,
                    curve: Curves.easeInOut,
                    duration: Duration(milliseconds: 500),
                  );
                }
                controller.nextPage(
                  duration: Duration(milliseconds: 700),
                  curve: Curves.easeInOut,
                );
              },
              // color: Theme.of(context).primaryColor,
              // textColor: Colors.white,
              // shape: RoundedRectangleBorder(
              //   borderRadius: BorderRadius.circular(20),
              // ),
            ),
          )
        ],
      ),
    );
  }

  Container buildDot(int index, BuildContext context) {
    return Container(
      height: 10,
      width: currentIndex == index ? 25 : 10,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color:
            currentIndex == index ? fourthColor : fourthColor.withOpacity(0.5),
      ),
    );
  }
}
