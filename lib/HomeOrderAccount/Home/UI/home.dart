import 'dart:async';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/Components/reusable_card.dart';
import 'package:user/HomeOrderAccount/Home/UI/Stores/stores.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Maps/UI/location_page.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/bannerbean.dart';
import 'package:user/bean/latlng.dart';
import 'package:user/bean/venderbean.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/parcel/parcalstorepage.dart';
import 'package:user/pharmacy/pharmastore.dart';
import 'package:user/restaturantui/ui/resturanthome.dart';

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
  List<VendorList> nearStores = [];
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

  TextEditingController searchController = TextEditingController();
  bool enteredFirst = false;

  @override
  void initState() {
    super.initState();
  }

  void _getLocation(context, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('lat') && !prefs.containsKey('lng')) {
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
          setState(() {
            locGrant = true;
            this.lat = lat;
            this.lng = lng;
          });
          prefs.setString("lat", lat.toString());
          prefs.setString("lng", lng.toString());
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
      double latw = double.parse('${prefs.getString('lat')}');
      double lngw = double.parse('${prefs.getString('lng')}');
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
    hitService();
    hitBannerUrl();
  }

  void performAction(
      BuildContext context, AppLocalizations locale, String type) async {
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
                      return LocationPage(latt, lngt);
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
              width: MediaQuery.of(context).size.width * 0.9,
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
                onChanged: (value) {
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
          ? Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
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
                                          onTap: () {},
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 5, vertical: 10),
                                            child: Material(
                                              elevation: 5,
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                              clipBehavior: Clip.hardEdge,
                                              child: Container(
                                                width: MediaQuery.of(context)
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
                                                  imageBaseUrl + e.banner_image,
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
                                            MediaQuery.of(context).size.width *
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
                        // childAspectRatio: itemWidth/(itemHeight),
                        controller: ScrollController(keepScrollOffset: false),
                        shrinkWrap: true,
                        scrollDirection: Axis.vertical,
                        children: (nearStores != null && nearStores.length > 0)
                            ? nearStores.map((e) {
                                pos = nearStores.indexOf(e) % 3;
                                return Card(
                                  child: InkWell(
                                    onTap: () => hitNavigator(
                                        context,
                                        e.category_name,
                                        e.ui_type,
                                        e.vendor_category_id),
                                  child: Container(
                                    height: 170,
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
                                            fit: BoxFit.cover,
                                            image: new AssetImage(
                                              'images/grocery.png',
                                            )
                                        )),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Text('${e.category_name}',
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
                      margin: EdgeInsets.only(left: 5,right: 5),
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
                      child: Text(
                        "Delvmart", textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black),
                        //style: Theme.of(context).textTheme.bodyText1,
                      ),
                    ),SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {},
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                        child: Material(
                          elevation: 5,
                          borderRadius: BorderRadius.circular(10.0),
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            width: MediaQuery.of(context).size.width * 0.94,
                            height: MediaQuery.of(context).size.width * 0.40,
//                                            padding: EdgeInsets.symmetric(horizontal: 10.0,vertical: 10.0),
                            decoration: BoxDecoration(
                              color: white_color,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child:  Image.asset(
                              'images/delvmart.png',
                              //'https://www.gstatic.com/webp/gallery/4.jpg',
                              fit: BoxFit.fill,
                              errorBuilder: (context, exception, stackTrack) =>
                                  Image.asset(
                                      'images/delvmart.png',
                                      fit: BoxFit.fill),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 5,right: 5),
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
                      child:  Row(
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
                        children: (nearStores != null && nearStores.length > 0)
                            ? nearStores.map((e) {
                          pos = nearStores.indexOf(e)%3;
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                side: BorderSide(width: 1, color: Colors.yellow)),
                           // child: ListTile(),
                            child: Container(
                              height: 300,
                              width: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(2.0),
                              ),
                              child:  Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Image(image: NetworkImage('https://www.gstatic.com/webp/gallery/4.jpg'),height: 50,width: 40,),
                                  Container(
                                    margin: EdgeInsets.only(left: 5,top:2,bottom:2,right: 5),
                                    color: Colors.yellow,
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
                                  Text(
                                    "50% Off", textAlign: TextAlign.center,
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.red),
                                    //style: Theme.of(context).textTheme.bodyText1,
                                  ),
                                ],
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
                      margin: EdgeInsets.only(left: 5,right: 5),
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
                      child:  Row(
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
                        children: (nearStores != null && nearStores.length > 0)
                            ? nearStores.map((e) {
                          pos = nearStores.indexOf(e)%3;
                          return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(5)),
                                side: BorderSide(width: 1, color: Colors.yellow)),
                            // child: ListTile(),
                            child: Container(
                              height: 300,
                              width: 100,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(2.0),
                              ),
                              child:  Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 2,
                                  ),
                                  Image(image: NetworkImage('https://www.gstatic.com/webp/gallery/4.jpg'),height: 50,width: 40,),
                                  Container(
                                    margin: EdgeInsets.only(left: 5,top:2,bottom:2,right: 5),
                                    color: Colors.yellow,
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
                                      Icon(
                                        Icons.star,
                                        color: Colors.red,
                                        size: 10,
                                      ),
                                      Icon(
                                        Icons.star,
                                        color: Colors.red,
                                        size: 10,
                                      ),
                                    ],
                                  ),
                                ],
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
                             child:Row(
                               children: [
                                 Image.asset(
                                   'images/checkout.png',
                                   width: 50,
                                   height: 50,
                                   fit: BoxFit.fitWidth,),
                                 Text("  Instant delivery\n  at door step",
                                   style: TextStyle(
                                       color: Colors.black,fontSize: 15),),
                               ],

                             ),
                           ),
                           SizedBox(
                             height: 5,
                           ),
                           Container(
                             //child:Text("List item ")
                             child:Row(
                               children: [SizedBox(
                                 width: 5,
                               ),
                                 Image.asset(
                                   'images/checkout.png',
                                   width: 50,
                                   height: 50,
                                   fit: BoxFit.fitWidth,),
                                 Text("  Order wide range\n  of variety",
                                   style: TextStyle(
                                       color: Colors.black,fontSize: 15),),
                               ],

                             ),
                           ),
                           SizedBox(
                             height: 5,
                           ),
                           Container(
                             //child:Text("List item ")
                             child:Row(
                               children: [
                                 Image.asset(
                                   'images/checkout.png',
                                   width: 50,
                                   height: 50,
                                   fit: BoxFit.fitWidth,),
                                 Text("  No minimum     \n  order value",
                                   style: TextStyle(
                                       color: Colors.black,fontSize: 15),),
                               ],

                             ),
                           ),
                           SizedBox(
                             height: 5,
                           ),
                           Container(
                             //child:Text("List item ")
                             child:Row(
                               children: [
                                 Image.asset(
                                   'images/checkout.png',
                                   width: 50,
                                   height: 50,
                                   fit: BoxFit.fitWidth,),
                                 Text("  All in one          ",
                                   style: TextStyle(
                                       color: Colors.black,fontSize: 15),),
                               ],

                             ),
                           ),
                           SizedBox(
                             height: 5,
                           ),
                           Container(
                             //child:Text("List item ")
                             child:Row(
                               children: [
                                 Image.asset(
                                   'images/checkout.png',
                                   width: 50,
                                   height: 50,
                                   fit: BoxFit.fitWidth,),
                                 Text("  Local test         ",
                                   style: TextStyle(
                                       color: Colors.black,fontSize: 15),),
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
                        padding: EdgeInsets.only(top:12,bottom: 12),
                        //height: 50,
                        width: MediaQuery.of(context).size.width-20,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.0),
                          gradient: LinearGradient(
                            begin: Alignment.topRight,
                            end: Alignment.bottomLeft,
                            colors: [
                              Colors.yellow,
                              Colors.red,
                            ],
                          )
                        ),
                        child:  Column(
                          children: <Widget>[
                            Text(
                              'Partner with us and earn',
                              style: TextStyle(color: Colors.white,fontSize: 16,fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      margin: EdgeInsets.all(5.0),
                    )
                  ],
                ),
              ),
            )
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

  void hitBannerUrl() async {
    setState(() {
      isFetch = true;
    });
    var url = bannerUrl;
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<BannerDetails> tagObjs = tagObjsJson
              .map((tagJson) => BannerDetails.fromJson(tagJson))
              .toList();
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
      print(e);
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
                  StoresPage(category_name, vendor_category_id)));
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
      hitBannerUrl();
    });
  }
}
