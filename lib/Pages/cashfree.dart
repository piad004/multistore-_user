/*
import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  var _selectedApp;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Cashfree SDK Sample'),
        ),
        body: Column(
          children: [
            Center(
              child: RaisedButton(
                child: Text('WEB CHECKOUT'),
                onPressed: () => makePayment(),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('SEAMLESS CARD'),
                onPressed: () => seamlessCardPayment(),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('SEAMLESS NETBANKING'),
                onPressed: () => seamlessNetbankingPayment(),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('SEAMLESS WALLET'),
                onPressed: () => seamlessWalletPayment(),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('SEAMLESS UPI COLLECT'),
                onPressed: () => seamlessUPIPayment(),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('SEAMLESS PAYPAL'),
                onPressed: () => seamlessPayPalPayment(),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('UPI INTENT'),
                onPressed: () => makeUpiPayment(),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('GET INSTALLED UPI APPS'),
                onPressed: () => getUPIApps(),
              ),
            ),
            Center(
              child: RaisedButton(
                child: Text('SEAMLESS UPI INTENT'),
                onPressed: () => seamlessUPIIntent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void getUPIApps() {
    CashfreePGSDK.getUPIApps().then((value) => {
      if(value != null && value.length > 0) {
        _selectedApp = value[0]
      }
    });
  }

  // WEB Intent
  makePayment() {
    //Replace with actual values
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "APP_ID";
    String customerPhone = "Customer Phone";
    String customerEmail = "sample@gmail.com";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));
  }

  // SEAMLESS - CARD
  Future<void> seamlessCardPayment() async {
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "APP_ID";
    String customerPhone = "Customer Phone";
    String customerEmail = "sample@gmail.com";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "card",
      "card_number": "ENTER CARD NUMBER",
      "card_expiryMonth": "MONTH IN MM format",
      "card_expiryYear": "EXPIRY IN YYYY format",
      "card_holder": "Card Holder Name",
      "card_cvv": "Card CVV"
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));
  }

  // SEAMLESS - NETBANKING
  Future<void> seamlessNetbankingPayment() async {
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "APP_ID";
    String customerPhone = "Customer Phone";
    String customerEmail = "sample@gmail.com";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "nb",
      "paymentCode": "ENTER Code", // Find Code here https://docs.cashfree.com/docs/net-banking
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));
  }

  // SEAMLESS - WALLET
  Future<void> seamlessWalletPayment() async {
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "APP_ID";
    String customerPhone = "Customer Phone";
    String customerEmail = "sample@gmail.com";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "wallet",
      "paymentCode": "ENTER Code", // Find Code here https://docs.cashfree.com/docs/wallets
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));
  }


  // SEAMLESS - UPI
  Future<void> seamlessUPIPayment() async {
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "APP_ID";
    String customerPhone = "Customer Phone";
    String customerEmail = "sample@gmail.com";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "upi",
      "upi_vpa": "ENTER Correct UPI ID here"
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));
  }


  // SEAMLESS - Paypal
  Future<void> seamlessPayPalPayment() async {
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "APP_ID";
    String customerPhone = "Customer Phone";
    String customerEmail = "sample@gmail.com";
    String notifyUrl = "https://test.gocashfree.com/notify";

    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,

      // EXTRA THINGS THAT NEEDS TO BE ADDED
      "paymentOption": "paypal"
    };

    CashfreePGSDK.doPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));
  }

  // UPI Intent
  Future<void> makeUpiPayment() async {
    //Replace with actual values
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "APP_ID";
    String customerPhone = "Customer Phone";
    String customerEmail = "sample@gmail.com";
    String notifyUrl = "https://test.gocashfree.com/notify";


    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl
    };

    CashfreePGSDK.doUPIPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));
  }


  // SEAMLESS UPI Intent
  Future<void> seamlessUPIIntent() async {
    //Replace with actual values
    String orderId = "ORDER_ID";
    String stage = "PROD";
    String orderAmount = "ORDER_AMOUNT";
    String tokenData = "TOKEN_DATA";
    String customerName = "Customer Name";
    String orderNote = "Order_Note";
    String orderCurrency = "INR";
    String appId = "APP_ID";
    String customerPhone = "Customer Phone";
    String customerEmail = "sample@gmail.com";
    String notifyUrl = "https://test.gocashfree.com/notify";


    Map<String, dynamic> inputParams = {
      "orderId": orderId,
      "orderAmount": orderAmount,
      "customerName": customerName,
      "orderNote": orderNote,
      "orderCurrency": orderCurrency,
      "appId": appId,
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "stage": stage,
      "tokenData": tokenData,
      "notifyUrl": notifyUrl,


      // For seamless UPI Intent
      "appName": _selectedApp["id"]
    };

    CashfreePGSDK.doUPIPayment(inputParams)
        .then((value) => value?.forEach((key, value) {
      print("$key : $value");
      //Do something with the result
    }));
  }
}*/
