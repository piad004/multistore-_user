import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/bannerbean.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/restaturantui/pages/product_tab.dart';
import 'package:user/restaturantui/pages/restaurant_information.dart';

class Restaurant_Sub extends StatefulWidget {
  final NearStores item;
  final dynamic currencySymbol;
  Restaurant_Sub(this.item, this.currencySymbol);

  @override
  _RestaurantState createState() => _RestaurantState();
}

class _RestaurantState extends State<Restaurant_Sub> {
  bool favourite = false;
  List<BannerDetails> listImage = [];
  bool isSlideFetch = false;
  bool isCartCount = false;

  var cartCount = 0;

  @override
  void initState() {
    getCartCount();
    super.initState();
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
  void getCartCount_new() {
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
      // getResturantFavioute(widget.item.vendor_id);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: scaffoldBgColor,
        body: SafeArea(
          child: NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  expandedHeight: 230,
                  backgroundColor: Colors.white,
                  pinned: true,
                  elevation: 0.0,
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
                    // IconButton(
                    //   icon: (favourite)
                    //       ? Icon(
                    //           Icons.bookmark,
                    //           color: innerBoxIsScrolled?kMainTextColor:kWhiteColor,
                    //         )
                    //       : Icon(
                    //           Icons.bookmark_border,
                    //           color: innerBoxIsScrolled?kMainTextColor:kWhiteColor,
                    //         ),
                    //   onPressed: () {
                    //     // setState(() {
                    //     //   favourite = !favourite;
                    //     // });
                    //     favourite
                    //         ? removeFavourite(widget.item, context)
                    //         : setFaviouriteResturant(widget.item, context);
                    //   },
                    // ),
                    Padding(
                      padding: const EdgeInsets.only(right: 6.0),
                      child: Stack(
                        children: [
                          IconButton(
                              icon: ImageIcon(
                                AssetImage('images/icons/ic_cart blk.png'),
                                color: innerBoxIsScrolled?kMainTextColor:kWhiteColor,
                              ),
                              onPressed: () {
                                if (isCartCount) {
                                  Navigator.pushNamed(context, PageRoutes.restviewCart)
                                      .then((value) {
                                    getCartCount_new();
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
                                  backgroundColor: innerBoxIsScrolled?kMainColor:kWhiteColor,
                                  child: Text(
                                    '$cartCount',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontSize: 7,
                                        color: innerBoxIsScrolled?kWhiteColor:kMainTextColor,
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                  title: Visibility(
                    visible: innerBoxIsScrolled ? true : false,
                    child: Text('${widget.item.vendor_name}'.toUpperCase(),
                        style: TextStyle(
                          color:
                              innerBoxIsScrolled ? kMainTextColor : kWhiteColor,
                          fontSize: 13.0,
                          fontFamily: 'OpenSans',
                          fontWeight: FontWeight.w500,
                        )),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Stack(
                      children: <Widget>[
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Container(
                            height: 180,
                            width: width,
                            alignment: Alignment.bottomCenter,
                            // decoration: BoxDecoration(
                            //   image: DecorationImage(
                            //     image: AssetImage(
                            //         'assets/restaurant/restaurant_3.png'),
                            //     fit: BoxFit.cover,
                            //   ),
                            // ),
                            child: Image.network(
                              imageBaseUrl + widget.item.vendor_logo,
                              fit: BoxFit.cover,
                              width: width,
                              height: 180,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          child: Container(
                            height: 180.0,
                            width: width,
                            color: kMainTextColor.withOpacity(0.6),
                            alignment: Alignment.bottomLeft,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.all(fixPadding),
                                  child: Text(
                                    '${widget.item.vendor_name}',
                                    style: TextStyle(
                                      fontSize: 22.0,
                                      color: innerBoxIsScrolled
                                          ? kMainTextColor
                                          : kWhiteColor,
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                    right: fixPadding,
                                    left: fixPadding,
                                  ),
                                  child: Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: kWhiteColor,
                                        size: 18.0,
                                      ),
                                      SizedBox(width: 2.0),
                                      Expanded(
                                        child: Text(
                                          '${widget.item.vendor_loc}',
                                          style: whiteSubHeadingStyle,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // Padding(
                                //   padding: EdgeInsets.all(fixPadding),
                                //   child: Row(
                                //     mainAxisAlignment: MainAxisAlignment.start,
                                //     crossAxisAlignment:
                                //         CrossAxisAlignment.center,
                                //     children: <Widget>[
                                //       Icon(Icons.star,
                                //           color: Colors.lime, size: 18.0),
                                //       SizedBox(width: 2.0),
                                //       Text(
                                //         '4.5',
                                //         style: whiteSubHeadingStyle,
                                //       ),
                                //     ],
                                //   ),
                                // ),
                                heightSpace,
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  bottom: TabBar(
                    indicatorColor: darkPrimaryColor,
                    labelColor: kMainTextColor,
                    indicatorPadding: EdgeInsets.only(right: 15.0, left: 15.0),
                    tabs: [
                      Tab(text: locale.productText),
                      // Tab(text: 'Review'),
                      Tab(text: locale.informationText),
                    ],
                  ),
                ),
              ];
            },
            body: Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
                color: kMainColor,
              ),
              child: TabBarView(
                children: [
                  ProductTabData(widget.item,widget.currencySymbol,(){
                    getCartCount();
                  }),
                  // ReviewTabData(widget.item),
                  RestaurantInformation(widget.item),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
