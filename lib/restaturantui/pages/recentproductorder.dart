import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/resturantbean/addonidlist.dart';
import 'package:user/bean/resturantbean/popular_item.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/restaturantui/helper/add_to_cartbottomsheet.dart';

class ProductsOrderedNew extends StatefulWidget {
  final dynamic currencySymbol;
  ProductsOrderedNew(this.currencySymbol);

  @override
  _ProductsOrderedStateNew createState() => _ProductsOrderedStateNew();
}

class _ProductsOrderedStateNew extends State<ProductsOrderedNew> {
  // final productList = [
  //   {
  //     'title': 'Fried Noodles',
  //     'subtitle': 'Chinese',
  //     'image': 'assets/products/products_6.png',
  //     'status': 'none'
  //   },
  //   {
  //     'title': 'Hakka Nuddles',
  //     'subtitle': 'Chinese',
  //     'image': 'assets/products/products_1.png',
  //     'status': 'none'
  //   },
  //   {
  //     'title': 'Dry Manchuriyan',
  //     'subtitle': 'Chinese',
  //     'image': 'assets/products/products_2.png',
  //     'status': 'none'
  //   },
  //   {
  //     'title': 'Margherita Pizza',
  //     'subtitle': 'Delicious Pizza',
  //     'image': 'assets/products/products_3.png',
  //     'status': 'none'
  //   },
  //   {
  //     'title': 'Thin Crust Pizza',
  //     'subtitle': 'Delicious Pizza',
  //     'image': 'assets/products/products_4.png',
  //     'status': 'none'
  //   },
  //   {
  //     'title': 'Veg Burger',
  //     'subtitle': 'Fast Food',
  //     'image': 'assets/products/products_5.png',
  //     'status': 'none'
  //   }
  // ];
  List<PopularItem> popularItem = [];
  List<PopularItem> nearStoresSearch = [];

  bool isFetch = false;
  bool isCartCount = false;
  var cartCount = 0;


  @override
  void initState() {
    hitBannerUrl();
    super.initState();
    getCartCount();
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
  void hitBannerUrl() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFetch = true;
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
              isFetch = false;
              popularItem.clear();
              nearStoresSearch.clear();
              popularItem = tagObjs;
              nearStoresSearch = List.from(tagObjs);
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
    var locale = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: CustomAppBar(
          titleWidget: Text(
            locale.productOrderList,
            style: Theme
                .of(context)
                .textTheme
                .bodyText1,
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
                            // getCartCount();
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
                width: MediaQuery
                    .of(context)
                    .size
                    .width * 0.85,
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
                    popularItem = nearStoresSearch
                        .where((element) =>
                        element.product_name
                            .toString()
                            .toLowerCase()
                            .contains(value.toLowerCase()))
                        .toList();
                  },
                ),
              ),
              preferredSize:
              Size(MediaQuery
                  .of(context)
                  .size
                  .width * 0.85, 52)),
        ),
      ),
      body: Container(
        width: width,
        child: (popularItem != null && popularItem.length > 0)
            ? ListView.builder(
          itemCount: popularItem.length,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            final item = popularItem[index];
            return InkWell(
              onTap: () async{
                DatabaseHelper db = DatabaseHelper.instance;
                db.getRestProdQty('${item.variant_id}')
                    .then((value) {
                  print('dddd - ${value}');
                  int index = item.variant.indexOf(PopularItemListd(item.variant_id,'','','','','','',0,0,false));
                  if (value != null) {
                    setState(() {
                      item.variant[index].addOnQty = value;
                    });
                  }else{
                    if(item.variant[index].addOnQty>0){
                      setState(() {
                        item.variant[index].addOnQty = 0;
                      });
                    }
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
                      productDescriptionModalBottomSheet(context, MediaQuery.of(context).size.height,item,widget.currencySymbol,priced);
                    });


                  });
                });
              },
              child: Container(
                width: 130.0,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin: (index != (popularItem.length - 1))
                    ? EdgeInsets.only(left: fixPadding)
                    : EdgeInsets.only(
                    left: fixPadding, right: fixPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      height: 110.0,
                      width: 130.0,
                      // alignment: Alignment.topRight,
                      padding: EdgeInsets.all(fixPadding),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                            top: Radius.circular(5.0)),
                        // image: DecorationImage(
                        //   image: AssetImage(item['image']),
                        //   fit: BoxFit.cover,
                        // ),
                      ),
                      child: Stack(
                        children: [
                          Image.network(
                            imageBaseUrl + item.product_image,
                            fit: BoxFit.fill,
                            height: 110.0,
                            width: 130.0,
                          ),
                          // Align(
                          //   alignment: Alignment.topRight,
                          //   child: Icon(
                          //     // (item['status'] == 'none')
                          //     //     ? Icons.bookmark_border
                          //     //     : Icons.bookmark,
                          //     Icons.bookmark_border,
                          //     size: 22.0,
                          //     color: kWhiteColor,
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    Container(
                      width: 130.0,
                      height: 50.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                              item.product_name,
                              style: listItemTitleStyle,
                              textAlign: TextAlign.start,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Text(
                              '${item.deal_price}',
                              style: listItemSubTitleStyle,
                              textAlign: TextAlign.start,
                              // maxLines: 1,
                              // overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        )
            : (isFetch)?ListView.builder(
          itemCount: 10,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            // final item = productList[index];
            return InkWell(
              onTap: () {},
              child: Container(
                width: 130.0,
                decoration: BoxDecoration(
                  color: kWhiteColor,
                  borderRadius: BorderRadius.circular(5.0),
                ),
                margin:
                EdgeInsets.only(left: fixPadding, right: fixPadding),
                // margin: (index != (productList.length - 1))
                //     ? EdgeInsets.only(left: fixPadding)
                //     : ,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Shimmer(
                      duration: Duration(seconds: 3),
                      color: Colors.white,
                      enabled: true,
                      direction: ShimmerDirection.fromLTRB(),
                      child: Container(
                        width: 130.0,
                        height: 110.0,
                        color: kTransparentColor,
                      ),
                    ),
                    Container(
                      width: 130.0,
                      height: 50.0,
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
                                width: 130.0,
                                height: 10.0,
                                color: kTransparentColor,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            EdgeInsets.only(left: 5.0, right: 5.0),
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              color: Colors.white,
                              enabled: true,
                              direction: ShimmerDirection.fromLTRB(),
                              child: Container(
                                width: 130.0,
                                height: 10.0,
                                color: kTransparentColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ):Container(),
      ),
    );
  }
}
