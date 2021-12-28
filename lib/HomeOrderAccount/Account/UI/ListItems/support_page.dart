import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/entry_field.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';

class SupportPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SupportPageState();
  }
}

class SupportPageState extends State<SupportPage> {
  static const String id = 'support_page';
  var number = '';
  dynamic userIds;
  bool _inProgress = false;
  var messageController = TextEditingController();
  var numberController = TextEditingController();
  int number_limit = 1;

  @override
  void initState() {
    super.initState();
    getPrefValue();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text(locale.support, style: Theme.of(context).textTheme.bodyText1),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                color: kCardBackgroundColor,
                child: Image(
                  image: AssetImage("images/logos/logo_user.png"),
                  centerSlice: Rect.largest,
                  fit: BoxFit.fill,
                  height: 220,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, top: 16.0),
                      child: Text(
                        locale.OrWriteUsYourQueries,
                        style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: EdgeInsets.only(left: 8.0, bottom: 16.0),
                      child: Text(
                        locale.yourWordsMeansALotToUs,
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                    EntryField(
                      image: 'images/icons/ic_phone.png',
                      label: locale.phonenumber,
                      maxLength: number_limit,
                      maxLines: 1,
                      controller: numberController,
                      readOnly: true,
                    ),
                    EntryField(
                      image: 'images/icons/ic_mail.png',
                      label: locale.yourmessage,
                      hint: locale.entermessage1,
                      controller: messageController,
                      maxLines: 5,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Align(
                      alignment: Alignment.center,
                      child: _inProgress
                          ? Container(
                              alignment: Alignment.center,
                              height: 50.0,
                              child: Platform.isIOS
                                  ? new CupertinoActivityIndicator()
                                  : new CircularProgressIndicator(),
                            )
                          : RaisedButton(
                              child: Text(
                                locale.submit,
                                style: TextStyle(
                                    color: kWhiteColor,
                                    fontSize: 17,
                                    fontWeight: FontWeight.w400),
                              ),
                              color: kMainColor,
                              highlightColor: kMainColor,
                              focusColor: kMainColor,
                              splashColor: kMainColor,
                              padding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                              onPressed: () {
                                setState(() {
                                  _inProgress = true;
                                });
                                handleSubmit();
                              },
                            ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void getPrefValue() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    String user_phone = prefs.getString('user_phone');
    setState(() {
      number_limit = prefs.getInt('number_limit');
      if(number_limit!=null){
        number_limit = number_limit+(user_phone.length);
      }else{
        number_limit = 0;
        number_limit = number_limit+(user_phone.length);
      }
      userIds = userId;
      number = user_phone;
      numberController.text = user_phone;
    });
  }

  void handleSubmit() {
    var locale = AppLocalizations.of(context);
    if (numberController.text.length > 9 &&
        messageController.text.length > 50) {
      var url = support;
      var client = http.Client();
      client.post(url, body: {
        'user_id': '${userIds}',
        'user_number': '${numberController.text}',
        'message': '${messageController.text}',
      }).then((value) {
        if (value.statusCode == 200) {
          var jsonData = jsonDecode(value.body);
          if (jsonData['status'] == "1") {
            setState(() {
              _inProgress = false;
              messageController.clear();
              Toast.show('${jsonData['message']}', context,
                  duration: Toast.LENGTH_SHORT);
            });
          } else {
            setState(() {
              _inProgress = false;
              Toast.show(locale.pleaseTryAgain, context,
                  duration: Toast.LENGTH_SHORT);
            });
          }
        } else {
          setState(() {
            _inProgress = false;
            Toast.show(locale.pleaseTryAgain, context,
                duration: Toast.LENGTH_SHORT);
          });
        }
      }).catchError((e) {
        setState(() {
          _inProgress = false;
        });
      });
    } else {
      setState(() {
        _inProgress = false;
      });
      Toast.show(
         locale.pleaseEnterValidMobileNoAndMessage,
          context,
          duration: Toast.LENGTH_SHORT);
    }
  }
}
