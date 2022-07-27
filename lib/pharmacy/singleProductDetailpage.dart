import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/productlistvarient.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/pharmacy/pharmabean/pharmahomecategory.dart';

class SingleProductDetailPage extends StatefulWidget {
  dynamic productId;
  dynamic vendorId;

  SingleProductDetailPage(this.productId, this.vendorId) {
    productId = productId;
    vendorId = vendorId;
  }

  @override
  State<StatefulWidget> createState() {
    return SingleProductDetailState(productId, vendorId);
  }
}

class SingleProductDetailState extends State<SingleProductDetailPage> {
  var currentIndex = 1;
  bool isCartCount = false;
  bool isFetch = true;
  var cartCount = 0;
  dynamic currency = '';
  dynamic productId;
  dynamic vendorId;
  dynamic totalAmount = 0.0;
  List<CategoryPharmacy> productList = new List<CategoryPharmacy>();

  SingleProductDetailState(var productId, var vendorId) {
    //setList(productVarintList);
    this.productId = productId;
    this.vendorId = vendorId;
  }

  void hitProductDetail() async {
    setState(() {
      isFetch = true;
    });

    //SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("vendor_id",vendor_id);

    var url = pharmacy_product_by_id;
    http.post(url, body: {
      'productId': '$productId',
     // 'type': '3',
      'vendor_id': '$vendorId'
    }).then((value) {

      var jsonDat = (value.body);
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        print('Response Body: - productId: $productId vendor_id : $vendorId' +'${value.body}');

       // if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body)['data'] as List;
          List<CategoryPharmacy> tagObjs = tagObjsJson
              .map((tagJson) => CategoryPharmacy.fromJson(tagJson))
              .toList();
          if (tagObjs.isNotEmpty) {
            setState(() {
              productList.clear();
              productList = tagObjs;
              setList(productList);
            });
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
      }
    }).catchError((e) {
      setState(() {
        isFetch = false;
      });
      print(e);
    });
  }

  @override
  void initState() {
    super.initState();
    hitProductDetail();
    getCartCount();
    getCurrency();
  }

  void getCartCount() {
    DatabaseHelper db = DatabaseHelper.instance;
    db.queryRowPharmaCount().then((value) {
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

    getCatC();
  }

  void getCatC() async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.calculateTotalpharma().then((value) {
      db.calculateTotalPharmaAdon().then((valued) {
        var tagObjsJson = value as List;
        var tagObjsJsond = valued as List;
        setState(() {
          if (value != null) {
            dynamic totalAmount_1 = tagObjsJson[0]['Total'];
            print('T--${totalAmount_1}');
            if (valued != null) {
              dynamic totalAmount_2 = tagObjsJsond[0]['Total'];
              print('T--${totalAmount_2}');
              if (totalAmount_2 == null) {
                if (totalAmount_1 == null) {
                  totalAmount = 0.0;
                } else {
                  totalAmount = double.parse('${totalAmount_1}');
                }
              } else {
                totalAmount = double.parse('${totalAmount_1}') +
                    double.parse('${totalAmount_2}');
              }
            } else {
              if (totalAmount_1 == null) {
                totalAmount = 0.0;
              } else {
                totalAmount = double.parse('${totalAmount_1}');
              }
            }
          } else {
            totalAmount = 0.0;
//          deliveryCharge = 0.0;
          }
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: AppBar(
          titleSpacing: 0.0,
          title: Text(
            '${productList.length>0?productList[0].product_name:''}',
            style: TextStyle(
                fontSize: 18, color: black_color, fontWeight: FontWeight.w500),
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
                          hitViewCart(context, locale);
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
        ),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Image(
                    image: NetworkImage((productList.length>0?productList[0].product_image:"")),
                    fit: BoxFit.cover,
                  ),
                ),
              )),
          Expanded(
            flex: 1,
            child: Padding(
              padding: EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 1;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                          color: (currentIndex == 1) ? kMainColor : kWhiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: kMainColor)),
                      alignment: Alignment.center,
                      width: MediaQuery.of(context).size.width * 0.5 - 20,
                      child: Text(
                        locale.variant,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            color:
                                (currentIndex == 1) ? kWhiteColor : black_color,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        currentIndex = 0;
                      });
                    },
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                          color: (currentIndex == 0) ? kMainColor : kWhiteColor,
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                          border: Border.all(color: kMainColor)),
                      width: MediaQuery.of(context).size.width * 0.5 - 20,
                      alignment: Alignment.center,
                      child: Text(
                        locale.description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 17,
                            color:
                                (currentIndex == 0) ? kWhiteColor : black_color,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
              flex: 5,
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: IndexedStack(
                  index: currentIndex,
                  children: [
                    ProductDescription(productList.length>0?productList[0].description:''),
                    (productList.length > 0)
                        ? ListView.builder(
                            itemCount: productList.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 5.0, top: 30.0, right: 14.0),
                                        child: Container(
                                          height: 93.3,
                                          width: 93.3,
                                          child: (productList != null &&
                                                  productList.length > 0 &&
                                              productList[0].product_image != null &&
                                              productList[0].product_image.toString() != '')
                                              ? Image.network(
                                                         productList[0]
                                                          .product_image,
//                                scale: 2.5
                                                  height: 93.3,
                                                  width: 93.3,
                                                  fit: BoxFit.cover,
                                                )
                                              : Image(
                                                  image: AssetImage(
                                                      'images/logos/logo_user1.png'),
                                                  height: 93.3,
                                                  width: 93.3,
                                                ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  EdgeInsets.only(right: 20),
                                              child: Text(
                                                  productList.length>0? productList[0].product_name:'',
                                                  style:
                                                      bottomNavigationTextStyle
                                                          .copyWith(
                                                              fontSize: 15)),
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                           /* Text(
                                                '${widget.currency} ${widget.productVarintList[index].price}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .caption),*/
                                            Row(
                                              children: [
                                                Visibility(
                                                  visible: (
                                                      productList.length>0?
                                                      productList[0]
                                                          .variant[index]
                                                          .price:'') !=
                                                      (productList.length>0?productList[0]
                                                          .variant[index]
                                                          .strick_price:''),
                                                  child: Text(
                                                      '$currency ${productList.length>0?(productList[0].variant[index].strick_price != null) ? productList[0].variant[index].strick_price.toString() : 0:0}',
                                                      style: TextStyle(
                                                          decorationColor:
                                                              Colors.red,
                                                          decorationStyle:
                                                              TextDecorationStyle
                                                                  .solid,
                                                          decoration:
                                                              TextDecoration
                                                                  .lineThrough,
                                                          fontSize:
                                                              14), /*Theme.of(
                                                              context)
                                                              .textTheme
                                                              .caption*/
                                                      ),
                                                ),
                                                SizedBox(width: 10),
                                                Text(
                                                    '$currency ${productList.length>0?(productList[0].variant[index].price != null) ? productList[0].variant[index].price.toString() : 0:0}',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .caption),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 20.0,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  Positioned(
                                    left: 110,
                                    bottom: 5,
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 40.0,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.0,vertical: 2),
                                        decoration: BoxDecoration(
                                          color: kCardBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(10.0),
                                        ),
                                        child: Container(
                                          width: 127.0,
                                          child:
                                            Text(
                                              '${productList.length>0?productList[0].variant[index].quantity:0} ${productList.length>0?productList[0].variant[index].unit:''}',
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),

                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      height: 30,
                                      right: 0.0,
                                      bottom: 5,
                                      child: ((productList.length>0)?productList[0]
                                                  .variant[index]
                                                  .addOnQty:0) ==
                                              0
                                          ? Container(
                                              height: 30.0,
                                              child: FlatButton(
                                                child: Text(
                                                  'Add',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .caption
                                                      .copyWith(
                                                          color: kMainColor,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                ),
                                                textTheme:
                                                    ButtonTextTheme.accent,
                                                onPressed: () {
                                                  setState(() {
                                                    var stock = int.parse(
                                                        //'${widget.productVarintList[index].stock}'
                                                        '10');
                                                    if (stock >
                                                        productList[0]
                                                            .variant[index]
                                                            .addOnQty) {
                                                      productList[0]
                                                          .variant[index]
                                                          .addOnQty++;
                                                      addOrMinusProduct(
                                                          productList[0]
                                                              .product_name,
                                                          productList[0]
                                                              .variant[index]
                                                              .unit,
                                                          double.parse(
                                                              '${productList[0].variant[index].price}'),
                                                          int.parse(
                                                              '${productList[0].variant[index].quantity}'),
                                                          productList[0].variant[index]
                                                              .addOnQty,
                                                          productList[0]
                                                              .product_image,
                                                          productList[0]
                                                              .variant[index]
                                                              .variant_id);
                                                    } else {
                                                      Toast.show(
                                                          locale
                                                              .noMoreStockAvailable,
                                                          context,
                                                          gravity:
                                                              Toast.BOTTOM);
                                                    }
                                                  });
                                                },
                                              ),
                                            )
                                          : Container(
                                              height: 30.0,
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 11.0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: kMainColor),
                                                borderRadius:
                                                    BorderRadius.circular(30.0),
                                              ),
                                              child: Row(
                                                children: <Widget>[
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                              productList.length>0?productList[0]
                                                            .variant[index]
                                                            .addOnQty--:0;
                                                      });
                                                      addOrMinusProduct(
                                                          productList[0]
                                                              .product_name,
                                                          productList[0]
                                                              .variant[index]
                                                              .unit,
                                                          double.parse(
                                                              '${productList[0].variant[index].price}'),
                                                          int.parse(
                                                              '${productList[0].variant[index].quantity}'),
                                                          productList[0].variant[index]
                                                              .addOnQty,
                                                          productList[0]
                                                              .product_image,
                                                          productList[0]
                                                              .variant[index]
                                                              .variant_id);
                                                    },
                                                    child: Icon(
                                                      Icons.remove,
                                                      color: kMainColor,
                                                      size: 20.0,
//size: 23.3,
                                                    ),
                                                  ),
                                                  SizedBox(width: 8.0),
                                                  Text(
                              productList.length>0?productList[0]
                                                          .variant[index]
                                                          .addOnQty
                                                          .toString():'',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption),
                                                  SizedBox(width: 8.0),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        var stock = int.parse(
                                                            //'${widget.productVarintList[index].stock}'
                                                            '10');
                                                        if (stock >
                                                            productList[0]
                                                                .variant[index]
                                                                .addOnQty) {
                                                          productList[0]
                                                              .variant[index]
                                                              .addOnQty++;
                                                          addOrMinusProduct(
                                                              productList[0]
                                                                  .product_name,
                                                              productList[0]
                                                                  .variant[index]
                                                                  .unit,
                                                              double.parse(
                                                                  '${productList[0].variant[index].price}'),
                                                              int.parse(
                                                                  '${productList[0].variant[index].quantity}'),
                                                              productList[0].variant[index]
                                                                  .addOnQty,
                                                              productList[0]
                                                                  .product_image,
                                                              productList[0]
                                                                  .variant[index]
                                                                  .variant_id);
                                                        } else {
                                                          Toast.show(
                                                              locale
                                                                  .noMoreStockAvailable,
                                                              context,
                                                              gravity:
                                                                  Toast.BOTTOM);
                                                        }
                                                      });
                                                    },
                                                    child: Icon(
                                                      Icons.add,
                                                      color: kMainColor,
                                                      size: 20.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            )
//                          upDataView(productVarientList[index].data[0].varient_id, index, context)

                                      ),
                                ],
                              );
                            })
                        : Container(),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  void addOrMinusProduct(product_name, unit, price, quantity, itemCount,
      varient_image, varient_id) async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.getPharmaCount(varient_id).then((value) {
      var vae = {
        DatabaseHelper.productId: '1',
        DatabaseHelper.productName: product_name,
        DatabaseHelper.price: (double.parse('${price}') * itemCount),
        DatabaseHelper.unit: unit,
        DatabaseHelper.quantitiy: int.parse('${quantity}'),
        DatabaseHelper.addQnty: itemCount,
        DatabaseHelper.varientId: varient_id
      };
      if (value == 0) {
        db.insertPharmaOrder(vae);
      } else {
        if (itemCount == 0) {
          db.deletePharmaProduct(varient_id).then((value) {
            db.deletePharmaAddOn(varient_id);
          });
        } else {
          db.updatePharmaProductData(vae, varient_id).then((vay) {
            getCatC();
          });
        }
      }
      getCartCount();
    }).catchError((e) {
      print(e);
    });
  }

  hitViewCart(BuildContext context, AppLocalizations locale) {
    if (isCartCount) {
      Navigator.pushNamed(context, PageRoutes.pharmacart).then((value) {
        setList(productList);
        getCartCount();
      });
    } else {
      Toast.show(locale.noValueCartText, context, duration: Toast.LENGTH_SHORT);
    }
  }


  void setList(List<CategoryPharmacy> tagObjs) {
    for (int i = 0; i < tagObjs[0].variant.length; i++) {
      DatabaseHelper db = DatabaseHelper.instance;
      db.getVarientPharmaCount(tagObjs[0].variant[i].variant_id).then((value) {
        print('print val $value');
        if (value == null) {
          setState(() {
            tagObjs[0].variant[i].addOnQty = 0;
          });
        } else {
          setState(() {
            tagObjs[0].variant[i].addOnQty = value;
            isCartCount = true;
          });
        }
      });
    }
  }

  void setLit(List<CategoryPharmacy> tagObjs) {
    for (int i = 0; i < tagObjs[0].variant.length; i++) {
      if (tagObjs[0].variant.length > 0) {
        DatabaseHelper db = DatabaseHelper.instance;
        db
            .getVarientPharmaCount(
            tagObjs[0].variant[i].variant_id)
            .then((value) {
          if (value == null) {
            setState(() {
              tagObjs[0].variant[i].addOnQty = 0;
            });
          } else {
            setState(() {
              tagObjs[i].addOnQty = value;
              isCartCount = true;
            });
            for (int j = 0; j < tagObjs[i].addons.length; j++) {
              db
                  .getPharmaCountAddon(tagObjs[i].addons[j].addon_id,
                  tagObjs[i].variant[tagObjs[i].selectPos].variant_id)
                  .then((valued) {
                if (valued != null && valued > 0) {
                  setState(() {
                    tagObjs[i].addons[j].isAdd = true;
                  });
                } else {
                  setState(() {
                    tagObjs[i].addons[j].isAdd = false;
                  });
                }
              });
            }
          }
        });
      }
    }
  }

  void clearCart() async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteAllPharma().then((value) {
      db.deleteAllAddonPharma().then((value) {
        getCatC();
      });
    });
  }

 /* void deleteAddOn(addonid) async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteAddOnIdPharma(int.parse(addonid)).then((value) {
      getCartItem();
      getCatC();
    });
  }*/

  showAlertDialog(BuildContext context, index) async {
    AppLocalizations locale = AppLocalizations.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
        clearCart();
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
        setState(() {
          // prefs.setString("vendor_id", '');
          productList[0].variant[index].addOnQty--;
        });
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

  void getCurrency() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      //currency = preferences.getString('curency');
      currency = '₹';
    });
  }
}

class ProductDescription extends StatelessWidget {
  final dynamic description;

  ProductDescription(this.description);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SingleChildScrollView(
          primary: true,
          child: Text(
            '${description}',
            style: TextStyle(
                fontSize: 16,
                color: kHintColor,
                height: 1.5,
                fontWeight: FontWeight.w400),
          ),
        ),
      ),
    );
  }
}
