import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/HomeOrderAccount/Home/UI/order_placed_map.dart';
import 'package:user/HomeOrderAccount/home_order_account.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/orderbean.dart';
import 'package:user/bean/resturantbean/orderhistorybean.dart';
import 'package:user/parcel/ordermappageparcel.dart';
import 'package:user/parcel/pharmacybean/parcelorderhistorybean.dart';
import 'package:user/pharmacy/order_map_pharma.dart';
import 'package:user/restaturantui/pages/ordermaprestaurant.dart';

class OrderPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OrderPageState();
  }
}

class OrderPageState extends State<OrderPage> {
  List<OngoingOrders> onGoingOrders = [];
  List<OrderHistoryRestaurant> onRestGoingOrders = [];
  List<OrderHistoryRestaurant> onPharmaGoingOrders = [];
  List<TodayOrderParcel> onParcelGoingOrders = [];

  dynamic currency = '';

  var khit = 0;
  bool isFetch = false;
  int countFetch = 0;

  List<String> tabDesign = [
    'Ongoing',
    'Cancelled',
    'Completed',
  ];

  @override
  void initState() {
    super.initState();
    getAllThreeData();
  }

  getOnGointOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = onGoingOrdersUrl;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('grocery ${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OngoingOrders> tagObjs = tagObjsJson
              .map((tagJson) => OngoingOrders.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onGoingOrders.clear();
              onGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getCanceledOreders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = cancelOrders;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OngoingOrders> tagObjs = tagObjsJson
              .map((tagJson) => OngoingOrders.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onGoingOrders.clear();
              onGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getCompletedOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = completeOrders;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        print('${value.body}');
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OngoingOrders> tagObjs = tagObjsJson
              .map((tagJson) => OngoingOrders.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onGoingOrders.clear();
              onGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getOnRestGointOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = user_ongoing_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('rest ${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onRestGoingOrders.clear();
              onRestGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getRestCanceledOreders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = user_cancel_order_history;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onRestGoingOrders.clear();
              onRestGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getRestCompletedOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = user_completed_orders;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        print('${value.body}');
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onRestGoingOrders.clear();
              onRestGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getOnPharmaGointOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = pharmacy_user_ongoing_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('pharma ${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onPharmaGoingOrders.clear();
              onPharmaGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getPharmaCanceledOreders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = pharmacy_user_cancel_order_history;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onPharmaGoingOrders.clear();
              onPharmaGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getPharmaCompletedOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = pharmacy_user_completed_orders;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        print('${value.body}');
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<OrderHistoryRestaurant> tagObjs = tagObjsJson
              .map((tagJson) => OrderHistoryRestaurant.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onPharmaGoingOrders.clear();
              onPharmaGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getOnParcelGointOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = parcel_user_ongoing_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('parcel ${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<TodayOrderParcel> tagObjs = tagObjsJson
              .map((tagJson) => TodayOrderParcel.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onParcelGoingOrders.clear();
              onParcelGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getParcelCanceledOreders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = parcel_user_cancel_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      print('${value.body}');
      if (value.statusCode == 200 && value.body != null) {
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<TodayOrderParcel> tagObjs = tagObjsJson
              .map((tagJson) => TodayOrderParcel.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onParcelGoingOrders.clear();
              onParcelGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  getParcelCompletedOrders() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = parcel_user_completed_order;
    http.post(url, body: {'user_id': '$userId'}).then((value) {
      if (value.statusCode == 200 && value.body != null) {
        print('${value.body}');
        if (value.body.contains("[{\"order_details\":\"no orders found\"}]") ||
            value.body.contains("{\"data\":[]}") ||
            value.body.contains("[{\"data\":\"No Cancelled Orders Yet\"}]")) {
        } else {
          var tagObjsJson = jsonDecode(value.body) as List;
          List<TodayOrderParcel> tagObjs = tagObjsJson
              .map((tagJson) => TodayOrderParcel.fromJson(tagJson))
              .toList();
          if (tagObjs.length > 0) {
            setState(() {
              onParcelGoingOrders.clear();
              onParcelGoingOrders = tagObjs;
            });
          }
        }
      }
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      if (countFetch == 4) {
        setState(() {
          isFetch = false;
        });
      }
      print(e);
    });
    countFetch = countFetch + 1;
  }

  void getAllThreeData() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
      isFetch = true;
      countFetch = 0;
      onGoingOrders.clear();
      onRestGoingOrders.clear();
      onPharmaGoingOrders.clear();
      onParcelGoingOrders.clear();
    });
    getOnGointOrders();
    getOnRestGointOrders();
    getOnPharmaGointOrders();
    getOnParcelGointOrders();
  }

  void getCancelledHistory() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
      isFetch = true;
      countFetch = 0;
      onGoingOrders.clear();
      onRestGoingOrders.clear();
      onPharmaGoingOrders.clear();
      onParcelGoingOrders.clear();
    });
    getCanceledOreders();
    getRestCanceledOreders();
    getPharmaCanceledOreders();
    getParcelCanceledOreders();
  }

  void getCompletedHistory() async{
  SharedPreferences preferences = await SharedPreferences.getInstance();
  setState(() {
  currency = preferences.getString('curency');
      isFetch = true;
      countFetch = 0;
      onGoingOrders.clear();
      onRestGoingOrders.clear();
      onPharmaGoingOrders.clear();
      onParcelGoingOrders.clear();
    });
    getCompletedOrders();
    getParcelCompletedOrders();
    getPharmaCompletedOrders();
    getRestCompletedOrders();
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).padding.top;
    var locale = AppLocalizations.of(context);
    setState(() {
      tabDesign = [
        locale.ongoingText,
        locale.cancelledText,
        locale.completedText,
      ];
    });

    return Scaffold(
      body: SafeArea(
        child: Container(
          color: kWhiteColor,
          child: Column(
            children: [
              Container(
                color: kWhiteColor,
                height: statusBarHeight*0.5,
              ),
              Container(
                color: kWhiteColor,
                width: MediaQuery.of(context).size.width,
                alignment: Alignment.center,
                child: Text(
                  locale.myOrdersText,
                  style: TextStyle(fontSize: 15),
                ),
              ),
              Container(
                color: kWhiteColor,
                height: statusBarHeight*0.5,
              ),
              Container(
                color: kWhiteColor,
                width: MediaQuery.of(context).size.width,
                height: 30,
                alignment: Alignment.center,
                child: ListView.builder(
                  itemCount: tabDesign.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          khit = index;
                        });
                        if (index == 0) {
                          getAllThreeData();
                        } else if (index == 1) {
                          getCancelledHistory();
                        } else if (index == 2) {
                          getCompletedHistory();
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width / 3,
                        alignment: Alignment.center,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Text(
                              '${tabDesign[index]}',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: kMainTextColor, fontSize: 15),
                            ),
                            Positioned(
                              bottom: 0.0,
                              width: MediaQuery.of(context).size.width / 3,
                              child: Container(
                                height: 1,
                                color: (khit == index) ? kMainColor : kWhiteColor,
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  primary: true,
                  child: Stack(
                    children: [
                      Visibility(
                          visible: ((onParcelGoingOrders != null &&
                                      onParcelGoingOrders.length > 0) ||
                                  (onRestGoingOrders != null &&
                                      onRestGoingOrders.length > 0) ||
                                  (onGoingOrders != null &&
                                      onGoingOrders.length > 0) ||
                                  (onPharmaGoingOrders != null &&
                                      onPharmaGoingOrders.length > 0))
                              ? true
                              : false,
                          child: Column(
                            children: [
                              Visibility(
                                  visible: (onGoingOrders != null &&
                                          onGoingOrders.length > 0)
                                      ? true
                                      : false,
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      primary: false,
                                      itemBuilder: (context, t) {
                                        return GestureDetector(
                                          onTap: () {
                                            if (onGoingOrders[t].order_status ==
                                                'Cancelled') {
                                            } else {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      OrderMapPage(
                                                    pageTitle:
                                                        '${onGoingOrders[t].vendor_name}',
                                                    ongoingOrders:
                                                        onGoingOrders[t],
                                                    currency: currency,
                                                  ),
                                                ),
                                              ).then((value) {
                                                if (khit == 0) {
                                                  getAllThreeData();
                                                } else if (khit == 1) {
                                                  getCancelledHistory();
                                                } else if (khit == 2) {
                                                  getCompletedHistory();
                                                }
                                              });
                                            }
                                          },
                                          behavior: HitTestBehavior.opaque,
                                          child: Container(
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 16.3),
                                                      child: Image.asset(
                                                        'images/maincategory/vegetables_fruitsact.png',
                                                        height: 42.3,
                                                        width: 33.7,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: ListTile(
                                                        title: Text(
                                                          'Order Id - #${onGoingOrders[t].cart_id}',
                                                          style:
                                                              orderMapAppBarTextStyle
                                                                  .copyWith(
                                                                      letterSpacing:
                                                                          0.07),
                                                        ),
                                                        subtitle: Text(
                                                          (onGoingOrders[t]
                                                                          .delivery_date !=
                                                                      null &&
                                                                  onGoingOrders[t]
                                                                          .time_slot !=
                                                                      null)
                                                              ? '${onGoingOrders[t].delivery_date} | ${onGoingOrders[t].time_slot}'
                                                              : '',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .headline6
                                                              .copyWith(
                                                                  fontSize: 11.7,
                                                                  letterSpacing:
                                                                      0.06,
                                                                  color: Color(
                                                                      0xffc1c1c1)),
                                                        ),
                                                        trailing: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: <Widget>[
                                                            Text(
                                                              '${onGoingOrders[t].order_status}',
                                                              style: orderMapAppBarTextStyle
                                                                  .copyWith(
                                                                      color:
                                                                          kMainColor),
                                                            ),
                                                            SizedBox(height: 7.0),
                                                            Text(
                                                              '${onGoingOrders[t].data.length} items | $currency ${onGoingOrders[t].price}',
                                                              style: Theme.of(
                                                                      context)
                                                                  .textTheme
                                                                  .headline6
                                                                  .copyWith(
                                                                      fontSize:
                                                                          11.7,
                                                                      letterSpacing:
                                                                          0.06,
                                                                      color: Color(
                                                                          0xffc1c1c1)),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                ),
                                                Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 1.0,
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36.0,
                                                          bottom: 6.0,
                                                          top: 12.0,
                                                          right: 12.0),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_pickup_pointact.png'),
                                                        size: 13.3,
                                                        color: kMainColor,
                                                      ),
                                                    ),
                                                    Text(
                                                      '${onGoingOrders[t].vendor_name}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption
                                                          .copyWith(
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                                  0.05),
                                                    ),
                                                  ],
                                                ),
                                                Row(
                                                  children: <Widget>[
                                                    Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 36.0,
                                                          bottom: 12.0,
                                                          top: 12.0,
                                                          right: 12.0),
                                                      child: ImageIcon(
                                                        AssetImage(
                                                            'images/custom/ic_droppointact.png'),
                                                        size: 13.3,
                                                        color: kMainColor,
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        '${onGoingOrders[t].address}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                fontSize: 10.0,
                                                                letterSpacing:
                                                                    0.05),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                (onGoingOrders.length - 1 == t)
                                                    ? Divider(
                                                        color:
                                                            kCardBackgroundColor,
                                                        thickness: 0,
                                                      )
                                                    : Divider(
                                                        color:
                                                            kCardBackgroundColor,
                                                        thickness: 13.3,
                                                      ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                      itemCount: onGoingOrders.length)),
                              Visibility(
                                visible: (onRestGoingOrders != null &&
                                    onRestGoingOrders.length > 0)
                                    ? true
                                    : false,
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible:(onGoingOrders != null &&
                                          onGoingOrders.length > 0),
                                      child: Divider(
                                        color: kCardBackgroundColor,
                                        thickness: 13.3,
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, t) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (onRestGoingOrders[t]
                                                  .order_status ==
                                                  'Cancelled') {
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderMapRestPage(
                                                          pageTitle:
                                                          '${onRestGoingOrders[t].vendor_name}',
                                                          ongoingOrders:
                                                          onRestGoingOrders[t],
                                                          currency: currency,
                                                        ),
                                                  ),
                                                ).then((value) {
                                                  if (khit == 0) {
                                                    getAllThreeData();
                                                  } else if (khit == 1) {
                                                    getCancelledHistory();
                                                  } else if (khit == 2) {
                                                    getCompletedHistory();
                                                  }
                                                });
                                              }
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 16.3),
                                                        child: Image.asset(
                                                          'images/maincategory/vegetables_fruitsact.png',
                                                          height: 42.3,
                                                          width: 33.7,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListTile(
                                                          title: Text(
                                                            'Order Id - #${onRestGoingOrders[t].cart_id}',
                                                            style: orderMapAppBarTextStyle
                                                                .copyWith(
                                                                letterSpacing:
                                                                0.07),
                                                          ),
                                                          subtitle: Text(
                                                            (onRestGoingOrders[t]
                                                                .delivery_date !=
                                                                null &&
                                                                onRestGoingOrders[
                                                                t]
                                                                    .time_slot !=
                                                                    null)
                                                                ? '${onRestGoingOrders[t].delivery_date} | ${onRestGoingOrders[t].time_slot}'
                                                                : '',
                                                            style: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                fontSize:
                                                                11.7,
                                                                letterSpacing:
                                                                0.06,
                                                                color: Color(
                                                                    0xffc1c1c1)),
                                                          ),
                                                          trailing: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: <Widget>[
                                                              Text(
                                                                '${onRestGoingOrders[t].order_status}',
                                                                style: orderMapAppBarTextStyle
                                                                    .copyWith(
                                                                    color:
                                                                    kMainColor),
                                                              ),
                                                              SizedBox(
                                                                  height: 7.0),
                                                              Text(
                                                                '${onRestGoingOrders[t].data.length} items | $currency ${onRestGoingOrders[t].remaining_amount}',
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .headline6
                                                                    .copyWith(
                                                                    fontSize:
                                                                    11.7,
                                                                    letterSpacing:
                                                                    0.06,
                                                                    color: Color(
                                                                        0xffc1c1c1)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: kCardBackgroundColor,
                                                    thickness: 1.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 36.0,
                                                            bottom: 6.0,
                                                            top: 12.0,
                                                            right: 12.0),
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'images/custom/ic_pickup_pointact.png'),
                                                          size: 13.3,
                                                          color: kMainColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${onRestGoingOrders[t].vendor_name}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                            fontSize: 10.0,
                                                            letterSpacing:
                                                            0.05),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 36.0,
                                                            bottom: 12.0,
                                                            top: 12.0,
                                                            right: 12.0),
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'images/custom/ic_droppointact.png'),
                                                          size: 13.3,
                                                          color: kMainColor,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${onRestGoingOrders[t].address}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                              0.05),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  (onRestGoingOrders.length - 1 ==
                                                          t)
                                                      ? Divider(
                                                          color:
                                                              kCardBackgroundColor,
                                                          thickness: 0.0,
                                                        )
                                                      : Divider(
                                                          color:
                                                              kCardBackgroundColor,
                                                          thickness: 13.3,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: onRestGoingOrders.length),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: (onPharmaGoingOrders != null &&
                                    onPharmaGoingOrders.length > 0)
                                    ? true
                                    : false,
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible:(onRestGoingOrders != null &&
                                          onRestGoingOrders.length > 0),
                                      child: Divider(
                                        color: kCardBackgroundColor,
                                        thickness: 13.3,
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, t) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (onPharmaGoingOrders[t]
                                                  .order_status ==
                                                  'Cancelled') {
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderMapPharmaPage(
                                                          pageTitle:
                                                          '${onPharmaGoingOrders[t].vendor_name}',
                                                          ongoingOrders:
                                                          onPharmaGoingOrders[t],
                                                          currency: currency,
                                                        ),
                                                  ),
                                                ).then((value) {
                                                  if (khit == 0) {
                                                    getAllThreeData();
                                                  } else if (khit == 1) {
                                                    getCancelledHistory();
                                                  } else if (khit == 2) {
                                                    getCompletedHistory();
                                                  }
                                                });
                                              }
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 16.3),
                                                        child: Image.asset(
                                                          'images/maincategory/vegetables_fruitsact.png',
                                                          height: 42.3,
                                                          width: 33.7,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListTile(
                                                          title: Text(
                                                            'Order Id - #${onPharmaGoingOrders[t].cart_id}',
                                                            style: orderMapAppBarTextStyle
                                                                .copyWith(
                                                                letterSpacing:
                                                                0.07),
                                                          ),
                                                          subtitle: Text(
                                                            (onPharmaGoingOrders[
                                                            t]
                                                                .delivery_date !=
                                                                null &&
                                                                onPharmaGoingOrders[
                                                                t]
                                                                    .time_slot !=
                                                                    null)
                                                                ? '${onPharmaGoingOrders[t].delivery_date} | ${onPharmaGoingOrders[t].time_slot}'
                                                                : '',
                                                            style: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                fontSize:
                                                                11.7,
                                                                letterSpacing:
                                                                0.06,
                                                                color: Color(
                                                                    0xffc1c1c1)),
                                                          ),
                                                          trailing: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: <Widget>[
                                                              Text(
                                                                '${onPharmaGoingOrders[t].order_status}',
                                                                style: orderMapAppBarTextStyle
                                                                    .copyWith(
                                                                    color:
                                                                    kMainColor),
                                                              ),
                                                              SizedBox(
                                                                  height: 7.0),
                                                              Text(
                                                                '${onPharmaGoingOrders[t].data.length} items | $currency ${onPharmaGoingOrders[t].remaining_amount}',
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .headline6
                                                                    .copyWith(
                                                                    fontSize:
                                                                    11.7,
                                                                    letterSpacing:
                                                                    0.06,
                                                                    color: Color(
                                                                        0xffc1c1c1)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: kCardBackgroundColor,
                                                    thickness: 1.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 36.0,
                                                            bottom: 6.0,
                                                            top: 12.0,
                                                            right: 12.0),
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'images/custom/ic_pickup_pointact.png'),
                                                          size: 13.3,
                                                          color: kMainColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${onPharmaGoingOrders[t].vendor_name}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                            fontSize: 10.0,
                                                            letterSpacing:
                                                            0.05),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 36.0,
                                                            bottom: 12.0,
                                                            top: 12.0,
                                                            right: 12.0),
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'images/custom/ic_droppointact.png'),
                                                          size: 13.3,
                                                          color: kMainColor,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${onPharmaGoingOrders[t].address}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                              0.05),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  (onPharmaGoingOrders.length -
                                                              1 ==
                                                          t)
                                                      ? Divider(
                                                          color:
                                                              kCardBackgroundColor,
                                                          thickness: 0.0,
                                                        )
                                                      : Divider(
                                                          color:
                                                              kCardBackgroundColor,
                                                          thickness: 13.3,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: onPharmaGoingOrders.length),
                                  ],
                                ),
                              ),
                              Visibility(
                                visible: (onParcelGoingOrders != null &&
                                    onParcelGoingOrders.length > 0)
                                    ? true
                                    : false,
                                child: Column(
                                  children: [
                                    Visibility(
                                      visible:(onPharmaGoingOrders != null &&
                                          onPharmaGoingOrders.length > 0),
                                      child: Divider(
                                        color: kCardBackgroundColor,
                                        thickness: 13.3,
                                      ),
                                    ),
                                    ListView.builder(
                                        shrinkWrap: true,
                                        primary: false,
                                        itemBuilder: (context, t) {
                                          return GestureDetector(
                                            onTap: () {
                                              if (onParcelGoingOrders[t]
                                                  .order_status ==
                                                  'Cancelled') {
                                              } else {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OrderMapParcelPage(
                                                          pageTitle:
                                                          '${onParcelGoingOrders[t].vendor_name}',
                                                          ongoingOrders:
                                                          onParcelGoingOrders[t],
                                                          currency: currency,
                                                        ),
                                                  ),
                                                ).then((value) {
                                                  if (khit == 0) {
                                                    getAllThreeData();
                                                  } else if (khit == 1) {
                                                    getCancelledHistory();
                                                  } else if (khit == 2) {
                                                    getCompletedHistory();
                                                  }
                                                });
                                              }
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Container(
                                              child: Column(
                                                children: [
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                        const EdgeInsets.only(
                                                            left: 16.3),
                                                        child: Image.asset(
                                                          'images/maincategory/vegetables_fruitsact.png',
                                                          height: 42.3,
                                                          width: 33.7,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: ListTile(
                                                          title: Text(
                                                            'Order Id - #${onParcelGoingOrders[t].cart_id}',
                                                            style: orderMapAppBarTextStyle
                                                                .copyWith(
                                                                letterSpacing:
                                                                0.07),
                                                          ),
                                                          subtitle: Text(
                                                            (onParcelGoingOrders[
                                                            t]
                                                                .pickup_date !=
                                                                null &&
                                                                onParcelGoingOrders[
                                                                t]
                                                                    .pickup_time !=
                                                                    null)
                                                                ? '${onParcelGoingOrders[t].pickup_date} | ${onParcelGoingOrders[t].pickup_time}'
                                                                : '',
                                                            style: Theme.of(
                                                                context)
                                                                .textTheme
                                                                .headline6
                                                                .copyWith(
                                                                fontSize:
                                                                11.7,
                                                                letterSpacing:
                                                                0.06,
                                                                color: Color(
                                                                    0xffc1c1c1)),
                                                          ),
                                                          trailing: Column(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                            children: <Widget>[
                                                              Text(
                                                                '${onParcelGoingOrders[t].order_status}',
                                                                style: orderMapAppBarTextStyle
                                                                    .copyWith(
                                                                    color:
                                                                    kMainColor),
                                                              ),
                                                              SizedBox(
                                                                  height: 5.0),
                                                              Text(
                                                                '1 items | ${currency} ${(double.parse('${onParcelGoingOrders[t].distance}') > 1) ? double.parse('${onParcelGoingOrders[t].charges}') * double.parse('${onParcelGoingOrders[t].distance}') : double.parse('${onParcelGoingOrders[t].charges}')}\n',
                                                                style: Theme.of(
                                                                    context)
                                                                    .textTheme
                                                                    .headline6
                                                                    .copyWith(
                                                                    fontSize:
                                                                    11.7,
                                                                    letterSpacing:
                                                                    0.06,
                                                                    color: Color(
                                                                        0xffc1c1c1)),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  Divider(
                                                    color: kCardBackgroundColor,
                                                    thickness: 1.0,
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 36.0,
                                                            bottom: 6.0,
                                                            top: 12.0,
                                                            right: 12.0),
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'images/custom/ic_pickup_pointact.png'),
                                                          size: 13.3,
                                                          color: kMainColor,
                                                        ),
                                                      ),
                                                      Text(
                                                        '${onParcelGoingOrders[t].vendor_name}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                            fontSize: 10.0,
                                                            letterSpacing:
                                                            0.05),
                                                      ),
                                                    ],
                                                  ),
                                                  Row(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding: EdgeInsets.only(
                                                            left: 36.0,
                                                            bottom: 12.0,
                                                            top: 12.0,
                                                            right: 12.0),
                                                        child: ImageIcon(
                                                          AssetImage(
                                                              'images/custom/ic_droppointact.png'),
                                                          size: 13.3,
                                                          color: kMainColor,
                                                        ),
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          '${onParcelGoingOrders[t].vendor_loc}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(
                                                              fontSize: 10.0,
                                                              letterSpacing:
                                                              0.05),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  (onParcelGoingOrders.length -
                                                              1 ==
                                                          t)
                                                      ? Divider(
                                                          color:
                                                              kCardBackgroundColor,
                                                          thickness: 0.0,
                                                        )
                                                      : Divider(
                                                          color:
                                                              kCardBackgroundColor,
                                                          thickness: 13.3,
                                                        ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                        itemCount: onParcelGoingOrders.length),
                                  ],
                                ),
                              ),
                            ],
                          )),
                      Visibility(
                        visible: ((onRestGoingOrders != null &&
                                    onRestGoingOrders.length == 0) &&
                                (onGoingOrders != null &&
                                    onGoingOrders.length == 0) &&
                                (onPharmaGoingOrders != null &&
                                    onPharmaGoingOrders.length == 0) &&
                                (onParcelGoingOrders != null &&
                                    onParcelGoingOrders.length == 0))
                            ? true
                            : false,
                        child: (!isFetch)
                            ? Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height-100,
                          alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      locale.noOrderFoundText1,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                        fontSize: 25,
                                        color: kMainTextColor,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.0,
                                            top: 10.0,
                                            bottom: 50,
                                            right: 20.0),
                                        child: Text(
                                          locale.noOrderFoundText2,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                            fontSize: 18,
                                            color: kHintColor,
                                          ),
                                        )),
                                    RaisedButton(
                                      onPressed: () {
                                        // clearCart();
                                        // Navigator.pushAndRemoveUntil(context,
                                        //     MaterialPageRoute(builder: (context) {
                                        //   return HomeOrderAccount();
                                        // }), (Route<dynamic> route) => false);
                                        Navigator.of(context).pushNamedAndRemoveUntil(PageRoutes.homeOrderAccountPage, (Route<dynamic> route) => false);

                                      },
                                      child: Text(
                                        locale.shopNowText,
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
                                    )
                                  ],
                                ),
                            )
                            : Container(
                                width: MediaQuery.of(context).size.width,
                                height: MediaQuery.of(context).size.height-100,
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
                                      locale.fetchingOrdersText,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: kMainTextColor),
                                    )
                                  ],
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
