import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/productlistvarient.dart';
import 'package:user/bean/subcategorylist.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/singleproductpage/singleproductpage.dart';

class ItemsPage extends StatefulWidget {
  final dynamic pageTitle;
  final dynamic category_name;
  final dynamic category_id;
  final dynamic distance;

  ItemsPage(
      this.pageTitle, this.category_name, this.category_id, this.distance);

  @override
  _ItemsPageState createState() =>
      _ItemsPageState(pageTitle, category_name, category_id);
}

class _ItemsPageState extends State<ItemsPage>
    with SingleTickerProviderStateMixin {
  int itemCount = 0;
  List<Tab> tabs = <Tab>[];

  final dynamic pageTitle;
  final dynamic category_name;
  final dynamic category_id;

  dynamic currency = '';

  List<SubCategoryList> subCategoryListApp = [];
  List<SubCategoryList> subCategoryListDemo = [
    SubCategoryList(
      '',
      '',
      '',
      '',
      '',
      '',
    ),
    SubCategoryList(
      '',
      '',
      '',
      '',
      '',
      '',
    ),
    SubCategoryList(
      '',
      '',
      '',
      '',
      '',
      '',
    ),
    SubCategoryList(
      '',
      '',
      '',
      '',
      '',
      '',
    ),
    SubCategoryList(
      '',
      '',
      '',
      '',
      '',
      '',
    ),
  ];

  List<ProductWithVarient> productVarientList = [];
  List<ProductWithVarient> productVarientListSearch = [];

  bool isCartCount = false;
  var cartCount = 0;

  dynamic totalAmount = 0.0;
  TextEditingController searchController = TextEditingController();
  TabController tabController;

  bool addMinus = false;

  bool isFetchList = false;
  bool isSearchOpen = false;

  _ItemsPageState(this.pageTitle, this.category_name, this.category_id);

  @override
  void initState() {
    super.initState();
    hitServices();
    getCartCount();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void getCartCount() {
    DatabaseHelper db = DatabaseHelper.instance;
    db.queryRowCount().then((value) {
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
    db.calculateTotal().then((value) {
      var tagObjsJson = value as List;
      setState(() {
        if (value != null) {
          totalAmount = tagObjsJson[0]['Total'];
        } else {
          totalAmount = 0.0;
        }
      });
    });
  }

  void setList2() {
    if (searchController != null && searchController.text.length > 0) {
      setState(() {
        searchController.clear();
        productVarientList.clear();
        productVarientList = List.from(productVarientListSearch);
      });
    } else {
      setState(() {
        isSearchOpen = false;
        productVarientList.clear();
        productVarientList = List.from(productVarientListSearch);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () async {
        if (isSearchOpen) {
          setList2();
          return false;
        } else {
          return true;
        }
      },
      child: DefaultTabController(
        length: tabs.length,
        child: Scaffold(
          body: SafeArea(
            left: false,
            right: false,
            bottom: false,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Visibility(
                  visible: isSearchOpen,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: 72,
                    padding: EdgeInsets.only(top: 5.0),
                    color: kWhiteColor,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: 52,
                          padding: EdgeInsets.only(left: 5),
                          decoration: BoxDecoration(
                            color: scaffoldBgColor,
                          ),
                          child: TextFormField(
                            controller: searchController,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              prefixIcon: Icon(
                                Icons.search,
                                color: kHintColor,
                              ),
                              hintText: locale.searchCategoryText,
                              suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    isSearchOpen = !isSearchOpen;
                                  });
                                },
                                icon: Icon(
                                  Icons.close,
                                  color: kHintColor,
                                ),
                              ),
                            ),
                            cursorColor: kMainColor,
                            autofocus: false,
                            onChanged: (value) {
                              setState(() {
                                productVarientList = productVarientListSearch
                                    .where((element) => element.product_name
                                    .toString()
                                    .toLowerCase()
                                    .contains(value.toLowerCase()))
                                    .toList();
                              });
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Visibility(
                  visible: !isSearchOpen,
                  child: CustomAppBar(
                  titleWidget: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(pageTitle,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: kMainTextColor)),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: <Widget>[
                            Icon(
                              Icons.location_on,
                              color: kIconColor,
                              size: 10,
                            ),
                            SizedBox(width: 10.0),
                            Text(
                                '${double.parse('${widget.distance}').toStringAsFixed(2)} km ',
                                style: Theme.of(context).textTheme.overline),
                            Text('|',
                                style: Theme.of(context).textTheme.overline),
                            Text(category_name,
                                style: Theme.of(context).textTheme.overline),
                            Spacer(),
                          ],
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    Padding(
                      padding: const EdgeInsets.only(right: 2.0),
                      child: IconButton(
                          icon: Icon(
                            Icons.search,
                            color: kHintColor,
                          ),
                          onPressed: () {
                            setState(() {
                              isSearchOpen = !isSearchOpen;
                            });
                          }),
                    ),
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
                                      context, PageRoutes.viewCart)
                                      .then((value) {
                                    setList(productVarientList);
                                    getCartCount();
                                  });
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
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                              ))
                        ],
                      ),
                    ),
                  ],
                ),),
                Column(
                  children: <Widget>[
                    TabBar(
                      tabs: tabs,
                      isScrollable: (subCategoryListApp != null &&
                          subCategoryListApp.length > 3)
                          ? true
                          : false,
                      labelColor: kMainColor,
                      unselectedLabelColor: kLightTextColor,
                      controller: tabController,
                      indicatorPadding:
                      EdgeInsets.symmetric(horizontal: 24.0),
                    ),
                    Divider(
                      color: kCardBackgroundColor,
                      thickness: 8.0,
                    )
                  ],
                ),
                Expanded(
                  child: DefaultTabController(
                    length: tabs.length,
                    child: TabBarView(
                      controller: tabController,
                      children: tabs.map((Tab tab) {
                        return Column(
                          children: [
                            Expanded(
                              child: (!isFetchList &&
                                  productVarientList != null &&
                                  productVarientList.length > 0)
                                  ? ListView.separated(
                                itemCount: productVarientList.length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(builder: (context) {
                                            return SingleProductPage(
                                                productVarientList[index],
                                                currency);
                                          })).then((value) {
                                        setList(productVarientList);
                                        getCartCount();
                                      });
                                    },
                                    behavior: HitTestBehavior.opaque,
                                    child: Stack(
                                      children: <Widget>[
                                        Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: <Widget>[
                                            Padding(
                                              padding: EdgeInsets.only(
                                                  left: 20.0,
                                                  top: 30.0,
                                                  right: 14.0),
                                              child: Container(
                                                height: 93.3,
                                                width: 93.3,
                                                child:
                                                (productVarientList != null &&
                                                    productVarientList
                                                        .length >
                                                        0)
                                                    ? Image.network(
                                                  imageBaseUrl +
                                                      productVarientList[
                                                      index]
                                                          .products_image,
                                                  height: 93.3,
                                                  width: 93.3,
                                                )
                                                    : Image(
                                                  image: AssetImage(
                                                      'images/logos/logo_user.png'),
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
                                                    padding: EdgeInsets.only(
                                                        right: 20),
                                                    child: Text(
                                                        productVarientList[
                                                        index]
                                                            .product_name,
                                                        style:
                                                        bottomNavigationTextStyle
                                                            .copyWith(
                                                            fontSize:
                                                            15)),
                                                  ),
                                                  SizedBox(
                                                    height: 8.0,
                                                  ),
                                                  Text(
                                                      '$currency ${(productVarientList[index].data.length > 0) ? productVarientList[index].data[productVarientList[index].selectPos].price : 0}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption),
                                                  SizedBox(
                                                    height: 20.0,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                        Positioned(
                                          left: 120,
                                          bottom: 5,
                                          child: Container(
                                            height: 30.0,
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 12.0),
                                            decoration: BoxDecoration(
                                              color: kCardBackgroundColor,
                                              borderRadius:
                                              BorderRadius.circular(30.0),
                                            ),
                                            child: (productVarientList[index]
                                                .data !=
                                                null &&
                                                productVarientList[index]
                                                    .data
                                                    .length >
                                                    0)
                                                ? DropdownButton<VarientList>(
                                                underline: Container(
                                                  height: 0.0,
                                                  color:
                                                  kCardBackgroundColor,
                                                ),
                                                value: productVarientList[
                                                index]
                                                    .data[
                                                productVarientList[
                                                index]
                                                    .selectPos],
                                                items: productVarientList[
                                                index]
                                                    .data
                                                    .map((e) {
                                                  return DropdownMenuItem<
                                                      VarientList>(
                                                    child: Text(
                                                      '${e.quantity} ${e.unit}',
                                                      style:
                                                      Theme.of(context)
                                                          .textTheme
                                                          .caption,
                                                    ),
                                                    value: e,
                                                  );
                                                }).toList(),
                                                onChanged: (vale) {
                                                  setState(() {
                                                    int indexd =
                                                    productVarientList[
                                                    index]
                                                        .data
                                                        .indexOf(vale);
                                                    if (indexd != -1) {
                                                      productVarientList[
                                                      index]
                                                          .selectPos =
                                                          indexd;
                                                      DatabaseHelper db =
                                                          DatabaseHelper
                                                              .instance;
                                                      db
                                                          .getVarientCount(
                                                          int.parse(
                                                              '${productVarientList[index].data[productVarientList[index].selectPos].varient_id}'))
                                                          .then((value) {
                                                        print(
                                                            'print t val $value');
                                                        if (value == null) {
                                                          setState(() {
                                                            productVarientList[
                                                            index]
                                                                .add_qnty = 0;
                                                          });
                                                        } else {
                                                          setState(() {
                                                            productVarientList[
                                                            index]
                                                                .add_qnty =
                                                                value;
                                                            isCartCount =
                                                            true;
                                                          });
                                                        }
                                                      });
                                                    }
                                                  });
                                                })
                                                : Text(''),
                                          ),
                                        ),
                                        Positioned(
                                          height: 30,
                                          right: 20.0,
                                          bottom: 5,
                                          child: (productVarientList[index]
                                              .data !=
                                              null &&
                                              productVarientList[index]
                                                  .data
                                                  .length >
                                                  0 &&
                                              int.parse(
                                                  '${productVarientList[index].data[productVarientList[index].selectPos].stock}') >
                                                  0)
                                              ? (productVarientList[index]
                                              .add_qnty ==
                                              0
                                              ? Container(
                                            height: 30.0,
                                            child: FlatButton(
                                              child: Text(
                                                locale.addText,
                                                style: Theme.of(
                                                    context)
                                                    .textTheme
                                                    .caption
                                                    .copyWith(
                                                    color:
                                                    kMainColor,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold),
                                              ),
                                              textTheme:
                                              ButtonTextTheme
                                                  .accent,
                                              onPressed: () {
                                                setState(() {
                                                  var stock = int.parse(
                                                      '${productVarientList[index].data[productVarientList[index].selectPos].stock}');
                                                  if (stock >
                                                      productVarientList[
                                                      index]
                                                          .add_qnty) {
                                                    productVarientList[
                                                    index]
                                                        .add_qnty++;
                                                    addOrMinusProduct(
                                                        productVarientList[
                                                        index]
                                                            .product_name,
                                                        productVarientList[
                                                        index]
                                                            .data[productVarientList[
                                                        index]
                                                            .selectPos]
                                                            .unit,
                                                        double.parse(
                                                            '${productVarientList[index].data[productVarientList[index].selectPos].price}'),
                                                        int.parse(
                                                            '${productVarientList[index].data[productVarientList[index].selectPos].quantity}'),
                                                        productVarientList[
                                                        index]
                                                            .add_qnty,
                                                        productVarientList[
                                                        index]
                                                            .data[productVarientList[
                                                        index]
                                                            .selectPos]
                                                            .varient_image,
                                                        productVarientList[
                                                        index]
                                                            .data[productVarientList[
                                                        index]
                                                            .selectPos]
                                                            .varient_id);
                                                  } else {
                                                    Toast.show(
                                                        locale.noMoreStockAvailable,
                                                        context,
                                                        gravity: Toast
                                                            .BOTTOM);
                                                  }
                                                });
                                              },
                                            ),
                                          )
                                              : Container(
                                            height: 30.0,
                                            padding:
                                            EdgeInsets.symmetric(
                                                horizontal: 11.0),
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: kMainColor),
                                              borderRadius:
                                              BorderRadius
                                                  .circular(30.0),
                                            ),
                                            child: Row(
                                              children: <Widget>[
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      productVarientList[
                                                      index]
                                                          .add_qnty--;
                                                    });
                                                    addOrMinusProduct(
                                                        productVarientList[
                                                        index]
                                                            .product_name,
                                                        productVarientList[
                                                        index]
                                                            .data[productVarientList[
                                                        index]
                                                            .selectPos]
                                                            .unit,
                                                        double.parse(
                                                            '${productVarientList[index].data[productVarientList[index].selectPos].price}'),
                                                        int.parse(
                                                            '${productVarientList[index].data[productVarientList[index].selectPos].quantity}'),
                                                        productVarientList[
                                                        index]
                                                            .add_qnty,
                                                        productVarientList[
                                                        index]
                                                            .data[productVarientList[
                                                        index]
                                                            .selectPos]
                                                            .varient_image,
                                                        productVarientList[
                                                        index]
                                                            .data[productVarientList[
                                                        index]
                                                            .selectPos]
                                                            .varient_id);
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
                                                    productVarientList[
                                                    index]
                                                        .add_qnty
                                                        .toString(),
                                                    style: Theme.of(
                                                        context)
                                                        .textTheme
                                                        .caption),
                                                SizedBox(width: 8.0),
                                                InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      var stock =
                                                      int.parse(
                                                          '${productVarientList[index].data[productVarientList[index].selectPos].stock}');
                                                      if (stock >
                                                          productVarientList[
                                                          index]
                                                              .add_qnty) {
                                                        productVarientList[
                                                        index]
                                                            .add_qnty++;
                                                        addOrMinusProduct(
                                                            productVarientList[
                                                            index]
                                                                .product_name,
                                                            productVarientList[
                                                            index]
                                                                .data[productVarientList[index]
                                                                .selectPos]
                                                                .unit,
                                                            double.parse(
                                                                '${productVarientList[index].data[productVarientList[index].selectPos].price}'),
                                                            int.parse(
                                                                '${productVarientList[index].data[productVarientList[index].selectPos].quantity}'),
                                                            productVarientList[
                                                            index]
                                                                .add_qnty,
                                                            productVarientList[
                                                            index]
                                                                .data[productVarientList[index]
                                                                .selectPos]
                                                                .varient_image,
                                                            productVarientList[
                                                            index]
                                                                .data[
                                                            productVarientList[index].selectPos]
                                                                .varient_id);
                                                      } else {
                                                        Toast.show(
                                                            locale.noMoreStockAvailable,
                                                            context,
                                                            gravity: Toast
                                                                .BOTTOM);
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
                                          ))
                                              : Container(
                                            child: Text(
                                              locale.outoffStockText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption
                                                  .copyWith(
                                                  color: kMainColor,
                                                  fontWeight:
                                                  FontWeight
                                                      .bold),
                                            ),
                                          ),
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
                                  : Container(
                                height: MediaQuery.of(context).size.height / 2,
                                width: MediaQuery.of(context).size.width,
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    isFetchList
                                        ? CircularProgressIndicator()
                                        : Container(
                                      width: 0.5,
                                    ),
                                    isFetchList
                                        ? SizedBox(
                                      width: 10,
                                    )
                                        : Container(
                                      width: 0.5,
                                    ),
                                    Text(
                                      (!isFetchList)
                                          ? locale.noProductAvailableText
                                          : locale.productSearchText,
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: kMainTextColor),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Visibility(
                              visible: isCartCount,
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 20.0),
                                child: Row(
                                  children: <Widget>[
                                    Image.asset(
                                      'images/icons/ic_cart wt.png',
                                      height: 19.0,
                                      width: 18.3,
                                    ),
                                    SizedBox(width: 20.7),
                                    Text(
                                      '$cartCount ${locale.itemsText} | $currency $totalAmount',
                                      style: bottomBarTextStyle.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    Spacer(),
                                    MaterialButton(
                                      color: Colors.white,
                                      onPressed: () => hitViewCart(context),
                                      child: Text(
                                        locale.viewCartText,
                                        style: Theme.of(context)
                                            .textTheme
                                            .caption
                                            .copyWith(
                                            color: kMainColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      textTheme: ButtonTextTheme.accent,
                                      disabledColor: Colors.white,
                                    ),
                                  ],
                                ),
                                color: kMainColor,
                                height: 60.0,
                              ),
                            )
                          ],
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  void addOrMinusProduct(product_name, unit, price, quantity, itemCount,
      varient_image, varient_id) async {
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
          db.delete(int.parse('${varient_id}'));
        } else {
          db.updateData(vae, int.parse('${varient_id}')).then((vay) {
            print('vay - $vay');
            getCatC();
          });
        }
      }
      getCartCount();
    }).catchError((e) {
      print(e);
    });
  }

  void hitServices() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
    });
    var url = subCategoryList;
    var response =
        await http.post(url, body: {'category_id': category_id.toString()});

    try {
      if (response.statusCode == 200) {
        print('Response Body: - ${response.body}');
        var jsonData = jsonDecode(response.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<SubCategoryList> tagObjs = tagObjsJson
              .map((tagJson) => SubCategoryList.fromJson(tagJson))
              .toList();
          setState(() {
            List<Tab> tabss = <Tab>[];
            for (SubCategoryList tagd in tagObjs) {
              tabss.add(Tab(
                text: tagd.subcat_name,
              ));
            }
            subCategoryListApp.clear();
            tabs.clear();
            subCategoryListApp = tagObjs;
            tabs = tabss;
            tabController = TabController(length: tabs.length, vsync: this);
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                setState(() {
                  productVarientList = [];
                  hitTabSeriveList(
                      subCategoryListApp[tabController.index].subcat_id);
                });
              }
            });
            setState(() {
              productVarientList = [];
              hitTabSeriveList(subCategoryListApp[0].subcat_id);
            });
          });
        }
      }
    } on Exception catch (_) {
      Timer(Duration(seconds: 5), () {
        hitServices();
      });
    }
  }

  void hitTabSeriveList(subCatId) async {
    var locale = AppLocalizations.of(context);
    setState(() {
      isFetchList = true;
    });
    var url = productListWithVarient;
    var response =
        await http.post(url, body: {'subcat_id': subCatId.toString()});
    try {
      if (response.statusCode == 200) {
        if (response.body.toString().contains('product_id')) {
          print('Response Body: - ${response.body}');
          var jsonData = jsonDecode(response.body);
          if (jsonData.toString().length > 4) {
            var tagObjsJson = jsonDecode(response.body) as List;
            List<ProductWithVarient> tagObjs = tagObjsJson
                .map((tagJson) => ProductWithVarient.fromJson(tagJson))
                .toList();
            setState(() {
              productVarientList.clear();
              productVarientListSearch.clear();
              productVarientList = tagObjs;
              setList(tagObjs);
            });
          }
          setState(() {
            isFetchList = false;
          });
        } else {
          setState(() {
            productVarientList.clear();
            isFetchList = false;
          });
        }
      }
    } on Exception catch (_) {
      Timer(Duration(seconds: 5), () {
        hitTabSeriveList(subCatId);
      });
    }
  }

  hitViewCart(BuildContext context) {
    var locale = AppLocalizations.of(context);
    if (isCartCount) {
      Navigator.pushNamed(context, PageRoutes.viewCart).then((value) {
        setList(productVarientList);
        getCartCount();
      });
    } else {
      Toast.show(locale.noValueInTheCart, context,
          duration: Toast.LENGTH_SHORT);
    }
  }

  void setList(List<ProductWithVarient> tagObjs) {
    for (int i = 0; i < tagObjs.length; i++) {
      if (tagObjs[i].data.length > 0) {
        DatabaseHelper db = DatabaseHelper.instance;
        db
            .getVarientCount(int.parse(
                '${tagObjs[i].data[tagObjs[i].selectPos].varient_id}'))
            .then((value) {
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
    productVarientListSearch = List.from(productVarientList);
  }
}

class BottomSheetWidget extends StatefulWidget {
  final String product_name;
  final String category_name;
  final dynamic currency;
  final List<VarientList> datas;
  List<VarientList> newdatas = [];

  BottomSheetWidget(
      this.product_name, this.datas, this.category_name, this.currency) {
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
      db.getVarientCount(int.parse('${tagObjs[i].varient_id}')).then((value) {
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
                      '${data[index].quantity} ${data[index].unit}  ${widget.currency} ${data[index].price}',
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
                            locale.addText,
                            style: Theme.of(context).textTheme.caption.copyWith(
                                color: kMainColor, fontWeight: FontWeight.bold),
                          ),
                          textTheme: ButtonTextTheme.accent,
                          onPressed: () {
                            setState(() {
                              var stock = int.parse('${data[index].stock}');
                              if (stock > data[index].add_qnty) {
                                data[index].add_qnty++;
                                addOrMinusProduct(
                                    product_name,
                                    data[index].unit,
                                    double.parse('${data[index].price}'),
                                    int.parse('${data[index].quantity}'),
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
                                    double.parse('${data[index].price}'),
                                    int.parse('${data[index].quantity}'),
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
                                  var stock = int.parse('${data[index].stock}');
                                  if (stock > data[index].add_qnty) {
                                    data[index].add_qnty++;
                                    addOrMinusProduct(
                                        product_name,
                                        data[index].unit,
                                        double.parse('${data[index].price}'),
                                        int.parse('${data[index].quantity}'),
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
      ],
    );
  }

  void addOrMinusProduct(product_name, unit, price, quantity, itemCount,
      varient_image, varient_id) async {
    DatabaseHelper db = DatabaseHelper.instance;
    Future<int> existing = db.getcount(int.parse('${varient_id}'));
    existing.then((value) {
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
          db.delete(int.parse('${varient_id}'));
        } else {
          db.updateData(vae, int.parse('${varient_id}'));
        }
      }
    });
  }
}
