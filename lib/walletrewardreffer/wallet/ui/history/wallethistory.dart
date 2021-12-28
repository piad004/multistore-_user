import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/rewardvalue.dart';

class WalletHistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WalletHistoryState();
  }
}

class WalletHistoryState extends State<WalletHistoryPage> {
  bool three_expandtrue = false;
  int style_selectedValue = 0;
  bool visible = false;
  int rs_selected = -1;
  String email = '';
  dynamic walletAmount = 0.0;
  dynamic currency = '';
  List<WalletHistory> history = [];
  bool isFetchStore = false;
  bool isFetchingList = false;
  List<String> rechargeList = ['1000','700','500','400','200','100','50','20','1'];

  int idd1 = -1;

  @override
  void initState() {
    super.initState();
    getWalletHistory();
  }

  void getWalletHistory() async {
    var locale = AppLocalizations.of(context);
    setState(() {
      isFetchStore = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userId = prefs.getInt('user_id');
    var client = http.Client();
    var url = creditHistroy;
    client.post(url, body: {
      'user_id': '${userId}',
    }).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonData['data'] as List;
          List<WalletHistory> tagObjs = tagObjsJson.map((tagJson) => WalletHistory.fromJson(tagJson)).toList();
          setState(() {
            history.clear();
            history = tagObjs;
            isFetchStore = false;
          });
        } else {
          isFetchStore = false;
          Toast.show(jsonData['message'], context, duration: Toast.LENGTH_SHORT);
        }
      } else {
        isFetchStore = false;
        Toast.show(locale.noHistoryFound, context, duration: Toast.LENGTH_SHORT);
      }
    }).catchError((e) {
      isFetchStore = false;
      Toast.show(locale.noHistoryFound, context, duration: Toast.LENGTH_SHORT);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    final double itemWidth = size.width / 2;
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(64.0),
        child: AppBar(
          automaticallyImplyLeading: true,
          backgroundColor: kWhiteColor,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                locale.walletHistory,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: kMainTextColor),
              ),
            ],
          ),
        ),
      ),
      body: (!isFetchStore && history!=null && history.length>0)
          ? SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                  color: kMainColor,
                  border: Border.all(color: kMainColor)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        locale.sNo,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kWhiteColor),
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Text(
                        locale.type,
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: kWhiteColor),
                      ),
                    ],
                  ),
                  Text(
                    locale.walletAmount,
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: kWhiteColor),
                  ),
                ],
              ),
            ),
            ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Text(
                              '${index + 1}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kMainTextColor),
                            ),
                            SizedBox(
                              width: 35,
                            ),
                            Text(
                              '${history[index].type}',
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: kMainTextColor),
                            ),
                          ],
                        ),
                        Text(
                          '$currency ${history[index].amount}',
                          style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kMainTextColor),
                        ),
                      ],
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return Container(
                    height: 2,
                    color: kCardBackgroundColor,
                  );
                },
                itemCount: history.length),
          ],
        ),
      )
          : Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: (!isFetchStore)?true:false,
                child: CircularProgressIndicator()),
            Visibility(
              visible: (!isFetchStore)?true:false,
              child: SizedBox(
                width: 10,
              ),
            ),
            Text(
              (!isFetchStore)?locale.noWalletHistoryFound:locale.fetchingWalletHistory,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kMainTextColor),
            )
          ],
        ),
      ),
    );
  }
}
