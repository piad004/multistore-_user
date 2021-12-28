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
import 'package:user/bean/nearstorebean.dart';
import 'package:user/bean/resturantbean/addonidlist.dart';
import 'package:user/bean/resturantbean/popular_item.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/restaturantui/helper/add_to_cartbottomsheet.dart';

class PopularItemList extends StatefulWidget {
  final NearStores item;
  final dynamic currencySymbol;
  final VoidCallback onVerificationDone;

  PopularItemList(this.item, this.currencySymbol, this.onVerificationDone);

  @override
  _PopularItemListState createState() => _PopularItemListState();
}

class _PopularItemListState extends State<PopularItemList> {
  List<PopularItem> popularItem = [];

  bool isFetch = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void hitBannerUrl() async {
    setState(() {
      isFetch = true;
    });
    var url = popular_item;
    http.post(url, body: {'vendor_id': '${widget.item.vendor_id}'}).then(
        (response) {
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
              isFetch = false;
              popularItem.clear();
              popularItem = tagObjs;
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

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Visibility(
      visible: (!isFetch && popularItem.length == 0) ? false : true,
      child: Container(
        width: width,
        height: 195.0,
        child: (popularItem != null && popularItem.length > 0)
            ? ListView.builder(
                itemCount: popularItem.length,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  final item = popularItem[index];
                  return Container(
                    width: 135.0,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin: (index != (popularItem.length - 1))
                        ? EdgeInsets.only(left: fixPadding)
                        : EdgeInsets.only(left: fixPadding, right: fixPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 110.0,
                          width: 135.0,
                          // alignment: Alignment.topRight,
                          padding: EdgeInsets.all(fixPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(5.0)),
                          ),
                          child: Stack(
                            children: [
                              Image.network(
                                imageBaseUrl + item.product_image,
                                fit: BoxFit.fill,
                                height: 110.0,
                                width: 130.0,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          width: 135.0,
                          height: 80.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Text(
                                  '${item.product_name}',
                                  style: listItemTitleStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Text(
                                  '${item.description}',
                                  style: listItemSubTitleStyle,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5.0, right: 5.0, left: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Text(
                                      '${widget.currencySymbol} ${item.deal_price}',
                                      style: priceStyle,
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        SharedPreferences prefs =
                                            await SharedPreferences
                                                .getInstance();
                                        if (prefs.getString("res_vendor_id") !=
                                                null &&
                                            prefs.getString("res_vendor_id") !=
                                                "" &&
                                            prefs.getString("res_vendor_id") !=
                                                '${item.variant[0].vendor_id}') {
                                          showAlertDialog(context, item,
                                              widget.currencySymbol, height);
                                        } else {
                                          DatabaseHelper db =
                                              DatabaseHelper.instance;
                                          db
                                              .getRestProdQty(
                                                  '${item.variant_id}')
                                              .then((value) {
                                            print('dddd - ${value}');
                                            if (value != null) {
                                              int index = item.variant.indexOf(
                                                  PopularItemListd(
                                                      item.variant_id,
                                                      '',
                                                      '',
                                                      '',
                                                      '',
                                                      '',
                                                      '',
                                                      0,
                                                      0,
                                                      false));
                                              setState(() {
                                                item.variant[index].addOnQty =
                                                    value;
                                              });
                                            }
                                            db
                                                .getAddOnList(
                                                    '${item.variant_id}')
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
                                                  int ind = addOnlist.indexOf(
                                                      AddonList(
                                                          '${item.addons[i].addon_id}'));
                                                  if (ind != null && ind >= 0) {
                                                    setState(() {
                                                      item.addons[i].isAdd =
                                                          true;
                                                    });
                                                  }
                                                }
                                              }

                                              db
                                                  .calculateTotalRestAdonA(
                                                      '${item.variant_id}')
                                                  .then((value1) {
                                                double priced = 0.0;
                                                if (value != null) {
                                                  var tagObjsJson =
                                                      value1 as List;
                                                  dynamic totalAmount_1 =
                                                      tagObjsJson[0]['Total'];
                                                  print('${totalAmount_1}');
                                                  if (totalAmount_1 != null) {
                                                    setState(() {
                                                      priced = double.parse(
                                                          '${totalAmount_1}');
                                                    });
                                                  }
                                                }
                                                productDescriptionModalBottomSheet(
                                                        context,
                                                        MediaQuery.of(context)
                                                            .size
                                                            .height,
                                                        item,
                                                        widget.currencySymbol,
                                                        priced)
                                                    .then((value) {
                                                  widget.onVerificationDone();
                                                });
                                              });
                                            });
                                          });
                                        }
                                      },
                                      child: Container(
                                        height: 20.0,
                                        width: 20.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: kMainColor,
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          color: kWhiteColor,
                                          size: 15.0,
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
                  );
                },
              )
            : ListView.builder(
                itemCount: 10,
                scrollDirection: Axis.horizontal,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // final item = productList[index];
                  return Container(
                    width: 135.0,
                    decoration: BoxDecoration(
                      color: kWhiteColor,
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    margin:
                        EdgeInsets.only(left: fixPadding, right: fixPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          height: 110.0,
                          width: 135.0,
                          alignment: Alignment.topRight,
                          padding: EdgeInsets.all(fixPadding),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(5.0)),
                          ),
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            color: Colors.white,
                            enabled: true,
                            direction: ShimmerDirection.fromLTRB(),
                            child: Container(
                              width: 135.0,
                              height: 110.0,
                              color: kTransparentColor,
                            ),
                          ),
                        ),
                        Container(
                          width: 135.0,
                          height: 80.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.all(5.0),
                                child: Shimmer(
                                  duration: Duration(seconds: 3),
                                  color: Colors.white,
                                  enabled: true,
                                  direction: ShimmerDirection.fromLTRB(),
                                  child: Container(
                                    width: 135.0,
                                    height: 10.0,
                                    color: kTransparentColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0, right: 5.0),
                                child: Shimmer(
                                  duration: Duration(seconds: 3),
                                  color: Colors.white,
                                  enabled: true,
                                  direction: ShimmerDirection.fromLTRB(),
                                  child: Container(
                                    width: 135.0,
                                    height: 10.0,
                                    color: kTransparentColor,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: 5.0, right: 5.0, left: 5.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Shimmer(
                                      duration: Duration(seconds: 3),
                                      color: Colors.white,
                                      enabled: true,
                                      direction: ShimmerDirection.fromLTRB(),
                                      child: Container(
                                        width: 50.0,
                                        height: 10.0,
                                        color: kTransparentColor,
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
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                          color: kTransparentColor,
                                        ),
                                        child: Shimmer(
                                          duration: Duration(seconds: 3),
                                          color: Colors.white,
                                          enabled: true,
                                          direction:
                                              ShimmerDirection.fromLTRB(),
                                          child: Container(
                                            width: 20.0,
                                            height: 20.0,
                                            color: kTransparentColor,
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
                  );
                },
              ),
      ),
    );
  }

  showAlertDialog(
      BuildContext context, PopularItem item, currencySymbol, double height) {
    var locale = AppLocalizations.of(context);
    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        deleteAllRestProduct(context, item, currencySymbol, height);
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
            locale.clear,
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
            locale.no,
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      title: Text(locale.inconvenienceNotice),
      content: Text(
          locale.orderFromDifferentStoreInSingleOrderIsNotAllowed),
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

  void deleteAllRestProduct(BuildContext context, PopularItem item,
      currencySymbol, double height) async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteAllRestProdcut();
    db.deleteAllAddOns();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("res_vendor_id", '${item.variant[0].vendor_id}');
    prefs.setString("store_resturant_name", '');
    db.getRestProdQty('${item.variant_id}').then((value) {
      if (value != null) {
        int index = item.variant.indexOf(PopularItemListd(
            item.variant_id, '', '', '', '', '', '', 0, 0, false));
        setState(() {
          item.variant[index].addOnQty = value;
        });
      }
      db.getAddOnList('${item.variant_id}').then((valued) {
        List<AddonList> addOnlist = [];
        if (valued != null && valued.length > 0) {
          addOnlist = valued.map((e) => AddonList.fromJson(e)).toList();
          for (int i = 0; i < item.addons.length; i++) {
            int ind =
                addOnlist.indexOf(AddonList('${item.addons[i].addon_id}'));
            if (ind != null && ind >= 0) {
              setState(() {
                item.addons[i].isAdd = true;
              });
            }
          }
        }
        print('list aaa - ${addOnlist.toString()}');

        db.calculateTotalRestAdonA('${item.variant_id}').then((value1) {
          double priced = 0.0;
          print('${value1}');
          if (value != null) {
            var tagObjsJson = value1 as List;
            dynamic totalAmount_1 = tagObjsJson[0]['Total'];
            print('${totalAmount_1}');
            if (totalAmount_1 != null) {
              setState(() {
                priced = double.parse('${totalAmount_1}');
              });
            }
          }
          productDescriptionModalBottomSheet(
                  context,
                  MediaQuery.of(context).size.height,
                  item,
                  widget.currencySymbol,
                  priced)
              .then((value) {
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
