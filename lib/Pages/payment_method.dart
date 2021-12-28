import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/list_tile.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Pages/order_placed.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/address.dart';
import 'package:user/bean/cartdetails.dart';
import 'package:user/bean/couponlist.dart';
import 'package:user/bean/creditcard.dart';
import 'package:user/bean/paymentstatus.dart';
import 'package:user/bean/paymongobean/payerrorpaymongo.dart';
import 'package:user/bean/paymongobean/paymentintentattach.dart';
import 'package:user/bean/paymongobean/paymentmethodmongo.dart';
import 'package:user/bean/paymongobean/paymongopayment.dart';
import 'package:user/bean/paymongobean/paymongopaymentintent.dart';
import 'package:user/bean/paymongobean/paymongosource.dart';
import 'package:user/bean/razropayorderstatusbean.dart';
import 'package:user/bean/striperes/chargeresponse.dart';
import 'package:user/paypal/paypalpayment.dart';

class PaymentPage extends StatefulWidget {
  final dynamic vendor_ids;
  final dynamic order_id;
  final dynamic cart_id;
  final double totalAmount;
  final PaymentVia tagObjs;
  final String orderArray;
  final ShowAddressNew addressDelivery;

  PaymentPage(this.vendor_ids, this.order_id, this.cart_id, this.totalAmount,
      this.tagObjs, this.orderArray,this.addressDelivery);

  @override
  State<StatefulWidget> createState() {
    return PaymentPageState(order_id, cart_id, totalAmount, tagObjs);
  }
}

class PaymentPageState extends State<PaymentPage> {
  BuildContext contextf;
  Razorpay _razorpay;
  var publicKey = '';
  var razorPayKey = '';
  double totalAmount = 0.0;
  double newtotalAmount = 0.0;
  PaymentVia paymentVia;
  dynamic currency = '';

  bool visiblity = false;
  String promocode = '';
  final dynamic order_id;
  final dynamic cart_id;

  bool razor = false;
  bool paystack = false;

  final _formKey = GlobalKey<FormState>();
  final _verticalSizeBox = const SizedBox(height: 20.0);
  final _horizontalSizeBox = const SizedBox(width: 10.0);
  String _cardNumber;
  String _cvv;
  int _expiryMonth = 0;
  int _expiryYear = 0;

  dynamic orderid;
  dynamic clientidR;
  dynamic screetKeyR;

  var showDialogBox = false;

  int radioId = -1;

  var setProgressText = 'Proceeding to placed order please wait!....';

  var showPaymentDialog = false;

  var _inProgress = false;

  double walletAmount = 0.0;
  double walletUsedAmount = 0.0;
  bool isFetch = false;

  bool iswallet = false;
  bool isCoupon = false;

  double coupAmount = 0.0;

  PaymentPageState(
      this.order_id, this.cart_id, this.totalAmount, this.paymentVia);

  List<CouponList> couponL = [];

  // Token _paymentToken;
  // PaymentMethod _paymentMethod;
  // String _error;
  // final String _currentSecret = null; //set this yourself, e.g using curl
  // PaymentIntentResult _paymentIntent;
  // Source _source;

  ScrollController _controller = ScrollController();

  @override
  void initState() {
    super.initState();
    newtotalAmount = double.parse('${totalAmount}');
    getCouponList();
    getWalletAmount();
  }

  void getWalletAmount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userId = prefs.getInt('user_id');
    setState(() {
      isFetch = true;
      currency = prefs.getString('curency');
    });
    var client = http.Client();
    var url = showWalletAmount;
    client.post(url, body: {
      'user_id': '${userId}',
    }).then((value) {
      if (value.statusCode == 200 && jsonDecode(value.body)['status'] == "1") {
        var jsonData = jsonDecode(value.body);
        var dataList = jsonData['data'] as List;
        setState(() {
          walletAmount = double.parse('${dataList[0]['wallet_credits']}');
          if (totalAmount > walletAmount) {
            if (walletAmount > 0.0) {
              iswallet = true;
            } else {
              iswallet = false;
            }
            totalAmount = totalAmount - walletAmount;
            walletUsedAmount = walletAmount;
          } else if (totalAmount < walletAmount) {
            if (walletAmount > 0.0) {
              iswallet = true;
            } else {
              iswallet = false;
            }
            totalAmount = 0.0;
            walletUsedAmount = newtotalAmount;
          } else {
            iswallet = false;
            walletUsedAmount = 0.0;
          }
        });
      }
      setState(() {
        isFetch = false;
      });
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print(e);
    });
  }

  void getCouponList() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String vendorId = preferences.getString('vendor_id');
    setState(() {
      currency = preferences.getString('curency');
    });
    var url = couponList;
    http.post(url, body: {
      'cart_id': '$cart_id',
      'vendor_id': '${vendorId}'
    }).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body)['data'] as List;
          List<CouponList> tagObjs = tagObjsJson
              .map((tagJson) => CouponList.fromJson(tagJson))
              .toList();
          setState(() {
            couponL.clear();
            couponL = tagObjs;
          });
        }
      }
    }).catchError((e) {
      print(e);
    });
  }

  void placedOrder(paymentStatus, paymentMethod, BuildContext context) {
    var locale = AppLocalizations.of(context);
    var url = checkOut;
    http.post(url, body: {
      'payment_method': '${paymentMethod}',
      'wallet': iswallet ? 'yes' : 'no',
      'payment_status': paymentStatus,
      'cart_id': '$cart_id'
    }).then((value) {
      print(value.body);
      if (value != null && value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          CartDetail details = CartDetail.fromJson(jsonData['data']);
          hitNavigator(cart_id, details.payment_method, details.payment_status,
              details.order_id, details.rem_price, context);
        } else {
          setState(() {
            showDialogBox = false;
          });
          Toast.show(jsonData['message'], context,
              duration: Toast.LENGTH_SHORT);
        }
      } else {
        setState(() {
          showDialogBox = false;
        });
        Toast.show(locale.somethingWentwrong, context,
            duration: Toast.LENGTH_SHORT);
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });
  }

  void hitNavigator(cart_id, payment_method, payment_status, order_id,
      rem_price, BuildContext context) async {
    var url = after_order_reward_msg;
    http.post(url, body: {
      'cart_id': '${cart_id}',
      'order_array': widget.orderArray
    }).then((value) {
      setState(() {
        showDialogBox = false;
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return OrderPlaced(
            payment_method, payment_status, cart_id, rem_price, currency, "1");
      }));
    }).catchError((e) {
      setState(() {
        showDialogBox = false;
      });
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return OrderPlaced(
            payment_method, payment_status, order_id, rem_price, currency, "1");
      }));
    });
  }

  void appCoupon(couponCode, BuildContext context) {
    var locale = AppLocalizations.of(context);
    var url = applyCoupon;
    http.post(url, body: {
      'coupon_code': '$couponCode',
      'cart_id': cart_id.toString()
    }).then((value) {
      if (value != null && value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          CartDetail details = CartDetail.fromJson(jsonData['data']);
          setState(() {
            isCoupon = true;
            totalAmount = double.parse(details.rem_price.toString());
            coupAmount = double.parse('${details.coupon_discount}');
            if (totalAmount > walletAmount) {
              if (walletAmount > 0.0) {
                iswallet = true;
              } else {
                iswallet = false;
              }
              totalAmount = totalAmount - walletAmount;
              walletUsedAmount = walletAmount;
            } else if (totalAmount < walletAmount) {
              if (walletAmount > 0.0) {
                iswallet = true;
              } else {
                iswallet = false;
              }
              totalAmount = 0.0;
              walletUsedAmount = newtotalAmount - coupAmount;
            } else {
              iswallet = false;
              walletUsedAmount = 0.0;
            }
            showDialogBox = false;
          });
        } else if (jsonData['status'] == "2") {
          CartDetail details = CartDetail.fromJson(jsonData['data']);
          setState(() {
            isCoupon = false;
            totalAmount = double.parse(details.total_price.toString());
            coupAmount = 0.0;
            if (totalAmount > walletAmount) {
              if (walletAmount > 0.0) {
                iswallet = true;
              } else {
                iswallet = false;
              }
              totalAmount = totalAmount - walletAmount;
              walletUsedAmount = walletAmount;
            } else if (totalAmount < walletAmount) {
              if (walletAmount > 0.0) {
                iswallet = true;
              } else {
                iswallet = false;
              }
              totalAmount = 0.0;
              walletUsedAmount = newtotalAmount;
            } else {
              iswallet = false;
              walletUsedAmount = 0.0;
            }
            showDialogBox = false;
          });
        } else {
          Toast.show(jsonData['message'], context,
              duration: Toast.LENGTH_SHORT);
          setState(() {
            radioId = -1;
            totalAmount = newtotalAmount;
            if (totalAmount > walletAmount) {
              if (walletAmount > 0.0) {
                iswallet = true;
              } else {
                iswallet = false;
              }
              totalAmount = totalAmount - walletAmount;
              walletUsedAmount = walletAmount;
            } else if (totalAmount < walletAmount) {
              if (walletAmount > 0.0) {
                iswallet = true;
              } else {
                iswallet = false;
              }
              totalAmount = 0.0;
              walletUsedAmount = newtotalAmount;
            } else {
              iswallet = false;
              walletUsedAmount = 0.0;
            }
            isCoupon = false;
            showDialogBox = false;
          });
        }
      } else {
        setState(() {
          totalAmount = newtotalAmount;
          radioId = -1;
          if (totalAmount > walletAmount) {
            if (walletAmount > 0.0) {
              iswallet = true;
            } else {
              iswallet = false;
            }
            totalAmount = totalAmount - walletAmount;
            walletUsedAmount = walletAmount;
          } else if (totalAmount < walletAmount) {
            if (walletAmount > 0.0) {
              iswallet = true;
            } else {
              iswallet = false;
            }
            totalAmount = 0.0;
            walletUsedAmount = newtotalAmount;
          } else {
            iswallet = false;
            walletUsedAmount = 0.0;
          }
          isCoupon = false;
          showDialogBox = false;
        });
        Toast.show(locale.somethingWentwrong, context,
            duration: Toast.LENGTH_SHORT);
      }
    }).catchError((e) {
      setState(() {
        totalAmount = newtotalAmount;
        radioId = -1;
        if (totalAmount > walletAmount) {
          if (walletAmount > 0.0) {
            iswallet = true;
          } else {
            iswallet = false;
          }
          totalAmount = totalAmount - walletAmount;
          walletUsedAmount = walletAmount;
        } else if (totalAmount < walletAmount) {
          if (walletAmount > 0.0) {
            iswallet = true;
          } else {
            iswallet = false;
          }
          totalAmount = 0.0;
          walletUsedAmount = newtotalAmount;
        } else {
          iswallet = false;
          walletUsedAmount = 0.0;
        }
        isCoupon = false;
        showDialogBox = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    if (contextf == null) {
      setState(() {
        contextf = context;
      });
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                locale.selectPymntMthdText,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: kMainTextColor),
              ),
              SizedBox(
                height: 5.0,
              ),
              Text(
                '${locale.amountPayText} $currency $totalAmount',
                style: Theme.of(context)
                    .textTheme
                    .headline6
                    .copyWith(color: kDisabledColor),
              ),
            ],
          ),
        ),
      ),
      body: isFetch
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 64,
              alignment: Alignment.center,
              child: CircularProgressIndicator(),
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 64,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    primary: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Visibility(
                            visible:
                                (paymentVia.payMode.paymentStatus != null &&
                                        '${paymentVia.payMode.paymentStatus}'
                                                .toUpperCase() ==
                                            'ON')
                                    ? true
                                    : false,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Visibility(
                                  visible: (paymentVia != null &&
                                      (('${paymentVia.paystack.paystackStatus}'
                                                  .toUpperCase() ==
                                              'YES') ||
                                          ('${paymentVia.stripe.stripeStatus}'
                                                  .toUpperCase() ==
                                              'YES') ||
                                          '${paymentVia.paymongobean.razorpayStatus}'
                                                  .toUpperCase() ==
                                              'YES')),
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    color: kCardBackgroundColor,
                                    child: Text(
                                      locale.creditDebitCard,
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                              color: kDisabledColor,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.67),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible: (paymentVia != null &&
                                      (('${paymentVia.paystack.paystackStatus}'
                                                  .toUpperCase() ==
                                              'YES') ||
                                          ('${paymentVia.stripe.stripeStatus}'
                                                  .toUpperCase() ==
                                              'YES') ||
                                          '${paymentVia.paymongobean.razorpayStatus}'
                                                  .toUpperCase() ==
                                              'YES')),
                                  child: BuildListTile(
                                    image: 'images/payment/credit_card.png',
                                    text: locale.debitcard,
                                    onTap: () {
                                      if ('${paymentVia.paystack.paystackStatus}'
                                              .toUpperCase() ==
                                          'YES') {
                                        setState(() {
                                          setProgressText =
                                              'Proceeding to placed order please wait!....';
                                          showDialogBox = true;
                                        });
                                        payStatck(
                                            "${paymentVia.paystack.paystackPublicKey}",
                                            (totalAmount * 100).toInt(),
                                            context,
                                            paymentVia
                                                .paystack.paymentCurrency);
                                      } else if ('${paymentVia.stripe.stripeStatus}'
                                              .toUpperCase() ==
                                          'YES') {
                                        setState(() {
                                          setProgressText =
                                              'Proceeding to placed order please wait!....';
                                          showDialogBox = true;
                                        });
                                        // StripePayment.setOptions(StripeOptions(
                                        //   publishableKey:
                                        //       '${paymentVia.stripe.stripePublishable}',
                                        //   merchantId:
                                        //       '${paymentVia.stripe.stripeMerchantId}',
                                        //   androidPayMode: 'true',
                                        // ));
                                        Navigator.of(context)
                                            .pushNamed(PageRoutes.stripecard)
                                            .then((value) {
                                          if (value != null) {
                                            CreditCard cardPay = value;
                                            // setStripePayment(
                                            //     paymentVia.stripe.stripeSecret,
                                            //     totalAmount,
                                            //     cardPay,
                                            //     paymentVia
                                            //         .stripe.paymentCurrency,
                                            //     context);
                                            setStripePayment(paymentVia.stripe.stripeSecret, totalAmount, cardPay, paymentVia.stripe.paymentCurrency, context);
                                          } else {
                                            Toast.show(
                                                'Payment cancelled', context,
                                                gravity: Toast.CENTER,
                                                duration: Toast.LENGTH_SHORT);
                                            setState(() {
                                              showDialogBox = false;
                                            });
                                          }
                                        }).catchError((e) {
                                          Toast.show(
                                              'Payment cancelled', context,
                                              gravity: Toast.CENTER,
                                              duration: Toast.LENGTH_SHORT);
                                          setState(() {
                                            showDialogBox = false;
                                          });
                                        });
                                      } else if ('${paymentVia.paymongobean.razorpayStatus}'
                                              .toUpperCase() ==
                                          'YES') {
                                        paymongoCreatePaymentIntent(
                                            '${paymentVia.paymongobean.razorpaySecret}',
                                            context,
                                            (totalAmount * 100).toInt(),
                                            '${paymentVia.paymongobean.paymentCurrency}');
                                      }
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible: (paymentVia != null &&
                                      (('${paymentVia.paystack.paystackStatus}'
                                                  .toUpperCase() ==
                                              'YES') ||
                                          ('${paymentVia.stripe.stripeStatus}'
                                                  .toUpperCase() ==
                                              'YES') ||
                                          '${paymentVia.paymongobean.razorpayStatus}'
                                                  .toUpperCase() ==
                                              'YES')),
                                  child: BuildListTile(
                                    image: 'images/payment/credit_card.png',
                                    text: locale.credticard,
                                    onTap: () {
                                      if ('${paymentVia.paystack.paystackStatus}'
                                              .toUpperCase() ==
                                          'YES') {
                                        setState(() {
                                          setProgressText =
                                              'Proceeding to placed order please wait!....';
                                          showDialogBox = true;
                                        });
                                        payStatck(
                                            "${paymentVia.paystack.paystackPublicKey}",
                                            (totalAmount * 100).toInt(),
                                            context,
                                            paymentVia
                                                .paystack.paymentCurrency);
                                      } else if ('${paymentVia.stripe.stripeStatus}'
                                              .toUpperCase() ==
                                          'YES') {
                                        setState(() {
                                          setProgressText =
                                              'Proceeding to placed order please wait!....';
                                          showDialogBox = true;
                                        });
                                        // StripePayment.setOptions(StripeOptions(
                                        //   publishableKey:
                                        //       '${paymentVia.stripe.stripePublishable}',
                                        //   merchantId:
                                        //       '${paymentVia.stripe.stripeMerchantId}',
                                        //   androidPayMode: 'test',
                                        // ));
                                        Navigator.of(context)
                                            .pushNamed(PageRoutes.stripecard)
                                            .then((value) {
                                          if (value != null) {
                                            CreditCard cardPay = value;
                                            // setStripePayment(
                                            //     paymentVia.stripe.stripeSecret,
                                            //     totalAmount,
                                            //     cardPay,
                                            //     paymentVia
                                            //         .stripe.paymentCurrency,
                                            //     context);
                                            setStripePayment(paymentVia.stripe.stripeSecret, totalAmount, cardPay, paymentVia.stripe.paymentCurrency, context);
                                          } else {
                                            Toast.show(
                                                'Payment cancelled', context,
                                                gravity: Toast.CENTER,
                                                duration: Toast.LENGTH_SHORT);
                                            setState(() {
                                              showDialogBox = false;
                                            });
                                          }
                                        }).catchError((e) {
                                          Toast.show(
                                              'Payment cancelled', context,
                                              gravity: Toast.CENTER,
                                              duration: Toast.LENGTH_SHORT);
                                          setState(() {
                                            showDialogBox = false;
                                          });
                                        });
                                      } else if ('${paymentVia.paymongobean.razorpayStatus}'
                                              .toUpperCase() ==
                                          'YES') {
                                        paymongoCreatePaymentIntent(
                                            '${paymentVia.paymongobean.razorpaySecret}',
                                            context,
                                            (totalAmount * 100).toInt(),
                                            '${paymentVia.paymongobean.paymentCurrency}');
                                      }
                                    },
                                  ),
                                ),
                              ],
                            )),
                        Visibility(
                          visible: (iswallet || isCoupon) ? true : false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                color: kCardBackgroundColor,
                                child: Text(
                                  locale.walletText.toUpperCase(),
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: kDisabledColor,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.67),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 20.0),
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible: iswallet, //iswallet
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'images/payment/wallet.png',
                                                height: 20.3,
                                              ),
                                              SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                locale.walletAmount,
                                                style: TextStyle(fontSize: 14),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '${currency} ${walletAmount.toStringAsFixed(2)}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: iswallet, //iswallet
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'images/payment/wallet.png',
                                                height: 20.3,
                                              ),
                                              SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                locale.walletAmount,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '- ${currency} ${walletUsedAmount.toStringAsFixed(2)}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Visibility(
                                      visible: isCoupon, //isCoupon
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Image.asset(
                                                'images/payment/coupon_amount.png',
                                                height: 20.3,
                                              ),
                                              SizedBox(
                                                width: 25,
                                              ),
                                              Text(
                                                locale.couponAmount,
                                                style: TextStyle(fontSize: 15),
                                              ),
                                            ],
                                          ),
                                          Text(
                                            '- ${currency} ${coupAmount.toStringAsFixed(2)}',
                                            style: TextStyle(fontSize: 15),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              'images/payment/amount.png',
                                              height: 20.3,
                                            ),
                                            SizedBox(
                                              width: 25,
                                            ),
                                            Text(
                                              locale.orderAmount,
                                              style: TextStyle(fontSize: 15),
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${currency} ${double.parse('$newtotalAmount').toStringAsFixed(2)}',
                                          style: TextStyle(fontSize: 15),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Visibility(
                          visible: (totalAmount > 0.0) ? true : false,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Visibility(
                                visible:
                                    (paymentVia.payMode.codStatus != null &&
                                            '${paymentVia.payMode.codStatus}'
                                                    .toUpperCase() ==
                                                'ON')
                                        ? true
                                        : false,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          vertical: 8.0, horizontal: 16.0),
                                      color: kCardBackgroundColor,
                                      child: Text(
                                        locale.cashText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                                color: kDisabledColor,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.67),
                                      ),
                                    ),
                                    BuildListTile(
                                        image: 'images/payment/amount.png',
                                        text: 'Cash on Delivery',
                                        onTap: () {
                                          setState(() {
                                            setProgressText =
                                                'Proceeding to placed order please wait!....';
                                            showDialogBox = true;
                                          });
                                          placedOrder(
                                              "success", "COD", context);
                                        }),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: (paymentVia.payMode.paymentStatus !=
                                            null &&
                                        '${paymentVia.payMode.paymentStatus}'
                                                .toUpperCase() ==
                                            'ON')
                                    ? true
                                    : false,
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.stretch,
                                  children: [
                                    (totalAmount > 0.0 &&
                                            paymentVia != null &&
                                            (('${paymentVia.paystack.paystackStatus}'.toUpperCase() == 'YES') ||
                                                ('${paymentVia.razorpay.razorpayStatus}'
                                                        .toUpperCase() ==
                                                    'YES') ||
                                                ('${paymentVia.paypal.paypalStatus}'
                                                        .toUpperCase() ==
                                                    'YES') ||
                                                ('${paymentVia.paymongobean.razorpayStatus}'
                                                        .toUpperCase() ==
                                                    'YES') ||
                                                ('${paymentVia.stripe.stripeStatus}'
                                                        .toUpperCase() ==
                                                    'YES')))
                                        ? Container(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8.0,
                                                horizontal: 16.0),
                                            color: kCardBackgroundColor,
                                            child: Text(
                                              locale.onlinePaymentText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                      color: kDisabledColor,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      letterSpacing: 0.67),
                                            ),
                                          )
                                        : SizedBox.shrink(),
                                    Visibility(
                                        visible: (paymentVia != null &&
                                            '${paymentVia.razorpay.razorpayStatus}'
                                                    .toUpperCase() ==
                                                'YES'),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: BuildListTile(
                                            image:
                                                'images/payment/credit_card.png',
                                            text: 'RazorPay',
                                            onTap: () {
                                              setState(() {
                                                setProgressText =
                                                    'Proceeding to placed order please wait!....';
                                                showDialogBox = true;
                                              });
                                              openCheckout(
                                                  '${paymentVia.razorpay.razorpayKey}',
                                                  (totalAmount * 100),
                                                  '${paymentVia.razorpay.razorpaySecret}',
                                                  context);
                                            },
                                          ),
                                        )),
                                    Visibility(
                                        visible: (paymentVia != null &&
                                            '${paymentVia.paymongobean.razorpayStatus}'
                                                    .toUpperCase() ==
                                                'YES'),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: BuildListTile(
                                            image:
                                                'images/payment/credit_card.png',
                                            text: 'Paymongo',
                                            onTap: () {
                                              setState(() {
                                                setProgressText =
                                                    'Proceeding to placed order please wait!....';
                                                showDialogBox = true;
                                              });
                                              paymongoCreatePaymentIntent(
                                                  '${paymentVia.paymongobean.razorpaySecret}',
                                                  context,
                                                  (totalAmount * 100).toInt(),
                                                  '${paymentVia.paymongobean.paymentCurrency}');
                                            },
                                          ),
                                        )),
                                    Visibility(
                                        visible: (paymentVia != null &&
                                            '${paymentVia.paystack.paystackStatus}'
                                                    .toUpperCase() ==
                                                'YES'),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: BuildListTile(
                                            image:
                                                'images/payment/credit_card.png',
                                            text: 'Paystack',
                                            onTap: () {
                                              setState(() {
                                                setProgressText =
                                                    'Proceeding to placed order please wait!....';
                                                showDialogBox = true;
                                              });
                                              payStatck(
                                                  "${paymentVia.paystack.paystackPublicKey}",
                                                  (totalAmount * 100).toInt(),
                                                  context,
                                                  paymentVia.paystack
                                                      .paymentCurrency);
                                            },
                                          ),
                                        )),
                                    Visibility(
                                        visible: (paymentVia != null &&
                                            '${paymentVia.paypal.paypalStatus}'
                                                    .toUpperCase() ==
                                                'YES'),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: BuildListTile(
                                            image:
                                                'images/payment/credit_card.png',
                                            text: 'Paypal',
                                            onTap: () {
                                              setState(() {
                                                setProgressText =
                                                    'Proceeding to placed order please wait!....';
                                                showDialogBox = true;
                                              });
                                              Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return PaypalPayment(
                                                    apCurrency:
                                                        '${paymentVia.paypal.paymentCurrency}',
                                                    clientId:
                                                        '${paymentVia.paypal.paypalClientId}',
                                                    secret:
                                                        '${paymentVia.paypal.paypalSecret}',
                                                    amount: '$totalAmount',
                                                    onFinish: (id, status) {
                                                      print('$id $status');
                                                      if (status == 'success') {
                                                        placedOrder("success",
                                                            "Card", context);
                                                      } else {
                                                        setState(() {
                                                          showDialogBox = false;
                                                        });
                                                      }
                                                    });
                                              })).catchError((e) {
                                                setState(() {
                                                  showDialogBox = false;
                                                });
                                              });
                                            },
                                          ),
                                        )),
                                    Visibility(
                                        visible: (paymentVia != null &&
                                            '${paymentVia.stripe.stripeStatus}'
                                                    .toUpperCase() ==
                                                'YES'),
                                        child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: BuildListTile(
                                            image:
                                                'images/payment/credit_card.png',
                                            text: 'Stripe',
                                            onTap: () {
                                              setState(() {
                                                setProgressText =
                                                    'Proceeding to placed order please wait!....';
                                                showDialogBox = true;
                                              });
                                              // StripePayment.setOptions(StripeOptions(
                                              //   publishableKey:
                                              //   '${paymentVia.stripe.stripePublishable}',
                                              //   merchantId:
                                              //   '${paymentVia.stripe.stripeMerchantId}',
                                              //   androidPayMode: 'test',
                                              // ));
                                              Navigator.of(context)
                                                  .pushNamed(PageRoutes.stripecard)
                                                  .then((value) {
                                                if (value != null) {
                                                  CreditCard cardPay = value;
                                                  // setStripePayment(
                                                  //     paymentVia.stripe.stripeSecret,
                                                  //     totalAmount,
                                                  //     cardPay,
                                                  //     paymentVia
                                                  //         .stripe.paymentCurrency,
                                                  //     context);
                                                  setStripePayment(paymentVia.stripe.stripeSecret, totalAmount, cardPay, paymentVia.stripe.paymentCurrency, context);
                                                } else {
                                                  Toast.show(
                                                      'Payment cancelled', context,
                                                      gravity: Toast.CENTER,
                                                      duration: Toast.LENGTH_SHORT);
                                                  setState(() {
                                                    showDialogBox = false;
                                                  });
                                                }
                                              }).catchError((e) {
                                                Toast.show(
                                                    'Payment cancelled', context,
                                                    gravity: Toast.CENTER,
                                                    duration: Toast.LENGTH_SHORT);
                                                setState(() {
                                                  showDialogBox = false;
                                                });
                                              });
                                            },
                                          ),
                                        )),
                                    Visibility(
                                        visible: (paymentVia != null &&
                                            '${paymentVia.paymongobean.razorpayStatus}'
                                                    .toUpperCase() ==
                                                'YES'),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.stretch,
                                          children: [
                                            Container(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: 8.0,
                                                  horizontal: 16.0),
                                              color: kCardBackgroundColor,
                                              child: Text(
                                                locale.externalwallet,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                        color: kDisabledColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        letterSpacing: 0.67),
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: BuildListTile(
                                                image:
                                                    'images/payment/credit_card.png',
                                                text: 'G-Cash',
                                                onTap: () {
                                                  setState(() {
                                                    setProgressText =
                                                        'Proceeding to placed order please wait!....';
                                                    showDialogBox = true;
                                                  });
                                                  paymongoCreateSource(
                                                      "${paymentVia.paymongobean.razorpaySecret}",
                                                      context,
                                                      (double.parse(
                                                                  '${totalAmount}') *
                                                              100)
                                                          .toInt(),
                                                      'gcash');
                                                },
                                              ),
                                            ),
                                            Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: BuildListTile(
                                                image:
                                                    'images/payment/credit_card.png',
                                                text: 'GrabPay',
                                                onTap: () {
                                                  setState(() {
                                                    setProgressText =
                                                        'Proceeding to placed order please wait!....';
                                                    showDialogBox = true;
                                                  });
                                                  paymongoCreateSource(
                                                      "${paymentVia.paymongobean.razorpaySecret}",
                                                      context,
                                                      (double.parse(
                                                                  '${totalAmount}') *
                                                              100)
                                                          .toInt(),
                                                      'grab_pay');
                                                },
                                              ),
                                            ),
                                          ],
                                        )),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 16.0),
                                color: kCardBackgroundColor,
                                child: Text(
                                  locale.promoCodeText,
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          color: kDisabledColor,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.67),
                                ),
                              ),
                              Divider(
                                color: kCardBackgroundColor,
                                thickness: 6.7,
                              ),
                              Container(
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.55,
                                            height: 45,
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.symmetric(
                                                vertical: 2.0),
                                            child: TextFormField(
                                              textAlign: TextAlign.center,
                                              decoration: InputDecoration(
                                                hintText:
                                                    "Enter Your promo code",
                                                fillColor: Colors.white,
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: BorderSide(
                                                      color: kMainColor,
                                                      width: 1),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: BorderSide(
                                                      color: kMainColor,
                                                      width: 1),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                  borderSide: BorderSide(
                                                      color: kMainColor,
                                                      width: 1),
                                                ),
                                              ),
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 13),
                                              cursorColor: kMainColor,
                                              showCursor: false,
                                              keyboardType: TextInputType.text,
                                              onChanged: (val) {
                                                setState(() => promocode = val);
                                              },
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                if (totalAmount != 0.0) {
                                                  visiblity = !visiblity;
                                                  setProgressText =
                                                      'Applying coupon please wait!....';
                                                  showDialogBox = true;
                                                  appCoupon(promocode, context);
                                                } else {
                                                  Toast.show(
                                                      locale
                                                          .couponCodeNotApplicable,
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_SHORT,
                                                      gravity: Toast.CENTER);
                                                }
                                              });
                                            },
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.28,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(40),
                                                  color: kMainColor),
                                              child: Text(
                                                locale.apply,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                    fontSize: 15,
                                                    color: kWhiteColor),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                color: kCardBackgroundColor,
                                thickness: 6.7,
                              ),
                              Visibility(
                                visible: (couponL != null && couponL.length > 0)
                                    ? true
                                    : false,
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 20),
                                  child: (couponL != null && couponL.length > 0)
                                      ? ListView.builder(
                                          primary: false,
                                          shrinkWrap: true,
                                          itemCount: couponL.length,
                                          itemBuilder: (context, t) {
                                            return Column(
                                              children: [
                                                Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 2.3,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Expanded(
                                                        child: Text(
                                                            '${couponL[t].coupon_code}\n${couponL[t].coupon_description}')),
                                                    Radio(
                                                        value: t,
                                                        groupValue: radioId,
                                                        toggleable: true,
                                                        onChanged: (val) {
                                                          print('${val}');
                                                          print(
                                                              '${radioId} - ${t}');
                                                          if (radioId != t ||
                                                              radioId == -1) {
                                                            setState(() {
                                                              if (totalAmount !=
                                                                  0.0) {
                                                                radioId = t;
                                                                print(
                                                                    '${radioId} - ${t}');
                                                                setProgressText =
                                                                    'Applying coupon please wait!....';
                                                                showDialogBox =
                                                                    true;
                                                                appCoupon(
                                                                    couponL[t]
                                                                        .coupon_code,
                                                                    context);
                                                              } else {
                                                                Toast.show(
                                                                    locale
                                                                        .couponCodeNotApplicable,
                                                                    context,
                                                                    duration: Toast
                                                                        .LENGTH_SHORT,
                                                                    gravity: Toast
                                                                        .CENTER);
                                                              }
                                                            });
                                                          } else {
                                                            setState(() {
                                                              radioId = -1;
                                                              showDialogBox =
                                                                  true;
                                                              appCoupon(
                                                                  couponL[t]
                                                                      .coupon_code,
                                                                  context);
                                                            });
                                                          }
                                                        })
                                                  ],
                                                ),
                                                Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 2.3,
                                                ),
                                              ],
                                            );
                                          })
                                      : Container(),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              )
                            ],
                          ),
                        ),
                        Visibility(
                            visible: (totalAmount > 0.0) ? false : true,
                            child: Container(
                              height: 250,
                              alignment: Alignment.bottomCenter,
                              child: SizedBox(
                                height: 40,
                                width: 150,
                                child: RaisedButton(
                                  onPressed: () {
                                    if (!showDialogBox) {
                                      setState(() {
                                        showDialogBox = true;
                                      });
                                      placedOrder('success', 'wallet', context);
                                    }
                                  },
                                  child: Text(
                                    locale.placeOrder,
                                    style: TextStyle(
                                        color: kWhiteColor,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  color: kMainColor,
                                  highlightColor: kMainColor,
                                  focusColor: kMainColor,
                                  splashColor: kMainColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ),
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                  Positioned.fill(
                      child: Visibility(
                    visible: showDialogBox,
                    child: GestureDetector(
                      onTap: () {},
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        // color: black_color.withOpacity(0.6),
                        height: MediaQuery.of(context).size.height - 100,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Align(
                          alignment: Alignment.center,
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    ),
                  )),
                ],
              )),
    );
  }

  var payPlugin = PaystackPlugin();

  void payStatck(String key, int price, BuildContext context,
      String paymentCurrency) async {
    if (key.startsWith("pk_")) {
      payPlugin.initialize(publicKey: key).then((value) {
        _startAfreshCharge(price, paymentCurrency);
      }).catchError((e) {
        setState(() {
          showDialogBox = false;
        });
        print(e);
      });
    } else {
      setState(() {
        showDialogBox = false;
      });
      Toast.show('Server down please use another payment method.', context,
          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
    }
  }

  void razorPay(
      keyRazorPay, amount, String secretKey, BuildContext context) async {
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    createOrderId(keyRazorPay, secretKey, amount.toInt(), 'INR',
        'order_trn_${DateTime.now().millisecond}', _razorpay, context);
  }

  void openCheckout(
      keyRazorPay, amount, String secretKey, BuildContext context) async {
    razorPay(keyRazorPay, amount, secretKey, context);
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    if (response.paymentId != null) {
      placedOrder("success", "Card", contextf);
    } else {
      checkRazorpayOrderStatus(clientidR, screetKeyR, orderid, contextf);
    }
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    checkRazorpayOrderStatus(clientidR, screetKeyR, orderid, contextf);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // print('pay wallet');
    // checkRazorpayOrderStatus(clientidR,screetKeyR,orderid,contextf);
  }

  void createOrderId(
      dynamic clientid,
      dynamic secretKey,
      dynamic amount,
      dynamic currency,
      dynamic receiptId,
      Razorpay razorpay,
      BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var authn = 'Basic ' + base64Encode(utf8.encode('$clientid:$secretKey'));
    Map<String, String> headers = {
      'Authorization': authn,
      'Content-Type': 'application/json'
    };

    var body = {
      'amount': '$amount',
      'currency': '$currency',
      'receipt': '$receiptId',
      'payment_capture': true,
    };

    //
    http
        .post(orderApiRazorpay, body: jsonEncode(body), headers: headers)
        .then((value) {
      print('orderid data - ${value.body}');
      var jsData = jsonDecode(value.body);
      if (jsData['error'] != null) {
        setState(() {
          showDialogBox = false;
        });
        Toast.show(
            'Something went wrong please contact with razorpay customer care.',
            context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else {
        print('${jsData['id']}');
        orderid = '${jsData['id']}';
        clientidR = '$clientid';
        screetKeyR = '$secretKey';
        Timer(Duration(seconds: 1), () async {
          var options = {
            'key': '${clientid}',
            'amount': amount,
            'name': '${prefs.getString('user_name')}',
            'description': 'Shopping Charges',
            'order_id': '${jsData['id']}',
            'prefill': {
              'contact': '${prefs.getString('user_phone')}',
              'email': '${prefs.getString('user_email')}'
            },
            'external': {
              'wallets': ['paytm']
            }
          };

          try {
            _razorpay.open(options);
          } catch (e) {
            setState(() {
              showDialogBox = false;
            });
            debugPrint(e);
          }
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });
  }

  void checkRazorpayOrderStatus(dynamic clientid, dynamic secretKey,
      dynamic orderid, BuildContext context) async {
    print('$orderid');
    var authn = 'Basic ' + base64Encode(utf8.encode('$clientid:$secretKey'));
    Map<String, String> headers = {
      'Authorization': authn,
      'Content-Type': 'application/json'
    };
    http
        .get(Uri.parse('$orderApiRazorpay/$orderid/payments'), headers: headers)
        .then((value) {
      print('orderid data - ${value.body}');
      var jsData = jsonDecode(value.body);
      if (jsData['error'] != null) {
        setState(() {
          showDialogBox = false;
        });
        Toast.show(
            'Something went wrong please contact with razorpay customer care.',
            context,
            duration: Toast.LENGTH_SHORT,
            gravity: Toast.CENTER);
      } else {
        RazorpayOrderStatusBean rPayStaus =
            RazorpayOrderStatusBean.fromJson(jsonDecode(value.body));
        if (int.parse('${rPayStaus.count}') > 0) {
          if ('${rPayStaus.items[0].status}'.toUpperCase() ==
                  'authorized'.toUpperCase() ||
              '${rPayStaus.items[0].status}'.toUpperCase() ==
                  'captured'.toUpperCase()) {
            placedOrder("success", "Card", contextf);
          } else {
            setState(() {
              showDialogBox = false;
            });
            Toast.show(
                'Something went wrong please contact with razorpay customer care.',
                context,
                duration: Toast.LENGTH_SHORT,
                gravity: Toast.CENTER);
          }
        } else {
          setState(() {
            showDialogBox = false;
          });
          Toast.show(
              'Something went wrong please contact with razorpay customer care.',
              context,
              duration: Toast.LENGTH_SHORT,
              gravity: Toast.CENTER);
        }
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });
  }

  _startAfreshCharge(int price, String paymentCurrency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // _formKey.currentState.save();

    Charge charge = Charge()
      ..amount = price // In base currency
      ..email = '${prefs.getString('user_email')}'
      ..currency = '$paymentCurrency'
      ..card = _getCardFromUI()
      ..reference = _getReference();

    _chargeCard(charge);
  }

  _chargeCard(Charge charge) async {
    payPlugin.chargeCard(context, charge: charge).then((value) {
      print('${value.status}');
      print('${value.toString()}');
      print('${value.card}');

      if (value.status && value.message == "Success") {
        placedOrder("success", "Card", context);
      }
    }).catchError((e) {
      setState(() {
        showDialogBox = false;
      });
    });
  }

  String _getReference() {
    String platform;
    if (Platform.isIOS) {
      platform = 'iOS';
    } else {
      platform = 'Android';
    }

    return 'ChargedFrom${platform}_${DateTime.now().millisecondsSinceEpoch}';
  }

  PaymentCard _getCardFromUI() {
    return PaymentCard(
      number: _cardNumber,
      cvc: _cvv,
      expiryMonth: _expiryMonth,
      expiryYear: _expiryYear,
    );
  }

  void setStripePayment(dynamic clientScretKey, double amount,
      CreditCard creditCardPay, String paymentCurrency, BuildContext context) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // print('${creditCardPay.toJson().toString()}');
    Map<String, String> headers = {
      'Authorization':
          'Bearer $clientScretKey',
      'Content-Type': 'application/x-www-form-urlencoded'
    };

    // print('${creditCardPay.toJson().toString()}');

    var body1 = {
      'type': 'card',
      'card[number]': '${creditCardPay.number}',
      'card[exp_month]': '${creditCardPay.expMonth}',
      'card[exp_year]': '${creditCardPay.expYear}',
      'card[cvc]': '${creditCardPay.cvc}',
      'billing_details[address][line1]': '${widget.addressDelivery.address}',
      'billing_details[address][postal_code]': '${widget.addressDelivery.pincode}',
      'billing_details[address][state]': '${widget.addressDelivery.state}',
      'billing_details[email]': '${prefs.getString('user_email')}',
      'billing_details[name]': '${prefs.getString('user_name')}',
      'billing_details[phone]': '${prefs.getString('user_phone')}',
    };

    http
        .post(Uri.parse('https://api.stripe.com/v1/payment_methods'),
            body: body1, headers: headers)
        .then((value) {
      print(value.body);
      var jsP = jsonDecode(value.body);
      if(jsP['error']!=null){
        setState(() {
          showDialogBox = false;
        });
      }else{
        createPaymentIntent('${amount.toInt() * 100}', '$paymentCurrency',
            headers, jsP, clientScretKey, context);
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });

    // StripePayment.createPaymentMethod(PaymentMethodRequest(card: creditCardPay))
    //     .then((value) {
    //   print('pt - ${value.toJson().toString()}');
    //   createPaymentIntent('${amount.toInt() * 100}', '$paymentCurrency',
    //       headers, value, clientScretKey, context);
    // }).catchError((e) {
    //   Toast.show(e.message, context,
    //       gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
    //   setState(() {
    //     showDialogBox = false;
    //   });
    // });
  }

  void createPaymentIntent(
      String amount,
      String currency,
      Map<String, String> hearder,
      dynamic paymentMethod,
      clientScretKey,
      BuildContext context) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card',
        'description': 'Shopping Charges on $appname'
      };
      http.post(paymentApiUrl, body: body, headers: hearder).then((value) {
        var js = jsonDecode(value.body);
        if(js['error']!=null){
          setState(() {
            showDialogBox = false;
          });
        }else{
          confirmCreatePaymentIntent(amount, currency, hearder, paymentMethod, js, clientScretKey, context);
        }
      }).catchError((e) {
        print('dd ${e}');
        Toast.show(e.message, context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        setState(() {
          showDialogBox = false;
        });
      });
    } catch (err) {
      Toast.show(
          'something went wrong with your payment if any amount deduct please wait for 10-15 working days.',
          context,
          gravity: Toast.CENTER,
          duration: Toast.LENGTH_SHORT);
      setState(() {
        showDialogBox = false;
      });
    }
  }

  void confirmCreatePaymentIntent(String amount,
      String currency,
      Map<String, String> hearder,
      dynamic paymentMethod,
      dynamic payintent,
      clientScretKey,
      BuildContext context) async{

    var body1 = {
      'payment_method': '${paymentMethod['id']}',
      'use_stripe_sdk': 'false',
      'return_url': '$imageBaseUrl'+'resources/views/admin/paymentvia/payment.php',
    };

    http.post(Uri.parse('$paymentApiUrl/${payintent['id']}/confirm'),
        body: body1, headers: hearder)
        .then((value) {
      print(value.body);
      var js = jsonDecode(value.body);
      if(js['error']!=null){
        setState(() {
          showDialogBox = false;
        });
      }else{
        if('${js['status']}'=='succeeded'){
          placedOrder("success", "Card",context);
        }else if('${js['status']}'=='requires_action'){
if(js['next_action']!=null && js['next_action']['redirect_to_url']!=null){
  Navigator.of(context).pushNamed(PageRoutes.paymentdoned, arguments: {
    'url': js['next_action']['redirect_to_url']['url']
  }).then((value) {
confirmPaymentStripe(payintent['id'], hearder);
  }).catchError((e) {
    print(e);
    setState(() {
      showDialogBox = false;
    });
  });
}else{
  setState(() {
    showDialogBox = false;
  });
}
        }
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });

  }

  void confirmPaymentStripe(dynamic jsValue, dynamic hearder) async{
    http.get(Uri.parse('$paymentApiUrl/$jsValue'),headers: hearder)
        .then((value) {
      print(value.body);
      var js = jsonDecode(value.body);
      if(js['error']!=null){
        setState(() {
          showDialogBox = false;
        });
      }else{
        print(js['status']);
        if('${js['status']}'=='succeeded'){
          placedOrder("success", "Card",context);
        }else{
          setState(() {
            showDialogBox = false;
          });
        }
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });
  }

  void createCharge(String tokenId, dynamic secretKey, dynamic currency,
      dynamic amount, Map<String, String> headers) async {
    try {
      Map<String, dynamic> body = {
        'amount': '$amount',
        'currency': '$currency',
        'source': tokenId,
        'description': 'Shopping Charges'
      };
      http.post(Uri.parse('https://api.stripe.com/v1/charges'), body: body, headers: headers)
          .then((value) {
        print('ss - ${value.body}');
        if (value.body.toString().contains('error')) {
          var jsd = jsonDecode(value.body);
          ErrorSt errorResp = ErrorSt.fromJson(jsd['error']);
          Toast.show('${errorResp.message}', context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          setState(() {
            showDialogBox = false;
          });
        } else {
          StripeChargeResponse chargeResp =
              StripeChargeResponse.fromJson(jsonDecode(value.body));
          if ('${chargeResp.status}'.toUpperCase() ==
              'succeeded'.toUpperCase()) {
            placedOrder("success", "Card", context);
          } else {
            setState(() {
              showDialogBox = false;
            });
          }
        }
      });
    } catch (err) {
      print('err charging user: ${err.toString()}');
      setState(() {
        showDialogBox = false;
      });
    }
  }

  //paymongo
  void paymongoCreatePaymentMethod(PaymentIntentPaymongo pday,
      Map<String, String> headers, BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Navigator.of(context).pushNamed(PageRoutes.paymongocd).then((cardValue) {
      print('${cardValue.toString()}');
      List<dynamic> cardDetaiils = List.from(cardValue);
      print('${cardDetaiils.toString()}');
      if (cardDetaiils != null && cardDetaiils.length == 5) {
        print('${cardDetaiils.toString()}');
        var carddetails = {
          'card_number': '${cardDetaiils[0]}'.replaceAll(' ', ''),
          'exp_month': int.parse('${cardDetaiils[1]}'),
          'exp_year': int.parse('${cardDetaiils[2]}'),
          'cvc': '${cardDetaiils[3]}',
        };
        var billing = {
          "email": "${prefs.getString('user_email')}",
          "name": "${prefs.getString('user_name')}",
          "phone": "${prefs.getString('user_phone')}"
        };

        var body = {
          'type': 'card',
          'details': carddetails,
          'billing': billing,
        };

        var bodyd = {
          "data": {"type": "payment_method", "attributes": body}
        };

        http
            .post(paymentMethod, body: jsonEncode(bodyd), headers: headers)
            .then((value) {
          var jsonD = jsonDecode(value.body);
          PaymentMethodPaymongo pmpa = PaymentMethodPaymongo.fromJson(jsonD);
          if (pmpa.data.id != null) {
            paymongoAtachPaymentIntent(pday, pmpa, context, headers);
          } else {
            PayErrorPaymongo payErr =
                PayErrorPaymongo.fromJson(jsonDecode(value.body));
            if (payErr != null) {
              Toast.show('${payErr.errors[0].detail}'.split('.')[1], context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
            } else {
              Toast.show('something went wrong!', context,
                  gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
            }
            setState(() {
              showDialogBox = false;
            });
          }
        }).catchError((e) {
          print(e);
          setState(() {
            showDialogBox = false;
          });
        });
      } else {
        setState(() {
          showDialogBox = false;
        });
        Toast.show('Payment Cancel', context,
            gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
      Toast.show('Payment Cancel', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
    });
  }

  void paymongoCreatePaymentIntent(dynamic clientSceret, BuildContext context,
      int amount, String currencyPayment) async {
    var keys = base64Encode(utf8.encode('$clientSceret'));
    var authn = 'Basic ' + keys;
    print(authn);
    Map<String, String> headers = {
      'Authorization': authn,
      'Content-Type': 'application/json'
    };
    var bodyd = {
      "data": {
        "type": "payment_intent",
        "attributes": {
          'amount': amount,
          'payment_method_allowed': ["card"],
          "payment_method_options": {
            "card": {"request_three_d_secure": "any"}
          },
          "description": "Shopping Charges",
          "currency": "PHP",
          "payments": [],
          "status": "awaiting_payment_method",
        }
      }
    };
    http
        .post(paymentIntent, body: jsonEncode(bodyd), headers: headers)
        .then((value) {
      print('${value.body}');
      PaymentIntentPaymongo pday =
          PaymentIntentPaymongo.fromJson(jsonDecode(value.body));
      if (pday != null && pday.data != null) {
        paymongoCreatePaymentMethod(pday, headers, context);
      } else {
        PayErrorPaymongo payErr =
            PayErrorPaymongo.fromJson(jsonDecode(value.body));
        if (payErr != null) {
          Toast.show('${payErr.errors[0].detail}'.split('.')[1], context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        } else {
          Toast.show('something went wrong!', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        }
        setState(() {
          showDialogBox = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });
  }

  void paymongoAtachPaymentIntent(
      PaymentIntentPaymongo pday,
      PaymentMethodPaymongo pmpa,
      BuildContext context,
      Map<String, String> headers) async {
    var bodyd = {
      "data": {
        "attributes": {
          'payment_method': '${pmpa.data.id}',
          'client_key': '${pday.data.attributes.clientKey}',
          'return_url':'$imageBaseUrl'+'resources/views/admin/paymentvia/payment.php',
        }
      }
    };

    http
        .post(Uri.parse('$paymentIntent/${pday.data.id}/attach'),
            body: jsonEncode(bodyd), headers: headers)
        .then((value) {
      print('${value.body}');
      PaymentAttachPaymongo padm =
          PaymentAttachPaymongo.fromJson(jsonDecode(value.body));
      if (padm != null) {
        if (padm.data.attributes.payments != null &&
            padm.data.attributes.payments.length > 0) {
          if (padm.data.attributes.payments[0].attributes.status == 'paid') {
            placedOrder('success', 'Card', context);
          }
        } else if (padm.data.attributes.nextAction != null) {
          Navigator.of(context).pushNamed(PageRoutes.paymentdoned, arguments: {
            'url': padm.data.attributes.nextAction.redirect.url
          }).then((value) {
            getPaymentStatusPaymongo(
                padm.data.id, context, headers, padm.data.attributes.clientKey);
          }).catchError((e) {
            print(e);
            setState(() {
              showDialogBox = false;
            });
          });
        } else {
          setState(() {
            showDialogBox = false;
          });
        }
      } else {
        PayErrorPaymongo payErr =
            PayErrorPaymongo.fromJson(jsonDecode(value.body));
        if (payErr != null) {
          Toast.show('${payErr.errors[0].detail}'.split('.')[1], context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        } else {
          Toast.show('something went wrong!', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        }
        setState(() {
          showDialogBox = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });
  }

  void getPaymentStatusPaymongo(dynamic id, BuildContext context,
      Map<String, String> headers, String clientKey) {
    var queryParameters = {"client_key": "$clientKey"};
    var uri = Uri.https(
        '$baseUrlPaymongo', 'v1/payment_intents/$id', queryParameters);
    http.get(uri, headers: headers).then((value) {
      print('vb - ${value.body}');
      PaymentAttachPaymongo padm =
          PaymentAttachPaymongo.fromJson(jsonDecode(value.body));
      if (padm != null) {
        if (padm.data.attributes.payments != null &&
            padm.data.attributes.payments.length > 0) {
          if (padm.data.attributes.payments[0].attributes.status == 'paid') {
            placedOrder('success', 'Card', context);
          } else {
            Toast.show('${padm.data.attributes.status}', context,
                gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
            setState(() {
              showDialogBox = false;
            });
          }
        } else {
          Toast.show('${padm.data.attributes.status}', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
          setState(() {
            showDialogBox = false;
          });
        }
      } else {
        PayErrorPaymongo payErr =
            PayErrorPaymongo.fromJson(jsonDecode(value.body));
        if (payErr != null) {
          Toast.show('${payErr.errors[0].detail}'.split('.')[1], context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        } else {
          Toast.show('something went wrong!', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        }
        setState(() {
          showDialogBox = false;
        });
      }
    }).catchError((e) {
      Toast.show('something went wrong!', context,
          gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
      setState(() {
        showDialogBox = false;
      });
    });
  }

  void paymongoCreateSource(dynamic clientSceret, BuildContext context,
      int amount, String type) async {
    var keys = base64Encode(utf8.encode('$clientSceret'));
    var authn = 'Basic ' + keys;
    print(authn);
    Map<String, String> headers = {
      'Authorization': authn,
      'Content-Type': 'application/json'
    };
    var bodyd = {
      "data": {
        "type": "source",
        "attributes": {
          "amount": amount,
          "currency": "PHP",
          "redirect": {
            "failed": "$imageBaseUrl"+"resources/views/admin/paymentvia/payment.php",
            "success": "$imageBaseUrl"+"resources/views/admin/paymentvia/payment.php"
          },
          "type": type
        }
      }
    };

    http
        .post(Uri.parse('https://api.paymongo.com/v1/sources'),
            body: jsonEncode(bodyd), headers: headers)
        .then((value) {
      print('${value.body}');
      PayMongoSource pday = PayMongoSource.fromJson(jsonDecode(value.body));
      if (pday != null && pday.data != null) {
        Navigator.of(context).pushNamed(PageRoutes.paymentdoned, arguments: {
          'url': pday.data.attributes.redirect.checkoutUrl
        }).then((value) {
          payMongoCreatePayment(pday.data.id, context, amount, headers, type);
        }).catchError((e) {
          print(e);
          setState(() {
            showDialogBox = false;
          });
        });
      } else {
        PayErrorPaymongo payErr =
            PayErrorPaymongo.fromJson(jsonDecode(value.body));
        if (payErr != null) {
          Toast.show('${payErr.errors[0].detail}', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        } else {
          Toast.show('something went wrong!', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        }
        setState(() {
          showDialogBox = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });
  }

  void payMongoCreatePayment(String sourceId, BuildContext context, int amount,
      Map<String, String> headers, String paymentType) {
    var bodyd = {
      "data": {
        "attributes": {
          "amount": amount,
          "currency": "PHP",
          "description": "Shopping Charges",
          "statement_descriptor": "Shopping Charges for Grocery at $appname",
          "source": {"id": sourceId, "type": "source"}
        }
      }
    };
    http
        .post(Uri.parse('https://api.paymongo.com/v1/payments'),
            body: jsonEncode(bodyd), headers: headers)
        .then((value) {
      print('${value.body}');
      PayMongoPayment pday = PayMongoPayment.fromJson(jsonDecode(value.body));
      if (pday != null && pday.data != null) {
        if ('${pday.data.attributes.status}'.toUpperCase() == 'PAID') {
          placedOrder("success", paymentType, context);
        }
      } else {
        PayErrorPaymongo payErr =
            PayErrorPaymongo.fromJson(jsonDecode(value.body));
        if (payErr != null) {
          Toast.show('${payErr.errors[0].detail}', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        } else {
          Toast.show('something went wrong!', context,
              gravity: Toast.CENTER, duration: Toast.LENGTH_SHORT);
        }
        setState(() {
          showDialogBox = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        showDialogBox = false;
      });
    });
  }
}
