import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/bannerbean.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/bean/resturantbean/addonidlist.dart';
import 'package:user/bean/resturantbean/categoryresturantlist.dart';
import 'package:user/bean/resturantbean/popular_item.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/restaturantui/helper/add_to_cartbottomsheet.dart';
import 'package:user/restaturantui/helper/juice_list.dart';
import 'package:user/restaturantui/widigit/column_builder.dart';

class ProductTabData extends StatefulWidget {
  final NearStores item;
final dynamic currencySymbol;
  final VoidCallback onVerificationDone;
  ProductTabData(this.item, this.currencySymbol,this.onVerificationDone);

  @override
  _ProductTabDataState createState() => _ProductTabDataState();
}

class _ProductTabDataState extends State<ProductTabData> {
  List<CategoryResturant> categoryList = [];
  List<CategoryResturantR> categoryList2 = [];
  List<PopularItem> popularItem = [];
  List<BannerDetails> listImage = [];
  bool isSlideFetch = false;
  bool isFetch = false;
  bool isFetchs = false;

  @override
  void initState() {
    // hitPopularitem();
    hitSliderUrl();
    hitResturantItem();
    super.initState();
  }

  void hitResturantItem() async {
    setState(() {
      isFetch = true;
    });
    print('${widget.item.vendor_id}');
    var url = homecategoryss;
    http.post(url, body: {
      'vendor_id': '${widget.item.vendor_id}'
    }).then((response) {
      print('sd - ${response.body}');
      if (response.statusCode == 200) {
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<CategoryResturant> tagObjs = tagObjsJson
              .map((tagJson) => CategoryResturant.fromJson(tagJson))
              .toList();
          List<CategoryResturantR> tagObjsC = tagObjsJson
              .map((tagJson) => CategoryResturantR.fromJson(tagJson))
              .toList();
          if (tagObjs != null && tagObjs.length > 0) {
            setState(() {
              isFetch = false;
              categoryList.clear();
              categoryList2.clear();
              categoryList = List.from(tagObjs);
              List<CategoryResturant>  categoryListNew = List.from(tagObjs);
              List<CategoryResturantR>  categoryListNewD = List.from(tagObjsC);
              categoryList2 = categoryListNewD.toSet().toList();
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
  void hitPopularitem() async {
    var locale = AppLocalizations.of(context);
    setState(() {
      isFetchs = true;
    });
    var url = popular_item;
    http.post(url, body: {
      'vendor_id': '${widget.item.vendor_id}'
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
              isFetchs = false;
              popularItem.clear();
              popularItem = tagObjs;
            });
          } else {
            setState(() {
              isFetchs = false;
            });
          }
        } else {
          setState(() {
            isFetchs = false;
          });
        }
      } else {
        setState(() {
          isFetchs = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isFetchs = false;
      });
    });
  }
  void hitSliderUrl() async {
    setState(() {
      isSlideFetch = true;
    });
    var url = resturant_banner;
    http.post(url,body: {
      'vendor_id': '${widget.item.vendor_id}'
    }).then((response) {
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

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      primary: true,
      children: <Widget>[
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
        heightSpace,
        heightSpace,
        (categoryList2 != null && categoryList2.length > 0)
            ? ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  var item = categoryList2[index];
                  print('${item.toString()}');
                  return (item.resturant_cat_id!=null)?Container(
                    color: kWhiteColor,
                    width: width,
                    child: Column(
                      children: [
                        Container(
                          width: width,
                          color: kWhiteColor,
                          child: Padding(
                            padding: EdgeInsets.all(fixPadding),
                            child: Text(
                              '${item.cat_name}',
                              style: headingStyle,
                            ),
                          ),
                        ),
                        Container(
                          color: kWhiteColor,
                          child: JuiceList(item,categoryList.where((element) => element.resturant_cat_id == item.resturant_cat_id).toList(),widget.currencySymbol,(){
                            widget.onVerificationDone();
                          }),
                        ),
                        Container(
                          height: 10.0,
                          color: kWhiteColor,
                        ),
                      ],
                    ),
                  ):SizedBox.shrink();
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      heightSpace,
                      heightSpace,
                    ],
                  );
                },
                itemCount: categoryList2.length)
            : (isFetch)?ListView.separated(
                shrinkWrap: true,
                primary: false,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Container(
                        color: kWhiteColor,
                        child: Padding(
                          padding: EdgeInsets.all(fixPadding),
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            color: Colors.white,
                            enabled: true,
                            direction: ShimmerDirection.fromLTRB(),
                            child: Container(
                              width: 100.0,
                              height: 20.0,
                              color: kTransparentColor,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: kWhiteColor,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: fixPadding, left: fixPadding),
                              child: Shimmer(
                                duration: Duration(seconds: 3),
                                color: Colors.white,
                                enabled: true,
                                direction: ShimmerDirection.fromLTRB(),
                                child: Container(
                                  width: 100.0,
                                  height: 20.0,
                                  color: kTransparentColor,
                                ),
                              ),
                            ),
                            ColumnBuilder(
                              itemCount: 2,
                              mainAxisAlignment: MainAxisAlignment.start,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              itemBuilder: (context, index) {
                                // final item = restaurantsList[index];
                                return Container(
                                  width: width,
                                  height: 105.0,
                                  margin: EdgeInsets.all(fixPadding),
                                  decoration: BoxDecoration(
                                    color: kWhiteColor,
                                    borderRadius: BorderRadius.circular(5.0),
                                  ),
                                  child: Stack(
                                    children: <Widget>[
                                      Positioned(
                                        right: fixPadding,
                                        child: InkWell(
                                          onTap: () {},
                                          child: Shimmer(
                                            duration: Duration(seconds: 3),
                                            color: Colors.white,
                                            enabled: true,
                                            direction:
                                                ShimmerDirection.fromLTRB(),
                                            child: Container(
                                              width: 22.0,
                                              height: 22.0,
                                              color: kTransparentColor,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Shimmer(
                                            duration: Duration(seconds: 3),
                                            color: Colors.white,
                                            enabled: true,
                                            direction:
                                                ShimmerDirection.fromLTRB(),
                                            child: Container(
                                              width: 90.0,
                                              height: 100.0,
                                              color: kTransparentColor,
                                            ),
                                          ),
                                          Container(
                                            width: width -
                                                ((fixPadding * 2) + 100.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: <Widget>[
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: fixPadding * 2,
                                                      left: fixPadding,
                                                      bottom: fixPadding),
                                                  child: Shimmer(
                                                    duration:
                                                        Duration(seconds: 3),
                                                    color: Colors.white,
                                                    enabled: true,
                                                    direction: ShimmerDirection
                                                        .fromLTRB(),
                                                    child: Container(
                                                      height: 20.0,
                                                      color: kTransparentColor,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: fixPadding,
                                                      right: fixPadding),
                                                  child: Shimmer(
                                                    duration:
                                                        Duration(seconds: 3),
                                                    color: Colors.white,
                                                    enabled: true,
                                                    direction: ShimmerDirection
                                                        .fromLTRB(),
                                                    child: Container(
                                                      height: 20.0,
                                                      color: kTransparentColor,
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      top: fixPadding,
                                                      left: fixPadding),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: <Widget>[
                                                      Shimmer(
                                                        duration: Duration(
                                                            seconds: 3),
                                                        color: Colors.white,
                                                        enabled: true,
                                                        direction:
                                                            ShimmerDirection
                                                                .fromLTRB(),
                                                        child: Container(
                                                          width: 100.0,
                                                          height: 20.0,
                                                          color:
                                                              kTransparentColor,
                                                        ),
                                                      ),
                                                      InkWell(
                                                        onTap: () {
                                                          // productDescriptionModalBottomSheet(
                                                          //     context, height);
                                                        },
                                                        child: Container(
                                                          height: 20.0,
                                                          width: 20.0,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        10.0),
                                                            color:
                                                                kTransparentColor,
                                                          ),
                                                          child: Shimmer(
                                                            duration: Duration(
                                                                seconds: 3),
                                                            color: Colors.white,
                                                            enabled: true,
                                                            direction:
                                                                ShimmerDirection
                                                                    .fromLTRB(),
                                                            child: Container(
                                                              width: 15.0,
                                                              height: 15.0,
                                                              color:
                                                                  kTransparentColor,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: 10.0,
                        color: kWhiteColor,
                      ),
                    ],
                  );
                },
                separatorBuilder: (context, index) {
                  return Column(
                    children: [
                      heightSpace,
                      heightSpace,
                    ],
                  );
                },
                itemCount: 10):SizedBox.shrink(),
      ],
    );
  }

  showAlertDialog(BuildContext context, PopularItem item, currencySymbol, double height) {
    var locale = AppLocalizations.of(context);
    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        deleteAllRestProduct(context, item, currencySymbol,height);
      },
      child: Card(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Container(
          padding: EdgeInsets.only(left:20, right:20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: red_color,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            locale.clear, style: TextStyle(fontSize: 13, color: kWhiteColor),),
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
          padding: EdgeInsets.only(left:20, right:20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: kGreenColor,
              borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Text(
            locale.no, style: TextStyle(fontSize: 13, color: kWhiteColor),),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: Text(locale.inconvenienceNotice),
      content: Text(
          locale.orderFromDifferentStoreInSingleOrderIsNotAllowed),
      actions: [
        clear,
        no
      ],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void deleteAllRestProduct(BuildContext context, PopularItem item,
      currencySymbol, double height) async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteAllRestProdcut();
    db.deleteAllAddOns();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("res_vendor_id", '${item.variant[0].vendor_id}');
    // prefs.setString("store_resturant_name", '${item.variant[0].vendor_name}');
    prefs.setString("store_resturant_name", '');
    db.getRestProdQty('${item.variant_id}')
        .then((value) {
      print('dddd - ${value}');
      if (value != null) {
        int index = item.variant.indexOf(PopularItemListd(item.variant_id,'','','','','','',0,0,false));
        setState(() {
          item.variant[index].addOnQty = value;
        });
      }
      db.getAddOnList('${item.variant_id}')
          .then((valued) {
        List<AddonList> addOnlist = [];
        if (valued != null &&
            valued.length > 0) {
          addOnlist = valued
              .map((e) =>
              AddonList.fromJson(e))
              .toList();
          for (int i = 0;
          i < item.addons.length;
          i++) {
            int ind = addOnlist.indexOf(AddonList(
                '${item.addons[i].addon_id}'));
            if (ind != null && ind >= 0) {
              setState(() {
                item.addons[i].isAdd =
                true;
              });
            }
          }
        }
        print(
            'list aaa - ${addOnlist.toString()}');

        db.calculateTotalRestAdonA('${item.variant_id}').then((value1){
          double priced = 0.0;
          print('${value1}');
          if(value!=null){
            var tagObjsJson = value1 as List;
            dynamic totalAmount_1 = tagObjsJson[0]['Total'];
            print('${totalAmount_1}');
            if(totalAmount_1!=null){
              setState((){
                priced = double.parse('${totalAmount_1}');
              });
            }
          }
          productDescriptionModalBottomSheet(context, MediaQuery.of(context).size.height,item,widget.currencySymbol,priced).then((value){
            widget.onVerificationDone();
          });
        });
        //
        // productDescriptionModalBottomSheet(
        //     context, height,item,widget.currencySymbol).then((value){
        //   widget.onVerificationDone();
        // });
      });
    });
  }
}
