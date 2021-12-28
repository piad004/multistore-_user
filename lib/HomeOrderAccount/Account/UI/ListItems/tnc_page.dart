import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:http/http.dart' as http;
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';

class TncPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return TncPageState();
  }
}

class TncPageState extends State<TncPage> {
  dynamic htmlString = '';

  @override
  void initState() {
    super.initState();
    getTnc();
  }

  void getTnc() async {
    var client = http.Client();
    var url = termcondition;
    client.get(url).then((value) {
      if (value.statusCode == 200 && jsonDecode(value.body)['status'] == "1") {
        var jsonData = jsonDecode(value.body);
        var dataList = jsonData['data'] as List;
        setState(() {
          htmlString = dataList[0]['termcondition'];
        });
      }
    }).catchError((e) {
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0.0,
        title: Text(locale.termsAndCondition,
            style: Theme.of(context).textTheme.bodyText1),
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
                padding: EdgeInsets.symmetric(vertical: 28.0, horizontal: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      locale.termsOfUse,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    // Text(
                    //   '\n${htmlString}',
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .caption
                    //       .copyWith(fontSize: 16),
                    // ),
                    Html(
                      data: htmlString,
                      style: {
                        "html": Style(
                          fontSize: FontSize.large,
//              color: Colors.white,
                        ),
                      },
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
}
