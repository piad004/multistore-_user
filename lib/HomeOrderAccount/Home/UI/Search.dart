import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/HomeOrderAccount/Home/UI/SearchModel.dart';
import 'package:user/HomeOrderAccount/Home/UI/Stores/stores.dart';
import 'package:user/HomeOrderAccount/Home/UI/appcategory/appcategory.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/BestDeal.dart';
import 'package:user/bean/BestRated.dart';
import 'package:user/bean/bannerbean.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/bean/productlistvarient.dart';
import 'package:user/bean/venderbean.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/parcel/fromtoaddress.dart';
import 'package:user/parcel/parcalstorepage.dart';
import 'package:user/pharmacy/pharmadetailpage.dart';
import 'package:user/pharmacy/pharmastore.dart';
import 'package:user/pharmacy/singleProductDetailpage.dart';
import 'package:user/restaturantui/pages/restaurant.dart';
import 'package:user/restaturantui/ui/resturanthome.dart';
import 'package:user/singleproductpage/singleproductpage.dart';

/*class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Search();
  }
}*/

class SearchPage extends StatefulWidget {
  dynamic searchType;
  dynamic vendorCatId;
  dynamic uiType;
  dynamic vendorId;
  dynamic subCatId;

  SearchPage(this.searchType,this.uiType,this.vendorCatId,this.vendorId,this.subCatId);

  @override
  _SearchState createState() => _SearchState(searchType,uiType,vendorCatId,this.vendorId,this.subCatId);
}

class _SearchState extends State<SearchPage> {
  dynamic searchType;
  dynamic vendorCatId;
  dynamic vendorId;
  dynamic subCatId;
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
  bool isFetch = false;
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
  var uiType;

  TextEditingController searchController = TextEditingController();
  bool enteredFirst = false;
  var refreshKey = GlobalKey<RefreshIndicatorState>();

  _SearchState(this.searchType,this.uiType,this.vendorCatId,this.vendorId,this.subCatId);

  @override
  void initState() {
    super.initState();
    getCurrency();
    getLoc();
  }

  void getLoc() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      lat = double.parse(prefs.getString('lat'));
      lng = double.parse(prefs.getString('lng'));
    });
  }

  void _getLocation(context, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('lat') &&
        !prefs.containsKey('lng') &&
        !prefs.containsKey('lnga')) {
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
        currency = jsonData['data'][0]['currency_sign'];
      }
    }).catchError((e) {});
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(125.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(229, 3, 4, 8)),
          child: Column(children: [
            AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: kWhiteColor,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Search",
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: kMainTextColor),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width * 0.95,
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
                  hitSearchUrl(value, lat, lng);
                },
              ),
            )
          ]),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height - 110,
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              (searchList != null && searchList.length > 0)
                  ? Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: ListView.separated(
                          shrinkWrap: true,
                          primary: false,
                          scrollDirection: Axis.vertical,
                          itemCount: searchList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                if ((searchList[index].onlineStatus.toString().toUpperCase() == "ON")) {
                                  if (searchList[index].type.toString().toUpperCase() ==
                                          "ST" ||
                                      searchList[index].type.toString().toUpperCase() ==
                                          "RP") {
                                    hitNavigatorStore(
                                        context,
                                        searchList[index].uiType.toString(),
                                        searchList[index].vendorName,
                                        searchList[index].vendorId.toString(),
                                        searchList[index].deliveryRange,
                                        searchList[index].distance,
                                        searchList[index].about,
                                        searchList[index].onlineStatus,
                                        searchList[index]
                                            .vendorCategoryId
                                            .toString(),
                                        searchList[index].vendorLoc,
                                        searchList[index].vendorLogo,
                                        searchList[index].vendorPhone);
                                    /* hitNavigator(
                        context,
                        searchList[index].categoryName,
                        searchList[index].uiType.toString(),
                        searchList[index].vendorCategoryId.toString());*/
                                  } else if (searchList[index]
                                          .type
                                          .toString().toUpperCase() ==
                                      "GP") {
                                    /* Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          ItemsPage(
                                              searchList[index].vendorName,
                                              searchList[index].categoryName
                                                  .toString(),
                                              searchList[index].vendorCategoryId
                                                  .toString(),
                                              searchList[index].distance)))
                                  .then((value) {
                                getCartCount();
                              });*/
                                    ProductWithVarient productWithVarient =
                                        new ProductWithVarient(
                                            searchList[index].productId,
                                            searchList[index].productName,
                                            searchList[index].productImage,
                                            1,
                                            searchList[index].varient,
                                            1);

                                    Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      return SingleProductPage(
                                          productWithVarient, currency);
                                    })).then((value) {
                                      // setList(searchList);
                                      getCartCount();
                                    });
                                  }else if (searchList[index]
                                          .type
                                          .toString().toUpperCase() ==
                                      "MP") {/*
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => PharmaItemPage(
                                                searchList[index].vendorName, searchList[index].vendorId,
                                                searchList[index].deliveryRange,searchList[index].distance)))
                                        .then((value) {
                                      getCartCount();
                                    });*/
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SingleProductDetailPage(
                                                searchList[index].productId, searchList[index].vendorId)))
                                        .then((value) {
                                      getCartCount();
                                    });
                                  }
                                } else {
                                  Toast.show(locale.storesClosedText, context,
                                      duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
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
                                      width: MediaQuery.of(context).size.width,
                                      color: white_color,
                                      padding: EdgeInsets.only(
                                          left: 10.0, top: 15, bottom: 15),
                                      child: Row(
                                        children: <Widget>[
                                          Container(
                                            width: 93.3,
                                            height: 93.3,
                                            child: Image.network(
                                              (searchList[index].type).toString().toUpperCase() == "GP"
                                                  ? imageBaseUrl +
                                                      searchList[index]
                                                          .productImage
                                                  : searchList[index]
                                                      .vendorLogo,
                                              width: 93.3,
                                              height: 93.3,
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Text(
                                                    (searchList[index].type).toString().toUpperCase() ==
                                                            "GP"
                                                        ? searchList[index]
                                                            .productName
                                                        : searchList[index]
                                                            .productName,
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .subtitle2
                                                        .copyWith(
                                                            color:
                                                                kMainTextColor,
                                                            fontSize: 16)),
                                                SizedBox(height: 8.0),
                                                Row(
                                                  children: <Widget>[
                                                    Icon(
                                                      Icons
                                                          .shopping_bag_outlined,
                                                      color: kIconColor,
                                                      size: 15,
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Expanded(
                                                      child: Text(
                                                          'Store - ${searchList[index].vendorName}',
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
                                                    Text(' |  ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                color:
                                                                    kMainColor,
                                                                fontSize:
                                                                    13.0)),
                                                    Expanded(
                                                      child: Text(
                                                          '${searchList[index].vendorLoc}',
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
                                                    SizedBox(width: 5.0),
                                                    Text(
                                                        '${searchList[index].onlineStatus + '  | '}',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                color:
                                                                    kLightTextColor,
                                                                fontSize:
                                                                    13.0)),
                                                    Icon(
                                                      Icons.location_on,
                                                      color: kIconColor,
                                                      size: 15,
                                                    ),
                                                    SizedBox(width: 5.0),
                                                    Text(
                                                        '${double.parse('${searchList[index].distance}').toStringAsFixed(2)} km ',
                                                        style: Theme.of(context)
                                                            .textTheme
                                                            .caption
                                                            .copyWith(
                                                                color:
                                                                    kLightTextColor,
                                                                fontSize:
                                                                    13.0)),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    /*Positioned(
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
                                  fontSize: 15),
                            ),
                          ),
                        ),
                      ),*/
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
                          isFetch
                              ? CircularProgressIndicator()
                              : Container(
                                  width: 0.5,
                                ),
                          isFetch
                              ? SizedBox(
                                  width: 10,
                                )
                              : Container(
                                  width: 0.5,
                                ),
                          Text(
                            (!isFetch) ? "No data found!" : "Searching...",
                            style: TextStyle(
                                fontSize: 18,
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
    );
  }

  void hitSearchUrl(var searchValue, var lat, var lng) async {
    setState(() {
      isFetch = true;
    });
   /* if(searchValue == null || searchValue == '')
      return;*/

    var type='';
    if(uiType.toString().toUpperCase() == "GROCERY" || uiType.toString() == "1")
      type ='["grocery_product"]';
    else if(uiType.toString().toUpperCase() == "RESTURANT" ||
        uiType.toString() == "2")
      type='["resturant_product"]';
    else if(uiType.toString()=="3")
      type='["all"]';
    else if(uiType.toString().toUpperCase()=="PHARMACY")
      type='["medicine_product"]';

    print('vendor cat;;;;'+vendorCatId.toString()+"vendor_id"+ vendorId.toString()+"subcat_id"+subCatId.toString());
    var url = searchUrl;
    http.post(url, body: {
      "type": type,
      "vendor_id": vendorId.toString(),
      "subcat_id": subCatId.toString(),
      //"type": '$searchType',
      "keyword": '${searchValue.toString()}',
      "vendor_cat_id": vendorCatId.toString(),
      "lat": '${lat.toString()}',
      "lng": '${lng.toString()}',
    }).then((response) {
      print(response.body.toString());
      if (response.statusCode == 200) {
        var ab = response.body;
        var jsonData = jsonDecode(response.body);

        //if (jsonData['status'] == "1") {
        var tagObjsJson = jsonDecode(response.body)['data'] as List;
        List<Data> tagObjs =
            tagObjsJson.map((tagJson) => Data.fromJson(tagJson)).toList();

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

  void hitNavigator(context, category_name, ui_type, vendor_category_id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (ui_type == "grocery" || ui_type == "Grocery" || ui_type == "1") {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => StoresPage(
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

  void hitNavigatorStore(
      context,
      ui_type,
      vendor_name,
      vendorId,
      deliveryrange,
      distance,
      about,
      onlineStatus,
      vendor_category_id,
      vendorLoc,
      vendorLogo,
      vendorPhone) async {
    NearStores item = NearStores(
        vendor_name,
        vendorPhone,
        vendorId,
        vendorLogo,
        vendor_category_id,
        distance,
        lat,
        lng,
        deliveryrange,
        onlineStatus,
        vendorLoc,
        about);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (ui_type == "grocery" ||
        ui_type == "Grocery" ||
        ui_type == "1" ||
        ui_type == 1) {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AppCategory(vendor_name, vendorId, distance,uiType))).then((value) {
        getCartCount();
      });
    } else if (ui_type == "resturant" ||
        ui_type == "Resturant" ||
        ui_type == "2" ||
        ui_type == 2) {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Restaurant_Sub(item, currency)))
          .then((value) {
        getCartCount();
      });
    } else if (ui_type == "pharmacy" ||
        ui_type == "Pharmacy" ||
        ui_type == "3" ||
        ui_type == 3) {
      prefs.setString("vendor_cat_id", '${vendor_category_id}');
      prefs.setString("ui_type", '${ui_type}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => PharmaItemPage(vendor_name,
                  vendor_category_id, deliveryrange, distance))).then((value) {
        getCartCount();
      });
    } else if (ui_type == "parcal" ||
        ui_type == "Parcal" ||
        ui_type == "4" ||
        ui_type == 4) {
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
    });
  }
}
