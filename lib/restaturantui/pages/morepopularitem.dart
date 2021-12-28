import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/nearstorebean.dart';
import 'package:user/bean/resturantbean/addonidlist.dart';
import 'package:user/bean/resturantbean/popular_item.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/restaturantui/helper/add_to_cartbottomsheet.dart';

class MorePopularItemList extends StatefulWidget {
  final NearStores item;
  final dynamic currencySymbol;
  MorePopularItemList(this.item, this.currencySymbol);

  @override
  _MorePopularItemListState createState() => _MorePopularItemListState();
}

class _MorePopularItemListState extends State<MorePopularItemList> {

  List<PopularItem> popularItem = [];
  List<PopularItem> popularItemSearch = [];

  bool isFetch = false;
  bool isCartCount = false;
  int cartCount = 0;

  @override
  void initState() {
    getCartCount();
    hitBannerUrl();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void hitBannerUrl() async {
    // SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFetch = true;
    });
    var url = popular_item;
    http.post(url, body: {
      'vendor_id': '${widget.item.vendor_id}'
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
              isFetch = false;
              popularItem.clear();
              popularItemSearch.clear();
              popularItem = List.from(tagObjs);
              popularItemSearch = List.from(tagObjs);
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


  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: CustomAppBar(
          titleWidget: Text(
            locale.popularItems,
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
                          Navigator.pushNamed(context, PageRoutes.restviewCart)
                              .then((value) {
                            getCartCount();
                          });
                        } else {
                          Toast.show(locale.noValueInTheCart, context,
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
                                fontWeight: FontWeight.w200),
                          ),
                        ),
                      ))
                ],
              ),
            ),
          ],
          bottom: PreferredSize(
              child: Container(
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
                    hintText: 'Search product...',
                  ),
                  cursorColor: kMainColor,
                  autofocus: false,
                  onChanged: (value) {
                    popularItem = popularItemSearch
                        .where((element) => element.product_name
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
      body:Container(
        width: width,
        height: height-110,
        margin: EdgeInsets.only(top: 20.0),
        child: (popularItem != null && popularItem.length > 0)?ListView.separated(
          itemCount: popularItem.length,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = popularItem[index];
            int indexws = item.variant.indexOf(PopularItemListd(item.variant_id,'','','','','','',0,0,false));
            return Container(
              decoration: BoxDecoration(
                color: kWhiteColor,
                borderRadius: BorderRadius.circular(5.0),
              ),
              margin: (index != (popularItem.length - 1))
                  ? EdgeInsets.only(left: fixPadding)
                  : EdgeInsets.only(left: fixPadding, right: fixPadding),
              child: Column(
                // crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        height: 100.0,
                        width: 90.0,
                        alignment: Alignment.topRight,
                        padding: EdgeInsets.all(fixPadding),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5.0),
                          // image: DecorationImage(
                          //   image: AssetImage(item['image']),
                          //   fit: BoxFit.cover,
                          // ),
                        ),
                        child: Image.network(
                          '${Uri.parse('${imageBaseUrl}${item.product_image}')}',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: width - ((fixPadding * 2) + 100.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(
                                  right: fixPadding * 2,
                                  left: fixPadding,
                                  bottom: fixPadding / 2),
                              child: Text(
                                '${item.product_name}',
                                style: listItemTitleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: fixPadding, right: fixPadding),
                              child: Text(
                                '${item.description}',
                                style: listItemSubTitleStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: fixPadding,
                                  right: fixPadding,
                                  top: fixPadding),
                              child: Text(
                                '(${item.variant[indexws].quantity} ${item.variant[indexws].unit})',
                                style: listItemSubTitleStyle,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  top: fixPadding, left: fixPadding),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Text(
                                    '${widget.currencySymbol} ${item.deal_price}',
                                    // '',
                                    style: priceStyle,
                                  ),
                                  InkWell(
                                    onTap: () async {

                                      SharedPreferences prefs = await SharedPreferences.getInstance();
                                      if (prefs.getString("res_vendor_id") != null &&
                                          prefs.getString("res_vendor_id") != "" &&
                                          prefs.getString("res_vendor_id") != '${item.variant[0].vendor_id}') {
                                        showAlertDialog(context, item, widget.currencySymbol,height);
                                      } else {
                                        DatabaseHelper db = DatabaseHelper.instance;
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
                                            // productDescriptionModalBottomSheet(
                                            //     context, height,item,widget.currencySymbol).then((value){
                                            //   widget.onVerificationDone();
                                            // });
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
                                                getCartCount();
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
                                        borderRadius: BorderRadius.circular(10.0),
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
                  )
                ],
              ),
            );
          },
          separatorBuilder: (context,index){
            return Divider(
              color: kCardBackgroundColor,
              thickness: 6.7,
            );
          },
        ):
        isFetch?Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(
                width: 10,
              ),
              Text(
                locale.fetchingPopularItemPleaseWait,
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: kMainTextColor),
              )
            ],
          ),
        ):Container(
          child: Text(locale.noPopularItemFoundAtThisMoment),
        ),
      ),
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
getCartCount();
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
