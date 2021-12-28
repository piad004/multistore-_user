import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/entry_field.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';

class RegisterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainTextColor),
        title: Text(
          locale.signUpText,
          style: TextStyle(
              fontSize: 18, color: kMainTextColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: RegisterForm(),
    );
  }
}

class RegisterForm extends StatefulWidget {
  @override
  _RegisterFormState createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _referalController = TextEditingController();
  var fullNameError = "";

  bool showDialogBox = false;
  dynamic token = '';
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();
    firebaseMessagingListner();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _referalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return ListView(
      scrollDirection: Axis.vertical,
      children: <Widget>[
        Divider(
          color: kCardBackgroundColor,
          thickness: 8.0,
        ),
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - 100,
          padding: EdgeInsets.only(right: 20, left: 20),
          child: Stack(
            children: <Widget>[
              Positioned(
                top: 10.0,
                left: 2.0,
                right: 2.0,
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Text(
                            locale.createNewAccountText,
                            style: TextStyle(
                                color: kMainTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 25),
                          )),
                      EntryField(
                          textCapitalization: TextCapitalization.words,
                          controller: _nameController,
                          hint: locale.fullNameText,
                          enable: !showDialogBox,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(color: kHintColor, width: 1),
                          )),
                      //email textField
                      EntryField(
                          textCapitalization: TextCapitalization.none,
                          controller: _emailController,
                          hint: locale.emailAddressText,
                          enable: !showDialogBox,
                          keyboardType: TextInputType.emailAddress,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(color: kHintColor, width: 1),
                          )),
                      EntryField(
                          hint: locale.applyreferralText,
                          controller: _referalController,
                          keyboardType: TextInputType.text,
                          enable: !showDialogBox,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(color: kHintColor, width: 1),
                          )),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                                text: locale.termsandconditionText1,
                                style: TextStyle(
                                  fontSize: 12.0,
                                  color: kMainTextColor,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.w500,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text:
                                          ' ${locale.termsandconditionText2}',
                                      style: TextStyle(
                                        fontSize: 12.0,
                                        color: appbar_color,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w500,
                                      ))
                                ])),
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
              ),
              Positioned(
                bottom: 12,
                left: 20,
                right: 20.0,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      showDialogBox = true;
                    });
                    if (_nameController.text.isEmpty) {
                      Toast.show(locale.enteryourfullnameText, context,
                          gravity: Toast.BOTTOM);
                      setState(() {
                        showDialogBox = false;
                      });
                    } else if (_emailController.text.isEmpty ||
                        !_emailController.text.contains('@') ||
                        !_emailController.text.contains('.')) {
                      setState(() {
                        showDialogBox = false;
                      });
                      Toast.show(locale.valiedEmailText, context,
                          gravity: Toast.BOTTOM);
                    } else {
                      hitService(_nameController.text, _emailController.text,
                          _referalController.text, context);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: kMainColor),
                    child: Text(
                      locale.continueText,
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
        )
      ],
    );
  }

  void hitService(
      String name, String email, String referal, BuildContext context) async {
    if (token != null && token.toString().length > 0) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var phoneNumber = prefs.getString('user_phone');
      var url = registerApi;
      http.post(url, body: {
        'user_name': name,
        'user_email': email,
        'user_phone': phoneNumber,
        'user_password': 'no',
        'device_id': '${token}',
        'user_image': 'usre.png'
      }).then((value) {
        print('Response Body: - ${value.body.toString()}');
        if (value.statusCode == 200) {
          setState(() {
            showDialogBox = false;
          });
          Navigator.pushNamed(context, PageRoutes.verification);
        }
      });
    } else {
      firebaseMessaging.getToken().then((value) {
        setState(() {
          token = value;
        });
        print('${value}');
        hitService(name, email, referal, context);
      });
    }
  }

  void firebaseMessagingListner() async {
    if (Platform.isIOS) iosPermission(firebaseMessaging);
    firebaseMessaging.getToken().then((value) {
      setState(() {
        token = value;
      });
    });
  }

  void iosPermission(FirebaseMessaging firebaseMessaging) {
    if(Platform.isIOS){
      firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    // firebaseMessaging.requestNotificationPermissions(
    //     IosNotificationSettings(sound: true, badge: true, alert: true));
    // firebaseMessaging.onIosSettingsRegistered.listen((event) {
    //   print('${event.provisional}');
    // });
  }
}
