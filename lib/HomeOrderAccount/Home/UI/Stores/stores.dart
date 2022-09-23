import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/HomeOrderAccount/Home/UI/Search.dart';
import 'package:user/HomeOrderAccount/Home/UI/appcategory/appcategory.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/bannerbean.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/bean/vendorbanner.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/parcel/fromtoaddress.dart';
import 'package:user/pharmacy/pharmadetailpage.dart';
import 'package:user/restaturantui/pages/restaurant.dart';

class StoresPage extends StatefulWidget {
  final String pageTitle;
  final dynamic vendor_category_id;
   String ui_type="";

  StoresPage(this.pageTitle, this.vendor_category_id, this.ui_type);

  @override
  State<StatefulWidget> createState() {
    return StoresPageState(pageTitle, vendor_category_id,ui_type);
  }
}

class StoresPageState extends State<StoresPage> with WidgetsBindingObserver{
  var http = Client();
  final String pageTitle;
  String ui_type="";
  final dynamic vendor_category_id;
  //List<VendorBanner> listImage = [];
  List<BannerDetails> listImage = [];
  List<NearStores> nearStores = [];
  List<NearStores> nearStoresSearch = [];
  List<NearStores> nearStoresShimmer = [
    NearStores("", "", "", "", "", "", "", "", "", "", "", ""),
    NearStores("", "", "", "", "", "", "", "", "", "", "", ""),
    NearStores("", "", "", "", "", "", "", "", "", "", "", ""),
    NearStores("", "", "", "", "", "", "", "", "", "", "", "")
  ];
  List<String> listImages = ['', '', '', '', ''];
  bool isFetch = true;
  bool isFetchStore = true;

  StoresPageState(this.pageTitle, this.vendor_category_id,this.ui_type);

  TextEditingController searchController = TextEditingController();
  bool isCartCount = false;
  int cartCount = 0;
  double userLat = 0.0;
  double userLng = 0.0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getShareValue();
    hitService();
    getCartCount();
  }


  @override
  void didChangeAppLifecycleState(final AppLifecycleState state) {
   // if (state == AppLifecycleState.resumed) {
      getShareValue();
      hitService();
   // }
  }


  getShareValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      var lat=prefs.getString('userLat');
      var lng = prefs.getString('userLng');
      if(lat != null && lng != null) {
        userLat = double.parse('${lat}');
        userLng = double.parse('${lng}');
      }
      hitBannerUrl();
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
    double min = mins_taken + 45;//45 min add as per client request
    if (min<60) {
      return ""+'${min.toInt()}'+" mins";
    }else {
      double tt = min % 60;
      String minutes = '${tt.toInt()}';
      minutes = minutes.length == 1 ? "0" + minutes : minutes;
      return '${(min.toInt() / 60).toStringAsFixed(2)}' + " hour " + minutes +"mins";
    }
  }

  void getCartCount() {
    DatabaseHelper db = DatabaseHelper.instance;
    db.queryRowCount().then((value) {
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

  @override
  void dispose() {
    super.dispose();
    http.close();
    WidgetsBinding.instance.removeObserver(this);
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
              pageTitle,
              style: Theme.of(context).textTheme.bodyText1,
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 6.0),
                child: Stack(
                  children: [
                    IconButton(
                        icon: ImageIcon(
                          AssetImage('images/icons/ic_cart blk.png'),
                        ),
                        onPressed: () {
                          if (isCartCount) {
                            Navigator.pushNamed(context, PageRoutes.viewCart)
                                .then((value) {
                              getCartCount();
                            });
                          } else {
                            Toast.show(locale.noValueCartText, context,
                                duration: Toast.LENGTH_SHORT);
                          }
                        }),
                    Positioned(
                        right: 5,
                        top: 2,
                        child: Visibility(
                          visible: isCartCount,
                          child: CircleAvatar(
                            minRadius: 4,
                            maxRadius: 8,
                            backgroundColor: kMainColor,
                            child: Text(
                              '$cartCount',
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  fontSize: 7,
                                  color: kWhiteColor,
                                  fontWeight: FontWeight.w900),
                            ),
                          ),
                        ))
                  ],
                ),
              ),
            ],
            bottom: PreferredSize(
              child:Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 52,
                  padding: EdgeInsets.only(left: 5),
                  decoration: BoxDecoration(
                      color: scaffoldBgColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: TextFormField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.search,
                        color: kHintColor,
                      ),
                      hintText: locale.searchStoreText,
                    ),
                    controller: searchController,
                    cursorColor: kMainColor,
                    readOnly: true,
                    autofocus: false,
                    onTap: (){
                      if(ui_type != null && nearStores != null && nearStores.length>0){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                             // builder: (context) => SearchPage('["shop"]',nearStores[0].vendor_category_id)))
                              builder: (context) =>
                                  SearchPage('["all"]',ui_type,
                                      (nearStores[0].vendor_category_id != null)? nearStores[0].vendor_category_id:"",
                                      '','')
                          ))
                          .then((value) {
                        getCartCount();
                      });
                    }else {
                        Toast.show(locale.noStoresFoundText, context,
                            duration: Toast.LENGTH_SHORT);
                      }
                    },
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
                                 /* Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              AppCategory(e.vendor_id, e.vendor_id, e.vendor_id))).then((value) {
                                    getCartCount();
                                  });*/
                                  hitNavigatorStore(context, e.ui_type, e.vendor_name, e.vendor_id, e.delivery_range, e.distance, e.about,
                                      e.online_status,e.vendor_category_id, e.vendor_loc, e.vendor_logo, e.vendor_phone);
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
                                  if ((nearStores[index].online_status.toString().toUpperCase() ==
                                          "ON")) {
                                    hitNavigator(
                                        context,
                                        nearStores[index].vendor_name,
                                        nearStores[index].vendor_id,
                                        nearStores[index].distance,locale);
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
                                            Container(
                                              width: 93.3,
                                              height: 93.3,
                                              child: Image.network(
                                                imageBaseUrl +
                                                    nearStores[index].vendor_logo,
                                                width: 93.3,
                                                height: 93.3,
                                                fit: BoxFit.fill,
                                              ),
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

                                                          (nearStores[index].distance)!=null?
                                                          '${double.parse('${nearStores[index].distance}').toStringAsFixed(2)} km ':'0 km',
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
                                                  fontSize: 15),
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
      ),
    );
  }

  void hitService() async {
    setState(() {
      isFetchStore = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = nearByStore;
    http.post(url, body: {
      'lat': '${prefs.getString('userLat')}',
      'lng': '${prefs.getString('userLng')}',
      'vendor_category_id': '${vendor_category_id}',
      'ui_type': '${prefs.getString('ui_type')}'
    }).then((value) {
      var body = value.body;
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        print('${jsonData.toString()}');
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
      Timer(Duration(seconds: 5), () {
        hitService();
      });
    });
  }

  void hitBannerUrl() async {
    var url = categoryBanner+'?lat='+userLat.toString()+'&lng='+userLng.toString()+'&ui_type='+vendor_category_id.toString();
    print(url.toString());
    http.get(Uri.parse(url)).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body)['data'] as List;
        /*  List<VendorBanner> tagObjs = tagObjsJson
              .map((tagJson) => VendorBanner.fromJson(tagJson))
              .toList();*/
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
      }
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print("error store"+e.toString());
    });
  }

  showAlertDialog(BuildContext context, vendor_name, vendor_id, distance, AppLocalizations locale) {
    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        deleteAllRestProduct(context, vendor_name, vendor_id, distance);
      },
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
            locale.clearText,
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );

    Widget no = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
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
      title: Text(locale.inconvenienceNoticeText1),
      content: Text(locale.inconvenienceNoticeText2),
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

  hitNavigator(BuildContext context, vendor_name, vendor_id, distance, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   /* if (isCartCount &&
        prefs.getString("vendor_id") != null &&
        prefs.getString("vendor_id") != "" &&
        prefs.getString("vendor_id") != '${vendor_id}') {
      showAlertDialog(context, vendor_name, vendor_id, distance,locale);
    } else*/ {
     // prefs.setString("vendor_id", '${vendor_id}');
      prefs.setString("store_name", '${vendor_name}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AppCategory(vendor_name, vendor_id, distance,ui_type))).then((value) {
        getCartCount();
      });
    }
  }

  void hitNavigatorStore(context, ui_type, vendor_name, vendorId,deliveryrange, distance,about,onlineStatus,
      vendor_category_id, vendorLoc,vendorLogo,vendorPhone) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var lat = prefs.getString("lat");
    var lng = prefs.getString("lng");
    NearStores item=NearStores(vendor_name, vendorPhone, vendorId, vendorLogo, vendor_category_id, distance, lat, lng,
        deliveryrange, onlineStatus, vendorLoc, about);

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
      var currency = prefs.getString('curency');
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


  void deleteAllRestProduct(
      BuildContext context, vendor_name, vendor_id, distance) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteAll().then((value) {
      prefs.setString("vendor_id", '${vendor_id}');
      prefs.setString("store_name", '${vendor_name}');
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  AppCategory(vendor_name, vendor_id, distance,ui_type))).then((value) {
        getCartCount();
      });
    });
  }
}
