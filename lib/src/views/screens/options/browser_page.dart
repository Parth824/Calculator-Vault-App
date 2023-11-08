import 'package:calculator_vault_app/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import '../../../../colors.dart';

class BrowserPage extends StatefulWidget {
  const BrowserPage({super.key});

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  InAppWebViewController? webViewController;
  late var url;
  var initialUrl = "https://google.com";
  TextEditingController textEditingController = TextEditingController();
  double _progress = 0;
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        var isLastPage = await webViewController!.canGoBack();

        if (isLastPage) {
          webViewController!.goBack();
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: firstColor,
        appBar: AppBar(
          backgroundColor: secondColor,
          centerTitle: true,
          title: Text(
            "Browser",
            style: TextStyle(fontFamily: "Gilroy"),
          ),
        ),
        body: Column(
          children: [
            Form(
              key: globalKey,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: getProportionateScreenHeight(15),),
                child: TextFormField(
                  cursorColor: fourthColor,
                  controller: textEditingController,
                  textInputAction: TextInputAction.go,
                  onFieldSubmitted: (value) async {
                    initialUrl = "https://";

                    if (value.contains(".")) {
                      setState(() {
                        initialUrl += value!;
                        print(initialUrl);
                      });
                      await webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: Uri.parse("https://" + value!),
                        ),
                      );
                    } else {
                      setState(() {
                        initialUrl += value!;
                        print(initialUrl);
                      });
                      await webViewController?.loadUrl(
                        urlRequest: URLRequest(
                          url: Uri.parse(
                              "https://www.google.com/search?q=" + value!),
                        ),
                      );
                    }
                  },

                  style: TextStyle(
                    color: Colors.white,
                    fontSize: getProportionateScreenHeight(14),
                    fontFamily: "Gilroy",
                  ),
                  decoration: InputDecoration(
                    hintText: "Search or Enter URL",
                    border: InputBorder.none,
                    hintStyle: TextStyle(
                      fontSize: getProportionateScreenHeight(14),
                      fontFamily: "Gilroy",
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            _progress < 1
                ? LinearProgressIndicator(
                    value: _progress,
              color: Colors.teal,
              backgroundColor: fourthColor,
                  )
                : SizedBox(),
            Expanded(
              child: InAppWebView(

                onWebViewCreated: (controller) =>
                    webViewController = controller,
                initialUrlRequest: URLRequest(
                  url: Uri.parse(initialUrl),
                ),
                onProgressChanged: (controller, progress) {
                  setState(() {
                    _progress = progress / 100;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
