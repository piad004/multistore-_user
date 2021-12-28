import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:horizontal_calendar_widget/date_helper.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/bottom_bar.dart';
import 'package:user/HomeOrderAccount/Account/UI/ListItems/saved_addresses_page.dart';
import 'package:user/HomeOrderAccount/home_order_account.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Pages/payment_method.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/address.dart';
import 'package:user/bean/cartdetails.dart';
import 'package:user/bean/cartitem.dart';
import 'package:user/bean/orderarray.dart';
import 'package:user/bean/paymentstatus.dart';
import 'package:user/databasehelper/dbhelper.dart';

class ViewCart extends StatefulWidget {
  @override
  _ViewCartState createState() => _ViewCartState();
}

class _ViewCartState extends State<ViewCart> {
  String storeName = '';

  List<CartItem> cartListI = [];

  var totalAmount = 0.0;
  dynamic deliveryCharge = 0.0;

  var showDialogBox = false;

  DateTime firstDate;
  DateTime lastDate;
  List<DateTime> dateList = [];
  List<dynamic> radioList = [];
  String dateTimeSt = '';
  String currency = '';
  bool isCartFetch = false;
  bool isEnteredFirst = false;
  ShowAddressNew addressDelivery;
  bool isFetchingTime = false;
  int idd = 0;
  int idd1 = 0;

  void getStoreName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storename = prefs.getString('store_name');
    setState(() {
      storeName = storename;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  // void prepareData(firstDate) {
  //   lastDate = toDateMonthYear(firstDate.add(Duration(days: 9)));
  //   dateList = getDateList(firstDate, lastDate);
  // }

  void prepareData(firstDate) {

    // lastDate = toDateMonthYear(firstDate.add(Duration(days: 9)));
    lastDate = DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(firstDate.add(Duration(days: 9))));
    dateList.add(firstDate);
    for(int i=0;i<9;i++){
      dateList.add(DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(firstDate.add(Duration(days: i+1)))));
    }
    // dateList = getDateList(firstDate, lastDate);
  }

  void dispose() {
    super.dispose();
  }

  void getCartItem() async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.queryAllRows().then((value) {
      List<CartItem> tagObjs =
          value.map((tagJson) => CartItem.fromJson(tagJson)).toList();
      if (tagObjs.length <= 0) {
        setState(() {
          totalAmount = 0.0;
          deliveryCharge = 0.0;
        });
      }
      setState(() {
        isCartFetch = false;
        cartListI.clear();
        cartListI = tagObjs;
      });
    });
  }

  void getCatC() async {
    DatabaseHelper db = DatabaseHelper.instance;
    db.calculateTotal().then((value) {
      var tagObjsJson = value as List;
      setState(() {
        if (value != null) {
          dynamic totalAmount_1 = tagObjsJson[0]['Total'];
          if (totalAmount_1 == null) {
            totalAmount = 0.0;
          } else {
            totalAmount = totalAmount_1 + deliveryCharge;
          }
        } else {
          totalAmount = 0.0;
        }
      });
    });
  }

  void getAddress(BuildContext context, AppLocalizations locale) async {
    // var locale = AppLocalizations.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isCartFetch = true;
      currency = prefs.getString('curency');
    });
    int userId = prefs.getInt('user_id');
    String vendorId = prefs.getString('vendor_id');
    var url = address_selection;
    http.post(url, body: {
      'user_id': '${userId}',
      'vendor_id': '${vendorId}'
    }).then((value) {
      if (value.statusCode == 200) {
        var jsonData = json.decode(value.body);
        if (jsonData['status'] == "1" &&
            jsonData['data'] != null &&
            jsonData['data'] != 'null') {
          AddressSelected addressWelcome = AddressSelected.fromJson(jsonData);
          if (addressWelcome.data != null) {
            setState(() {
              isCartFetch = false;
              addressDelivery = addressWelcome.data;
              deliveryCharge =
                  double.parse('${addressDelivery.delivery_charge}');
              getCatC();
            });
          }else{
            isCartFetch = false;
            addressDelivery = null;
            deliveryCharge = 0.0;
            getCatC();
          }
        } else {
          setState(() {
            isCartFetch = false;
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
          addressDelivery = null;
          deliveryCharge = 0.0;
          getCatC();
        });
        Toast.show(locale.addressNotFound, context, duration: Toast.LENGTH_SHORT);
      }
    }).catchError((e) {
      setState(() {
        isCartFetch = false;
        addressDelivery = null;
        deliveryCharge = 0.0;
        getCatC();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    final double itemWidth = size.width / 2;
    if(!isEnteredFirst){
      setState(() {
        isEnteredFirst = true;
      });
      getAddress(context,locale);
      // firstDate = toDateMonthYear(DateTime.now());
      // prepareData(firstDate);
      // dateTimeSt =
      // '${firstDate.year}-${(firstDate.month.toString().length == 1) ? '0' + firstDate.month.toString() : firstDate.month}-${firstDate.day}';
      // lastDate = toDateMonthYear(firstDate.add(Duration(days: 9)));
      print('${DateFormat('dd/MM/yyyy').format(DateTime.now())}');
      firstDate = DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));
      prepareData(firstDate);
      dateTimeSt =
      '${firstDate.year}-${(firstDate.month.toString().length == 1) ? '0' + firstDate.month.toString() : firstDate.month}-${firstDate.day}';
      // lastDate = toDateMonthYear(firstDate.add(Duration(days: 9)));
      lastDate = DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(firstDate.add(Duration(days: 9))));
      getStoreName();
      getCartItem();
      getCatC();
      dynamic date =
          '${firstDate.day}-${(firstDate.month.toString().length == 1) ? '0' + firstDate.month.toString() : firstDate.month}-${firstDate.year}';
      hitDateCounter(date);
    }
    return Scaffold(
      appBar: AppBar(
        title:
            Text(locale.confirmOrderText, style: Theme.of(context).textTheme.bodyText1),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
            child: RaisedButton(
              onPressed: () {
                if (!showDialogBox) {
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
          )
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
                                      currency,
                                      '${cartListI[index].product_name}',
                                      (cartListI[index].price /
                                          cartListI[index].add_qnty),
                                      cartListI[index].add_qnty,
                                      cartListI[index].qnty,
                                      cartListI[index].unit,
                                      () => setState(() {
                                        var price_d = cartListI[index].price /
                                            cartListI[index].add_qnty;
                                        cartListI[index].add_qnty--;
                                        cartListI[index].price = (price_d *
                                            cartListI[index].add_qnty);
                                        addOrMinusProduct(
                                            cartListI[index].product_name,
                                            cartListI[index].unit,
                                            cartListI[index].price,
                                            cartListI[index].qnty,
                                            cartListI[index].add_qnty,
                                            cartListI[index].product_img,
                                            cartListI[index].varient_id,
                                            index,
                                            price_d);
                                      }),
                                      () => setState(() {
                                        var price_d = cartListI[index].price /
                                            cartListI[index].add_qnty;
                                        cartListI[index].add_qnty++;
                                        cartListI[index].price = (price_d *
                                            cartListI[index].add_qnty);
                                        addOrMinusProduct(
                                            cartListI[index].product_name,
                                            cartListI[index].unit,
                                            cartListI[index].price,
                                            cartListI[index].qnty,
                                            cartListI[index].add_qnty,
                                            cartListI[index].product_img,
                                            cartListI[index].varient_id,
                                            index,
                                            price_d);
                                      }),
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
                          Container(
                            padding: EdgeInsets.all(10.0),
                            color: kCardBackgroundColor,
                            child: Text(locale.dateSlotText,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Color(0xff616161),
                                        letterSpacing: 0.67)),
                          ),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 6.7,
                          ),
                          Container(
                            height: 35,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(right: 5, left: 5),
                            child: ListView.builder(
                                itemCount: dateList.length,
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  var dateCount1 =
                                      '${dateList[index].day.toString()}/${(dateList[index].month.toString().length == 1) ? '0' + dateList[index].month.toString() : dateList[index].month}/${dateList[index].year}';
                                  DateFormat formatter =
                                      DateFormat('dd MMM yyyy');
                                  var dateCount =
                                      formatter.format(dateList[index]);
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        idd = index;
                                        dateTimeSt =
                                            '${dateList[index].year}-${(dateList[index].month.toString().length == 1) ? '0' + dateList[index].month.toString() : dateList[index].month}-${dateList[index].day}';
                                        dynamic date =
                                            '${dateList[index].day}-${(dateList[index].month.toString().length == 1) ? '0' + dateList[index].month.toString() : dateList[index].month}-${dateList[index].year}';

                                        hitDateCounter(date);
                                        print('${dateTimeSt}');
                                      });
                                    },
                                    child: Container(
                                      padding:
                                          EdgeInsets.only(right: 10, left: 10),
                                      margin:
                                          EdgeInsets.only(right: 5, left: 5),
                                      height: 30,
                                      // width:
                                      //     MediaQuery.of(context).size.width / 3,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: (idd == index)
                                              ? kMainColor
                                              : kWhiteColor,
                                          shape: BoxShape.rectangle,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                              color: (idd == index)
                                                  ? kMainColor
                                                  : kMainColor)),
                                      child: Text(
                                        '${dateCount}',
                                        style: TextStyle(
                                            color: (idd == index)
                                                ? kWhiteColor
                                                : kMainTextColor,
                                            fontSize: 14),
                                      ),
                                    ),
                                  );
                                }),
                          ),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 6.7,
                          ),
                          Container(
                            padding: EdgeInsets.all(10.0),
                            color: kCardBackgroundColor,
                            child: Text(locale.timeSlotText,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                        color: Color(0xff616161),
                                        letterSpacing: 0.67)),
                          ),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 6.7,
                          ),
                          (!isFetchingTime && radioList.length > 0)
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.only(right: 5, left: 5),
                                  child: GridView.builder(
                                    itemCount: radioList.length,
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 3,
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                      childAspectRatio:
                                          (itemWidth / itemHeight),
                                    ),
                                    controller: ScrollController(
                                        keepScrollOffset: false),
                                    shrinkWrap: true,
                                    scrollDirection: Axis.vertical,
                                    itemBuilder: (context, index) {
                                      return GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            idd1 = index;
                                            print('${radioList[idd1]}');
                                          });
                                        },
                                        child: SizedBox(
                                          height: 100,
                                          child: Container(
                                            margin: EdgeInsets.only(
                                                right: 5,
                                                left: 5,
                                                top: 5,
                                                bottom: 5),
                                            height: 30,
                                            width: 100,
                                            alignment: Alignment.center,
                                            decoration: BoxDecoration(
                                                color: (idd1 == index)
                                                    ? kMainColor
                                                    : kWhiteColor,
                                                shape: BoxShape.rectangle,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                    color: (idd1 == index)
                                                        ? kMainColor
                                                        : kMainColor)),
                                            child: Text(
                                              '${radioList[index].toString()}',
                                              style: TextStyle(
                                                  color: (idd1 == index)
                                                      ? kWhiteColor
                                                      : kMainTextColor,
                                                  fontSize: 12),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  alignment: Alignment.center,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      isFetchingTime
                                          ? CircularProgressIndicator()
                                          : Container(
                                              width: 0.5,
                                            ),
                                      isFetchingTime
                                          ? SizedBox(
                                              width: 10,
                                            )
                                          : Container(
                                              width: 0.5,
                                            ),
                                      Expanded(
                                        child: Text(
                                          (isFetchingTime)
                                              ? locale.fetchingTimeSlotText
                                              : locale.noTimeSlotText,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w600,
                                              color: kMainTextColor),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
                                    '$currency ${double.parse(double.parse('$deliveryCharge').toStringAsFixed(2))}',
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
                                    '$currency ${double.parse(double.parse('$totalAmount').toStringAsFixed(2))}',
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
                                      Spacer(),
                                      GestureDetector(
                                        onTap: () async {
                                          SharedPreferences prefs =
                                              await SharedPreferences
                                                  .getInstance();
                                          String vendorId =
                                              prefs.getString('vendor_id');
                                          Navigator.of(context).push(
                                              MaterialPageRoute(
                                                  builder: (context) {
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
                                          ? '${addressDelivery.address != null ? '${addressDelivery.address})' : ''} \n ${(addressDelivery.delivery_charge != null) ? addressDelivery.delivery_charge : ''}'
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
                                  "${double.parse(double.parse('$totalAmount').toStringAsFixed(2))}",
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

  void createCart(BuildContext context, AppLocalizations locale) async {
    if (cartListI != null && cartListI.length > 0) {
      if (radioList != null && radioList.length > 0) {
        if (totalAmount != null &&
            totalAmount > 0.0 &&
            addressDelivery != null) {
          var url = addToCart;
          SharedPreferences pref = await SharedPreferences.getInstance();
          int userId = pref.getInt('user_id');
          String vendorId = pref.getString('vendor_id');
          String ui_type = pref.getString("ui_type");
          List<OrderArrayGrocery> orderArray = [];
          for (CartItem item in cartListI) {
            orderArray.add(OrderArrayGrocery(int.parse('${item.add_qnty}'),
                int.parse('${item.varient_id}')));
          }
          http.post(url, body: {
            'user_id': userId.toString(),
            'vendor_id': vendorId,
            'order_array': orderArray.toString(),
            'delivery_date': dateTimeSt,
            'time_slot': '${radioList[idd1]}',
            'ui_type': ui_type
          }).then((value) {
            print(value.body);
            if (value != null && value.statusCode == 200) {
              var jsonData = jsonDecode(value.body);
              if (jsonData['status'] == "1") {
                Toast.show(jsonData['message'], context,
                    duration: Toast.LENGTH_SHORT);
                CartDetail details = CartDetail.fromJson(jsonData['data']);
                getVendorPayment(vendorId, details, orderArray.toString());
              } else {
                Toast.show(jsonData['message'], context,
                    duration: Toast.LENGTH_SHORT);
                setState(() {
                  showDialogBox = false;
                });
              }
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
            Toast.show(locale.noValueInTheCart, context,
                duration: Toast.LENGTH_SHORT);
          } else {
            Toast.show(
                locale.noAddressFound,
                context,
                duration: Toast.LENGTH_SHORT);
          }
        }
      } else {
        setState(() {
          showDialogBox = false;
        });
        Toast.show(locale.plsSelectDeliveryTimeText, context,
            duration: Toast.LENGTH_SHORT);
      }
    } else {
      setState(() {
        showDialogBox = false;
      });
      Toast.show(locale.noValueCartText, context,
          duration: Toast.LENGTH_SHORT);
    }
  }

  void getVendorPayment(String vendorId, CartDetail details, String orderArray) async {
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
            return PaymentPage(
                vendorId,
                details.order_id,
                details.cart_id,
                double.parse(details.total_price.toString()),
                tagObjs,
                orderArray,
                addressDelivery);
          }));
        }
      }
    }).catchError((e) {
      print(e);
    });
  }

  void addOrMinusProduct(product_name, unit, price, quantity, itemCount,
      varient_image, varient_id, index, price_d) async {
    DatabaseHelper db = DatabaseHelper.instance;
    Future<int> existing = db.getcount(int.parse(varient_id));
    existing.then((value) {
      var vae = {
        DatabaseHelper.productName: product_name,
        DatabaseHelper.price: (price_d * itemCount),
        DatabaseHelper.unit: unit,
        DatabaseHelper.quantitiy: quantity,
        DatabaseHelper.addQnty: itemCount,
        DatabaseHelper.productImage: varient_image,
        DatabaseHelper.varientId: int.parse(varient_id)
      };
      if (value == 0) {
        db.insert(vae);
      } else {
        if (itemCount == 0) {
          db.delete(int.parse(varient_id));
        } else {
          db.updateData(vae, int.parse(varient_id));
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
    currency,
    String title,
    dynamic price,
    int itemCount,
    int qnty,
    dynamic unit,
    Function onPressedMinus,
    Function onPressedPlus,
  ) {
    String selected;
    return Column(
      children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(left: 7.0, top: 13.3),
            child: ListTile(
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle2
                            .copyWith(color: kMainTextColor),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      '${currency} ${price}',
                      style: Theme.of(context)
                          .textTheme
                          .subtitle2
                          .copyWith(color: kMainTextColor),
                    ),
                  ],
                ),
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
                      // Spacer(),
                    ]),
              ),
            ))
      ],
    );
  }

  void hitDateCounter(date) async {
    setState(() {
      isFetchingTime = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String vendorId = pref.getString('vendor_id');
    var url = timeSlots;
    http.post(url,
        body: {'vendor_id': vendorId, 'selected_date': '$date'}).then((value) {
      if (value != null && value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var rdlist = jsonData['data'] as List;
          print('list $rdlist');
          setState(() {
            radioList.clear();
            radioList = rdlist;
          });
        } else {
          setState(() {
            radioList = [];
          });
          Toast.show(jsonData['message'], context,
              duration: Toast.LENGTH_SHORT);
        }
      } else {
        setState(() {
          radioList = [];
          // radioList = rdlist;
        });
      }
      setState(() {
        isFetchingTime = false;
      });
    }).catchError((e) {
      setState(() {
        isFetchingTime = false;
      });
      print(e);
    });
  }

  void clearCart() async {
    setState(() {
      isCartFetch = true;
    });
    DatabaseHelper db = DatabaseHelper.instance;
    db.deleteAll().then((value) {
      getCartItem();
    });
  }
}
