import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:toast/toast.dart';
import 'package:user/HomeOrderAccount/Account/UI/ListItems/addaddresspage.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/bannerbean.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/bean/resturantbean/categoryresturantlist.dart';
import 'package:user/bean/resturantbean/popular_item.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/restaturantui/helper/categorylist.dart';
import 'package:user/restaturantui/helper/hot_sale.dart';
import 'package:user/restaturantui/helper/product_order.dart';
import 'package:user/restaturantui/pages/rasturantlistpage.dart';
import 'package:user/restaturantui/pages/recentproductorder.dart';
import 'package:user/restaturantui/pages/restaurant.dart';
import 'package:user/restaturantui/searchResturant.dart';

class Restaurant extends StatefulWidget {
  final String pageTitle;

  Restaurant(this.pageTitle);

  @override
  State<StatefulWidget> createState() {
    return RestaurantState(pageTitle);
  }
}

class RestaurantState extends State<Restaurant> {
  final String pageTitle;

  double lat;
  double lng;

  String cityName = '';

  List<PopularItem> popularItem = [];
  List<CategoryResturant> categoryList = [];

  List<BannerDetails> listImage = [];
  List<NearStores> nearStores = [];
  List<NearStores> nearStoresSearch = [];

  RestaurantState(this.pageTitle);

  String currentAddress = "76A, New York, US.";
  bool address1 = true;
  bool address2 = false;
  dynamic currencySymbol = '';
  dynamic cartCount = 0;
  bool isCartCount = false;
  bool isProdcutOrderFetch = false;
  bool isCategoryFetch = false;
  bool isSlideFetch = false;
  bool isFetchRestStore = false;

  @override
  void initState() {
    _hitServices();
    super.initState();
  }

  void _hitServices() {
    getCurrentSymbol();
    _getDemoLocation();
    // _getLocation();
    getCartCount();
    hitProductUrl();
    hitCategoryUrl();
    // hitSliderUrl();
    hitRestaurantService();
  }

  void getCartCount() {
    DatabaseHelper db = DatabaseHelper.instance;
    db.queryRowCountRest().then((value) {
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



  getCurrentSymbol() async {
    SharedPreferences pre = await SharedPreferences.getInstance();
    setState(() {
      currencySymbol = pre.getString('curency');
    });
  }

  void hitProductUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isProdcutOrderFetch = true;
    });
    var url = popular_item;
    http.post(url, body: {
      'vendor_id': '${preferences.getString('vendor_cat_id')}'
      // 'vendor_id': '24'
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print('Response Body: - ${response.body}');
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<PopularItem> tagObjs = tagObjsJson
              .map((tagJson) => PopularItem.fromJson(tagJson))
              .toList();
          if (tagObjs != null && tagObjs.length > 0) {
            setState(() {
              isProdcutOrderFetch = false;
              popularItem.clear();
              popularItem = tagObjs;
            });
          } else {
            setState(() {
              isProdcutOrderFetch = false;
            });
          }
        } else {
          setState(() {
            isProdcutOrderFetch = false;
          });
        }
      } else {
        setState(() {
          isProdcutOrderFetch = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isProdcutOrderFetch = false;
      });
    });
  }

  void hitCategoryUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isCategoryFetch = true;
    });
    var url = homecategoryss;
    http.post(url, body: {
      'vendor_id': '${preferences.getString('vendor_cat_id')}'
      // 'vendor_id': '24'
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print('Response Body: - ${response.body}');
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<CategoryResturant> tagObjs = tagObjsJson
              .map((tagJson) => CategoryResturant.fromJson(tagJson))
              .toList();
          if (tagObjs != null && tagObjs.length > 0) {
            setState(() {
              isCategoryFetch = false;
              categoryList.clear();
              categoryList = tagObjs;
            });
          } else {
            setState(() {
              isCategoryFetch = false;
            });
          }
        } else {
          setState(() {
            isCategoryFetch = false;
          });
        }
      } else {
        setState(() {
          isCategoryFetch = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isCategoryFetch = false;
      });
    });
  }

  void hitSliderUrl() async {
    setState(() {
      isSlideFetch = true;
    });
    var url = resturant_banner;
    http.get(url).then((response) {
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        print('Response Body: - ${response.body}');
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<BannerDetails> tagObjs = tagObjsJson
              .map((tagJson) => BannerDetails.fromJson(tagJson))
              .toList();
          if (tagObjs != null && tagObjs.length > 0) {
            setState(() {
              isSlideFetch = false;
              listImage.clear();
              listImage = tagObjs;
            });
          } else {
            setState(() {
              isSlideFetch = false;
            });
          }
        } else {
          setState(() {
            isSlideFetch = false;
          });
        }
      } else {
        setState(() {
          isSlideFetch = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isSlideFetch = false;
      });
    });
  }

  void hitRestaurantService() async {
    setState(() {
      isFetchRestStore = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(
        'data - ${prefs.getString('lat')} - ${prefs.getString('lng')} - ${prefs.getString('vendor_cat_id')} - ${prefs.getString('ui_type')}');
    var url = nearByStore;
    http.post(url, body: {
      'lat': '${prefs.getString('lat')}',
      'lng': '${prefs.getString('lng')}',
      'vendor_category_id': '${prefs.getString('vendor_cat_id')}',
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
            isFetchRestStore = false;
            nearStores.clear();
            nearStoresSearch.clear();
            nearStores = tagObjs;
            nearStoresSearch = List.from(nearStores);
          });
        } else {
          setState(() {
            isFetchRestStore = false;
          });
        }
      } else {
        setState(() {
          isFetchRestStore = false;
        });
      }
    }).catchError((e) {
      setState(() {
        isFetchRestStore = false;
      });
      print(e);
      Timer(Duration(seconds: 5), () {
        hitRestaurantService();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      color: kMainColor,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 130,
                  backgroundColor: Colors.white,
                  pinned: true,
                  floating: true,
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: innerBoxIsScrolled ? kMainTextColor : kWhiteColor,
                      size: 24.0,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  actions: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Stack(
                        children: [
                          IconButton(
                              icon: ImageIcon(
                                AssetImage('images/icons/ic_cart blk.png'),
                                color: innerBoxIsScrolled
                                    ? kMainTextColor
                                    : kWhiteColor,
                              ),
                              onPressed: () {
                                if (isCartCount) {
                                  Navigator.pushNamed(
                                          context, PageRoutes.restviewCart)
                                      .then((value) {
                                    getCartCount();
                                  });
                                } else {
                                  Toast.show(locale.noValueCartText, context,
                                      duration: Toast.LENGTH_SHORT);
                                }
//                        getCurrency();
                              }),
                          Positioned(
                              right: 5,
                              top: 2,
                              child: Visibility(
                                visible: isCartCount,
                                child: CircleAvatar(
                                  minRadius: 4,
                                  maxRadius: 8,
                                  backgroundColor: innerBoxIsScrolled
                                      ? kMainColor
                                      : kWhiteColor,
                                  child: Text(
                                    '$cartCount',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: innerBoxIsScrolled
                                            ? kWhiteColor
                                            : kMainTextColor,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                    // IconButton(
                    //   icon: Icon(Icons.shopping_cart,color: innerBoxIsScrolled?kMainTextColor:kWhiteColor,size: 24.0,),
                    //   onPressed: () {
                    //    hitResturantCart(context);
                    //   },
                    // ),
                  ],
                  title: InkWell(
                    onTap: () {
                      // _addressBottomSheet(context, width);
                      // Navigator.of(context)
                      //     .push(MaterialPageRoute(builder: (context) {
                      //   return LocationPage(lat, lng);
                      // })).then((value) {
                      //   if (value != null) {
                      //     print('${value.toString()}');
                      //     BackLatLng back = value;
                      //     getBackResult(back.lat, back.lng);
                      //   }
                      // }).catchError((e) {
                      //   print(e);
                      //   // getBackResult();
                      // });
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(locale.deliveringToText,
                            style: TextStyle(
                              color: innerBoxIsScrolled
                                  ? kMainTextColor
                                  : kWhiteColor,
                              fontSize: 13.0,
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.w500,
                            )),
                        SizedBox(
                          height: 5.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: innerBoxIsScrolled
                                  ? kMainTextColor
                                  : kWhiteColor,
                              size: 16.0,
                            ),
                            Expanded(
                              child: Text(cityName,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: innerBoxIsScrolled
                                        ? kMainTextColor
                                        : kWhiteColor,
                                    fontSize: 13.0,
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.w500,
                                  )),
                            ),
                            // Icon(
                            //   Icons.arrow_drop_down,
                            //   color: innerBoxIsScrolled
                            //       ? kMainTextColor
                            //       : kWhiteColor,
                            //   size: 16.0,
                            // ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      padding: EdgeInsets.only(
                          left: fixPadding,
                          right: fixPadding,
                          top: 0.0,
                          bottom: fixPadding),
                      alignment: Alignment.bottomCenter,
                      decoration: BoxDecoration(
                        color: kMainColor,
                      ),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                                  context,
                                  PageTransition(
                                      type: PageTransitionType.rightToLeft,
                                      child: SearchRestaurantStore(
                                          currencySymbol)))
                              .then((value) {
                            getCartCount();
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20.0),
                          padding: EdgeInsets.symmetric(
                              vertical: 6.0, horizontal: 10.0),
                          decoration: BoxDecoration(
                              boxShadow: [
                                BoxShadow(color: kCardBackgroundColor),
                              ],
                              borderRadius: BorderRadius.circular(30.0),
                              color: kCardBackgroundColor,
                              border: Border.all(color: kCardBackgroundColor)),
                          child: Padding(
                            padding: EdgeInsets.all(fixPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
//                                  Icon(
//                                    Icons.search,
//                                    color: kMainColor,
//                                    size: 20.0,
//                                  ),
                                ImageIcon(
                                  AssetImage('images/icons/ic_search.png'),
                                  color: Colors.black,
                                  size: 16,
                                ),
                                Padding(
                                  padding:
                                      EdgeInsets.only(left: fixPadding * 2),
                                  child: Text(
                                    locale.doYouFindSomeText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(color: kHintColor,fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  automaticallyImplyLeading: false,
                ),
              ];
            },
            body: SafeArea(
              child: Container(
                height: height,
                width: width,
                decoration: BoxDecoration(
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(15.0)),
                  color: kCardBackgroundColor,
                ),
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  children: <Widget>[
                    // Image Slider List Start
//                     Visibility(
//                       visible: (!isSlideFetch && listImage!=null && listImage.length>0)?true:false,
//                       child: Column(
//                         children: [
//                           Padding(
//                             padding: EdgeInsets.only(top: fixPadding * 1.5),
//                             child: ImageSliderList(listImage,(){
// getCartCount();
//                             }),
//                           ),
//                           // Image Slider List End
//                           heightSpace,
//                         ],
//                       ),
//                     ),
                    Visibility(
                      visible: (!isSlideFetch && listImage.length > 0)
                          ? true
                          : false,
                      child: Container(
                        width: width,
                        height: 160.0,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10, bottom: 5),
                          child: (listImage != null && listImage.length > 0)
                              ? ListView.builder(
                                  itemCount: listImage.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // final item = listImage[index];
                                    return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 170.0,
                                        margin: (index !=
                                                (listImage.length - 1))
                                            ? EdgeInsets.only(left: fixPadding)
                                            : EdgeInsets.only(
                                                left: fixPadding,
                                                right: fixPadding),
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   image: Image.network(imageBaseUrl+listImage[index].banner_image),
                                          //   fit: BoxFit.cover,
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Image.network(
                                          '${imageBaseUrl}${listImage[index].banner_image}',
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : ListView.builder(
                                  itemCount: 10,
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    // final item = listImages[index];
                                    return InkWell(
                                      onTap: () {},
                                      child: Container(
                                        width: 170.0,
                                        margin: (index != (10 - 1))
                                            ? EdgeInsets.only(left: fixPadding)
                                            : EdgeInsets.only(
                                                left: fixPadding,
                                                right: fixPadding),
                                        decoration: BoxDecoration(
                                          // image: DecorationImage(
                                          //   image: AssetImage(imageBaseUrl+item.banner_image),
                                          //   fit: BoxFit.cover,
                                          // ),
                                          borderRadius:
                                              BorderRadius.circular(10.0),
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
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ),
                    ),
                    // Categories Start
                    Visibility(
                      // visible: (!isCategoryFetch && categoryList!=null && categoryList.length>0)?true:false,
                      visible: false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(fixPadding),
                            child: Text(
                              locale.categoriesText,
                              style: headingStyle,
                            ),
                          ),
                          CategoryList(categoryList, () {
                            getCartCount();
                          }),
                          // Categories End
                          heightSpace,
                        ],
                      ),
                    ),
                    // Products Ordered Start
                    Visibility(
                      visible: (!isProdcutOrderFetch &&
                              popularItem != null &&
                              popularItem.length > 0)
                          ? true
                          : false,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(fixPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  locale.productsOrderedText,
                                  style: headingStyle,
                                ),
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(
                                            type:
                                                PageTransitionType.bottomToTop,
                                            child: ProductsOrderedNew(
                                                currencySymbol)));
                                  },
                                  child: Text(locale.viewAllText, style: moreStyle),
                                ),
                              ],
                            ),
                          ),
                          ProductsOrdered(currencySymbol, popularItem, () {
                            getCartCount();
                          }),
                          // Products Ordered End
                          heightSpace,
                          heightSpace,
                        ],
                      ),
                    ),
                    // Products Ordered Start
                    Visibility(
                        visible: (!isFetchRestStore && nearStores.length == 0)
                            ? false
                            : true,
                        child: Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(fixPadding),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    locale.storeText,
                                    style: headingStyle,
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                              context,
                                              PageTransition(
                                                  type: PageTransitionType
                                                      .bottomToTop,
                                                  child: ResturantPageList(
                                                      currencySymbol)))
                                          .then((value) {
                                        getCartCount();
                                      });
                                    },
                                    child: Text(locale.viewAllText, style: moreStyle),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              width: width,
                              // height: 170.0,
                              child: (nearStores != null &&
                                      nearStores.length > 0)
                                  ?GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 1.0),
                                  controller: ScrollController(keepScrollOffset: false),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: nearStores.length,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:(context,index){
                                    final item = nearStores[index];
                                    return InkWell(
                                      onTap: () async {
                                        if((item.online_status == "on" || item.online_status == "On" || item.online_status == "ON")){
                                          hitNavigator(context,item,locale);
                                        }else{
                                          Toast.show(locale.storesClosedText, context,
                                              duration: Toast.LENGTH_SHORT);
                                        }

                                      },
                                      child: Stack(
                                        children: [
                                          Container(
                                            width: width/2,
                                            decoration: BoxDecoration(
                                              color: kWhiteColor,
                                              borderRadius:
                                              BorderRadius.circular(5.0),
                                            ),
                                            margin: (index !=
                                                (nearStores.length - 1))
                                                ? EdgeInsets.only(
                                                left: fixPadding)
                                                : EdgeInsets.only(
                                                left: fixPadding,
                                                right: fixPadding),
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                              children: <Widget>[
                                                Container(
                                                    height: 110.0,
                                                    width: 130.0,
                                                    alignment:
                                                    Alignment.center,
                                                    padding: EdgeInsets.all(
                                                        fixPadding),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                      BorderRadius.vertical(
                                                          top: Radius
                                                              .circular(
                                                              5.0)),
                                                    ),
                                                    child: Image.network(
                                                      imageBaseUrl +
                                                          item.vendor_logo,
                                                      fit: BoxFit.fill,
                                                    )),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.symmetric(horizontal: 8),
                                                  child: Text(
                                                    '${item.vendor_name}',
                                                    style:
                                                    listItemTitleStyle,
                                                    maxLines: 2,
                                                    textAlign: TextAlign.center,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                  EdgeInsets.only(
                                                      left: 5.0,
                                                      right: 5.0),
                                                  child: Text(
                                                    '${double.parse('${nearStores[index].distance}').toStringAsFixed(2)} km',
                                                    style:
                                                    listItemSubTitleStyle,
                                                    maxLines: 1,
                                                    overflow: TextOverflow
                                                        .ellipsis,
                                                  ),
                                                ),
                                                // Container(
                                                //   child: Column(
                                                //     mainAxisAlignment:
                                                //     MainAxisAlignment
                                                //         .center,
                                                //     crossAxisAlignment:
                                                //     CrossAxisAlignment
                                                //         .start,
                                                //     children: <Widget>[
                                                //
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            ),
                                          ),
                                          Positioned(
                                            top: 50,
                                            height: 40,
                                            width: 150,
                                            child: Visibility(
                                              visible: (nearStores[index].online_status == "off" || nearStores[index].online_status == "Off" || nearStores[index].online_status == "OFF")?true:false,
                                              child: Container(
                                                alignment: Alignment.center,
                                                color: kCardBackgroundColor,
                                                child: Text(locale.storesClosedText,style: TextStyle(
                                                    color: red_color,
                                                    fontSize: 13
                                                ),),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                              )
                              // ListView.builder(
                              //         itemCount: nearStores.length,
                              //         scrollDirection: Axis.horizontal,
                              //         physics: BouncingScrollPhysics(),
                              //         itemBuilder: (context, index) {
                              //           final item = nearStores[index];
                              //           return InkWell(
                              //             onTap: () async {
                              //               if((item.online_status == "on" || item.online_status == "On" || item.online_status == "ON")){
                              //                 hitNavigator(context, item,locale);
                              //               }else{
                              //                 Toast.show(locale.storesClosedText, context,
                              //                     duration: Toast.LENGTH_SHORT);
                              //               }
                              //
                              //             },
                              //             child: Stack(
                              //               children: [
                              //                 Container(
                              //                   width: 130.0,
                              //                   decoration: BoxDecoration(
                              //                     color: kWhiteColor,
                              //                     borderRadius:
                              //                     BorderRadius.circular(5.0),
                              //                   ),
                              //                   margin: (index !=
                              //                       (nearStores.length - 1))
                              //                       ? EdgeInsets.only(
                              //                       left: fixPadding)
                              //                       : EdgeInsets.only(
                              //                       left: fixPadding,
                              //                       right: fixPadding),
                              //                   child: Column(
                              //                     crossAxisAlignment:
                              //                     CrossAxisAlignment.center,
                              //                     mainAxisAlignment:
                              //                     MainAxisAlignment.start,
                              //                     children: <Widget>[
                              //                       Container(
                              //                           height: 110.0,
                              //                           width: 130.0,
                              //                           alignment:
                              //                           Alignment.topRight,
                              //                           padding: EdgeInsets.all(
                              //                               fixPadding),
                              //                           decoration: BoxDecoration(
                              //                             borderRadius:
                              //                             BorderRadius.vertical(
                              //                                 top: Radius
                              //                                     .circular(
                              //                                     5.0)),
                              //                           ),
                              //                           child: Image.network(
                              //                             imageBaseUrl +
                              //                                 item.vendor_logo,
                              //                             fit: BoxFit.fill,
                              //                           )),
                              //                       Container(
                              //                         width: 130.0,
                              //                         height: 60.0,
                              //                         child: Column(
                              //                           mainAxisAlignment:
                              //                           MainAxisAlignment
                              //                               .center,
                              //                           crossAxisAlignment:
                              //                           CrossAxisAlignment
                              //                               .start,
                              //                           children: <Widget>[
                              //                             Padding(
                              //                               padding:
                              //                               EdgeInsets.all(5.0),
                              //                               child: Text(
                              //                                 '${item.vendor_name}',
                              //                                 style:
                              //                                 listItemTitleStyle,
                              //                                 maxLines: 1,
                              //                                 overflow: TextOverflow
                              //                                     .ellipsis,
                              //                               ),
                              //                             ),
                              //                             Padding(
                              //                               padding:
                              //                               EdgeInsets.only(
                              //                                   left: 5.0,
                              //                                   right: 5.0),
                              //                               child: Text(
                              //                                 '${double.parse('${nearStores[index].distance}').toStringAsFixed(2)} km',
                              //                                 style:
                              //                                 listItemSubTitleStyle,
                              //                                 maxLines: 1,
                              //                                 overflow: TextOverflow
                              //                                     .ellipsis,
                              //                               ),
                              //                             ),
                              //                           ],
                              //                         ),
                              //                       ),
                              //                     ],
                              //                   ),
                              //                 ),
                              //                 Positioned(
                              //                   top: 50,
                              //                   height: 40,
                              //                   width: 150,
                              //                   child: Visibility(
                              //                     visible: (nearStores[index].online_status == "off" || nearStores[index].online_status == "Off" || nearStores[index].online_status == "OFF")?true:false,
                              //                     child: Container(
                              //                       alignment: Alignment.center,
                              //                       color: kCardBackgroundColor,
                              //                       child: Text(locale.storesClosedText,style: TextStyle(
                              //                           color: red_color,
                              //                         fontSize: 13
                              //                       ),),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ],
                              //             ),
                              //           );
                              //         },
                              //       )


                                  : GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 10,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      childAspectRatio: 1.0),
                                  controller: ScrollController(keepScrollOffset: false),
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: 10,
                                  physics: NeverScrollableScrollPhysics(),
                                  itemBuilder:(context,index){
                                   return InkWell(
                                     onTap: () {},
                                     child: Container(
                                       width: width/2,
                                       decoration: BoxDecoration(
                                         color: kWhiteColor,
                                         borderRadius:
                                         BorderRadius.circular(5.0),
                                       ),
                                       margin: EdgeInsets.only(
                                           left: fixPadding,
                                           right: fixPadding),
                                       child: Column(
                                         crossAxisAlignment:
                                         CrossAxisAlignment.center,
                                         mainAxisAlignment:
                                         MainAxisAlignment.start,
                                         children: <Widget>[
                                           Container(
                                             height: 130,
                                             width: 110,
                                             alignment: Alignment.center,
                                             padding: EdgeInsets.all(
                                                 fixPadding),
                                             decoration: BoxDecoration(
                                               borderRadius:
                                               BorderRadius.vertical(
                                                   top:
                                                   Radius.circular(
                                                       5.0)),
                                               // image: DecorationImage(
                                               //   image: AssetImage(item['image']),
                                               //   fit: BoxFit.cover,
                                               // ),
                                             ),
                                             child: Shimmer(
                                               duration:
                                               Duration(seconds: 3),
                                               color: Colors.white,
                                               enabled: true,
                                               direction: ShimmerDirection
                                                   .fromLTRB(),
                                               child: Container(
                                                 width: 130.0,
                                                 height: 110.0,
                                                 color: kTransparentColor,
                                               ),
                                             ),
                                           ),
                                           Padding(
                                             padding:
                                             EdgeInsets.all(5.0),
                                             child: Shimmer(
                                               duration: Duration(
                                                   seconds: 3),
                                               color: Colors.white,
                                               enabled: true,
                                               direction:
                                               ShimmerDirection
                                                   .fromLTRB(),
                                               child: Container(
                                                 width: 90.0,
                                                 height: 10.0,
                                                 color:
                                                 kTransparentColor,
                                               ),
                                             ),
                                           ),
                                           Padding(
                                             padding:
                                             EdgeInsets.only(
                                                 left: 5.0,
                                                 right: 5.0),
                                             child: Shimmer(
                                               duration: Duration(
                                                   seconds: 3),
                                               color: Colors.white,
                                               enabled: true,
                                               direction:
                                               ShimmerDirection
                                                   .fromLTRB(),
                                               child: Container(
                                                 width: 90.0,
                                                 height: 10.0,
                                                 color:
                                                 kTransparentColor,
                                               ),
                                             ),
                                           ),
                                         ],
                                       ),
                                     ),
                                   );
                                  }
                              ),
                            ),
                            heightSpace,
                          ],
                        )),
                    // FavouriteRestaurantsList(currencySymbol,nearStores,nearStoresSearch,() {
                    //   getCartCount();
                    //   print("value rest up");
                    // }),
                    // Products Ordered End

                    // Hot Sale Start
                    Visibility(
                      visible: (!isProdcutOrderFetch &&
                              popularItem != null &&
                              popularItem.length > 0)
                          ? true
                          : false,
                      child: Column(
                        children: [
                          heightSpace,
                          Padding(
                            padding: EdgeInsets.all(fixPadding),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  locale.hotSaleText,
                                  style: headingStyle,
                                ),
                                InkWell(
                                  onTap: () {
                                    // Navigator.push(context, PageTransition(type: PageTransitionType.downToUp, child: MoreList()));
                                  },
                                  child: Text(locale.viewAllText, style: moreStyle),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    HotSale(currencySymbol, popularItem, () {
                      getCartCount();
                    }),
                    // Hot Sale End
                    heightSpace,
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  hitNavigator(BuildContext context, NearStores item, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('${prefs.getString("res_vendor_id")}');
    print('${item.vendor_id}');
    if (isCartCount &&
        prefs.getString("res_vendor_id") != null &&
        prefs.getString("res_vendor_id") != "" &&
        prefs.getString("res_vendor_id") != '${item.vendor_id}') {
      showAlertDialog(context, item, currencySymbol,locale);
    } else {
      prefs.setString("res_vendor_id", '${item.vendor_id}');
      prefs.setString("store_resturant_name", '${item.vendor_name}');
      Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Restaurant_Sub(item, currencySymbol)))
          .then((value) {
        getCartCount();
      });
    }
  }

  showAlertDialog(BuildContext context, NearStores item, currencySymbol,AppLocalizations locale) {
    // set up the buttons
    // Widget no = FlatButton(
    //   padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
    //   child: Text("OK"),
    //   onPressed: () {
    //     Navigator.of(context, rootNavigator: true).pop('dialog');
    //   },
    // );

    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        deleteAllRestProduct(context, item, currencySymbol);
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: red_color,
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
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: kGreenColor,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            locale.noText,
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );

    // Widget yes = FlatButton(
    //   padding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
    //   child: Text("OK"),
    //   onPressed: () {
    //     Navigator.of(context, rootNavigator: true).pop('dialog');
    //   },
    // );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(locale.inconvenienceNoticeText1),
      content: Text(locale.inconvenienceNoticeText2),
      actions: [clear, no],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteAllRestProduct(
      BuildContext context, NearStores item, currencySymbol) async {
    DatabaseHelper database = DatabaseHelper.instance;
    database.deleteAllRestProdcut();
    database.deleteAllAddOns();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("res_vendor_id", '${item.vendor_id}');
    prefs.setString("store_resturant_name", '${item.vendor_name}');
    Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Restaurant_Sub(item, currencySymbol)))
        .then((value) {
      getCartCount();
    });
  }
  void _getDemoLocation() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String lati = prefs.getString('lat');
    String longi = prefs.getString('lng');
    lat = double.parse(lati);
    lng = double.parse(longi);
    final coordinates = new Coordinates(lat, lng);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      if (value[0].featureName != null && value[0].featureName.isNotEmpty && value[0].subAdminArea != null && value[0].subAdminArea.isNotEmpty) {
        setState(() {
          this.lat = lat;
          this.lng = lng;
          String city = '${value[0].featureName}';
          cityName = '${city} (${value[0].subAdminArea})';
        });
      }
      else if (value[0].subAdminArea != null && value[0].subAdminArea.isNotEmpty) {
        print('${value[0].locality}');
        this.lat = lat;
        this.lng = lng;
        String city = '${value[0].subAdminArea}';
        cityName = '${city.toUpperCase()}';
      }
      else if (value[0].adminArea != null && value[0].adminArea.isNotEmpty) {
        print('${value[0].locality}');
        this.lat = lat;
        this.lng = lng;
        String city = '${value[0].subAdminArea}';
        cityName = '${city.toUpperCase()}';
      }
      else{
        print('${value[0].locality}');
        setState(() {
          this.lat = lat;
          this.lng = lng;
          String city = '${value[0].addressLine}';
          cityName = '${city}';
        });
      }
    }).catchError((e) {
      print(e);
    });
  }
// Bottom Sheet for Address Ends Here
}
