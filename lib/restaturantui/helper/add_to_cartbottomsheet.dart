import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/resturantbean/addonidlist.dart';
import 'package:user/bean/resturantbean/popular_item.dart';
import 'package:user/databasehelper/dbhelper.dart';

Future productDescriptionModalBottomSheet(context, height, PopularItem item, currencySymbol, priced) {
  int initialItemCount = 0;
  double itemPrice = 0.0;
  double price = 0.0;
  int index = item.variant.indexOf(
      PopularItemListd(item.variant_id, '', '', '', '', '', '', 0, 0, false));
  if (item.variant[index].addOnQty > 0) {
    price = (double.parse('${item.variant[index].addOnQty}') *
            double.parse('${item.deal_price}')) +
        priced;
  }
  double width = MediaQuery.of(context).size.width;
  bool s = false, m = false, l = false, option1 = false, option2 = false;
  DatabaseHelper db = DatabaseHelper.instance;
  db.getAddOnList('${item.variant[index].variant_id}').then((valued) {
    List<AddonList> addOnlist = [];
    if (valued != null && valued.length > 0) {
      addOnlist = valued.map((e) => AddonList.fromJson(e)).toList();
      for (int i = 0; i < item.addons.length; i++) {
        int ind = addOnlist.indexOf(AddonList('${item.addons[i].addon_id}'));
        if (ind != null && ind >= 0) {
          item.addons[i].isAdd = true;
        }
      }
    }
  });

  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        var locale = AppLocalizations.of(context);
        return StatefulBuilder(
          builder: (context, setState) {
            setAddOrMinusProdcutQty(PopularItem items, BuildContext context,
                produtId, productName, qty) async {
              print('tb - ${qty}');
              DatabaseHelper db = DatabaseHelper.instance;
              db.getRestProductcount('${items.variant_id}').then((value) {
                print('value d - $value');
                var vae = {
                  DatabaseHelper.productId: produtId,
                  DatabaseHelper.varientId: '${items.variant_id}',
                  DatabaseHelper.productName: productName,
                  DatabaseHelper.price:
                      ((double.parse('${items.deal_price}') * qty)),
                  DatabaseHelper.addQnty: qty,
                  DatabaseHelper.unit: items.variant[index].unit,
                  DatabaseHelper.quantitiy: items.variant[index].quantity
                };
                if (value == 0) {
                  db.insertRaturantOrder(vae).then((valueaa) {
                    setState(() {
                      item.variant[index].addOnQty = qty;
                      price = double.parse('${item.deal_price}') * qty;
                    });
                  });
                } else {
                  if (qty == 0) {
                    db.deleteResProduct('${items.variant_id}').then((value2) {
                      setState(() {
                        item.variant[index].addOnQty = qty;
                        price = double.parse('${item.deal_price}') * qty;
                      });
                      db.deleteAddOn(int.parse('${items.variant_id}'));
                    });
                  } else {
                    db
                        .updateRestProductData(vae, '${items.variant_id}')
                        .then((vay) {
                      print('vay - $vay');
                      setState(() {
                        item.variant[index].addOnQty = qty;
                        price = double.parse('${item.deal_price}') * qty;
                      });
                    });
                  }
                }
              }).catchError((e) {
                print(e);
              });
            }

            Future<dynamic> setAddOnToDatabase(isSelected, DatabaseHelper db,
                AddOnList addon, variant_id) async {
              var vae = {
                DatabaseHelper.varientId: '${variant_id}',
                DatabaseHelper.addonid: '${addon.addon_id}',
                DatabaseHelper.price: addon.addon_price,
                DatabaseHelper.addonName: addon.addon_name
              };
              await db.insertAddOn(vae).then((value) {
                print('addon add $value');
                if (value != null && value > 0) {
                  setState(() {
                    addon.isAdd = true;
                    isSelected = true;
                    db
                        .calculateTotalRestAdonA('${item.variant_id}')
                        .then((value1) {
                      double pricedd = 0.0;
                      print('${value1}');
                      if (value != null) {
                        var tagObjsJson = value1 as List;
                        dynamic totalAmount_1 = tagObjsJson[0]['Total'];
                        print('${totalAmount_1}');
                        if (totalAmount_1 != null) {
                          setState(() {
                            pricedd = double.parse('${totalAmount_1}');
                            if (item.variant[index].addOnQty > 0) {
                              price = (double.parse(
                                          '${item.variant[index].addOnQty}') *
                                      double.parse('${item.deal_price}')) +
                                  pricedd;
                            }
                          });
                        } else {
                          setState(() {
                            if (item.variant[index].addOnQty > 0) {
                              price = (double.parse(
                                          '${item.variant[index].addOnQty}') *
                                      double.parse('${item.deal_price}')) +
                                  pricedd;
                            }
                          });
                        }
                      }
                    });
                  });
                } else {
                  setState(() {
                    addon.isAdd = false;
                    isSelected = false;
                    db
                        .calculateTotalRestAdonA('${item.variant_id}')
                        .then((value1) {
                      double pricedd = 0.0;
                      print('${value1}');
                      if (value != null) {
                        var tagObjsJson = value1 as List;
                        dynamic totalAmount_1 = tagObjsJson[0]['Total'];
                        print('${totalAmount_1}');
                        if (totalAmount_1 != null) {
                          setState(() {
                            pricedd = double.parse('${totalAmount_1}');
                            if (item.variant[index].addOnQty > 0) {
                              price = (double.parse(
                                          '${item.variant[index].addOnQty}') *
                                      double.parse('${item.deal_price}')) +
                                  pricedd;
                            }
                          });
                        } else {
                          setState(() {
                            if (item.variant[index].addOnQty > 0) {
                              price = (double.parse(
                                          '${item.variant[index].addOnQty}') *
                                      double.parse('${item.deal_price}')) +
                                  pricedd;
                            }
                          });
                        }
                      }
                    });
                  });
                }
                return value;
              }).catchError((e) {
                return null;
              });
            }

            Future<dynamic> deleteAddOn(isSelected, DatabaseHelper db,
                AddOnList addon, variant_id) async {
              var locale = AppLocalizations.of(context);
              await db.deleteAddOnId('${addon.addon_id}').then((value) {
                print('addon delete $value');
                if (value != null && value > 0) {
                  setState(() {
                    addon.isAdd = false;
                    isSelected = false;
                    db
                        .calculateTotalRestAdonA('${item.variant_id}')
                        .then((value1) {
                      double pricedd = 0.0;
                      if (value != null) {
                        var tagObjsJson = value1 as List;
                        dynamic totalAmount_1 = tagObjsJson[0]['Total'];
                        print('${totalAmount_1}');
                        if (totalAmount_1 != null) {
                          setState(() {
                            pricedd = double.parse('${totalAmount_1}');
                            if (item.variant[index].addOnQty > 0) {
                              price = (double.parse(
                                          '${item.variant[index].addOnQty}') *
                                      double.parse('${item.deal_price}')) +
                                  pricedd;
                            }
                          });
                        } else {
                          setState(() {
                            if (item.variant[index].addOnQty > 0) {
                              price = (double.parse(
                                          '${item.variant[index].addOnQty}') *
                                      double.parse('${item.deal_price}')) +
                                  pricedd;
                            }
                          });
                        }
                      }
                    });
                  });
                } else {
                  setState(() {
                    addon.isAdd = true;
                    isSelected = true;
                    db
                        .calculateTotalRestAdonA('${item.variant_id}')
                        .then((value1) {
                      double pricedd = 0.0;
                      print('${value1}');
                      if (value != null) {
                        var tagObjsJson = value1 as List;
                        dynamic totalAmount_1 = tagObjsJson[0]['Total'];
                        print('${totalAmount_1}');
                        if (totalAmount_1 != null) {
                          setState(() {
                            pricedd = double.parse('${totalAmount_1}');
                            if (item.variant[index].addOnQty > 0) {
                              price = (double.parse(
                                          '${item.variant[index].addOnQty}') *
                                      double.parse('${item.deal_price}')) +
                                  pricedd;
                            }
                          });
                        } else {
                          setState(() {
                            if (item.variant[index].addOnQty > 0) {
                              price = (double.parse(
                                          '${item.variant[index].addOnQty}') *
                                      double.parse('${item.deal_price}')) +
                                  pricedd;
                            }
                          });
                        }
                      }
                    });
                  });
                }
                return value;
              }).catchError((e) {
                return null;
              });
            }

            getAddOnItem(bool isSelected, String qty, String price, int indexs,
                AddOnList addon, variant_id) {
              var locale = AppLocalizations.of(context);
              var aqty = '';
              return Padding(
                padding: EdgeInsets.only(right: fixPadding, left: fixPadding),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        InkWell(
                          onTap: () async {
                            if (item.variant[index].addOnQty > 0) {
                              DatabaseHelper db = DatabaseHelper.instance;
                              db
                                  .getCountAddon('${addon.addon_id}')
                                  .then((value) {
                                print('addon count $value');
                                if (value != null && value > 0) {
                                  deleteAddOn(isSelected, db, addon, variant_id)
                                      .then((value) {
                                    print('addon deleted $value');
                                  }).catchError((e) {
                                    print(e);
                                  });
                                } else {
                                  setAddOnToDatabase(
                                          isSelected, db, addon, variant_id)
                                      .then((value) {
                                    print('addon addd $value');
                                  }).catchError((e) {
                                    print(e);
                                  });
                                }
                              }).catchError((e) {
                                print(e);
                              });
                            } else {
                              Toast.show(
                                  locale.addFirstProductToAddAddon, context,
                                  duration: Toast.LENGTH_SHORT);
                            }
                          },
                          child: Container(
                            width: 26.0,
                            height: 26.0,
                            decoration: BoxDecoration(
                                color: (addon.isAdd) ? kMainColor : kWhiteColor,
                                borderRadius: BorderRadius.circular(13.0),
                                border: Border.all(
                                    width: 1.0,
                                    color: kHintColor.withOpacity(0.7))),
                            child: Icon(Icons.check,
                                color: kWhiteColor, size: 15.0),
                          ),
                        ),
                        widthSpace,
                        Text(
                          '$qty',
                          style: listItemTitleStyle,
                        ),
                      ],
                    ),
                    Text(
                      '${currencySymbol} $price',
                      style: listItemTitleStyle,
                    ),
                  ],
                ),
              );
            }

            return Wrap(
              children: <Widget>[
                Container(
                  // height: height - 100.0,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(16)),
                    color: kWhiteColor,
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(fixPadding),
                        alignment: Alignment.center,
                        child: Container(
                          width: 35.0,
                          height: 3.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25.0),
                            color: kHintColor,
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(fixPadding),
                        child: Text(
                          locale.addNewitem,
                          style: headingStyle,
                        ),
                      ),
                      Container(
                        width: width,
                        margin: EdgeInsets.all(fixPadding),
                        decoration: BoxDecoration(
                          color: kWhiteColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              height: 70.0,
                              width: 70.0,
                              alignment: Alignment.topRight,
                              padding: EdgeInsets.all(fixPadding),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Image.network(
                                imageBaseUrl + item.product_image,
                                fit: BoxFit.fill,
                              ),
                            ),
                            Container(
                              width: width - ((fixPadding * 2) + 70.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: fixPadding * 2,
                                        left: fixPadding,
                                        bottom: fixPadding),
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
                                      '(${item.variant[index].quantity} ${item.variant[index].unit})',
                                      style: listItemSubTitleStyle,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        top: fixPadding,
                                        right: fixPadding,
                                        left: fixPadding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Text(
                                          '${currencySymbol} ${item.deal_price}',
                                          style: priceStyle,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            InkWell(
                                              // onTap: decrementItem,
                                              onTap: () {
                                                if (item.variant[index]
                                                        .addOnQty <=
                                                    0) {
                                                  print('in less then zero');
                                                } else {
                                                  setAddOrMinusProdcutQty(
                                                      item,
                                                      context,
                                                      item.product_id,
                                                      item.product_name,
                                                      (item.variant[index]
                                                              .addOnQty -
                                                          1));
                                                }
                                              },
                                              child: Container(
                                                height: 26.0,
                                                width: 26.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          13.0),
                                                  color: (item.variant[index]
                                                              .addOnQty ==
                                                          0)
                                                      ? Colors.grey[300]
                                                      : kMainColor,
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: (item.variant[index]
                                                              .addOnQty ==
                                                          0)
                                                      ? kMainTextColor
                                                      : kWhiteColor,
                                                  size: 15.0,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  right: 8.0, left: 8.0),
                                              child: Text(
                                                  '${item.variant[index].addOnQty}'),
                                            ),
                                            InkWell(
                                              // onTap: incrementItem(),
                                              onTap: () {
                                                setAddOrMinusProdcutQty(
                                                    item,
                                                    context,
                                                    item.product_id,
                                                    item.product_name,
                                                    (item.variant[index]
                                                            .addOnQty +
                                                        1));
                                              },
                                              child: Container(
                                                height: 26.0,
                                                width: 26.0,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          13.0),
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
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      heightSpace,
                      Container(
                        width: width,
                        color: kCardBackgroundColor,
                        padding: EdgeInsets.all(fixPadding),
                        child: Text(
                          locale.options,
                          style: listItemSubTitleStyle,
                        ),
                      ),
                      Container(
                        color: kWhiteColor,
                        child: (item.addons != null && item.addons.length > 0)
                            ? ListView.separated(
                                shrinkWrap: true,
                                itemCount: item.addons.length,
                                itemBuilder: (context, indexd) {
                                  return getAddOnItem(
                                      (item.addons[indexd].isAdd != null &&
                                              item.addons[indexd].isAdd)
                                          ? true
                                          : false,
                                      // addOnlist.contains(AddonList(item.addons[index].addon_id))?true:false,
                                      '${item.addons[indexd].addon_name}',
                                      '${item.addons[indexd].addon_price}',
                                      index,
                                      item.addons[indexd],
                                      item.variant[index].variant_id);
                                },
                                separatorBuilder: (context, ind) {
                                  return heightSpace;
                                },
                              )
                            : Container(),
                      ),
                      // Options End
                      // Add to Cart button row start here
                      Padding(
                        padding: EdgeInsets.all(fixPadding),
                        child: InkWell(
                          onTap: () {
//                            Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: ()));
                          },
                          child: Container(
                            width: width - (fixPadding * 2),
                            padding: EdgeInsets.all(fixPadding),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              color: kMainColor,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      '$initialItemCount ITEM',
                                      style: TextStyle(
                                        color: kMainColor,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                    SizedBox(height: 3.0),
                                    Text(
                                      '${currencySymbol} $price',
                                      style: whiteSubHeadingStyle,
                                    ),
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    if (item.variant[index].addOnQty > 0) {
                                      Navigator.of(context).pop();
                                      Navigator.pushNamed(
                                          context, PageRoutes.restviewCart);
                                    } else {
                                      Toast.show(
                                          locale.noValueInTheCart, context,
                                          duration: Toast.LENGTH_SHORT);
                                    }
                                  },
                                  child: Text(
                                    locale.goToCart,
                                    style: wbuttonWhiteTextStyle,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Add to Cart button row end here
                    ],
                  ),
                ),
              ],
            );
          },
        );
      });
}
