import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/language_cubit.dart';
import 'package:user/bean/languagebean.dart';

import '../bean/languagebean.dart';

class Settings extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SettingState();
  }
}

class SettingState extends State<Settings> {
  LanguageCubit _languageCubit;
  bool _switchValueEmail = true;
  bool _switchValueSms = true;
  bool _switchValueInApp = true;
  dynamic userId;
  bool enteredFirst = false;
  List<LanguageCode> radioList = [];

  String selectedLanguage;
  int idd1 = 0;

  @override
  void initState() {
    // getSharePrefOrUserId();
    super.initState();
    _languageCubit = BlocProvider.of<LanguageCubit>(context);
  }

  getSharePrefOrUserId() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('language') && preferences.getString('language')!=null){
      int indit = radioList.indexOf(LanguageCode(preferences.getString('language'),''));
      if(indit == 0 || indit>0){
        setState(() {
          idd1 = indit;
        });
      }
    }

    setState(() {
      if (preferences.containsKey('emailnoti')) {
        _switchValueEmail = preferences.getBool('emailnoti');
      } else {
        _switchValueEmail = true;
      }
      if (preferences.containsKey('smsnoti')) {
        _switchValueSms = preferences.getBool('smsnoti');
      } else {
        _switchValueSms = true;
      }
      if (preferences.containsKey('inappnoti')) {
        _switchValueInApp = preferences.getBool('inappnoti');
      } else {
        _switchValueInApp = true;
      }

      userId = preferences.getInt('user_id');
    });
  }

  getAsyncValue(List<LanguageCode> languagesd, AppLocalizations locale) async {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.containsKey('language') &&
          prefs.getString('language').length > 0) {
        String langCode = prefs.getString('language');
        if (langCode == 'en') {
          selectedLanguage = locale.englishh;
        } else if (langCode == 'es') {
          selectedLanguage = locale.spanishh;
        } else if (langCode == 'hi') {
          selectedLanguage = locale.hindih;
        }else{
          selectedLanguage = locale.englishh;
        }
        setState(() {
          idd1 = radioList.indexOf(LanguageCode('', selectedLanguage));
        });
      } else {
        idd1 = 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    final double itemWidth = size.width / 2;
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false);
    pr.style(
        message: locale.settingProgressMsg,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CupertinoActivityIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
    if (!enteredFirst) {
      setState(() {
        enteredFirst = true;
      });
      radioList = [
        LanguageCode('en',locale.englishh),
        LanguageCode('hi',locale.hindih),
        LanguageCode('es',locale.spanishh),
      ];
      getAsyncValue(radioList, locale);
    }

    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: kWhiteColor,
        elevation: 0.0,
        title: Text(
          locale.settingheding,
          style: headingStyle,
        ),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
            child: RaisedButton(
              onPressed: () {
                pr.show();
                hitService(context, pr,locale);
              },
              child: Text(
                locale.savetext,
                style:
                    TextStyle(color: kWhiteColor, fontWeight: FontWeight.w400),
              ),
              color: kMainColor,
              highlightColor: kMainColor,
              focusColor: kMainColor,
              splashColor: kMainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                locale.notificationtext,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: kHintColor),
              ),
            ),
            Container(
                color: kWhiteColor,
                margin: EdgeInsets.only(top: 8),
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.smstext,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: kHintColor),
                          ),
                          CupertinoSwitch(
                            value: _switchValueSms,
                            activeColor: kMainColor,
                            onChanged: (value) {
                              setState(() {
                                _switchValueSms = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.emailtext,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: kHintColor),
                          ),
                          CupertinoSwitch(
                            value: _switchValueEmail,
                            activeColor: kMainColor,
                            onChanged: (value) {
                              setState(() {
                                _switchValueEmail = value;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            locale.inapptext,
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                                color: kHintColor),
                          ),
                          CupertinoSwitch(
                            value: _switchValueInApp,
                            activeColor: kMainColor,
                            onChanged: (value) {
                              setState(() {
                                _switchValueInApp = value;
                              });
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                )),
           /* SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                locale.languagetext,
                style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: kHintColor),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(right: 5, left: 5),
              child: GridView.builder(
                itemCount: radioList.length,
                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  crossAxisSpacing: 4.0,
                  mainAxisSpacing: 4.0,
                  childAspectRatio:
                  (itemWidth / itemHeight),
                ),
                controller: ScrollController(
                    keepScrollOffset: false),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () async{
                      setState(() {
                        idd1 = index;
                        selectedLanguage = radioList[idd1].langString;
                        _languageCubit.selectLanguage(radioList[idd1].langCode);
                      });
                    },
                    child: SizedBox(
                      height: 100,
                      child: Container(
                        margin: EdgeInsets.only(
                            right: 5,
                            left: 5,
                            top: 5,
                            bottom: 5),
                        height: 30,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: (idd1 == index)
                                ? kMainColor
                                : kWhiteColor,
                            shape: BoxShape.rectangle,
                            borderRadius:
                            BorderRadius.circular(20),
                            border: Border.all(
                                color: (idd1 == index)
                                    ? kMainColor
                                    : kMainColor)),
                        child: Text(
                          '${radioList[index].langString}',
                          style: TextStyle(
                              color: (idd1 == index)
                                  ? kWhiteColor
                                  : kMainTextColor,
                              fontSize: 14),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )*/
          ],
        ),
      ),
    );
  }

  void hitService(BuildContext context, ProgressDialog pr, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = notificationby;
    await http.post(url, body: {
      'user_id': '${userId}',
      'sms': '${(_switchValueSms) ? 1 : 0}',
      'app': '${(_switchValueInApp) ? 1 : 0}',
      'email': '${(_switchValueEmail) ? 1 : 0}'
    }).then((response) {
      if (response.statusCode == 200) {
        print('Response Body: - ${response.body}');
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "1") {
          prefs.setBool('emailnoti', _switchValueEmail);
          prefs.setBool('smsnoti', _switchValueSms);
          prefs.setBool('inappnoti', _switchValueInApp);
          pr.hide();
          Toast.show(locale.settingsupdatedtext, context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
        } else {
          Toast.show(locale.settingsupdatedtext, context,
              duration: Toast.LENGTH_SHORT, gravity: Toast.BOTTOM);
          pr.hide();
        }
      } else {
        pr.hide();
      }
    }).catchError((e) {
      print(e);
      pr.hide();
    });
  }
}
