import 'package:calculator_vault_app/colors.dart';
import 'package:calculator_vault_app/size_config.dart';
import 'package:calculator_vault_app/src/helpers/AppLifecycleReactor%20.dart';
import 'package:calculator_vault_app/src/views/screens/options_page.dart';
import 'package:calculator_vault_app/src/views/screens/security_question.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import '../../helpers/AppOpenAdManager.dart';
import 'home_page.dart';
import 'widgets/input_button.dart';

class PasswordPage extends StatefulWidget {
  final bool? isPasswordChanging;

  const PasswordPage({super.key, this.isPasswordChanging});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  bool passwordEntered = false;
  String password = '', confirmPassword = '';
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    height: SizeConfig.screenHeight * 0.2,
                  ),
                  Text(
                    !passwordEntered
                        ? "Create New Password"
                        : "Confirm password",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(24),
                      color: Colors.white,
                      fontFamily: "Gilroy",
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.015),
                  Text(
                    "Enter 4-digit password and then press \"=\"",
                    style: TextStyle(
                      fontSize: getProportionateScreenHeight(16),
                      color: Colors.white,
                      fontFamily: "Gilroy",
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.06),
                  Text(
                    passwordText(),
                    style: TextStyle(
                      fontFamily: "Gilroy",
                      color: Colors.white,
                      fontSize: getProportionateScreenHeight(24),
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.05)
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            decoration: BoxDecoration(
              color: firstColor,
              borderRadius: BorderRadius.vertical(
                  top: Radius.circular(getProportionateScreenHeight(20))),
            ),
            child: InputBoard(
              isPassword: true,
              onBackspace: onBackspace,
              onClear: onClear,
              onChange: onChange,
              onModuloPress: () => setState(() => password = '$password%'),
              onSubmit: onSubmit,
            ),
          ),
        ],
      ),
    );
  }

  String passwordText() {
    String s = "-  -  -  -";
    if (!passwordEntered && password.isNotEmpty) {
      s = " * " * password.length;
    }
    if (passwordEntered && confirmPassword.isNotEmpty) {
      s = " * " * confirmPassword.length;
    }
    return s;
  }

  void onBackspace() {
    if (passwordEntered && confirmPassword.isNotEmpty) {
      confirmPassword =
          confirmPassword.substring(0, confirmPassword.length - 1);
      setState(() {});
    }
    if (!passwordEntered && password.isNotEmpty) {
      setState(() => password = password.substring(0, password.length - 1));
    }
  }

  void onClear() {
    password = confirmPassword = '';
    passwordEntered = false;
    setState(() {});
  }

  void onChange(v) {
    if (!passwordEntered) {
      if (password.length < 4) {
        password = password + v;
      }
    } else {
      if (confirmPassword.length < 4) {
        confirmPassword = confirmPassword + v;
      }
    }
    setState(() {});
  }

  void onSubmit() {
    if (password.length < 4) {
      Fluttertoast.showToast(msg: "Enter atleast 4 characters");
      return;
    }
    if (password.length > 4) {
      Fluttertoast.showToast(msg: "Enter atleast 4 characters");
      return;
    }
    if (!passwordEntered) {
      setState(() => passwordEntered = true);
    } else {
      if (confirmPassword == password) {
        final box = Hive.box<String>('appPassword');
        box.put('password', password);
        onSuccess(context);
      } else {
        password = confirmPassword = '';
        passwordEntered = false;
        setState(() {});
        Fluttertoast.showToast(
          msg: "Password doesn't matched!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
      }
    }
  }

  void onSuccess(BuildContext context) {
    if (widget.isPasswordChanging != null && widget.isPasswordChanging!) {
      Navigator.pop(context);
    } else {
      Get.off(
        () => HomePage(appPassword: password),
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 500),
        transition: Transition.fade,
      );
      if (security.isEmpty) {
        Get.to(
          () => SecurityPage(),
          curve: Curves.easeInOut,
          duration: Duration(milliseconds: 500),
          transition: Transition.fade,
        );
      }
    }
    Fluttertoast.showToast(
      msg: widget.isPasswordChanging != null && widget.isPasswordChanging!
          ? "Password Updated!"
          : "Password Created",
      backgroundColor: Colors.green,
    );
  }
}
