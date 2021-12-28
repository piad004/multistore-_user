import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/bean/vendorbanner.dart';
import 'package:user/parcel/fromtoaddress.dart';

class ParcalStoresPage extends StatefulWidget {
  final dynamic vendor_category_id;

  ParcalStoresPage(this.vendor_category_id);

  @override
  State<StatefulWidget> createState() {
    return ParcalPageState(vendor_category_id);
  }
}

class ParcalPageState extends State<ParcalStoresPage> {
  TextEditingController searchController = TextEditingController();
  final dynamic vendor_category_id;

  // final dynamic ui_type;

  List<VendorBanner> listImage = [];
  List<NearStores> nearStores = [];
  List<NearStores> nearStoresSearch = [];
  List<NearStores> nearStoresShimmer = [
    NearStores("", "", "", "", "", "", "", "", "", "", "", ""),
    NearStores("", "", "", "", "", "", "", "", "", "", "", ""),
    NearStores("", "", "", "", "", "", "", "", "", "", "", ""),
    NearStores("", "", "", "", "", "", "", "", "", "", "", "")
  ];
  List<String> listImages = ['', '', '', '', ''];
  double userLat = 0.0;
  double userLng = 0.0;
  bool isFetch = false;
  bool isFetchStore = true;

  ParcalPageState(this.vendor_category_id);

  bool isCartCount = false;
  int cartCount = 0;

  @override
  void initState() {
    getShareValue();
    super.initState();
    hitService();
  }

  @override
  void dispose() {
    super.dispose();
//    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (searchController != null && searchController.text.length > 0) {
          setState(() {
            searchController.clear();
            nearStores.clear();
            nearStores = List.from(nearStoresSearch);
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: CustomAppBar(
            titleWidget: Text(
              locale.parcelpagehedingText,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            bottom: PreferredSize(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 52,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      color: scaffoldBgColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: TextFormField(
                    controller: searchController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: kHintColor,
                      ),
                      hintText: locale.searchStoreText,
                    ),
                    cursorColor: kMainColor,
                    autofocus: false,
                    onChanged: (value) {
                      nearStores = nearStoresSearch
                          .where((element) => element.vendor_name
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                          .toList();
                    },
                  ),
                ),
                preferredSize:
                    Size(MediaQuery.of(context).size.width * 0.85, 52)),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 110,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(left: 20.0, top: 20.0),
                  child: Text(
                    '${nearStores.length} ${locale.storesFoundText}',
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: kHintColor, fontSize: 18),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                (nearStores != null && nearStores.length > 0)
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: ListView.separated(
                            shrinkWrap: true,
                            primary: false,
                            scrollDirection: Axis.vertical,
                            itemCount: nearStores.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  if ((nearStores[index].online_status ==
                                          "on" ||
                                      nearStores[index].online_status == "On" ||
                                      nearStores[index].online_status ==
                                          "ON")) {
                                    hitNavigator(
                                        context,
                                        nearStores[index].vendor_name,
                                        nearStores[index].vendor_id,
                                        nearStores[index].distance);
                                  } else {
                                    Toast.show(locale.storesClosedText, context,
                                        duration: Toast.LENGTH_SHORT);
                                  }
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Material(
                                  elevation: 2,
                                  shadowColor: white_color,
                                  clipBehavior: Clip.hardEdge,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Stack(
                                    children: [
                                      Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        color: white_color,
                                        padding: EdgeInsets.only(
                                            left: 20.0, top: 15, bottom: 15),
                                        child: Row(
                                          children: <Widget>[
                                            Image.network(
                                              imageBaseUrl +
                                                  nearStores[index].vendor_logo,
                                              width: 93.3,
                                              height: 93.3,
                                            ),
                                            SizedBox(width: 13.3),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: <Widget>[
                                                  Text(
                                                      nearStores[index]
                                                          .vendor_name,
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .subtitle2
                                                          .copyWith(
                                                              color:
                                                                  kMainTextColor,
                                                              fontSize: 18)),
                                                  SizedBox(height: 8.0),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.location_on,
                                                        color: kIconColor,
                                                        size: 15,
                                                      ),
                                                      SizedBox(width: 10.0),
                                                      Text(
                                                          '${double.parse('${nearStores[index].distance}').toStringAsFixed(2)} km ',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(
                                                                  color:
                                                                      kLightTextColor,
                                                                  fontSize:
                                                                      13.0)),
                                                      Text('| ',
                                                          style: Theme.of(
                                                                  context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(
                                                                  color:
                                                                      kMainColor,
                                                                  fontSize:
                                                                      13.0)),
                                                      Expanded(
                                                        child: Text(
                                                            '${nearStores[index].vendor_loc}',
                                                            maxLines: 2,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .caption
                                                                .copyWith(
                                                                    color:
                                                                        kLightTextColor,
                                                                    fontSize:
                                                                        13.0)),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(height: 6),
                                                  Row(
                                                    children: <Widget>[
                                                      Icon(
                                                        Icons.access_time,
                                                        color: kIconColor,
                                                        size: 15,
                                                      ),
                                                      SizedBox(width: 10.0),
                                                      Text('${calculateTime(double.parse('${nearStores[index].lat}'), double.parse('${nearStores[index].lng}'), userLat, userLng)}',
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(
                                                              color:
                                                              kLightTextColor,
                                                              fontSize: 13.0)),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Positioned(
                                        bottom: 20,
                                        child: Visibility(
                                          visible: (nearStores[index]
                                                          .online_status ==
                                                      "off" ||
                                                  nearStores[index]
                                                          .online_status ==
                                                      "Off" ||
                                                  nearStores[index]
                                                          .online_status ==
                                                      "OFF")
                                              ? true
                                              : false,
                                          child: Container(
                                            height: 40,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                10,
                                            alignment: Alignment.center,
                                            color: kCardBackgroundColor,
                                            child: Text(
                                              locale.storesClosedText,
                                              style: TextStyle(
                                                  color: red_color,
                                                  fontSize: headingSize),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                height: 10,
                              );
                            }),
                      )
                    : Container(
                        height: MediaQuery.of(context).size.height / 2,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            isFetchStore
                                ? CircularProgressIndicator()
                                : Container(
                                    width: 0.5,
                                  ),
                            isFetchStore
                                ? SizedBox(
                                    width: 10,
                                  )
                                : Container(
                                    width: 0.5,
                                  ),
                            Text(
                              (!isFetchStore)
                                  ? locale.noStoresFoundText
                                  : locale.fetchingStoresText,
                              style: TextStyle(
                                  fontSize: headingSize,
                                  fontWeight: FontWeight.w600,
                                  color: kMainTextColor),
                            )
                          ],
                        ),
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void hitService() async {
    setState(() {
      isFetchStore = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(
        '${prefs.getString('lat')} - ${prefs.getString('lng')} - ${vendor_category_id}');
    var url = nearByStore;
    http.post(url, body: {
      'lat': '${prefs.getString('lat')}',
      'lng': '${prefs.getString('lng')}',
      'vendor_category_id': '${vendor_category_id}',
      'ui_type': '${prefs.getString('ui_type')}'
    }).then((value) {
      print('${value.statusCode} ${value.body}');
      if (value.statusCode == 200) {
        print('Response Body: - ${value.body}');
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body)['data'] as List;
          List<NearStores> tagObjs = tagObjsJson
              .map((tagJson) => NearStores.fromJson(tagJson))
              .toList();
          setState(() {
            nearStores.clear();
            nearStoresSearch.clear();
            nearStores = tagObjs;
            nearStoresSearch = List.from(nearStores);
          });
        }
      }
      setState(() {
        isFetchStore = false;
      });
    }).catchError((e) {
      setState(() {
        isFetchStore = false;
      });
      print(e);
      Timer(Duration(seconds: 5), () {
        hitService();
      });
    });
  }

  hitNavigator(BuildContext context, vendor_name, vendor_id, distance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("pr_vendor_id", '${vendor_id}');
    prefs.setString("pr_store_name", '${vendor_name}');
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                AddressFrom(vendor_name, vendor_id, distance)));
  }

  getShareValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userLat = double.parse('${prefs.getString('lat')}');
      userLng = double.parse('${prefs.getString('lng')}');
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  String calculateTime(lat1, lon1, lat2, lon2){
    double kms = calculateDistance(lat1, lon1, lat2, lon2);
    double kms_per_min = 0.5;
    double mins_taken = kms / kms_per_min;
    double min = mins_taken;
    if (min<60) {
      return ""+'${min.toInt()}'+" mins";
    }else {
      double tt = min % 60;
      String minutes = '${tt.toInt()}';
      minutes = minutes.length == 1 ? "0" + minutes : minutes;
      return '${(min.toInt() / 60)}' + " hour " + minutes +"mins";
    }
  }
}
