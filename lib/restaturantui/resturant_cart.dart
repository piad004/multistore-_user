import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/bottom_bar.dart';
import 'package:user/HomeOrderAccount/Account/UI/ListItems/saved_addresses_page.dart';
import 'package:user/HomeOrderAccount/home_order_account.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/address.dart';
import 'package:user/bean/cartdetails.dart';
import 'package:user/bean/cartitem.dart';
import 'package:user/bean/orderarray.dart';
import 'package:user/bean/paymentstatus.dart';
import 'package:user/bean/resturantbean/restaurantcartitem.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/restaturantui/pages/payment_restaurant_page.dart';

class RestuarantViewCart extends StatefulWidget {
  @override
  _RestuarantViewCartState createState() => _RestuarantViewCartState();
}

class _RestuarantViewCartState extends State<RestuarantViewCart> {
  // StreamController<String> streamController = StreamController.broadcast();

  String storeName = '';
  String vendorCatId = '';
  String uiType = '';
  dynamic vendorId = '';
  bool isEnteredFirst = false;
  List<RestaurantCartItem> cartListI = [];

  var totalAmount = 0.0;
  dynamic deliveryCharge = 0.0;

  var showDialogBox = false;

  bool forceRender = false;
  String currency = '';
  bool isCartFetch = false;
  // List<ShowAddress> showAddressList = [];
  ShowAddressNew addressDelivery;
  AddressSelected addressSelected;

  void getStoreName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storename = prefs.getString('store_resturant_name');
    String vendor_cat_id = prefs.getString('vendor_cat_id');
    String ui_type = prefs.getString('ui_type');
    dynamic vendor_id = prefs.getString('res_vendor_id');
    setState(() {
      currency = prefs.getString('curency');
      if (storename != null && storename.length > 0) {
        storeName = storename;
      }
      if (vendorCatId != null && vendorCatId.length > 0) {
        vendorCatId = vendor_cat_id;
      }
      if (uiType != null && uiType.length > 0) {
        uiType = ui_type;
      }
      if (vendor_id != null && vendor_id.length > 0) {
        vendorId = vendor_id;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // streamController.stream.listen((event) {
    //   print('${event}');
    // });

  }

  void dispose() {
    // streamController.close();
    super.dispose();
  }

  void getCartItem() async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.getResturantOrderList().then((value) {
      List<RestaurantCartItem> tagObjs =
          value.map((tagJson) => RestaurantCartItem.fromJson(tagJson)).toList();
      setState(() {
        cartListI = List.from(tagObjs);
      });
      print('cart value :- ${cartListI.toString()}');
      for (int i = 0; i < cartListI.length; i++) {
        print('${cartListI[i].varient_id}');
        db
            .getAddOnListWithPrice(int.parse('${cartListI[i].varient_id}'))
            .then((values) {
          print('${values}');
          List<AddonCartItem> tagObjsd =
              values.map((tagJson) => AddonCartItem.fromJson(tagJson)).toList();
          if (tagObjsd != null) {
            setState(() {
              cartListI[i].addon = tagObjsd;
            });
          }
        });
      }
      setState(() {
        isCartFetch = false;
      });
      getAddress(context,AppLocalizations.of(context));
    });
  }

  void getCatC() async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.calculateTotalRest().then((value) {
      db.calculateTotalRestAdon().then((valued) {
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
                  totalAmount =
                      double.parse('${totalAmount_1}') + deliveryCharge;
                }
              } else {
                totalAmount = double.parse('${totalAmount_1}') +
                    double.parse('${totalAmount_2}') +
                    deliveryCharge;
              }
            } else {
              if (totalAmount_1 == null) {
                totalAmount = 0.0;
              } else {
                totalAmount = double.parse('${totalAmount_1}') + deliveryCharge;
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

  void getAddress(context, AppLocalizations locale) async {
    setState(() {
      isCartFetch = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    String vendorId = prefs.getString('res_vendor_id');
   /* var productsJson="";
    if(cartListI!=null && cartListI.length>0) {
      List<String> productList=[];
      for (int i = 0; i < cartListI.length; i++) {
        productList.add(cartListI[i].product_name);
      }

      productsJson = jsonEncode(
          productList.map((product) => product.toString()).toList());
    }*/
    List<OrderArrayGrocery> orderArray = [];
    for (RestaurantCartItem item in cartListI) {
      orderArray.add(OrderArrayGrocery(int.parse('${item.add_qnty}'),
          int.parse('${item.varient_id}')));
    }

    var url = address_selection;
    http.post(url, body: {
      'user_id': '${userId}',
      'vendor_id': '${vendorId}',
      'product_name_list': '${orderArray.toString()}'
    }).then((value) {
      var body = value.body;
      print('${value.statusCode} ${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1" && jsonData['data']!=null && jsonData['data']!='null') {
          AddressSelected addressWelcome = AddressSelected.fromJson(jsonData);
          if(addressWelcome.data!=null){
            setState(() {
              isCartFetch = false;
              addressSelected = addressWelcome;
              addressDelivery = addressWelcome.data;
              deliveryCharge = double.parse('${addressDelivery.delivery_charge}');
              getCatC();
            });
          }else{
            isCartFetch = false;
            addressSelected = null;
            addressDelivery = null;
            deliveryCharge = 0.0;
            getCatC();
          }

        } else {
          setState(() {
            isCartFetch = false;
            addressSelected = null;
            addressDelivery = null;
            deliveryCharge = 0.0;
            getCatC();
          });
          Toast.show(locale.addressNotFound, context,
              duration: Toast.LENGTH_SHORT);
        }
      } else {
        setState(() {
          isCartFetch = false;
          addressSelected = null;
          addressDelivery = null;
          deliveryCharge = 0.0;
          getCatC();
        });
        Toast.show(locale.noAddressFound, context, duration: Toast.LENGTH_SHORT);
      }
    }).catchError((e) {
      setState(() {
        isCartFetch = false;
        addressSelected = null;
        addressDelivery = null;
        deliveryCharge = 0.0;
        getCatC();
      });
      print(e);
    });
  }



  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    if(!isEnteredFirst){
      setState(() {
        isEnteredFirst = true;
      });
      getStoreName();
      getCartItem();
      getCatC();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(locale.checkOutText, style: Theme.of(context).textTheme.bodyText1),
        actions: [
        /*  Padding(
            padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
            child: RaisedButton(
              onPressed: () {
                if(!showDialogBox){
                  clearCart();
                }
              },
              child: Text(
                locale.cartClearText,
                style:
                    TextStyle(color: kWhiteColor, fontWeight: FontWeight.w400),
              ),
              color: kMainColor,
              highlightColor: kMainColor,
              focusColor: kMainColor,
              splashColor: kMainColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
          )*/
        ],
      ),
      body: (!isCartFetch && cartListI != null && cartListI.length > 0)
          ? Stack(
              children: <Widget>[
                Column(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ListView(
                        shrinkWrap: true,
                        primary: true,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(20.0),
                            color: kCardBackgroundColor,
                            child: Text(storeName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Color(0xff616161),
                                        letterSpacing: 0.67)),
                          ),
                          (cartListI != null && cartListI.length > 0)
                              ? ListView.separated(
                                  primary: false,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    return cartOrderItemListTile(
                                      context,
                                      '${cartListI[index].product_name}',
                                      (double.parse(
                                              '${cartListI[index].price}') /
                                          int.parse(
                                              '${cartListI[index].add_qnty}')),
                                      int.parse('${cartListI[index].add_qnty}'),
                                      cartListI[index].qnty,
                                      cartListI[index].unit,
                                      () => setState(() {
                                        int addQ = int.parse(
                                            '${cartListI[index].add_qnty}');
                                        var price_d = double.parse(
                                                '${cartListI[index].price}') /
                                            addQ;
                                        addQ--;
                                        cartListI[index].price =
                                            (price_d * addQ);
                                        cartListI[index].add_qnty = addQ;
                                        addOrMinusProduct(
                                            cartListI[index].product_name,
                                            cartListI[index].unit,
                                            cartListI[index].price,
                                            cartListI[index].qnty,
                                            cartListI[index].add_qnty,
                                            cartListI[index].varient_id,
                                            index,
                                            price_d);
                                      }),
                                      () => setState(() {
                                        int addQ = int.parse(
                                            '${cartListI[index].add_qnty}');
                                        var price_d = double.parse(
                                                '${cartListI[index].price}') /
                                            addQ;
                                        addQ++;
                                        cartListI[index].price =
                                            (price_d * addQ);
                                        cartListI[index].add_qnty = addQ;
                                        addOrMinusProduct(
                                            cartListI[index].product_name,
                                            cartListI[index].unit,
                                            cartListI[index].price,
                                            cartListI[index].qnty,
                                            cartListI[index].add_qnty,
                                            cartListI[index].varient_id,
                                            index,
                                            price_d);
                                      }),
                                      cartListI[index].addon,
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 1.0,
                                    );
                                  },
                                  itemCount: cartListI.length)
                              : Container(),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 6.7,
                          ),
                          // Padding(
                          //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          //   child: EntryField(
                          //     hint: 'Any instruction? E.g Carry package carefully',
                          //     image: 'images/custom/ic_instruction.png',
                          //     border: InputBorder.none,
                          //   ),
                          // ),
                          // Divider(
                          //   color: kCardBackgroundColor,
                          //   thickness: 6.7,
                          // ),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 6.7,
                          ),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 20.0),
                            child: Text(locale.paymentInfoText,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(color: kDisabledColor)),
                            color: Colors.white,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    locale.subTotalText,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Text(
                                    '$currency ${double.parse(double.parse('$totalAmount').toStringAsFixed(2))  - double.parse(double.parse('$deliveryCharge').toStringAsFixed(2))}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ]),
                          ),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 1.0,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    locale.serviceFeeText,
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                  Text(
                                    '$currency ${deliveryCharge.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ]),
                          ),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 1.0,
                          ),
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 20.0),
                            child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text(
                                    locale.amountPayText,
                                    style: Theme.of(context)
                                        .textTheme
                                        .caption
                                        .copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    '$currency ${totalAmount.toStringAsFixed(2)}',
                                    style: Theme.of(context).textTheme.caption,
                                  ),
                                ]),
                          ),
                          Container(
                            height: 15.0,
                            color: kCardBackgroundColor,
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 13.0,
                                  bottom: 13.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: <Widget>[
                                  Row(
                                    children: <Widget>[
                                      Icon(
                                        Icons.location_on,
                                        color: Color(0xffc4c8c1),
                                        size: 13.3,
                                      ),
                                      SizedBox(
                                        width: 11.0,
                                      ),
                                      Text(locale.deliveringToText,
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  color: kDisabledColor,
                                                  fontWeight: FontWeight.bold)),
//                            Text(' HOME',
//                                style: Theme
//                                    .of(context)
//                                    .textTheme
//                                    .caption
//                                    .copyWith(
//                                    color: kMainColor,
//                                    fontWeight: FontWeight.bold)),
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async{
                                          SharedPreferences prefs = await SharedPreferences.getInstance();
                                          String vendorId = prefs.getString('res_vendor_id');
                                          Navigator.of(context)
                                              .push(MaterialPageRoute(builder: (context) {
                                            return SavedAddressesPage(vendorId);
                                          })).then((value) {
                                            getAddress(context,locale);
                                          });
                                        },
                                        child: Text(locale.changeText,
                                            style: Theme.of(context)
                                                .textTheme
                                                .caption
                                                .copyWith(
                                                    color: kMainColor,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 13.0,
                                  ),
                                  Text(
                                      addressDelivery != null
                                          //? '${addressDelivery.address != null ? '${addressDelivery.address})' : ''} \n ${(addressDelivery.delivery_charge != null) ? addressDelivery.delivery_charge : ''}'
                                          ? '${addressDelivery.address != null ? '${addressDelivery.address}' : ''}'
                                          : '',
                                      style: Theme.of(context)
                                          .textTheme
                                          .caption
                                          .copyWith(
                                          fontSize: 11.7,
                                          color: Color(0xffb7b7b7)))
                                ],
                              ),
                            ),
                          ),
                          BottomBar(
                              text: "${locale.payText} $currency "
                                  "$totalAmount",
                              onTap: () {
                                setState(() {
                                  showDialogBox = true;
                                });
                                createCart(context,locale);
                              }),
                        ],
                      ),
                    ),
                  ],
                ),
                Positioned.fill(
                    child: Visibility(
                      visible: showDialogBox,
                      child: GestureDetector(
                        onTap: () {},
                        behavior: HitTestBehavior.opaque,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height - 100,
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ),
                    )),
              ],
            )
          : Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height - 64,
              alignment: Alignment.center,
              child: isCartFetch
                  ? CircularProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                            padding: EdgeInsets.all(10),
                            child: Text(
                              '${locale.noValueCartText}\n${locale.clickShopNowText}',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),
                            )),
                        RaisedButton(
                          onPressed: () {
                            // clearCart();
                            // Navigator.pushAndRemoveUntil(context,
                            //     MaterialPageRoute(builder: (context) {
                            //   return HomeOrderAccount();
                            // }), (Route<dynamic> route) => false);
                            Navigator.of(context).pushNamedAndRemoveUntil(PageRoutes.homeOrderAccountPage, (Route<dynamic> route) => false);
                          },
                          child: Text(
                            locale.shopNowText,
                            style: TextStyle(
                                color: kWhiteColor,
                                fontWeight: FontWeight.w400),
                          ),
                          color: kMainColor,
                          highlightColor: kMainColor,
                          focusColor: kMainColor,
                          splashColor: kMainColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        )
                      ],
                    ),
            ),
    );
  }

  void deleteCart() async {
    var url= deleteCartUrl;
    http.get(url).then((value) {
      print("delete cart::::"+ value.body);
    }).catchError((e) {
      print("delete cart error :==: $e");
      setState(() {
        showDialogBox = false;
      });
    });
  }

  void createCart(BuildContext context, AppLocalizations locale) async {
    if (cartListI != null && cartListI.length > 0) {
      if (totalAmount != null && totalAmount > 0.0 && addressDelivery != null) {
        var url = returant_order;
        SharedPreferences pref = await SharedPreferences.getInstance();
        int userId = pref.getInt('user_id');
        String vendorId = pref.getString('res_vendor_id');
        String ui_type = pref.getString("ui_type");
        List<OrderArray> orderArray = [];
        List<OrderAdonArray> orderAddonArray = [];
        for (RestaurantCartItem item in cartListI) {
          orderArray.add(OrderArray(
              int.parse('${item.add_qnty}'), int.parse('${item.varient_id}')));
          if (item.addon.length > 0) {
            for (AddonCartItem addItem in item.addon) {
              orderAddonArray
                  .add(OrderAdonArray(int.parse('${addItem.addonid}')));
            }
          }
        }

        print(
            '$userId $vendorId ${orderArray.toString()} ${orderAddonArray.toString()}');
        http.post(url, body: {
          'user_id': '${userId}',
          'vendor_id': vendorId,
          'order_array': orderArray.toString(),
          'order_array1':
              (orderAddonArray.length > 0) ? orderAddonArray.toString() : '',
          'ui_type': ui_type,
          'delivery_charge': deliveryCharge.toString()
        }).then((value) {
          var body = value.body;
          print('${value.statusCode} ${value.body}');
          if (value != null && value.statusCode == 200) {
            var jsonData = jsonDecode(value.body);
            if (jsonData['status'] == "1") {
              Toast.show(jsonData['message'], context,
                  duration: Toast.LENGTH_SHORT);
              CartDetail details = CartDetail.fromJson(jsonData['data']);
              getVendorPayment(vendorId, details);
            } else {
              Toast.show(jsonData['message'], context,
                  duration: Toast.LENGTH_SHORT);
              setState(() {
                showDialogBox = false;
              });
            }
//        print('resp value - ${value.body}');

          } else {
            setState(() {
              showDialogBox = false;
            });
          }
        }).catchError((_) {
          setState(() {
            showDialogBox = false;
          });
        });
      } else {
        setState(() {
          showDialogBox = false;
        });
        if (addressDelivery != null) {
          Toast.show(locale.noValueCartText, context,
              duration: Toast.LENGTH_SHORT);
        } else {
          Toast.show(
              //locale.noAddressFound,
              'Address not found, please add/change address!!',
              context,
              duration: Toast.LENGTH_LONG);
        }
      }
    } else {
      setState(() {
        showDialogBox = false;
      });
      Toast.show(locale.noValueCartText, context,
          duration: Toast.LENGTH_SHORT);
    }
  }

  void getVendorPayment(String vendorId, CartDetail details) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
    });
    var url = paymentvia;
    var client = http.Client();
    client.get(url).then((value) {
      print('${value.statusCode} - ${value.body}');
      if (value.statusCode == 200) {
        setState(() {
          showDialogBox = false;
        });
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body);
          PaymentVia tagObjs = PaymentVia.fromJson(tagObjsJson);

          Navigator.of(context).push(MaterialPageRoute(builder: (context) {
            return PaymentRestPage(vendorId, details.order_id, details.cart_id,
                double.parse(details.total_price.toString()), tagObjs,addressDelivery);
          }));
        }
      }
    }).catchError((e) {
      print(e);
    });
  }

  void addOrMinusProduct(product_name, unit, price, quantity, itemCount,
      varient_id, index, price_d) async {
    DatabaseHelper db = DatabaseHelper.instance;
    Future<int> existing = db.getRestProductcount(int.parse(varient_id));
    existing.then((value) {
      var vae = {
        DatabaseHelper.productId: '1',
        DatabaseHelper.productName: product_name,
        DatabaseHelper.price: (price_d * itemCount),
        DatabaseHelper.unit: unit,
        DatabaseHelper.quantitiy: quantity,
        DatabaseHelper.addQnty: itemCount,
        DatabaseHelper.varientId: int.parse(varient_id)
      };

      print('value we - $value');

      if (value == 0) {
        db.insertRaturantOrder(vae);
      } else {
        if (itemCount == 0) {
          db.deleteResProduct(int.parse(varient_id)).then((value) {
            db.deleteAddOn(int.parse(varient_id));
          });
        } else {
          db.updateRestProductData(vae, int.parse(varient_id));
        }
      }
      getCatC();
      setState(() {
        if (itemCount == 0) {
          getCartItem();
        }
      });
    });
  }

  Widget cartOrderItemListTile(
    BuildContext context,
    String title,
    dynamic price,
    int itemCount,
    dynamic qnty,
    dynamic unit,
    Function onPressedMinus,
    Function onPressedPlus,
    List<AddonCartItem> addon,
  ) {
    String selected;
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 7.0, top: 10.3),
            child: ListTile(
              // contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
              title:Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    title,
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: kMainTextColor),
                  ),
                  // SizedBox(width: 30,),
                  Text(
                    '${currency} ${price}',
                    style: Theme.of(context)
                        .textTheme
                        .subtitle2
                        .copyWith(color: kMainTextColor),
                  ),
                  Container(
                    height: 30.0,
                    //width: 76.7,
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: kMainColor),
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    child: Row(
                      children: <Widget>[
                        InkWell(
                          onTap: onPressedMinus,
                          child: Icon(
                            Icons.remove,
                            color: kMainColor,
                            size: 20.0,
                            //size: 23.3,
                          ),
                        ),
                        SizedBox(width: 8.0),
                        Text('$itemCount',
                            style: Theme.of(context).textTheme.caption),
                        SizedBox(width: 8.0),
                        InkWell(
                          onTap: onPressedPlus,
                          child: Icon(
                            Icons.add,
                            color: kMainColor,
                            size: 20.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 15.0, bottom: 14.2),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        height: 30.0,
                        padding: EdgeInsets.symmetric(horizontal: 18.0),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: kCardBackgroundColor,
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Text(
                          '${qnty} ${unit}',
                          style: Theme.of(context).textTheme.caption,
                        ),
                      ),
                      // Spacer(),

                    ]),
              ),
            )),
        Visibility(
            visible: (addon != null && addon.length > 0),
            child: ListView.builder(
              primary: false,
              shrinkWrap: true,
              itemBuilder: (context, indexd) {
                return Padding(
                  padding: EdgeInsets.only(left: 20, right: 20),
                  child: Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${addon[indexd].addonName} ($currency ${addon[indexd].price})',
                          style: Theme.of(context)
                              .textTheme
                              .subtitle2
                              .copyWith(color: kMainTextColor),
                        ),
                        IconButton(
                            icon: Icon(Icons.close),
                            iconSize: 15,
                            onPressed: () async {
                              deleteAddOn(addon[indexd].addonid);
                            })
                      ],
                    ),
                  ),
                );
              },
              itemCount: addon.length,
            ))
      ],
    );
  }

  void clearCart() async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteAllRestProdcut().then((value) {
      db.deleteAllAddOns().then((values) {
        cartListI.clear();
        getCartItem();
        getCatC();
      });
    });
  }

  void deleteAddOn(addonid) async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteAddOnId(int.parse(addonid)).then((value) {
      getCartItem();
      getCatC();
    });
  }
}
