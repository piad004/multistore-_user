import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/customprogresscircle.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/rewardvalue.dart';

class Reward extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RewardState();
  }
}

class RewardState extends State<Reward> {
  dynamic rewardPoint = 0;
  dynamic rewardValues = 0.0;

  var isRedeem = false;

  progressView() {
    return CustomPaint(
      child: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${rewardPoint}',
            style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: kMainTextColor),
          ),
          Text(
            'Total Earned',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.bold, color: kHintColor),
          ),
        ],
      )),
      foregroundPainter: ProgressPainter(Colors.amber, kMainColor, 100, 10.0),
    );
  }

  List<RewardHistory> history = [];
  bool isFetchStore = false;

  @override
  void initState() {
    super.initState();
    getRewardValue();
    getHistory();
  }

  void getRewardValue() async {
    setState(() {
      isFetchStore = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    var client = http.Client();
    var url = rewardvalues;
    client.post(url, body: {
      'user_id': '${userId}',
    }).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && jsonDecode(value.body)['status'] == "1") {
        var jsonData = jsonDecode(value.body);
        setState(() {
          rewardPoint = jsonData['data']['rewards'];
          if (double.parse(rewardPoint) == 0.0) {
            isRedeem = false;
          } else {
            isRedeem = true;
          }
        });
      }
      setState(() {
        isFetchStore = false;
      });
    }).catchError((e) {
      setState(() {
        isFetchStore = false;
      });
      print(e);
    });
  }

  void getHistory() async {
    var locale = AppLocalizations.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    var client = http.Client();
    var url = rewardhistory;
    client.post(url, body: {
      'user_id': '${userId}',
    }).then((value) {
      print('${value.statusCode} ${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonData['data'] as List;
          List<RewardHistory> tagObjs = tagObjsJson
              .map((tagJson) => RewardHistory.fromJson(tagJson))
              .toList();
          setState(() {
            history.clear();
            history = tagObjs;
          });
        } else {
          Toast.show(jsonData['message'], context,
              duration: Toast.LENGTH_SHORT);
        }
      } else {
        Toast.show(locale.noHistoryFound, context, duration: Toast.LENGTH_SHORT);
      }
    }).catchError((e) {
      Toast.show(locale.noHistoryFound, context, duration: Toast.LENGTH_SHORT);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
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
                locale.rewardPoints,
                style: Theme.of(context)
                    .textTheme
                    .bodyText1
                    .copyWith(color: kMainTextColor),
              ),
            ],
          ),
          actions: [
            Visibility(
              visible: isRedeem ? true : false,
              child: Padding(
                padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: RaisedButton(
                  onPressed: () {
                    redeemPoints();
                  },
                  child: Text(
                    locale.redeem,
                    style: TextStyle(
                        color: kWhiteColor, fontWeight: FontWeight.w400),
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
            )
          ],
        ),
      ),
      body: (!isFetchStore)
          ? Column(
              children: <Widget>[
                Card(
                  elevation: 3,
                  margin: EdgeInsets.only(top: 5, left: 10, right: 10),
                  child: Center(
                    widthFactor: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          height: 150.0,
                          width: 150.0,
                          padding: EdgeInsets.all(5.0),
                          margin: EdgeInsets.only(top: 5, bottom: 20.0),
                          child: progressView(),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${rewardPoint}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: kMainTextColor),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        locale.earned,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kHintColor),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        locale.zero,
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: kMainTextColor),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        locale.spent,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kHintColor),
                                      ),
                                    ],
                                  )),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${rewardPoint}',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: kMainTextColor),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        locale.have,
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: kHintColor),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                      color: kMainColor, border: Border.all(color: kMainColor)),
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
                            locale.orderId,
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: kWhiteColor),
                          ),
                        ],
                      ),
                      Text(
                        locale.rewardPoint,
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
                        padding:
                            EdgeInsets.symmetric(horizontal: 10, vertical: 10),
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
                                  '#${history[index].cart_id}',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      color: kMainTextColor),
                                ),
                              ],
                            ),
                            Text(
                              '${history[index].reward_points}',
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
            )
          : Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    locale.fetchingRewardPoints,
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

  void redeemPoints() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    var url = redeem;
    var client = http.Client();
    client.post(url, body: {
      'user_id': '${userId}',
    }).then((value) {
      if (value.statusCode == 200) {
        var redemData = jsonDecode(value.body);
        if (redemData['status'] == "1") {
          print('${value.body}');
          setState(() {
            isRedeem = false;
            rewardPoint = 0.0;
          });
          Toast.show(redemData['message'], context,
              duration: Toast.LENGTH_SHORT);
        }
      }
    }).catchError((e) {});
  }
}
