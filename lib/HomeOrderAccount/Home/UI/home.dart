import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/Components/reusable_card.dart';
import 'package:user/HomeOrderAccount/Home/UI/Search.dart';
import 'package:user/HomeOrderAccount/Home/UI/Stores/stores.dart';
import 'package:user/HomeOrderAccount/Home/UI/appcategory/appcategory.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Maps/UI/location_page.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/BestDeal.dart';
import 'package:user/bean/BestRated.dart';
import 'package:user/bean/bannerbean.dart';
import 'package:user/bean/latlng.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/bean/venderbean.dart';
import 'package:user/HomeOrderAccount/Home/UI/SearchModel.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/parcel/fromtoaddress.dart';
import 'package:user/parcel/parcalstorepage.dart';
import 'package:user/pharmacy/pharmadetailpage.dart';
import 'package:user/pharmacy/pharmastore.dart';
import 'package:user/restaturantui/pages/restaurant.dart';
import 'package:user/restaturantui/ui/resturanthome.dart';
import 'package:user/restaturantui/ui/search.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String cityName = 'NO LOCATION SELECTED';
  double lat = 0.0;
  double lng = 0.0;
  List<BannerDetails> listImage = [];
  List<Data> searchList = [];
  List<VendorList> nearStores = [];
  List<BestDeal> bestDealList = [];
  List<BestRated> bestRatingList = [];
  List<VendorList> nearStoresShimmer = [
    VendorList("", "", "", ""),
    VendorList("", "", "", ""),
    VendorList("", "", "", ""),
    VendorList("", "", "", "")
  ];
  List<String> listImages = ['', '', '', '', ''];
  bool isCartCount = false;
  int cartCount = 0;
  bool isFetch = true;
  bool locGrant = true;

  static const List<Color> colors = [
    Colors.blue,
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.grey,
    Colors.pink
  ];
  static List<Color> lightColors = [
    lightBlue,
    lightRed,
    lightYellow,
    lightGreen,
    lightGrey,
    lightPink
  ];
  var pos = 0;
  var isDelvmartBanner = "off";
  var delvmartBanner = "";
  var delvmartVendorId;
  var delvmartVendorName = "";
  var delvmartDistance;
  var delvmartVendorLogo;
  var delvmartVendorCategoryId;
  var delvmartVendorPhone;
  var delvmartDeliveryRange;
  var delvmartOnlineStatus;
  var delvmartVendorLoc;
  var delvmartAbout;
  var delvmartUiType;
  var currency;

  TextEditingController searchController = TextEditingController();
  bool enteredFirst = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
  }

  void _getLocation(context, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('lat') && !prefs.containsKey('lng')&&!prefs.containsKey('lnga')) {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.whileInUse ||
          permission == LocationPermission.always) {
        bool isLocationServiceEnableds =
        await Geolocator.isLocationServiceEnabled();
        if (isLocationServiceEnableds) {
          Position position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.best);
          double lat = position.latitude;
          double lng = position.longitude;
          //get
          setState(() {
            locGrant = true;
            this.lat = lat;
            this.lng = lng;
          });
          prefs.setString("lat", lat.toString());
          prefs.setString("lng", lng.toString());
          prefs.setString("userLat", lat.toString());
          prefs.setString("userLng", lng.toString());
          hitAddressPlace(lat, lng);
        } else {
          showAlertDialog(context, locale, 'opens');
        }
      } else if (permission == LocationPermission.denied) {
        showAlertDialog(context, locale, 'openp');
      } else if (permission == LocationPermission.deniedForever) {
        showAlertDialog(context, locale, 'openas');
      }
    } else {
      /*double latw = double.parse('${prefs.getString('lat')}');
      double lngw = double.parse('${prefs.getString('lng')}');*/
      double latw = double.parse('0.0');
      double lngw = double.parse('0.0');
      print('$latw - $lngw');
      if (latw != null && lngw != null && latw > 0.0 && lngw > 0.0) {
        hitAddressPlace(latw, lngw);
      } else {
        prefs.remove('lat');
        prefs.remove('lng');
        _getLocation(context, locale);
      }
    }
  }

  void hitAddressPlace(double latd, double lngd) async {
    setState(() {
      this.lat = latd;
      this.lng = lngd;
    });
    print('$lat - $lng');
    final coordinates = new Coordinates(lat, lng);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      for (Address add in value) {
        print(add.addressLine);
      }
      if (value[0].featureName != null &&
          value[0].featureName.isNotEmpty &&
          value[0].subAdminArea != null &&
          value[0].subAdminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].featureName}';
          cityName = '${city} (${value[0].subAdminArea})';
        });
      } else if (value[0].subAdminArea != null &&
          value[0].subAdminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].subAdminArea}';
          cityName = '${city.toUpperCase()}';
        });
      } else if (value[0].adminArea != null && value[0].adminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].subAdminArea}';
          cityName = '${city.toUpperCase()}';
        });
      } else {
        setState(() {
          String city = '${value[0].addressLine}';
          cityName = '${city}';
        });
      }
      if (cityName.toUpperCase() == 'NULL') {
        setState(() {
          cityName = 'Change your location';
        });
      } else if (cityName.toUpperCase().contains('NULL')) {
        setState(() {
          cityName = 'Change your location';
        });
      }
    }).catchError((e) {
      setState(() {
        cityName = 'Change your location';
      });
    });
    getCurrency();
    hitService();
    hitBannerUrl(lat, lng);
    hitServiceBestDeal(lat, lng);
    hitServiceBestRated(lat, lng);
  }

  void performAction(BuildContext context, AppLocalizations locale,
      String type) async {
    if (type == 'opens') {
      Geolocator.openLocationSettings().then((value) {
        if (value) {
          _getLocation(context, locale);
        } else {
          Toast.show(locale.locationPermissionIsRequired, context,
              duration: Toast.LENGTH_SHORT);
        }
      }).catchError((e) {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      });
    } else if (type == 'openp') {
      Geolocator.requestPermission().then((permissiond) {
        if (permissiond == LocationPermission.whileInUse ||
            permissiond == LocationPermission.always) {
          _getLocation(context, locale);
        } else {
          Toast.show(locale.locationPermissionIsRequired, context,
              duration: Toast.LENGTH_SHORT);
        }
      });
    } else if (type == 'openas') {
      Geolocator.openAppSettings().then((value) {
        _getLocation(context, locale);
      }).catchError((e) {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      });
    }
  }

  showAlertDialog(BuildContext context, AppLocalizations locale, String type) {
    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        performAction(context, locale, type);
      },
      behavior: HitTestBehavior.opaque,
      child: Material(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            locale.ok,
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );

    Widget no = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      behavior: HitTestBehavior.opaque,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            locale.noText,
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(locale.locationheading),
      content: Text(locale.locationheadingSub),
      actions: [clear, no],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void getCartCount() {
    DatabaseHelper db = DatabaseHelper.instance;
    db.queryRowBothCount().then((value) {
      setState(() {
        if (value != null && value > 0) {
          cartCount = value;
          isCartCount = true;
        } else {
          cartCount = 0;
          isCartCount = false;
        }
      });
    });
  }

  void getCurrency() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var currencyUrl = currencyuri;
    var client = http.Client();
    client.get(currencyUrl).then((value) {
      var jsonData = jsonDecode(value.body);
      if (value.statusCode == 200 && jsonData['status'] == "1") {
        preferences.setString(
            'curency', '${jsonData['data'][0]['currency_sign']}');
        currency=jsonData['data'][0]['currency_sign'];
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    if (!enteredFirst) {
      setState(() {
        enteredFirst = true;
      });
      _getLocation(context, locale);
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(229, 3, 4, 8)),
          child: Column(children: [
            CustomAppBar(
                color: kMainColor,
                leading: Padding(
                  padding: const EdgeInsets.only(left: 10),
                  child: Icon(
                    Icons.location_on,
                    color: kWhiteColor,
                  ),
                ),
                titleWidget: GestureDetector(
                  onTap: () {
                    double latt = 0.0;
                    double lngt = 0.0;
                    if (lat != null && lng != null && lat > 0.0 && lng > 0.0) {
                      latt = lat;
                      lngt = lng;
                    }
                    print('dd $latt - $lngt');
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return LocationPage(latt, lngt,false);
                    })).then((value) {
                      if (value != null) {
                        print('${value.toString()}');
                        BackLatLng back = value;
                        getBackResult(back.lat, back.lng, back.address);
                      }
                    }).catchError((e) {
                      print(e);
                    });
                  },
                  child: Row(children: [
                    Text(
                      '${cityName}',
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: kWhiteColor),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 50),
                      child: Icon(
                        Icons.arrow_downward_rounded,
                        color: kWhiteColor,
                      ),
                    ),
                  ]),
                ),
                actions: []),
            Container(
              width: MediaQuery
                  .of(context)
                  .size
                  .width * 0.9,
              height: 48,
              padding: EdgeInsets.only(left: 5),
              decoration: BoxDecoration(
                  color: kWhiteColor, borderRadius: BorderRadius.circular(5)),
              child: TextFormField(
                style: TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: kHintColor,
                  ),
                  //hintText: locale.searchStoreText,
                  hintText: "Search for store/item",
                ),
                controller: searchController,
                cursorColor: kMainColor,
                autofocus: false,
                readOnly: true,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              SearchPage('["all"]','1','','',''))).then((value) {

                  });
                },
                onChanged: (value) {
                  /*hitSearchUrl(value, lat, lng);*/
                  /* nearStores = nearStoresSearch
                        .where((element) => element.vendor_name
                        .toString()
                        .toLowerCase()
                        .contains(value.toLowerCase()))
                        .toList();*/
                },
              ),
            )
          ]),
        ),
      ),
      body: locGrant
          ?  RefreshIndicator(
          key: refreshKey,
          child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              /*Padding(
                padding: EdgeInsets.only(top: 16.0, left: 24.0),
                child: Row(
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: locale.gotDeliveredText,
                            style: Theme.of(context).textTheme.bodyText1,
                            children: <TextSpan>[
                              TextSpan(
                                  text:
                                  ' ${locale.everythingYouNeedText}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontWeight: FontWeight.normal))
                            ])),
                    // Expanded(
                    //   child: Text(
                    //     locale.gotDeliveredText,
                    //     style: Theme.of(context).textTheme.bodyText1,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 5.0,
                    // ),
                    // Text(
                    //   locale.everythingYouNeedText,
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1
                    //       .copyWith(fontWeight: FontWeight.normal),
                    // ),
                  ],
                ),
              ),*/
              Visibility(
                visible:
                (!isFetch && listImage.length == 0) ? false : true,
                child: Padding(
                  padding: EdgeInsets.only(top: 10, bottom: 5),
                  child: CarouselSlider(
                      options: CarouselOptions(
                        height: 170.0,
                        autoPlay: true,
                        initialPage: 0,
                        viewportFraction: 0.9,
                        enableInfiniteScroll: true,
                        reverse: false,
                        autoPlayInterval: Duration(seconds: 3),
                        autoPlayAnimationDuration:
                        Duration(milliseconds: 800),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        scrollDirection: Axis.horizontal,
                      ),
                      items: (listImage != null && listImage.length > 0)
                          ? listImage.map((e) {
                        return Builder(
                          builder: (context) {
                            return InkWell(
                              onTap: () {
                                hitNavigatorStore(context, e.ui_type, e.vendor_name, e.vendor_id, e.delivery_range, e.distance, e.about,
                                    e.online_status,e.vendor_category_id, e.vendor_loc, e.vendor_logo, e.vendor_phone);
                               /* Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            AppCategory(
                                                e.vendor_name, e.vendor_id,
                                                e.distance))).then((value) {
                                  getCartCount();
                                });*/
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 10),
                                child: Material(
                                  elevation: 5,
                                  borderRadius:
                                  BorderRadius.circular(20.0),
                                  clipBehavior: Clip.hardEdge,
                                  child: Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width *
                                        0.90,
//                                            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                                    decoration: BoxDecoration(
                                      color: white_color,
                                      borderRadius:
                                      BorderRadius.circular(
                                          20.0),
                                    ),
                                    child: Image.network(
                                      //imageBaseUrl + e.banner_image,
                                      e.banner_image,
                                      fit: BoxFit.fill,
                                      errorBuilder: (context,
                                          exception,
                                          stackTrack) =>
                                          Image.asset(
                                              'images/delvmart.png',
                                              fit: BoxFit.fill),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      }).toList()
                          : listImages.map((e) {
                        return Builder(builder: (context) {
                          return Container(
                            width:
                            MediaQuery
                                .of(context)
                                .size
                                .width *
                                0.90,
                            margin: EdgeInsets.symmetric(
                                horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius:
                              BorderRadius.circular(20.0),
                            ),
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              //Default value
                              color: Colors.white,
                              //Default value
                              enabled: true,
                              //Default value
                              direction:
                              ShimmerDirection.fromLTRB(),
                              //Default Value
                              child: Container(
                                color: kTransparentColor,
                              ),
                            ),
                          );
                        });
                      }).toList()),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 16.0, left: 10.0),
                child: Row(
                  children: <Widget>[
                    RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                            text: "Instant Delivery",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black),
                            //style: Theme.of(context).textTheme.bodyText1,
                            children: <TextSpan>[
                              /*TextSpan(
                                  text:
                                  ' ${locale.everythingYouNeedText}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyText1
                                      .copyWith(fontWeight: FontWeight.normal))*/
                            ])),
                    // Expanded(
                    //   child: Text(
                    //     locale.gotDeliveredText,
                    //     style: Theme.of(context).textTheme.bodyText1,
                    //   ),
                    // ),
                    // SizedBox(
                    //   width: 5.0,
                    // ),
                    // Text(
                    //   locale.everythingYouNeedText,
                    //   style: Theme.of(context)
                    //       .textTheme
                    //       .bodyText1
                    //       .copyWith(fontWeight: FontWeight.normal),
                    // ),
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  childAspectRatio: 100/80,
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: (nearStores != null && nearStores.length > 0)
                      ? nearStores.map((e) {
                    pos = nearStores.indexOf(e) % 3;
                    return Container(
                      child: InkWell(
                        onTap: () =>
                            hitNavigator(
                                context,
                                e.category_name,
                                e.ui_type,
                                e.vendor_category_id),
                        child: Container(
                          height: 100,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            /* gradient: LinearGradient(
                                  colors: [
                                    lightColors[pos],
                                    Colors.white,
                                    Colors.white,
                                    Colors.white
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  stops: [0.2, 1,1,1],
                                  tileMode: TileMode.decal),*/
                            borderRadius:
                            BorderRadius.circular(5.0),
                            image: DecorationImage(
                              fit: BoxFit.fill,
                              image: NetworkImage(
                                '${e.category_image}',
                                //'${imageBaseUrl}${e.category_image}',
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text('',
                                // child: Text('${e.category_name}',
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: colors[pos])),
                          ),
                          margin: EdgeInsets.all(5.0),
                        ),
                      ),
                    );
                    /*return ReusableCard(
                      cardChild: CardContent(
                        text: '${e.category_name}',
                        image: '${imageBaseUrl}${e.category_image}',
                      ),
                      onPress: () => hitNavigator(
                          context,
                          e.category_name,
                          e.ui_type,
                          e.vendor_category_id),
                    );*/
                  }).toList()
                      : nearStoresShimmer.map((e) {
                    return ReusableCard(
                        cardChild: Shimmer(
                          duration: Duration(seconds: 3),
                          //Default value
                          color: Colors.white,
                          //Default value
                          enabled: true,
                          //Default value
                          direction: ShimmerDirection.fromLTRB(),
                          //Default Value
                          child: Container(
                            color: kTransparentColor,
                          ),
                        ),
                        onPress: () {});
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                color: Colors.black12,
                height: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),

              Visibility(
                visible: isDelvmartBanner == "on" || isDelvmartBanner == "On" ||
                    isDelvmartBanner == "ON" ? true : false,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.only(left: 10),
                      child: Text(
                        "Delvmart", textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        //style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),

                    InkWell(
                      onTap: () {
                        hitNavigatorStore(context,delvmartUiType,delvmartVendorName, delvmartVendorId,
                           delvmartDeliveryRange, delvmartDistance,delvmartAbout,delvmartOnlineStatus,delvmartVendorCategoryId,
                        delvmartVendorLoc,delvmartVendorLogo,delvmartVendorPhone);
                      },
                      child:
                      // if(isDelvmartBanner=="on"){
                      Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10.0),
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            width: MediaQuery
                                .of(context)
                                .size
                                .width * 0.94,
                            height: MediaQuery
                                .of(context)
                                .size
                                .width * 0.40,
//                                            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                            decoration: BoxDecoration(
                              color: white_color,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Image.network(
                              //'images/delvmart.png',
                              delvmartBanner,
                              fit: BoxFit.fill,
                              errorBuilder: (context, exception, stackTrack) =>
                                  Image.asset(
                                      'images/delvmart.png',
                                      fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ) /*}else {Text(
                    '',)}*/,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5, right: 5),
                      color: Colors.black12,
                      height: 2,
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              '',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Best deals for you  ", textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      //style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Image.asset(
                      'images/best_deals.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.fitWidth,
                    ),
                    //Image(image: NetworkImage('https://www.gstatic.com/webp/gallery/4.jpg'),height: 20,width: 20,)
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  //childAspectRatio: 200,
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: (bestDealList != null && bestDealList.length > 0)
                      ? bestDealList.map((e) {
                    pos = bestDealList.indexOf(e) % 3;
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(width: 1, color: darkYellowColor1)),
                      // child: ListTile(),
                      child: Container(
                        height: 300,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            hitNavigatorStore(context, e.ui_type, e.vendor_name, e.vendor_id, e.delivery_range, e.distance, e.about,
                                e.online_status,e.vendor_category_id, e.vendor_loc, e.logo, e.vendor_phone);
                           /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AppCategory(
                                            e.vendor_name, e.vendor_id,
                                            e.distance))).then((value) {
                              getCartCount();
                            });*/
                          },
                          child:
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              margin: EdgeInsets.only(top:5),
                              child:
                            Image.network(
                              e.logo,
                              fit: BoxFit.fill, height: 48, width: 40,
                              errorBuilder: (context, exception, stackTrack) =>
                                  Image.asset(
                                      'images/delvmart.png',
                                      fit: BoxFit.fill, height: 48, width: 40),
                            ),
                              //NetworkImage('https://www.gstatic.com/webp/gallery/4.jpg'),height: 50,width: 40,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, top: 2, bottom: 2, right: 5),
                              color: darkYellowColor1,
                              height: 1,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text(e.percentage.toString() +
                                "% Off", textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: darkRedColor),
                              //style: Theme.of(context).textTheme.bodyText1,
                            ),
                          ],
                        ),
                        ),
                      ),
                      margin: EdgeInsets.all(5.0),
                    );
                    /*return ReusableCard(
                      cardChild: CardContent(
                        text: '${e.category_name}',
                        image: '${imageBaseUrl}${e.category_image}',
                      ),
                      onPress: () => hitNavigator(
                          context,
                          e.category_name,
                          e.ui_type,
                          e.vendor_category_id),
                    );*/

                  }).toList()
                      : nearStoresShimmer.map((e) {
                    return ReusableCard(
                        cardChild: Shimmer(
                          duration: Duration(seconds: 3),
                          //Default value
                          color: Colors.white,
                          //Default value
                          enabled: true,
                          //Default value
                          direction: ShimmerDirection.fromLTRB(),
                          //Default Value
                          child: Container(
                            color: kTransparentColor,
                          ),
                        ),
                        onPress: () {});
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.only(left: 5, right: 5),
                color: Colors.black12,
                height: 2,
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        '',
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 10),
                child: Row(
                  children: <Widget>[
                    Text(
                      "Best rated shop  ", textAlign: TextAlign.left,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                      //style: Theme.of(context).textTheme.bodyText1,
                    ),
                    Image.asset(
                      'images/star.png',
                      width: 20,
                      height: 20,
                      fit: BoxFit.fitWidth,
                    ),
                    // Image(image: NetworkImage('https://www.gstatic.com/webp/gallery/4.jpg'),height: 20,width: 20,)
                  ],
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 5),
                child: GridView.count(
                  crossAxisCount: 4,
                  crossAxisSpacing: 0.0,
                  mainAxisSpacing: 0.0,
                  //childAspectRatio: 200,
                  controller: ScrollController(keepScrollOffset: false),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  children: (bestRatingList != null &&
                      bestRatingList.length > 0)
                      ? bestRatingList.map((e) {
                    pos = bestRatingList.indexOf(e) % 3;
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5)),
                          side: BorderSide(width: 1, color: darkYellowColor1)),
                      // child: ListTile(),
                      child: Container(
                        height: 300,
                        width: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                        ),
                        child: InkWell(
                          onTap: () {
                            hitNavigatorStore(context, e.ui_type, e.vendor_name, e.vendor_id, e.delivery_range, e.distance, e.about,
                                e.online_status,e.vendor_category_id, e.vendor_loc, e.logo, e.vendor_phone);
                           /* Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        AppCategory(
                                            e.vendor_name, e.vendor_id,
                                            e.distance))).then((value) {
                              getCartCount();
                            });*/
                          },
                          child:
                        Column(
                          children: <Widget>[
                            SizedBox(
                              height: 2,
                            ),
                            Container(
                              margin: EdgeInsets.only(top:5),
                              child:
                            Image.network(
                              e.logo,
                              fit: BoxFit.fill, height: 45, width: 40,
                              errorBuilder: (context, exception, stackTrack) =>
                                  Image.asset(
                                      'images/delvmart.png',
                                      fit: BoxFit.fill, height: 45, width: 40),
                            ),
                              //NetworkImage('https://www.gstatic.com/webp/gallery/4.jpg'),height: 50,width: 40,
                            ),
                            //Image(image: NetworkImage('https://www.gstatic.com/webp/gallery/4.jpg'),height: 50,width: 40,),
                            Container(
                              margin: EdgeInsets.only(
                                  left: 5, top: 2, bottom: 2, right: 5),
                              color: darkYellowColor1,
                              height: 1,
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      '',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                    width: MediaQuery
                                        .of(context)
                                        .size
                                        .width * 0.20,
                                    child:
                                    RatingBar.builder(
                                      initialRating: double.parse(e.rating),
                                      minRating: 1,
                                      direction: Axis.horizontal,
                                      allowHalfRating: true,
                                      itemCount: 5,
                                      itemSize: 13,
                                      itemPadding: EdgeInsets.symmetric(
                                          horizontal: 0),
                                      itemBuilder: (context, _) =>
                                          Icon(
                                            Icons.star,
                                            color: darkRedColor,
                                          ),
                                      onRatingUpdate: (rating) {
                                        print(rating);
                                      },
                                    )
                                ),
                                //////////////////
                              ],
                            ),
                          ],
                        ),
                        ),
                      ),
                      margin: EdgeInsets.all(5.0),
                    );
                    /*return ReusableCard(
                      cardChild: CardContent(
                        text: '${e.category_name}',
                        image: '${imageBaseUrl}${e.category_image}',
                      ),
                      onPress: () => hitNavigator(
                          context,
                          e.category_name,
                          e.ui_type,
                          e.vendor_category_id),
                    );*/

                  }).toList()
                      : nearStoresShimmer.map((e) {
                    return ReusableCard(
                        cardChild: Shimmer(
                          duration: Duration(seconds: 3),
                          //Default value
                          color: Colors.white,
                          //Default value
                          enabled: true,
                          //Default value
                          direction: ShimmerDirection.fromLTRB(),
                          //Default Value
                          child: Container(
                            color: kTransparentColor,
                          ),
                        ),
                        onPress: () {});
                  }).toList(),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      Container(
                        //child:Text("List item ")
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                'images/instantdelivery.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.fitWidth,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffe8442e)),
                            ),
                            Text("  Instant delivery\n  at door step",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15),),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        //child:Text("List item ")
                        child: Row(
                          children: [SizedBox(
                            width: 10,
                          ),
                            Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                'images/orderwide.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.fitWidth,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffe8442e)),
                            ),
                            Text("  Order wide range\n  of variety",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15),),
                          ],

                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        //child:Text("List item ")
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                'images/localtest.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.fitWidth,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffe8442e)),
                            ),
                            Text("  No minimum     \n  order value",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15),),
                          ],

                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        //child:Text("List item ")
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                'images/allinone.png',
                                width: 10,
                                height: 10,
                                fit: BoxFit.fitWidth,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffe8442e)),
                            ),
                            Text("  All in one          ",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15),),
                          ],

                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Container(
                        //child:Text("List item ")
                        child: Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              padding: EdgeInsets.all(10),
                              child: Image.asset(
                                'images/localtest.png',
                                width: 30,
                                height: 30,
                                fit: BoxFit.fitWidth,),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Color(0xffe8442e)),
                            ),
                            Text("  Local test         ",
                              style: TextStyle(
                                  color: Colors.black, fontSize: 15),),
                          ],

                        ),
                      ),
                    ],
                  ),
                  Image.asset(
                    'images/delivery_boy.png',
                    width: 145,
                    height: 160,
                    fit: BoxFit.fitWidth,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  /*side: BorderSide(width: 0, )*/),
                // child: ListTile(),
                child: Container(
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(top: 12, bottom: 12),
                  //height: 50,
                  width: MediaQuery
                      .of(context)
                      .size
                      .width - 20,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2.0),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          darkYellowColor,
                          darkRedColor,
                        ],
                      )
                  ),
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Partner with us and earn',
                        style: TextStyle(color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                margin: EdgeInsets.all(5.0),
              )
            ],
          ),
        ),
      ),
        onRefresh: refreshCall)
          : Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locale.alertloc11,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                  color: kMainTextColor,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 20.0, top: 10.0, bottom: 50, right: 20.0),
                  child: Text(
                    locale.locationheadingSub,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: kHintColor,
                    ),
                  )),
              RaisedButton(
                onPressed: () {
                  _getLocation(context, locale);
                },
                child: Text(
                  locale.presstoallow,
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
              )
            ],
          ),
        ),
      ),
    );
  }

  void hitService() async {
    var url = vendorUrl;
    var response = await http.get(url);
    try {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<VendorList> tagObjs = tagObjsJson
              .map((tagJson) => VendorList.fromJson(tagJson))
              .toList();
          setState(() {
            nearStores.clear();
            nearStores = tagObjs;
          });
        }
      }
    } on Exception catch (_) {
      Timer(Duration(seconds: 5), () {
        hitService();
      });
    }
  }

  void hitServiceBestDeal(var lat, var lng) async {
    var url = bestDealUrl + '?lat=' + lat.toString() + '&lng=' + lng.toString();
    var response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<BestDeal> tagObjs = tagObjsJson
              .map((tagJson) => BestDeal.fromJson(tagJson))
              .toList();
          setState(() {
            bestDealList.clear();
            bestDealList = tagObjs;
          });
        }
      }
    } on Exception catch (_) {
      Timer(Duration(seconds: 5), () {
        // hitServiceBestDeal();
      });
    }
  }

  void hitServiceBestRated(var lat, var lng) async {
    var url = bestRatingUrl + '?lat=' + lat.toString() + '&lng=' + lng.toString();
    var response = await http.get(Uri.parse(url));
    try {
      var body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<BestRated> tagObjs = tagObjsJson
              .map((tagJson) => BestRated.fromJson(tagJson))
              .toList();
          setState(() {
            bestRatingList.clear();
            bestRatingList = tagObjs;
          });
        }
      }
    } on Exception catch (_) {
      Timer(Duration(seconds: 5), () {
        // hitServiceBestRated();
      });
    }
  }

  void hitSearchUrl(var searchValue,var lat, var lng) async {
    setState(() {
      isFetch = true;
    });

    var url = searchUrl;
    http.post(url,body: {
      "type":'["all"]',
      "keyword":'${searchValue.toString()}',
      "vendor_cat_id":'',
      "lat":'${lat.toString()}',
      "lng":'${lng.toString()}',
    }).then((response) {
      if (response.statusCode == 200) {
        var ab=response.body;
        var jsonData = jsonDecode(response.body);

        //if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<Data> tagObjs = tagObjsJson
              .map((tagJson) => Data.fromJson(tagJson))
              .toList();

          if (tagObjs.isNotEmpty) {
            setState(() {
              searchList.clear();
              searchList = tagObjs;
            });
          } else {
            setState(() {
              isFetch = false;
            });
          }
        } else {
          setState(() {
            isFetch = false;
          });
        }
     /* } else {
        setState(() {
          isFetch = false;
        });
      }*/
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
    });
  }

  void hitBannerUrl(var lat, var lng) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isFetch = true;
    });
    //var url = bannerUrl;
    var url = bannerUrl + '?lat=' + lat.toString() + '&lng=' + lng.toString();
    http.get(Uri.parse(url)).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);

        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<BannerDetails> tagObjs = tagObjsJson
              .map((tagJson) => BannerDetails.fromJson(tagJson))
              .toList();
          setState(() {
            isDelvmartBanner = jsonData['delvmart_set'];
            delvmartBanner = jsonData['dbanner_url'];
            delvmartVendorId = jsonData['vendor_id'];
            delvmartVendorName = jsonData['vendor_name'];
            delvmartDistance = jsonData['distance'];
            delvmartVendorLogo = jsonData['vendor_logo'];
            delvmartVendorCategoryId = jsonData['vendor_category_id'];
            delvmartVendorPhone = jsonData['vendor_phone'];
            delvmartDeliveryRange = jsonData['delivery_range'];
            delvmartOnlineStatus = jsonData['online_status'];
            delvmartVendorLoc = jsonData['vendor_loc'];
            delvmartAbout = jsonData['about'];
            delvmartUiType = jsonData['ui_type'];

            prefs.setString('delvmart_vendor_id', delvmartVendorId.toString());
          });

          if (tagObjs.isNotEmpty) {
            setState(() {
              listImage.clear();
              listImage = tagObjs;
            });
          } else {
            setState(() {
              isFetch = false;
            });
          }
        } else {
          setState(() {
            isFetch = false;
          });
        }
      } else {
        setState(() {
          isFetch = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
    });
  }

  void hitNavigator(context, category_name, ui_type, vendor_category_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (ui_type == "grocery" || ui_type == "Grocery" || ui_type == "1") {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StoresPage(
                      category_name, vendor_category_id, ui_type.toString())));
    } else if (ui_type == "resturant" ||
        ui_type == "Resturant" ||
        ui_type == "2") {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Restaurant("Urbanby Resturant")));
    } else if (ui_type == "pharmacy" ||
        ui_type == "Pharmacy" ||
        ui_type == "3") {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  StoresPharmaPage('${category_name}', vendor_category_id)));
    } else if (ui_type == "parcal" || ui_type == "Parcal" || ui_type == "4") {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ParcalStoresPage('${vendor_category_id}')));
    }
  }

  void hitNavigatorStore(context, ui_type, vendor_name, vendorId,deliveryrange, distance,about,onlineStatus,
      vendor_category_id, vendorLoc,vendorLogo,vendorPhone) async {
    NearStores item=NearStores(vendor_name, vendorPhone, vendorId, vendorLogo, vendor_category_id, distance, lat, lng,
        deliveryrange, onlineStatus, vendorLoc, about);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (ui_type == "grocery" || ui_type == "Grocery" || ui_type == "1"|| ui_type == 1) {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AppCategory(
                      vendor_name, vendorId,
                      distance,ui_type))).then((value) {
        getCartCount();
      });
    } else if (ui_type == "resturant" ||
        ui_type == "Resturant" ||
        ui_type == "2"|| ui_type == 2) {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => Restaurant_Sub(item, currency)))
          .then((value) {
        getCartCount();
      });
    }
    else if (ui_type == "pharmacy" ||
        ui_type == "Pharmacy" ||
        ui_type == "3" || ui_type == 3) {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PharmaItemPage(
                  vendor_name, vendor_category_id, deliveryrange, distance)))
          .then((value) {
        getCartCount();
      });
    } else if (ui_type == "parcal" || ui_type == "Parcal" || ui_type == "4"|| ui_type == 4) {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AddressFrom(vendor_name, vendor_category_id, distance)));
     /* Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ParcalStoresPage('${vendor_category_id}')));*/
    }
  }

  void getBackResult(latss, lngss, address) async {
    print('$latss - $lngss');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("lat", latss.toString());
    prefs.setString("lng", lngss.toString());
    setState(() {
      lat = latss;
      lng = lngss;
    });
    print('$lat - $lng');
    print(address);
    final coordinates = new Coordinates(latss, lngss);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      for (Address add in value) {
        print(add.addressLine);
      }
      if (value[0].featureName != null &&
          value[0].featureName.isNotEmpty &&
          value[0].subAdminArea != null &&
          value[0].subAdminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].featureName}';
          cityName = '${city} (${value[0].subAdminArea})';
        });
      } else if (value[0].subAdminArea != null &&
          value[0].subAdminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].subAdminArea}';
          cityName = '${city.toUpperCase()}';
        });
      } else if (value[0].adminArea != null && value[0].adminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].subAdminArea}';
          cityName = '${city.toUpperCase()}';
        });
      } else {
        setState(() {
          String city = '${value[0].addressLine}';
          cityName = '${city}';
        });
      }
      if (cityName.toUpperCase() == 'NULL') {
        setState(() {
          cityName = address;
        });
      } else if (cityName.toUpperCase().contains('NULL')) {
        setState(() {
          cityName = address;
        });
      }
      hitService();
      hitBannerUrl(lat, lng);
    });
  }

  Future<Null> refreshCall() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      getCurrency();
      hitService();
      hitBannerUrl(lat, lng);
      hitServiceBestDeal(lat, lng);
      hitServiceBestRated(lat, lng);
    });
    return null;
  }
}
