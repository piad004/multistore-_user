import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Auth/MobileNumber/UI/phone_number.dart';
import 'package:user/Components/entry_field.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';

class EditProfile extends StatelessWidget {

  dynamic name;
  dynamic email;
  dynamic mobile;
  EditProfile(this.name, this.email, this.mobile);

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        iconTheme: IconThemeData(color: kMainTextColor),
        title: Text(
          locale.editProfileText,
          style: TextStyle(
              fontSize: 18, color: kMainTextColor, fontWeight: FontWeight.w600),
        ),
      ),
      body: EditProfileForm(name,email,mobile),
    );
  }
}

class EditProfileForm extends StatefulWidget {

  dynamic name;
  dynamic email;
  dynamic mobile;
  EditProfileForm(this.name, this.email, this.mobile);

  @override
  _EditProfileFormState createState() => _EditProfileFormState(name,email,mobile);
}

class _EditProfileFormState extends State<EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _referalController = TextEditingController();
  var fullNameError = "";

  bool showDialogBox = false;
  dynamic token = '';
  FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  var name;
  var email;
  var mobile;
  _EditProfileFormState(this.name, this.email, this.mobile);

  @override
  void initState() {
    super.initState();
    setState(() {
      _nameController.text=name;
      _emailController.text=email;
      _referalController.text=mobile;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _referalController.dispose();
    super.dispose();
  }

 /* Future<bool> back(){
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
    PhoneNumber_New()), (Route<dynamic> route) => false);
  }*/

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return
    //WillPopScope( onWillPop: back,child:
      ListView(
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
                          hint: 'Mobile',
                          controller: _referalController,
                          keyboardType: TextInputType.text,
                          enable: false,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50.0),
                            borderSide: BorderSide(color: kHintColor, width: 1),
                          )),
                      SizedBox(
                        height: 20,
                      ),
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
                      locale.savetext,
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
    )
    //,)
    ;
  }

  void hitService(
      String name, String email, String referal, BuildContext context) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var userId = prefs.getInt('user_id');
      var url = editProfile;
      http.post(url, body: {
        'user_id': userId.toString(),
        'user_name': name,
        'user_email': email
      }).then((value) {
        var body =value.body;
        print('edit Response Body: - ${value.body.toString()}');
        if (value.statusCode == 200) {
          setState(() {
            showDialogBox = false;
            prefs.setString('user_name',name);
            prefs.setString('user_email',email);
          });
          Navigator.pop(context);
        }
      });
  }

}
