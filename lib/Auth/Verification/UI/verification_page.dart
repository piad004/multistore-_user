import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/currencybean.dart';
import 'package:user/bean/newloginbean/loginbean.dart';

class OtpVerify extends StatefulWidget {
  @override
  _OtpVerifyState createState() => _OtpVerifyState();
}

class _OtpVerifyState extends State<OtpVerify> {
  final TextEditingController _controller = TextEditingController();
  FirebaseMessaging messaging;
  bool isDialogShowing = false;
  dynamic token = '';
  var showDialogBox = false;
  var verificaitonPin = "";
  var firebaseAuth;
  var actualCode;

  // AuthCredential _authCredential;
  bool firebaseOtp = false;

  @override
  void initState() {
    super.initState();
    hitAsyncInit();
  }

  void hitAsyncInit() async {
    Firebase.initializeApp();
    messaging = FirebaseMessaging.instance;
    messaging.getToken().then((value) {
      token = value;
    });
    getFIrebaseStatus();
  }

  void getFIrebaseStatus() async {
    setState(() {
      showDialogBox = true;
    });
    var url = firebase;
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print('${response.body}');
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonData['data']['status'];
          if (tagObjsJson != null && (tagObjsJson == '1' || tagObjsJson == 1)) {
            print('fd ${tagObjsJson}');
            setState(() {
              firebaseOtp = true;
            });
            initialAuth();
          } else {
            setState(() {
              firebaseOtp = false;
              showDialogBox = false;
            });
          }
        } else {
          setState(() {
            firebaseOtp = false;
            showDialogBox = false;
          });
        }
      } else {
        setState(() {
          firebaseOtp = false;
          showDialogBox = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        firebaseOtp = false;
        showDialogBox = false;
      });
    });
  }

  initialAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userNumber = prefs.getString('user_phone');
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.verifyPhoneNumber(
      phoneNumber: userNumber,
      verificationCompleted: (PhoneAuthCredential credential) {},
      verificationFailed: (FirebaseAuthException e) {
        print(e.message);
        setState(() {
          showDialogBox = false;
        });
      },
      codeSent: (String verificationId, int resendToken) {
        setState(() {
          showDialogBox = false;
          actualCode = verificationId;
        });
        print('code sent');
      },
      codeAutoRetrievalTimeout: (String verificationId) {},
    );
  }

  _signInWithPhoneNumber(String smsCode, BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: actualCode, smsCode: smsCode);
    auth.signInWithCredential(credential).then((value) {
      if (value != null) {
        User userd = value.user;
        if (userd != null) {
          hitFirebaseSuccessStatus('success', context);
        } else {
          setState(() {
            showDialogBox = false;
          });
        }
      } else {
        setState(() {
          showDialogBox = false;
        });
      }
    }).catchError((e) {
      print('user null + $e');
      setState(() {
        showDialogBox = false;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        title: Text(
          locale.verificationText,
          style: headingStyle,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height - 100,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(
                            top: 10, bottom: 5, right: 80, left: 80),
                        child: Center(
                          child: Text(
                            locale.verifynumberText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontSize: 30,
                                fontWeight: FontWeight.w800),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Text(
                          locale.otpcodeText,
                          textAlign: TextAlign.center,
                          style: Theme.of(context)
                              .textTheme
                              .headline6
                              .copyWith(fontSize: 16, color: Colors.black87),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        padding: EdgeInsets.only(right: 20.0, left: 20.0),
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10.0),
                            PinCodeTextField(
                              autofocus: true,
                              controller: _controller,
                              hideCharacter: false,
                              highlight: true,
                              highlightColor: kHintColor,
                              defaultBorderColor: kMainColor,
                              hasTextBorderColor: kMainColor,
                              maxLength: firebaseOtp ? 6 : 4,
                              pinBoxRadius: firebaseOtp ? 30 : 40,
                              onDone: (text) {
                                SystemChannels.textInput
                                    .invokeMethod('TextInput.hide');
                                verificaitonPin = text;
                              },
                              pinBoxWidth: firebaseOtp ? 45 : 60,
                              pinBoxHeight: firebaseOtp ? 45 : 60,
                              hasUnderline: false,
                              wrapAlignment: WrapAlignment.spaceAround,
                              pinBoxDecoration: ProvidedPinBoxDecoration
                                  .roundedPinBoxDecoration,
                              pinTextStyle: TextStyle(
                                  fontSize: firebaseOtp ? 18.0 : 22.0),
                              pinTextAnimatedSwitcherTransition:
                                  ProvidedPinBoxTextAnimation.scalingTransition,
                              pinTextAnimatedSwitcherDuration:
                                  Duration(milliseconds: 300),
                              highlightAnimationBeginColor: Colors.black,
                              highlightAnimationEndColor: Colors.white12,
                              keyboardType: TextInputType.number,
                            ),
                            SizedBox(height: 15.0),
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                locale.didnotrecivecodeText,
                                textDirection: TextDirection.ltr,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Align(
                              alignment: Alignment.center,
                              child: GestureDetector(
                                onTap: () {
                                  if (!showDialogBox) {
                                    setState(() {
                                      showDialogBox = true;
                                    });
                                    hitResend();
                                  }
                                },
                                child: Text(
                                  locale.resendCodeText,
                                  textDirection: TextDirection.ltr,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: kMainColor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Visibility(
                                visible: showDialogBox,
                                child: Align(
                                  alignment: Alignment.center,
                                  child: CircularProgressIndicator(),
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 40,
                      ),
                    ],
                  )),
              Positioned(
                bottom: 12,
                left: 20,
                right: 20.0,
                child: InkWell(
                  onTap: () {
                    if (!showDialogBox) {
                      setState(() {
                        showDialogBox = true;
                      });
                      if (firebaseOtp) {
                        _signInWithPhoneNumber(verificaitonPin, context);
                      } else {
                        hitService(verificaitonPin, context);
                      }
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: kMainColor),
                    child: Text(
                      locale.verifyText,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void hitService(String verificaitonPin, BuildContext context) async {
    if (token != null && token.toString().length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = verifyPhone;
      await http.post(url, body: {
        'phone': prefs.getString('user_phone'),
        'otp': verificaitonPin,
        'device_id': '${token}'
      }).then((response) {
        print('Response Body: - ${response.body}');
        if (response.statusCode == 200) {
          print('Response Body: - ${response.body}');
          var jsonData = jsonDecode(response.body);
          if (jsonData['status'] == 1) {
            var userId = int.parse('${jsonData['data']['user_id']}');
            prefs.setInt("user_id", userId);
            prefs.setString("user_name", jsonData['data']['user_name']);
            prefs.setString("user_email", jsonData['data']['user_email']);
            prefs.setString("user_image", jsonData['data']['user_image']);
            prefs.setString("user_phone", jsonData['data']['user_phone']);
            prefs.setString("user_password", jsonData['data']['user_password']);
            prefs.setString(
                "wallet_credits", jsonData['data']['wallet_credits']);
            // prefs.setString("first_recharge_coupon",
            //     jsonData['data']['first_recharge_coupon']);
            prefs.setBool("phoneverifed", true);
            prefs.setBool("islogin", true);
            prefs.setString("refferal_code", jsonData['data']['referral_code']);
            if (jsonData['currency'] != null) {
              CurrencyData currencyData =
                  CurrencyData.fromJson(jsonData['currency']);
              print('${currencyData.toString()}');
              prefs.setString("curency", '${currencyData.currency_sign}');
            }
            setState(() {
              showDialogBox = false;
            });
            Navigator.pushNamedAndRemoveUntil(
                context,
                PageRoutes.homeOrderAccountPage,
                (Route<dynamic> route) => false);
          } else {
            prefs.setBool("phoneverifed", false);
            prefs.setBool("islogin", false);
            setState(() {
              showDialogBox = false;
            });
          }
        } else {
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
      messaging.getToken().then((value) {
        token = value;
        hitService(verificaitonPin, context);
      });
    }
  }

  void hitFirebaseSuccessStatus(String status, BuildContext context) async {
    if (token != null && token.toString().length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var url = verifyotpfirebase;
      await http.post(url, body: {
        'user_phone': prefs.getString('user_phone'),
        'status': status,
        'device_id': '${token}'
      }).then((response) {
        print('Response Body: - ${response.body}');
        if (response.statusCode == 200) {
          print('Response Body: - ${response.body}');
          LoginData loginBody = LoginData.fromJson(jsonDecode(response.body));
          // var jsonData = jsonDecode(response.body);
          if ('${loginBody.status}' == '1') {
            var userId = int.parse('${loginBody.data.userId}');
            prefs.setInt("user_id", userId);
            prefs.setString("user_name", loginBody.data.userName);
            prefs.setString("user_email", loginBody.data.userEmail);
            prefs.setString("user_image", loginBody.data.userImage);
            prefs.setString("user_phone", loginBody.data.userPhone);
            prefs.setString("user_password", loginBody.data.userPassword);
            prefs.setString("wallet_credits", loginBody.data.walletCredits);
            // prefs.setString("first_recharge_coupon", loginBody.data.r);
            prefs.setBool("phoneverifed", true);
            prefs.setBool("islogin", true);
            prefs.setString("refferal_code", loginBody.data.referralCode);
            if (loginBody.currency != null) {
              // CurrencyData currencyData = CurrencyData.fromJson(jsonData['currency']);
              print('${loginBody.currency.currencySign}');
              prefs.setString("curency", '${loginBody.currency.currencySign}');
            }
            setState(() {
              showDialogBox = false;
            });
            Navigator.pushNamedAndRemoveUntil(
                context,
                PageRoutes.homeOrderAccountPage,
                (Route<dynamic> route) => false);
          } else {
            prefs.setBool("phoneverifed", false);
            prefs.setBool("islogin", false);
            setState(() {
              showDialogBox = false;
            });
          }
        } else {
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
      messaging.getToken().then((value) {
        token = value;
        hitFirebaseSuccessStatus(status, context);
      });
    }
  }

  void hitResend() async {
    if (firebaseOtp) {
      initialAuth();
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      http.post(resend_otp,
          body: {'user_phone': prefs.getString('user_phone')}).then((value) {
        var js = jsonDecode(value.body);
        setState(() {
          showDialogBox = false;
        });
      }).catchError((e) {
        setState(() {
          showDialogBox = false;
        });
      });
    }
  }
}
