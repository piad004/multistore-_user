import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
import 'package:user/bean/productlistvarient.dart';
import 'package:user/bean/resturantbean/addonidlist.dart';
import 'package:user/bean/resturantbean/searchcategory.dart';
import 'package:user/bean/searchlist.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/restaturantui/pages/restaurant.dart';
import 'package:user/restaturantui/widigit/column_builder.dart';

class SearchRestaurantStore extends StatefulWidget {
  dynamic currencySymbol;

  SearchRestaurantStore(this.currencySymbol);

  @override
  State<StatefulWidget> createState() {
    return SearchRestaurantStoreState();
  }
}

class SearchRestaurantStoreState extends State<SearchRestaurantStore> {
  var isCartCount = false;
  TextEditingController searchController = TextEditingController();
  var cartCount = 0;
  List<StoresRestaurant> nearStores = [];
  List<SearchCategory> categoryList = [];
  double userLat = 0.0;
  double userLng = 0.0;
  List<SearchProuduct> productVarient = [];
  String searchString = '';

  @override
  void initState() {
    getShareValue();
    super.initState();
    getCartCount();
  }

  getShareValue() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userLat = double.parse('${prefs.getString('lat')}');
      userLng = double.parse('${prefs.getString('lng')}');
    });
  }

  double calculateDistance(lat1, lon1, lat2, lon2){
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 - c((lat2 - lat1) * p)/2 +
        c(lat1 * p) * c(lat2 * p) *
            (1 - c((lon2 - lon1) * p))/2;
    return 12742 * asin(sqrt(a));
  }

  String calculateTime(lat1, lon1, lat2, lon2){
    double kms = calculateDistance(lat1, lon1, lat2, lon2);
    double kms_per_min = 0.5;
    double mins_taken = kms / kms_per_min;
    double min = mins_taken;
    if (min<60) {
      return ""+'${min.toInt()}'+" mins";
    }else {
      double tt = min % 60;
      String minutes = '${tt.toInt()}';
      minutes = minutes.length == 1 ? "0" + minutes : minutes;
      return '${(min.toInt() / 60)}' + " hour " + minutes +"mins";
    }
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
    return WillPopScope(
      onWillPop: () async {
        if (searchController != null && searchController.text.length > 0) {
          setState(() {
            searchController.clear();
            nearStores.clear();
            productVarient.clear();
            categoryList.clear();
          });
          return false;
        } else {
          return true;
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(110.0),
          child: CustomAppBar(
            titleWidget: Text(
              locale.searchProductOrStore,
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
                            Navigator.pushNamed(
                                    context, PageRoutes.restviewCart)
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
                      hintText: 'Search....',
                    ),
                    controller: searchController,
                    cursorColor: kMainColor,
                    autofocus: false,
                    onEditingComplete: () {
                      SystemChannels.textInput.invokeMethod('TextInput.hide');
                      hitSearch(searchString);
                    },
                    onChanged: (value) {
                      searchString = value;
                    },
                  ),
                ),
                preferredSize:
                    Size(MediaQuery.of(context).size.width * 0.85, 52)),
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height - 110,
          child: SingleChildScrollView(
            primary: true,
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Visibility(
                    visible: (nearStores != null && nearStores.length > 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 20.0),
                          child: Text(
                            '${nearStores.length} Store found',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: kHintColor, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: (nearStores != null && nearStores.length > 0)
                              ? ListView.separated(
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemCount: nearStores.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        if ((nearStores[index].online_status ==
                                                "on" ||
                                            nearStores[index].online_status ==
                                                "On" ||
                                            nearStores[index].online_status ==
                                                "ON")) {
                                          hitNavigator(
                                              context,
                                              nearStores[index].vendor_name,
                                              nearStores[index].vendor_id,
                                              nearStores[index].distance,
                                              nearStores[index]);
                                        } else {
                                          Toast.show(
                                              locale.restaurantAreClosedNow,
                                              context,
                                              duration: Toast.LENGTH_SHORT);
                                        }
                                      },
                                      child: Material(
                                          elevation: 2,
                                          shadowColor: white_color,
                                          clipBehavior: Clip.hardEdge,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                color: white_color,
                                                padding: EdgeInsets.only(
                                                    left: 20.0,
                                                    top: 15,
                                                    bottom: 15),
                                                child: Row(
                                                  children: <Widget>[
                                                    Image.network(
                                                      imageBaseUrl +
                                                          nearStores[index]
                                                              .vendor_logo,
                                                      width: 93.3,
                                                      height: 93.3,
                                                    ),
                                                    SizedBox(width: 13.3),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Text(
                                                            nearStores[index]
                                                                .vendor_name,
                                                            style: Theme.of(
                                                                    context)
                                                                .textTheme
                                                                .subtitle2
                                                                .copyWith(
                                                                    color:
                                                                        kMainTextColor,
                                                                    fontSize:
                                                                        18)),
                                                        SizedBox(height: 8.0),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.location_on,
                                                              color: kIconColor,
                                                              size: 15,
                                                            ),
                                                            SizedBox(
                                                                width: 10.0),
                                                            Text(
                                                                '${double.parse('${nearStores[index].distance}').toStringAsFixed(2)} km ',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption
                                                                    .copyWith(
                                                                        color:
                                                                            kLightTextColor,
                                                                        fontSize:
                                                                            13.0)),
                                                            Text('|',
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption
                                                                    .copyWith(
                                                                        color:
                                                                            kMainColor,
                                                                        fontSize:
                                                                            13.0)),
                                                            Text(
                                                                nearStores[
                                                                        index]
                                                                    .vendor_name,
                                                                style: Theme.of(
                                                                        context)
                                                                    .textTheme
                                                                    .caption
                                                                    .copyWith(
                                                                        color:
                                                                            kLightTextColor,
                                                                        fontSize:
                                                                            13.0)),
                                                          ],
                                                        ),
                                                        SizedBox(height: 6),
                                                        Row(
                                                          children: <Widget>[
                                                            Icon(
                                                              Icons.access_time,
                                                              color: kIconColor,
                                                              size: 15,
                                                            ),
                                                            SizedBox(
                                                                width: 10.0),
                                                            Text('${calculateTime(double.parse('${nearStores[index].lat}'), double.parse('${nearStores[index].lng}'), userLat, userLng)}',
                                                                style: Theme.of(context)
                                                                    .textTheme
                                                                    .caption
                                                                    .copyWith(
                                                                    color:
                                                                    kLightTextColor,
                                                                    fontSize: 13.0)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              Positioned(
                                                bottom: 20,
                                                child: Visibility(
                                                  visible: (nearStores[index]
                                                                  .online_status ==
                                                              "off" ||
                                                          nearStores[index]
                                                                  .online_status ==
                                                              "Off" ||
                                                          nearStores[index]
                                                                  .online_status ==
                                                              "OFF")
                                                      ? true
                                                      : false,
                                                  child: Container(
                                                    height: 40,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            10,
                                                    alignment: Alignment.center,
                                                    color: kCardBackgroundColor,
                                                    child: Text(
                                                      locale.storeClosedNow,
                                                      style: TextStyle(
                                                          color: red_color),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 10,
                                    );
                                  })
                              : Container(),
                        )
                      ],
                    )),
                Visibility(
                    visible: (categoryList != null && categoryList.length > 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0, top: 5),
                          child: Text(
                            '${categoryList.length} Category found',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: kHintColor, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              left: 10, right: 10, top: 20, bottom: 30),
                          child: ListView.separated(
                              shrinkWrap: true,
                              primary: false,
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // hitNavigators(
                                    //     context,
                                    //     categoryList[index].vendor_name,
                                    //     categoryList[index].category_name,
                                    //     categoryList[index].category_id,
                                    //     categoryList[index].distance);
                                  },
                                  behavior: HitTestBehavior.opaque,
                                  child: Material(
                                    elevation: 2,
                                    borderRadius: BorderRadius.circular(10),
                                    clipBehavior: Clip.antiAlias,
                                    child: Container(
                                      color: white_color,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      child: Row(
                                        children: [
                                          (categoryList[index].cat_image !=
                                                  null)
                                              ? Image.network(
                                                  imageBaseUrl +
                                                      categoryList[index]
                                                          .cat_image,
                                                  height: 80,
                                                  width: 90,
                                                )
                                              : Image.asset(
                                                  'images/logos/logo_user1.png',
                                                  height: 80,
                                                  width: 90,
                                                ),
                                          SizedBox(
                                            width: 13.5,
                                          ),
                                          Expanded(
                                              child: Text(
                                            categoryList[index].cat_name,
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 18,
                                                color: kMainTextColor),
                                          )),
                                          Align(
                                            alignment: Alignment.centerLeft,
                                            child: Icon(
                                              Icons.keyboard_arrow_right,
                                              size: 30,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              },
                              separatorBuilder: (context, index) {
                                return SizedBox(
                                  height: 5,
                                );
                              },
                              itemCount: categoryList.length),
                        )
                      ],
                    )),
                Visibility(
                    visible:
                        (productVarient != null && productVarient.length > 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 20.0),
                          child: Text(
                            '${productVarient.length} Product found',
                            style: Theme.of(context)
                                .textTheme
                                .headline6
                                .copyWith(color: kHintColor, fontSize: 18),
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: (productVarient != null &&
                                  productVarient.length > 0)
                              ? ListView.separated(
                                  itemCount: productVarient.length,
                                  shrinkWrap: true,
                                  primary: false,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    var item = productVarient[index];
                                    return Container(
                                      color: kWhiteColor,
                                      width: MediaQuery.of(context).size.width,
                                      child: Column(
                                        children: [
                                          Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: kWhiteColor,
                                            child: Padding(
                                              padding: EdgeInsets.all(10.0),
                                              child: Text(
                                                '${item.product_name}',
                                                style: headingStyle,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            color: kWhiteColor,
                                            child: JuiceListSearch(
                                                item, widget.currencySymbol,
                                                () {
                                              getCartCount();
                                            }),
                                          ),
                                          Container(
                                            height: 10.0,
                                            color: kWhiteColor,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) {
                                    return SizedBox(
                                      height: 5,
                                    );
                                  },
                                )
                              : Container(),
                        )
                      ],
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  hitNavigator(BuildContext context, vendor_name, vendor_id, distance,
      StoresRestaurant nearStor) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("res_vendor_id", '${vendor_id}');
    prefs.setString("store_resturant_name", '${vendor_name}');
    NearStores st = NearStores(
        nearStor.vendor_name,
        nearStor.vendor_phone,
        nearStor.vendor_id,
        nearStor.vendor_logo,
        nearStor.vendor_category_id,
        nearStor.distance,
        nearStor.lat,
        nearStor.lng,
        nearStor.delivery_range,
        nearStor.online_status,
        nearStor.vendor_loc,
        nearStor.about);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Restaurant_Sub(st, widget.currencySymbol))).then((value) {
      getCartCount();
    });
  }

  void addOrMinusProduct(product_name, unit, price, quantity, itemCount,
      varient_image, varient_id) async {
//    addMinus = true;
    DatabaseHelper db = DatabaseHelper.instance;
    db.getcount(varient_id).then((value) {
      print('value d - $value');
      var vae = {
        DatabaseHelper.productName: product_name,
        DatabaseHelper.price: (price * itemCount),
        DatabaseHelper.unit: unit,
        DatabaseHelper.quantitiy: quantity,
        DatabaseHelper.addQnty: itemCount,
        DatabaseHelper.productImage: varient_image,
        DatabaseHelper.varientId: varient_id
      };
      if (value == 0) {
        db.insert(vae);
      } else {
        if (itemCount == 0) {
          db.delete(varient_id);
        } else {
          db.updateData(vae, varient_id).then((vay) {
            print('vay - $vay');
          });
        }
      }
      getCartCount();
    }).catchError((e) {
      print(e);
    });
  }

  void hitSearch(String searchString) async {
    var locale = AppLocalizations.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print('${searchString}');
    var client = http.Client();
    var url = resturantsearchingFor;
    client.post(url, body: {
      'prod_name': '${searchString}',
      'lat': '${prefs.getString('lat')}',
      'lng': '${prefs.getString('lng')}',
      // 'lat': '29.00545090',
      // 'lng': '77.02136210',
    }).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        print('Response Body: - ${jsonData.toString()}');
        if (jsonData['status'] == "1") {
          Toast.show(jsonData['message'], context,
              duration: Toast.LENGTH_SHORT);
          var tagObjsJsonStore = jsonData['stores'] as List;
          var tagObjsJsonCategory = jsonData['category'] as List;
//          var tagObjsJsonSub = jsonData['subcat'] as List;
          var tagObjsJsonProd = jsonData['products'] as List;
          print(tagObjsJsonProd.toString());
          List<StoresRestaurant> _tags = tagObjsJsonStore
              .map((tagJson) => StoresRestaurant.fromJson(tagJson))
              .toList();
          List<SearchCategory> _tags2 = tagObjsJsonCategory
              .map((tagJson) => SearchCategory.fromJson(tagJson))
              .toList();
//          List<SubCategoryList> _tags3 = tagObjsJsonSub.map((tagJson) => SubCategoryList.fromJson(tagJson)).toList();
          List<SearchProuduct> _tags4 = tagObjsJsonProd
              .map((tagJson) => SearchProuduct.fromJson(tagJson))
              .toList();
          print('${_tags4.toString()}');
          setState(() {
            nearStores.clear();
            productVarient.clear();
            categoryList.clear();
            nearStores = _tags;
            categoryList = _tags2;
            productVarient = _tags4;
            // setList(productVarient);
          });
        } else {
          Toast.show(locale.storeNotFound, context, duration: Toast.LENGTH_SHORT);
        }
      }
    }).catchError((e) {
      Toast.show(locale.storeNotFound, context, duration: Toast.LENGTH_SHORT);
    });
  }

  void setList(List<ProductVarient> tagObjs) {
    for (int i = 0; i < tagObjs.length; i++) {
      DatabaseHelper db = DatabaseHelper.instance;
      db.getVarientCount(tagObjs[i].data[0].varient_id).then((value) {
        print('print val $value');
        if (value == null) {
          setState(() {
            tagObjs[i].add_qnty = 0;
          });
        } else {
          setState(() {
            tagObjs[i].add_qnty = value;
            isCartCount = true;
          });
        }
      });
    }
  }

// void hitNavigators(context, pageTitle, category_name, category_id, distance) {
//   Navigator.push(
//       context,
//       MaterialPageRoute(
//           builder: (context) =>
//               ItemsPage(pageTitle, category_name, category_id, distance)))
//       .then((value) {
//     getCartCount();
//   });
// }
}

class BottomSheetWidget extends StatefulWidget {
  final String product_name;
  final String category_name;
  final List<VarientList> datas;
  List<VarientList> newdatas = [];

  BottomSheetWidget(this.product_name, this.datas, this.category_name) {
    newdatas.clear();
    newdatas.addAll(datas);
    newdatas.removeAt(0);
  }

  @override
  State<StatefulWidget> createState() {
    return BottomSheetWidgetState(product_name, newdatas);
  }
}

class BottomSheetWidgetState extends State<BottomSheetWidget> {
  final String product_name;
  final List<VarientList> data;

  BottomSheetWidgetState(this.product_name, this.data) {
    setList(data);
  }

  void setList(List<VarientList> tagObjs) {
    for (int i = 0; i < tagObjs.length; i++) {
      DatabaseHelper db = DatabaseHelper.instance;
      db.getVarientCount(tagObjs[i].varient_id).then((value) {
        print('print val $value');
        if (value == null) {
          setState(() {
            tagObjs[i].add_qnty = 0;
          });
        } else {
          setState(() {
            tagObjs[i].add_qnty = value;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return ListView(
      children: <Widget>[
        Container(
          height: 80.7,
          color: kCardBackgroundColor,
          padding: EdgeInsets.all(10.0),
          child: ListTile(
            title: Text(product_name,
                style: Theme.of(context)
                    .textTheme
                    .caption
                    .copyWith(fontSize: 15, fontWeight: FontWeight.w500)),
            subtitle: Text('${widget.category_name}',
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 15)),
          ),
        ),
        ListView.separated(
          shrinkWrap: true,
          primary: true,
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 20,
                    ),
                    Text(
                      '${data[index].quantity} ${data[index].unit}',
                      style: Theme.of(context)
                          .textTheme
                          .caption
                          .copyWith(fontSize: 16.7),
                    )
                  ],
                ),
                data[index].add_qnty == 0
                    ? Container(
                        height: 30.0,
                        child: FlatButton(
                          child: Text(
                            locale.add,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                color: kMainColor, fontWeight: FontWeight.bold),
                          ),
                          textTheme: ButtonTextTheme.accent,
                          onPressed: () {
                            setState(() {
                              if (data[index].stock > data[index].add_qnty) {
                                data[index].add_qnty++;
                                addOrMinusProduct(
                                    product_name,
                                    data[index].unit,
                                    data[index].price,
                                    data[index].quantity,
                                    data[index].add_qnty,
                                    data[index].varient_image,
                                    data[index].varient_id);
                              } else {
                                Toast.show(locale.noMoreStockAvailable, context,
                                    gravity: Toast.BOTTOM);
                              }
                            });
                          },
                        ),
                      )
                    : Container(
                        height: 30.0,
                        padding: EdgeInsets.symmetric(horizontal: 11.0),
                        decoration: BoxDecoration(
                          border: Border.all(color: kMainColor),
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                        child: Row(
                          children: <Widget>[
                            InkWell(
                              onTap: () {
                                setState(() {
                                  data[index].add_qnty--;
                                });
                                addOrMinusProduct(
                                    product_name,
                                    data[index].unit,
                                    data[index].price,
                                    data[index].quantity,
                                    data[index].add_qnty,
                                    data[index].varient_image,
                                    data[index].varient_id);
                              },
                              child: Icon(
                                Icons.remove,
                                color: kMainColor,
                                size: 20.0,
                                //size: 23.3,
                              ),
                            ),
                            SizedBox(width: 8.0),
                            Text(data[index].add_qnty.toString(),
                                style: Theme.of(context).textTheme.caption),
                            SizedBox(width: 8.0),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  if (data[index].stock >
                                      data[index].add_qnty) {
                                    data[index].add_qnty++;
                                    addOrMinusProduct(
                                        product_name,
                                        data[index].unit,
                                        data[index].price,
                                        data[index].quantity,
                                        data[index].add_qnty,
                                        data[index].varient_image,
                                        data[index].varient_id);
                                  } else {
                                    Toast.show(
                                        locale.noMoreStockAvailable, context,
                                        gravity: Toast.BOTTOM);
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
              ],
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              height: 20,
              color: Colors.transparent,
            );
          },
        ),
//        CheckboxGroup(
//          labelStyle:
//              Theme.of(context).textTheme.caption.copyWith(fontSize: 16.7),
//          labels: list,
//        ),
      ],
    );
  }

  void addOrMinusProduct(product_name, unit, price, quantity, itemCount,
      varient_image, varient_id) async {
//    addMinus = true;
    DatabaseHelper db = DatabaseHelper.instance;
    Future<int> existing = db.getcount(varient_id);
    existing.then((value) {
      print('value d - $value');
      var vae = {
        DatabaseHelper.productName: product_name,
        DatabaseHelper.price: (price * itemCount),
        DatabaseHelper.unit: unit,
        DatabaseHelper.quantitiy: quantity,
        DatabaseHelper.addQnty: itemCount,
        DatabaseHelper.productImage: varient_image,
        DatabaseHelper.varientId: varient_id
      };
      if (value == 0) {
        db.insert(vae);
      } else {
        if (itemCount == 0) {
          db.delete(varient_id);
        } else {
          db.updateData(vae, varient_id).then((vay) {
            print('vay - $vay');
//            getCatC();
          });
        }
      }
//      getCartCount();
    });
  }

//  void getCartCount() {
//    DatabaseHelper db = DatabaseHelper.instance;
//    db.queryRowCount().then((value) {
//      setState(() {
//        if (value != null && value > 0) {
//          cartCount = value;
//          isCartCount = true;
//        } else {
//          cartCount = 0;
//          isCartCount = false;
//        }
//      });
//    });
//
//    getCatC();
//  }
//
//  void getCatC() async {
//    DatabaseHelper db = DatabaseHelper.instance;
//    db.calculateTotal().then((value) {
//      var tagObjsJson = value as List;
//      setState(() {
//        if (value != null) {
//          totalAmount = tagObjsJson[0]['Total'];
//        } else {
//          totalAmount = 0.0;
//        }
//      });
//    });
//  }
}

class JuiceListSearch extends StatefulWidget {
  final SearchProuduct item;
  final dynamic currencySymbol;
  final VoidCallback onVerificationDone;

  JuiceListSearch(this.item, this.currencySymbol, this.onVerificationDone);

  @override
  _JuiceListSearchState createState() => _JuiceListSearchState();
}

class _JuiceListSearchState extends State<JuiceListSearch> {
  int currentIndex = -1;

  var fixPadding = 10.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(right: fixPadding, left: fixPadding),
          child: Text(
            '${widget.item.varients.length} items',
            style: listItemSubTitleStyle,
          ),
        ),
        ColumnBuilder(
          itemCount: widget.item.varients.length,
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          itemBuilder: (context, index) {
            final item = widget.item.varients[index];
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
                  // Positioned(
                  //   right: fixPadding,
                  //   child: InkWell(
                  //     onTap: () {
                  //       setFaviouriteResturant(
                  //           item, context, index, widget.item.product_id);
                  //     },
                  //     child: Icon(
                  //       (widget.item.variant[index].isFaviourite == 0)
                  //           ? Icons.bookmark_border
                  //           : Icons.bookmark,
                  //       // Icons.bookmark,
                  //       size: 22.0,
                  //       color: kHintColor,
                  //     ),
                  //   ),
                  // ),
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
                          imageBaseUrl + widget.item.product_image,
                          fit: BoxFit.fill,
                        ),
                      ),
                      Container(
                        width: width - ((fixPadding * 2) + 110.0),
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
                                '${widget.item.product_name}',
                                style: listItemTitleStyle,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                  left: fixPadding, right: fixPadding),
                              child: Text(
                                '${widget.item.description}',
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
                                '(${item.quantity} ${item.unit})',
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
                                    '${widget.currencySymbol} ${item.price}',
                                    style: priceStyle,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      currentIndex = index;
                                      DatabaseHelper db =
                                          DatabaseHelper.instance;
                                      db
                                          .getRestProdQty('${item.variant_id}')
                                          .then((value) {
                                        print('dddd - ${value}');
                                        if (value != null) {
                                          setState(() {
                                            item.addOnQty = value;
                                          });
                                        } else {
                                          if (item.addOnQty > 0) {
                                            setState(() {
                                              item.addOnQty = 0;
                                            });
                                          }
                                        }
                                        db
                                            .getAddOnList('${item.variant_id}')
                                            .then((valued) {
                                          List<AddonList> addOnlist = [];
                                          if (valued != null &&
                                              valued.length > 0) {
                                            addOnlist = valued
                                                .map((e) =>
                                                    AddonList.fromJson(e))
                                                .toList();
                                            for (int i = 0;
                                                i < widget.item.addons.length;
                                                i++) {
                                              int ind = addOnlist.indexOf(AddonList(
                                                  '${widget.item.addons[i].addon_id}'));
                                              if (ind != null && ind >= 0) {
                                                setState(() {
                                                  widget.item.addons[i].isAdd =
                                                      true;
                                                });
                                              }
                                            }
                                          }
                                          print(
                                              'list aaa - ${addOnlist.toString()}');

                                          db
                                              .calculateTotalRestAdonA(
                                                  '${item.variant_id}')
                                              .then((value1) {
                                            double priced = 0.0;
                                            print('${value1}');
                                            if (value != null) {
                                              var tagObjsJson = value1 as List;
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
                                                    height,
                                                    widget.item,
                                                    index,
                                                    addOnlist,
                                                    widget.currencySymbol,
                                                    priced)
                                                .then((value) {
                                              // print('${value}');
                                              widget.onVerificationDone();
                                            });
                                          });

                                          print('list - ${valued}');
                                        });
                                      });
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
                ],
              ),
            );
          },
        ),
      ],
    );
  }

// void setFaviouriteResturant(
//     SearchProuduct item, BuildContext context, index, product_id) async {
//   DatabaseHelper db = DatabaseHelper.instance;
//   var vae = {
//     DatabaseHelper.productId: product_id,
//     DatabaseHelper.varientId: item[index].var
//   };
//   db.insertFaviProduct(vae).then((value) {
//     print('$value');
//     setState(() {
//       widget.item.variants[index].isFaviourite = 1;
//     });
//     Scaffold.of(context).showSnackBar(SnackBar(
//       content: Text('Added to Favourite'),
//     ));
//   });
// }
}

Future productDescriptionModalBottomSheet(context, height, SearchProuduct item,
    getIn, List<AddonList> addOnlist, currencySymbol, double priced) async {
  int initialItemCount = 0;
  double itemPrice = 0.0;
  double price = 0.0;

  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString("res_vendor_id", '${item.vendor_id}');
  prefs.setString("store_resturant_name",
      '${(item.vendor_name != null) ? item.vendor_name : ''}');

  // item.variant[getIn].variant_id

  if (item.varients[getIn].addOnQty > 0) {
    price = (double.parse('${item.varients[getIn].addOnQty}') *
            double.parse('${item.varients[getIn].price}')) +
        priced;
  }
  double width = MediaQuery.of(context).size.width;
  DatabaseHelper db = DatabaseHelper.instance;
  db.getAddOnList('${item.varients[getIn].variant_id}').then((valued) {
    List<AddonList> addOnlist = [];
    if (valued != null && valued.length > 0) {
      addOnlist = valued.map((e) => AddonList.fromJson(e)).toList();
      for (int i = 0; i < item.addons.length; i++) {
        int ind = addOnlist.indexOf(AddonList('${item.addons[i].addon_id}'));
        if (ind != null && ind >= 0) {
          // setState(() {
          //
          // });
          item.addons[i].isAdd = true;
        }
      }
    }
    print('list aaa - ${addOnlist.toString()}');
    // productDescriptionModalBottomSheet(context, MediaQuery.of(context).size.height,item,widget.currencySymbol);
  });

  // db.calculateTotalRestAdonA('${item.varients[getIn].variant_id}').then((value){
  //   print('${value}');
  //   if(value!=null){
  //     var tagObjsJson = value as List;
  //     dynamic totalAmount_1 = tagObjsJson[0]['Total'];
  //     if(totalAmount_1!=null){
  //       price = double.parse('${totalAmount_1}')+price;
  //     }
  //   }
  //
  // });

  return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext bc) {
        return StatefulBuilder(
          builder: (context, setState) {
            // incrementItem() {
            //   setState(() {
            //     initialItemCount = initialItemCount + 1;
            //     price = itemPrice * initialItemCount;
            //   });
            // }
            //
            // decrementItem() {
            //   if (initialItemCount > 1) {
            //     setState(() {
            //       initialItemCount = initialItemCount - 1;
            //       price = itemPrice * initialItemCount;
            //     });
            //   }
            // }

            // db.calculateTotalRestAdonA('${item.varients[getIn].variant_id}').then((value){
            //   print('${value}');
            //   if(value!=null){
            //     var tagObjsJson = value as List;
            //     dynamic totalAmount_1 = tagObjsJson[0]['Total'];
            //     print('${totalAmount_1}');
            //     if(totalAmount_1!=null){
            //       setState((){
            //         price = double.parse('${totalAmount_1}')+price;
            //       });
            //     }
            //   }
            //
            // });
            var locale = AppLocalizations.of(context);
            setAddOrMinusProdcutQty(SearchVaritant items, BuildContext context,
                index, produtId, productName, qty) async {
              print('tb - ${qty}');
              DatabaseHelper db = DatabaseHelper.instance;
              db.getRestProductcount('${items.variant_id}').then((value) {
                print('value d - $value');
                var vae = {
                  DatabaseHelper.productId: produtId,
                  DatabaseHelper.varientId: '${items.variant_id}',
                  DatabaseHelper.productName: productName,
                  DatabaseHelper.price:
                      ((double.parse('${items.price}') * qty)),
                  DatabaseHelper.addQnty: qty,
                  DatabaseHelper.unit: items.unit,
                  DatabaseHelper.quantitiy: items.quantity
                };
                if (value == 0) {
                  db.insertRaturantOrder(vae).then((valueaa) {
                    db
                        .calculateTotalRestAdonA(
                            '${item.varients[getIn].variant_id}')
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
                            item.varients[getIn].addOnQty = qty;
                            price =
                                (double.parse('${item.varients[getIn].price}') *
                                        qty) +
                                    pricedd;
                          });
                        } else {
                          setState(() {
                            item.varients[getIn].addOnQty = qty;
                            price =
                                (double.parse('${item.varients[getIn].price}') *
                                        qty) +
                                    pricedd;
                          });
                        }
                      } else {
                        setState(() {
                          item.varients[getIn].addOnQty = qty;
                          price =
                              (double.parse('${item.varients[getIn].price}') *
                                      qty) +
                                  pricedd;
                        });
                      }
                    });
                  });
                } else {
                  if (qty == 0) {
                    db.deleteResProduct('${items.variant_id}').then((value2) {
                      setState(() {
                        item.varients[getIn].addOnQty = qty;
                        price =
                            double.parse('${item.varients[getIn].price}') * qty;
                      });
                      db
                          .deleteAddOn(int.parse('${items.variant_id}'))
                          .then((value) {
                        db
                            .calculateTotalRestAdonA(
                                '${item.varients[getIn].variant_id}')
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
                                item.varients[getIn].addOnQty = qty;
                                price = (double.parse(
                                            '${item.varients[getIn].price}') *
                                        qty) +
                                    pricedd;
                              });
                            } else {
                              setState(() {
                                item.varients[getIn].addOnQty = qty;
                                price = (double.parse(
                                            '${item.varients[getIn].price}') *
                                        qty) +
                                    pricedd;
                              });
                            }
                          } else {
                            setState(() {
                              item.varients[getIn].addOnQty = qty;
                              price = (double.parse(
                                          '${item.varients[getIn].price}') *
                                      qty) +
                                  pricedd;
                            });
                          }
                        });
                      });
                    });
                  } else {
                    db
                        .updateRestProductData(vae, '${items.variant_id}')
                        .then((vay) {
                      print('vay - $vay');
                      db
                          .calculateTotalRestAdonA(
                              '${item.varients[getIn].variant_id}')
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
                              item.varients[getIn].addOnQty = qty;
                              price = (double.parse(
                                          '${item.varients[getIn].price}') *
                                      qty) +
                                  pricedd;
                            });
                          } else {
                            setState(() {
                              item.varients[getIn].addOnQty = qty;
                              price = (double.parse(
                                          '${item.varients[getIn].price}') *
                                      qty) +
                                  pricedd;
                            });
                          }
                        } else {
                          setState(() {
                            item.varients[getIn].addOnQty = qty;
                            price =
                                (double.parse('${item.varients[getIn].price}') *
                                        qty) +
                                    pricedd;
                          });
                        }
                      });
                    });
                  }
                }
              }).catchError((e) {
                print(e);
              });
            }

            Future<dynamic> setAddOnToDatabase(isSelected, DatabaseHelper db,
                AddOnsL addon, variant_id, int indexaa) async {
              var vae = {
                DatabaseHelper.varientId: '${variant_id}',
                DatabaseHelper.addonid: '${addon.addon_id}',
                DatabaseHelper.price: addon.addon_price,
                DatabaseHelper.addonName: addon.addon_name
              };
              await db.insertAddOn(vae).then((value) {
                print('addon add $value');
                if (value != null && value == 1) {
                  // setState(() {
                  //
                  // });

                  db
                      .calculateTotalRestAdonA(
                          '${item.varients[getIn].variant_id}')
                      .then((value1) {
                    double pricedd = 0.0;
                    print('${value1}');
                    if (value != null) {
                      var tagObjsJson = value1 as List;
                      dynamic totalAmount_1 = tagObjsJson[0]['Total'];
                      print('${totalAmount_1}');
                      if (totalAmount_1 != null) {
                        setState(() {
                          item.addons[indexaa].isAdd = true;
                          // addon.isAdd = true;
                          isSelected = true;
                          pricedd = double.parse('${totalAmount_1}');
                          // item.varients[getIn].addOnQty = qty;
                          price =
                              (double.parse('${item.varients[getIn].price}') *
                                      item.varients[getIn].addOnQty) +
                                  pricedd;
                        });
                      } else {
                        setState(() {
                          item.addons[indexaa].isAdd = true;
                          // addon.isAdd = true;
                          isSelected = true;
                          // item.varients[getIn].addOnQty = qty;
                          price =
                              (double.parse('${item.varients[getIn].price}') *
                                      item.varients[getIn].addOnQty) +
                                  pricedd;
                        });
                      }
                    } else {
                      setState(() {
                        item.addons[indexaa].isAdd = true;
                        isSelected = true;
                        price = (double.parse('${item.varients[getIn].price}') *
                                item.varients[getIn].addOnQty) +
                            pricedd;
                      });
                    }
                  });
                } else {
                  setState(() {
                    item.addons[indexaa].isAdd = false;
                    // addon.isAdd = false;
                    isSelected = false;
                  });
                }
                return value;
              }).catchError((e) {
                return null;
              });
            }

            Future<dynamic> deleteAddOn(isSelected, DatabaseHelper db,
                AddOnsL addon, variant_id, int indexaa) async {
              await db.deleteAddOnId('${addon.addon_id}').then((value) {
                print('addon delete $value');
                if (value != null && value > 0) {
                  // setState(() {
                  //   // addon.isAdd = false;
                  //
                  // });

                  db
                      .calculateTotalRestAdonA(
                          '${item.varients[getIn].variant_id}')
                      .then((value1) {
                    double pricedd = 0.0;
                    print('${value1}');
                    if (value != null) {
                      var tagObjsJson = value1 as List;
                      dynamic totalAmount_1 = tagObjsJson[0]['Total'];
                      print('${totalAmount_1}');
                      if (totalAmount_1 != null) {
                        setState(() {
                          item.addons[indexaa].isAdd = false;
                          isSelected = false;
                          pricedd = double.parse('${totalAmount_1}');
                          // item.varients[getIn].addOnQty = qty;
                          price =
                              (double.parse('${item.varients[getIn].price}') *
                                      item.varients[getIn].addOnQty) +
                                  pricedd;
                        });
                      } else {
                        setState(() {
                          item.addons[indexaa].isAdd = false;
                          isSelected = false;
                          // item.varients[getIn].addOnQty = qty;
                          price =
                              (double.parse('${item.varients[getIn].price}') *
                                      item.varients[getIn].addOnQty) +
                                  pricedd;
                        });
                      }
                    } else {
                      setState(() {
                        item.addons[indexaa].isAdd = false;
                        isSelected = false;
                        price = (double.parse('${item.varients[getIn].price}') *
                                item.varients[getIn].addOnQty) +
                            pricedd;
                      });
                    }
                  });
                } else {
                  db
                      .calculateTotalRestAdonA(
                          '${item.varients[getIn].variant_id}')
                      .then((value1) {
                    double pricedd = 0.0;
                    print('${value1}');
                    if (value != null) {
                      var tagObjsJson = value1 as List;
                      dynamic totalAmount_1 = tagObjsJson[0]['Total'];
                      print('${totalAmount_1}');
                      if (totalAmount_1 != null) {
                        setState(() {
                          item.addons[indexaa].isAdd = true;
                          isSelected = true;
                          pricedd = double.parse('${totalAmount_1}');
                          // item.varients[getIn].addOnQty = qty;
                          price =
                              (double.parse('${item.varients[getIn].price}') *
                                      item.varients[getIn].addOnQty) +
                                  pricedd;
                        });
                      } else {
                        setState(() {
                          item.addons[indexaa].isAdd = true;
                          isSelected = true;
                          // item.varients[getIn].addOnQty = qty;
                          price =
                              (double.parse('${item.varients[getIn].price}') *
                                      item.varients[getIn].addOnQty) +
                                  pricedd;
                        });
                      }
                    } else {
                      setState(() {
                        item.addons[indexaa].isAdd = true;
                        isSelected = true;
                        price = (double.parse('${item.varients[getIn].price}') *
                                item.varients[getIn].addOnQty) +
                            pricedd;
                      });
                    }
                  });
                }
                return value;
              }).catchError((e) {
                return null;
              });
            }

            getAddOnItem(bool isSelected, String qty, String price, int indexaa,
                AddOnsL addon, variant_id) {
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
                            if (item.varients[getIn].addOnQty > 0) {
                              DatabaseHelper db = DatabaseHelper.instance;
                              db
                                  .getCountAddon('${addon.addon_id}')
                                  .then((value) {
                                print('addon count $value');
                                if (value != null && value > 0) {
                                  deleteAddOn(isSelected, db, addon, variant_id,
                                          indexaa)
                                      .then((value) {
                                    print('addon deleted $value');
                                  }).catchError((e) {
                                    print(e);
                                  });
                                } else {
                                  setAddOnToDatabase(isSelected, db, addon,
                                          variant_id, indexaa)
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
                        // widthSpace,
                        // Text(
                        //   'Size $size',
                        //   style: listItemTitleStyle,
                        // ),
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
                                        right: fixPadding * 2,
                                        left: fixPadding,
                                        bottom: fixPadding),
                                    child: Text(
                                      '${item.description}',
                                      style: listItemTitleStyle,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        right: fixPadding * 2,
                                        left: fixPadding,
                                        bottom: fixPadding),
                                    child: Text(
                                      '(${item.varients[getIn].quantity} ${item.varients[getIn].unit})',
                                      style: listItemTitleStyle,
                                      maxLines: 1,
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
                                          '${currencySymbol} ${item.varients[getIn].price}',
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
                                                if (item.varients[getIn]
                                                        .addOnQty <=
                                                    0) {
                                                  print('in less then zero');
                                                } else {
                                                  setAddOrMinusProdcutQty(
                                                      item.varients[getIn],
                                                      context,
                                                      getIn,
                                                      item.product_id,
                                                      item.product_name,
                                                      (item.varients[getIn]
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
                                                  color: (item.varients[getIn]
                                                              .addOnQty ==
                                                          0)
                                                      ? Colors.grey[300]
                                                      : kMainColor,
                                                ),
                                                child: Icon(
                                                  Icons.remove,
                                                  color: (item.varients[getIn]
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
                                                  '${item.varients[getIn].addOnQty}'),
                                            ),
                                            InkWell(
                                              // onTap: incrementItem(),
                                              onTap: () {
                                                setAddOrMinusProdcutQty(
                                                    item.varients[getIn],
                                                    context,
                                                    getIn,
                                                    item.product_id,
                                                    item.product_name,
                                                    (item.varients[getIn]
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
                      // Size Start
                      // Container(
                      //   color: kCardBackgroundColor,
                      //   padding: EdgeInsets.all(fixPadding),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      //     crossAxisAlignment: CrossAxisAlignment.center,
                      //     children: <Widget>[
                      //       Text(
                      //         'Varient',
                      //         style: listItemSubTitleStyle,
                      //       ),
                      //       Text(
                      //         'Price',
                      //         style: listItemSubTitleStyle,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // Container(
                      //     color: kWhiteColor,
                      //     child:
                      //         (item.variant != null && item.variant.length > 0)
                      //             ? ListView.separated(
                      //                 shrinkWrap: true,
                      //                 itemCount: item.variant.length,
                      //                 itemBuilder: (context, index) {
                      //                   return getSizeListItem(
                      //                       (item.variant[index].isSelected!=null && item.variant[index].isSelected)?true:false,
                      //                       '${item.variant[index].quantity} ${item.variant[index].unit}',
                      //                       '${item.variant[index].price}',index,item.variant[index]);
                      //                 },
                      //                 separatorBuilder: (context, ind) {
                      //                   return heightSpace;
                      //                 },
                      //               )
                      //             : Container()),
                      // Size End
                      // Options Start
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
                                itemBuilder: (context, indexw) {
                                  // item.addons[index].isAdd = addOnlist.contains(AddonList(item.addons[index].addon_id))?true:false;
                                  return Padding(
                                    padding: EdgeInsets.only(
                                        right: fixPadding, left: fixPadding),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: <Widget>[
                                            InkWell(
                                              onTap: () async {
                                                if (item.varients[getIn]
                                                        .addOnQty >
                                                    0) {
                                                  DatabaseHelper db =
                                                      DatabaseHelper.instance;
                                                  db
                                                      .getCountAddon(
                                                          '${item.addons[indexw].addon_id}')
                                                      .then((value) {
                                                    print('addon count $value');
                                                    if (value != null &&
                                                        value > 0) {
                                                      deleteAddOn(
                                                              (item.addons[indexw].isAdd !=
                                                                          null &&
                                                                      item
                                                                          .addons[
                                                                              indexw]
                                                                          .isAdd)
                                                                  ? true
                                                                  : false,
                                                              db,
                                                              item.addons[
                                                                  indexw],
                                                              item
                                                                  .varients[
                                                                      getIn]
                                                                  .variant_id,
                                                              indexw)
                                                          .then((value) {
                                                        print(
                                                            'addon deleted $value');
                                                      }).catchError((e) {
                                                        print(e);
                                                      });
                                                    } else {
                                                      // setAddOnToDatabase(
                                                      //     (item.addons[indexw].isAdd != null && item.addons[indexw].isAdd) ? true : false, db, item.addons[indexw], item.variant[getIn].variant_id,indexw)
                                                      //     .then((value) {
                                                      //   print('addon addd $value');
                                                      // }).catchError((e) {
                                                      //   print(e);
                                                      // });
                                                      var vae = {
                                                        DatabaseHelper
                                                                .varientId:
                                                            '${item.varients[getIn].variant_id}',
                                                        DatabaseHelper.addonid:
                                                            '${item.addons[indexw].addon_id}',
                                                        DatabaseHelper.price:
                                                            item.addons[indexw]
                                                                .addon_price,
                                                        DatabaseHelper
                                                                .addonName:
                                                            item.addons[indexw]
                                                                .addon_name
                                                      };
                                                      db
                                                          .insertAddOn(vae)
                                                          .then((value) {
                                                        print(
                                                            'addon add $value');
                                                        if (value != null &&
                                                            value > 0) {
                                                          setState(() {
                                                            item.addons[indexw]
                                                                .isAdd = true;
                                                            // addon.isAdd = true;
                                                            // isSelected = true;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            item.addons[indexw]
                                                                .isAdd = false;
                                                            // addon.isAdd = false;
                                                            // isSelected = false;
                                                          });
                                                        }
                                                        return value;
                                                      }).catchError((e) {
                                                        return null;
                                                      });
                                                    }
                                                  }).catchError((e) {
                                                    print(e);
                                                  });
                                                } else {
                                                  Toast.show(
                                                      locale.addFirstProductToAddAddon,
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_SHORT);
                                                }
                                              },
                                              child: Container(
                                                width: 26.0,
                                                height: 26.0,
                                                decoration: BoxDecoration(
                                                    color: (item.addons[indexw]
                                                            .isAdd)
                                                        ? kMainColor
                                                        : kWhiteColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            13.0),
                                                    border: Border.all(
                                                        width: 1.0,
                                                        color: kHintColor
                                                            .withOpacity(0.7))),
                                                child: Icon(Icons.check,
                                                    color: kWhiteColor,
                                                    size: 15.0),
                                              ),
                                            ),
                                            // widthSpace,
                                            // Text(
                                            //   'Size $size',
                                            //   style: listItemTitleStyle,
                                            // ),
                                            widthSpace,
                                            Text(
                                              '${item.addons[indexw].addon_name}',
                                              style: listItemTitleStyle,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          '${currencySymbol} ${item.addons[indexw].addon_price}',
                                          style: listItemTitleStyle,
                                        ),
                                      ],
                                    ),
                                  );
                                  // getAddOnItem(
                                  //   (item.addons[indexw].isAdd != null && item.addons[indexw].isAdd) ? true : false,
                                  //   // addOnlist.contains(AddonList(item.addons[index].addon_id))?true:false,
                                  //   '${item.addons[indexw].addon_name}',
                                  //   '${item.addons[indexw].addon_price}',
                                  //   indexw,
                                  //   item.addons[indexw],
                                  //   item.variant[getIn].variant_id);
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
                          onTap: () async {
                            DatabaseHelper db = DatabaseHelper.instance;
                            db.queryResturantProdCount().then((value) {
                              if (value != null && value > 0) {
                              } else {
                                Toast.show(
                                    locale.addSomeProductIntoContinue,
                                    context,
                                    duration: Toast.LENGTH_SHORT);
                              }
                            });
                            // Navigator.of(context).pushNamed()
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
                                      '${item.varients[getIn].addOnQty} ITEM',
                                      style: TextStyle(
                                        color: kWhiteColor,
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
                                    if (item.varients[getIn].addOnQty > 0) {
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
