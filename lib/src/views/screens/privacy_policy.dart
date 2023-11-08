import 'package:calculator_vault_app/src/helpers/AppLifecycleReactor%20.dart';
import 'package:calculator_vault_app/src/helpers/AppOpenAdManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../../colors.dart';
import '../../../size_config.dart';

class PrivacyPolicyPage extends StatefulWidget {
  const PrivacyPolicyPage({super.key});

  @override
  State<PrivacyPolicyPage> createState() => _PrivacyPolicyPageState();
}

class _PrivacyPolicyPageState extends State<PrivacyPolicyPage> {
  WebViewController webViewController = WebViewController()
    ..loadRequest(
      Uri.parse("https://sites.google.com/view/vpnshield/home"),
    );
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

        title: Text(
          "Privacy Policy",
          style: TextStyle(fontFamily: "Gilroy"),
        ),
      ),
      body: WebViewWidget(controller: webViewController),
    );
  }
}
