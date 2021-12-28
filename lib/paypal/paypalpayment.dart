import 'dart:core';
import 'package:flutter/material.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/paypal/paypalservices.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaypalPayment extends StatefulWidget {
  final Function onFinish;
  final String clientId;
  final String secret;
  final String amount;
  final String apCurrency;

  PaypalPayment({this.onFinish,this.clientId,this.secret,this.amount,this.apCurrency});

  @override
  State<StatefulWidget> createState() {
    return PaypalPaymentState(clientId,secret);
  }
}

class PaypalPaymentState extends State<PaypalPayment> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String checkoutUrl;
  String executeUrl;
  String accessToken;
  PaypalServices services;
  PaypalPaymentState(String clientid, String secret){
    services = PaypalServices(clientid,secret,true);
  }


  // you can change default currency according to your need
  Map<dynamic, dynamic> defaultCurrency = {
    "symbol": "USD",
    "decimalDigits": 2,
    "symbolBeforeTheNumber": true,
    "currency": "USD"
  };

  bool isEnableShipping = false;
  bool isEnableAddress = false;

  String returnURL = 'return.example.com';
  String cancelURL = 'cancel.example.com';

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero, () async {
      try {
        accessToken = await services.getAccessToken();
        print(accessToken);
        final transactions = getOrderParams(double.parse('${widget.amount}'));
        print(transactions);
        final res =
        await services.createPaypalPayment(transactions, accessToken);
        if (res != null) {
          setState(() {
            checkoutUrl = res["approvalUrl"];
            executeUrl = res["executeUrl"];
          });
        }
      } catch (e) {
        print('exception: ' + e.toString());
        final snackBar = SnackBar(
          content: Text(e.toString()),
          duration: Duration(seconds: 10),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {

            },
          ),
        );
        _scaffoldKey.currentState.showSnackBar(snackBar);
        widget.onFinish('','fail');
        // Navigator.of(context).pop();
      }
    });
  }

  // item name, price and quantity
  String itemName = '';
  String itemPrice = '';
  int quantity = 1;

  Map<String, dynamic> getOrderParams(double amount) {
    List items = [
      {
        "name": 'Grocery Shopping',
        "description": "Grocery Shopping",
        "quantity": "1",
        "price": '${amount}',
        "tax": "0.00",
        "sku": "1",
        "currency": '${widget.apCurrency}'
      }
    ];

    String shippingCost = '0.0';

    Map<String, dynamic> temp = {
      "intent": "sale",
      "payer": {"payment_method": "paypal"},
      "transactions": [
        {
          "amount": {
            "total": '$amount',
            "currency": '${widget.apCurrency}',
            "details": {
              "subtotal": '$amount',
              "shipping": shippingCost,
            }
          },
          "description": "The payment transaction description.",
          "payment_options": {
            "allowed_payment_method": "INSTANT_FUNDING_SOURCE"
          },
          "item_list": {
            "items": items
          }
        }
      ],
      "note_to_payer": "Contact us for any questions on your order.",
      "redirect_urls": {"return_url": returnURL, "cancel_url": cancelURL}
    };
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    // print('urls - ${checkoutUrl}');

    if (checkoutUrl != null) {
      return WillPopScope(
        onWillPop: () async{
          return false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: kWhiteColor,
            leading: GestureDetector(
              child: Icon(Icons.arrow_back_ios),
              onTap: () {
                widget.onFinish('','fail');
                Navigator.pop(context);
              },
            ),
          ),
          body: WebView(
            initialUrl: checkoutUrl,
            javascriptMode: JavascriptMode.unrestricted,
            navigationDelegate: (NavigationRequest request) {
              if (request.url.contains(returnURL)) {
                final uri = Uri.parse(request.url);
                final payerID = uri.queryParameters['PayerID'];
                if (payerID != null) {
                  services
                      .executePayment(executeUrl, payerID, accessToken)
                      .then((id) {
                    widget.onFinish(id,'success');
                    Navigator.of(context).pop();
                  });
                } else {
                  widget.onFinish('','fail');
                  Navigator.of(context).pop();
                }
                // Navigator.of(context).pop();
              }
              if (request.url.contains(cancelURL)) {
                widget.onFinish('','fail');
                Navigator.of(context).pop();
              }
              return NavigationDecision.navigate;
            },
          ),
        ),
      );
    } else {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
                widget.onFinish('','fail');
              }),
          backgroundColor: Colors.black12,
          elevation: 0.0,
        ),
        body: Center(child: Container(child: CircularProgressIndicator())),
      );
    }
  }
}
