import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/helpers/AppLifecycleReactor%20.dart';
import 'package:calculator_vault_app/src/helpers/AppOpenAdManager.dart';
import 'package:calculator_vault_app/src/views/screens/password_page.dart';
import 'package:calculator_vault_app/src/views/screens/privacy_policy.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:launch_review/launch_review.dart';
import 'package:share_plus/share_plus.dart';

import '../../../colors.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
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
        title: const Text(
          "Settings",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: SizeConfig.screenHeight * 0.08,
              width: SizeConfig.screenWidth,
              color: fourthColor.withOpacity(0.5),
              child: Row(
                children: [
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.05,
                  ),
                  SvgPicture.asset("assets/icons/bulb-idea.svg"),
                  SizedBox(
                    width: SizeConfig.screenWidth * 0.035,
                  ),
                  Text(
                    "Notice :   Press 11223344= to \nCreate New Password",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(16),
                      fontFamily: "Gilroy",
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: SizeConfig.screenHeight * 0.025,
            ),
            Container(
              height: SizeConfig.screenHeight * 0.29,
              width: SizeConfig.screenWidth * 0.92,
              decoration: BoxDecoration(
                color: secondColor,
                borderRadius:
                    BorderRadius.circular(getProportionateScreenHeight(10)),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.015,
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                          () => PasswordPage(
                                isPasswordChanging: true,
                              ),
                          duration: Duration(milliseconds: 500),
                          transition: Transition.fade,
                          curve: Curves.easeInOut);
                    },
                    child: Container(
                      height: SizeConfig.screenHeight * 0.05,
                      width: SizeConfig.screenWidth * 0.84,
                      child: Row(
                        children: [
                          Text(
                            "Change Password",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Gilroy",
                              fontSize: getProportionateScreenHeight(15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 12,
                    endIndent: 12,
                  ),
                  GestureDetector(
                    onTap: (){
                      setState(() {
                        LaunchReview.launch(
                          androidAppId: "com.xm.calculator_vault_app21",
                        );
                      });
                    },
                    child: Container(
                      height: SizeConfig.screenHeight * 0.05,
                      width: SizeConfig.screenWidth * 0.84,
                      child: Row(
                        children: [
                          Text(
                            "Rate Us",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Gilroy",
                              fontSize: getProportionateScreenHeight(15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 12,
                    endIndent: 12,
                  ),
                  // StreamBuilder(
                  //   stream: FirebaseFirestore.instance
                  //       .collection('share')
                  //       .doc("1")
                  //       .snapshots(),
                  //   builder: (context, snapshot) {
                  //     if (snapshot.hasError) {
                  //       print(snapshot.error);
                  //     } else if (snapshot.hasData) {
                  //       DocumentSnapshot<Map<String, dynamic>>? data =
                  //           snapshot.data;
                  //       return GestureDetector(
                  //         onTap: (){
                  //           Share.share(data!['applink']);
                  //         },
                  //         child: Container(
                  //           height: SizeConfig.screenHeight * 0.05,
                  //           width: SizeConfig.screenWidth * 0.84,
                  //           child: Row(
                  //             children: [
                  //               Text(
                  //                 "Share With Friends",
                  //                 style: TextStyle(
                  //                   color: Colors.white,
                  //                   fontFamily: "Gilroy",
                  //                   fontSize: getProportionateScreenHeight(15),
                  //                 ),
                  //               ),
                  //             ],
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //     return GestureDetector(
                  //       onTap: (){

                  //       },
                  //       child: Container(
                  //         height: SizeConfig.screenHeight * 0.05,
                  //         width: SizeConfig.screenWidth * 0.84,
                  //         child: Row(
                  //           children: [
                  //             Text(
                  //               "Share With Friends",
                  //               style: TextStyle(
                  //                 color: Colors.white,
                  //                 fontFamily: "Gilroy",
                  //                 fontSize: getProportionateScreenHeight(15),
                  //               ),
                  //             ),
                  //           ],
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   // child: GestureDetector(
                  //   //   onTap: (){
                  //   //
                  //   //   },
                  //   //   child: Container(
                  //   //     height: SizeConfig.screenHeight * 0.05,
                  //   //     width: SizeConfig.screenWidth * 0.84,
                  //   //     child: Row(
                  //   //       children: [
                  //   //         Text(
                  //   //           "Share With Friends",
                  //   //           style: TextStyle(
                  //   //             color: Colors.white,
                  //   //             fontFamily: "Gilroy",
                  //   //             fontSize: getProportionateScreenHeight(15),
                  //   //           ),
                  //   //         ),
                  //   //       ],
                  //   //     ),
                  //   //   ),
                  //   // ),
                  // ),
                  Divider(
                    thickness: 1,
                    color: Colors.grey,
                    indent: 12,
                    endIndent: 12,
                  ),
                  GestureDetector(
                    onTap: (){
                      Get.to(
                            () => PrivacyPolicyPage(),
                        curve: Curves.easeInOut,
                        transition: Transition.fade,
                        duration: Duration(milliseconds: 500),
                      );
                    },
                    child: Container(
                      height: SizeConfig.screenHeight * 0.05,
                      width: SizeConfig.screenWidth * 0.84,
                      child: Row(
                        children: [
                          Text(
                            "Privacy Policy",
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Gilroy",
                              fontSize: getProportionateScreenHeight(15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      // ListView(
      //   children: [
      //     ListTile(
      //       title: const Text("Change Password",style: TextStyle(fontFamily: "GilRoy",color: Colors.white),),
      //       onTap: () => Get.to(
      //           () => PasswordPage(
      //                 isPasswordChanging: true,
      //               ),
      //           duration: Duration(milliseconds: 500),
      //           transition: Transition.fade,
      //           curve: Curves.easeInOut),
      //     ),

      // ListTile(
      //   title: const Text(""),
      //   onTap: () => Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => const CreatePasswordPage(),
      //     ),
      //   ),
      // ),
      // ],
      // ),
    );
  }
}
