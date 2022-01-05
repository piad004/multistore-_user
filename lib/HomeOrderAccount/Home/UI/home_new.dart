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
import 'package:user/Components/card_content.dart';
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

  bool enteredFirst = false;

  @override
  void initState() {
    super.initState();
  }

  void _getLocation(context, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(!prefs.containsKey('lat') && !prefs.containsKey('lng')){
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
          hitAddressPlace(lat,lng);
        } else {
          showAlertDialog(context, locale, 'opens');
        }
      }
      else if (permission == LocationPermission.denied) {
        showAlertDialog(context, locale, 'openp');
      } else if (permission == LocationPermission.deniedForever) {
        showAlertDialog(context, locale, 'openas');
      }
    }else{
      double latw = double.parse('${prefs.getString('lat')}');
      double lngw = double.parse('${prefs.getString('lng')}');
      print('$latw - $lngw');
      if(latw!=null && lngw!=null && latw>0.0 && lngw>0.0){
        hitAddressPlace(latw,lngw);
      }else{
        prefs.remove('lat');
        prefs.remove('lng');
        _getLocation(context, locale);
      }
    }
  }

  void hitAddressPlace(double latd, double lngd) async{
    setState(() {
      this.lat = latd;
      this.lng = lngd;
    });
    print('$lat - $lng');
    final coordinates = new Coordinates(lat,lng);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      for(Address add in value){
        print(add.addressLine);
      }
      if (value[0].featureName != null && value[0].featureName.isNotEmpty && value[0].subAdminArea != null && value[0].subAdminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].featureName}';
          cityName = '${city} (${value[0].subAdminArea})';
        });
      }
      else if (value[0].subAdminArea != null && value[0].subAdminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].subAdminArea}';
          cityName = '${city.toUpperCase()}';
        });
      }
      else if (value[0].adminArea != null && value[0].adminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].subAdminArea}';
          cityName = '${city.toUpperCase()}';
        });
      }
      else{
        setState(() {
          String city = '${value[0].addressLine}';
          cityName = '${city}';
        });
      }
      if(cityName.toUpperCase()=='NULL'){
        setState(() {
          cityName = 'Change your location';
        });
      }else if(cityName.toUpperCase().contains('NULL')){
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


  void performAction(BuildContext context, AppLocalizations locale, String type) async{
    if(type == 'opens'){
      Geolocator.openLocationSettings().then((value) {
        if (value) {
          _getLocation(context,locale);
        } else {
          Toast.show(locale.locationPermissionIsRequired, context,
              duration: Toast.LENGTH_SHORT);
        }
      }).catchError((e) {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      });
    }else if(type == 'openp'){
      Geolocator.requestPermission().then((permissiond){
        if (permissiond == LocationPermission.whileInUse ||
            permissiond == LocationPermission.always) {
          _getLocation(context,locale);
        } else {
          Toast.show(locale.locationPermissionIsRequired, context,
              duration: Toast.LENGTH_SHORT);
        }
      });
    }else if(type == 'openas'){
      Geolocator.openAppSettings().then((value) {
        _getLocation(context,locale);
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
        performAction(context,locale,type);
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
    if(!enteredFirst){
      setState(() {
        enteredFirst = true;
      });
      _getLocation(context,locale);
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: CustomAppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Icon(
              Icons.location_on,
              color: kMainColor,
            ),
          ),
          titleWidget: GestureDetector(
            onTap: () {
              double latt = 0.0;
              double lngt = 0.0;
              if(lat!=null && lng !=null && lat>0.0 && lng>0.0){
                latt = lat;
                lngt = lng;
              }
              print('dd $latt - $lngt');
              Navigator.of(context).push(MaterialPageRoute(builder: (context) {
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
            child: Text(
              '${cityName}',
              maxLines: 2,
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: kMainTextColor),
            ),
          ),
        ),
      ),
      body: locGrant?Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Padding(
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
              ),
              Visibility(
                visible: (!isFetch && listImage.length == 0) ? false : true,
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
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
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
                                      BorderRadius.circular(20.0),
                                    ),
                                    child: Image.network(
                                      imageBaseUrl + e.banner_image,
                                      fit: BoxFit.fill,
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
                            MediaQuery.of(context).size.width * 0.90,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20.0),
                            ),
                            child: Shimmer(
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
                          );
                        });
                      }).toList()),
                ),
              ),
              SizedBox(
                height: 20,
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
                    return ReusableCard(
                      cardChild: CardContent(
                        image: '${imageBaseUrl}${e.category_image}',
                        text: '${e.category_name}',
                      ),
                      onPress: () => hitNavigator(
                          context,
                          e.category_name,
                          e.ui_type,
                          e.vendor_category_id),
                    );
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
            ],
          ),
        ),
      ):Center(
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
                      left: 20.0,
                      top: 10.0,
                      bottom: 50,
                      right: 20.0),
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
    final coordinates = new Coordinates(latss,lngss);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      for(Address add in value){
        print(add.addressLine);
      }
      if (value[0].featureName != null && value[0].featureName.isNotEmpty && value[0].subAdminArea != null && value[0].subAdminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].featureName}';
          cityName = '${city} (${value[0].subAdminArea})';
        });
      }
      else if (value[0].subAdminArea != null && value[0].subAdminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].subAdminArea}';
          cityName = '${city.toUpperCase()}';
        });
      }
      else if (value[0].adminArea != null && value[0].adminArea.isNotEmpty) {
        setState(() {
          String city = '${value[0].subAdminArea}';
          cityName = '${city.toUpperCase()}';
        });
      }
      else{
        setState(() {
          String city = '${value[0].addressLine}';
          cityName = '${city}';
        });
      }
      if(cityName.toUpperCase()=='NULL'){
        setState(() {
          cityName = address;
        });
      }else if(cityName.toUpperCase().contains('NULL')){
        setState(() {
          cityName = address;
        });
      }
      hitService();
      hitBannerUrl();
    });
  }
}