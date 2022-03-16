import 'dart:async';

import 'package:flutter/material.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PartnerWithUsWebView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return PartnerWithUsState();
  }
}

class PartnerWithUsState extends State<PartnerWithUsWebView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  var url = '';

  @override
  Widget build(BuildContext context) {
    //Map<String, dynamic> datar = ModalRoute.of(context).settings.arguments;
    setState(() {
      //url = datar['url'];
      url =
          'https://docs.google.com/forms/d/e/1FAIpQLSc5yShV9ookvDBW2eRyuxjZQ8JLX24xMkqjUobHHREYCRo3-A/viewform?vc=0&c=0&w=1&flr=0&usp=mail_form_link';
    });

    return WillPopScope(
      onWillPop: () async {
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
        ),
        body: Center(
          child: WebView(
            initialUrl: '$url',
            javascriptMode: JavascriptMode.unrestricted,
            onPageStarted: (value) {},
            onWebViewCreated: (WebViewController webViewController) {
              if (!_controller.isCompleted) {
                _controller.complete(webViewController);
              }
            },
            onPageFinished: (value) {
              if (value.contains('$imageBaseUrl' +
                  'resources/views/admin/paymentvia/payment.php')) {
                print('pp pay - $value');
                Navigator.of(context).pop();
              }
            },
            javascriptChannels: <JavascriptChannel>[
              JavascriptChannel(
                  name: 'messageHandler',
                  onMessageReceived: (s) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                      content: Text(s.message),
                    ));
                  }),
            ].toSet(),
          ),
        ),
      ),
    );
  }
}
