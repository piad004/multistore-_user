import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/HomeOrderAccount/Home/UI/Search.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/databasehelper/dbhelper.dart';
import 'package:user/pharmacy/pharmabean/pharmahomecategory.dart';

class PharmaItemPage extends StatefulWidget {
  final dynamic vendorName;
  final dynamic vendor_id;
  final dynamic deliveryRange;
  final dynamic distance;

  PharmaItemPage(
      this.vendorName, this.vendor_id, this.deliveryRange, this.distance);

  @override
  _ItemsPharmaPageState createState() => _ItemsPharmaPageState();
}

class _ItemsPharmaPageState extends State<PharmaItemPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  List<Tab> tabs = <Tab>[];
  dynamic currency = '';
  bool isCartCount = false;
  var cartCount = 0;
  var currentPage = 1;
  var totalPage = 1;
  dynamic totalAmount = 0.0;
  TabController tabController;
  bool addMinus = false;
  bool isSearchOpen = false;
  bool isFetchList = false;
  bool isFetch = true;
  List<CategoryPharmacy> categoryList = [];
  List<CategoryPharmacy> categoryList2 = [];
  List<CategoryPharmacy> categoryList3 = [];
  List<CategoryPharmacy> categoryList3Search = [];

  @override
  void initState() {
    super.initState();
    hitPharmacyCat();
    getCartCount();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setTab() {
    tabController = TabController(length: tabs.length, vsync: this);
    tabController.addListener(() {
      print(tabController.index);
      if (tabController.indexIsChanging) {
        currentPage = 1;
        hitPharmacyProductById(
            categoryList2[tabController.index].resturant_cat_id);
        /* setState(() {
          categoryList3 = [];
          categoryList3Search = [];
          categoryList3 = categoryList
              .where((element) =>
          element.resturant_cat_id ==
              categoryList2[tabController.index]
                  .resturant_cat_id &&
              element.product_name != null)
              .toList();
          categoryList3Search = List.from(categoryList3);
          setList(categoryList3);
        });*/
      }
    });
  }

  //
  void hitPharmacyCat() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFetch = true;
      currency = preferences.getString("curency");
    });
    var url = pharmacy_category;
    http.post(url, body: {
      'vendor_id': '${widget.vendor_id}',
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonDat = (response.body);
        var jsonData = jsonDecode(response.body);
        print('Response Body: - ${response.body}');
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<CategoryPharmacy> tagObjs = tagObjsJson
              .map((tagJson) => CategoryPharmacy.fromJson(tagJson))
              .toList();
          if (tagObjs != null && tagObjs.length > 0) {
            setState(() {
              categoryList.clear();
              categoryList2.clear();
              tabs.clear();

              categoryList = List.from(tagObjs);
              List<CategoryPharmacy> categoryListNew = List.from(tagObjs);
              categoryList2 = categoryListNew.toSet().toList();

              List<Tab> tabss = <Tab>[];
              for (CategoryPharmacy parh in categoryList2) {
                tabss.add(Tab(
                  text: parh.cat_name,
                ));
              }
              tabs = tabss;
              hitPharmacyProductById(categoryList2[0].resturant_cat_id);
              setTab();
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

  void hitPharmacyProductById(var id) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFetch = true;
      currency = preferences.getString("curency");
    });
   // _buildProgressIndicator();
    var url = pharmacy_product_by_category;
    http.post(url, body: {
      'resturant_cat_id': id.toString(),
      'page': currentPage.toString()
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonDat = (response.body);
        print(jsonDat);
        var jsonData = jsonDecode(response.body);
        print('Response Body: - ${response.body}');
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<CategoryPharmacy> tagObjs = tagObjsJson
              .map((tagJson) => CategoryPharmacy.fromJson(tagJson))
              .toList();
          if (tagObjs != null && tagObjs.length > 0) {
            setState(() {
              //categoryList.clear();
              //categoryList2.clear();

              var pageInfoJson = jsonDecode(response.body)['page_info'];
              currentPage = pageInfoJson['page'];
              totalPage = pageInfoJson['total_page'];
              //Toast.show("page : "+currentPage.toString()+" Total : "+totalPage.toString(), context,duration: Toast.LENGTH_SHORT,gravity: Toast.BOTTOM);

              List<CategoryPharmacy> categoryListNew = List.from(tagObjs);

              if (currentPage == 1) {
                categoryList3.clear();
                categoryList3Search.clear();

                categoryList3 = categoryListNew;
              } else
                categoryList3.addAll(categoryListNew);

              categoryList3Search = List.from(categoryList3);
              setList(categoryList3);

              /* categoryList3 = categoryList
                    .where((element) =>
                element.resturant_cat_id ==
                    categoryList2[0].resturant_cat_id)
                    .toList();*/

              isFetch = false;
              isFetchList = false;
            });
          } else {
            setState(() {
              isFetch = false;
              isFetchList = false;
            });
          }
        } else {
          setState(() {
            isFetch = false;
            isFetchList = false;
          });
        }
      } else {
        setState(() {
          isFetch = false;
          isFetchList = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isFetch = false;
        isFetchList = false;
      });
    });
  }

  void hitPharmacyItem() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      isFetch = true;
      currency = preferences.getString("curency");
    });
    var url = pharmacy_homecategory;
    http.post(url, body: {
      'vendor_id': '${widget.vendor_id}',
      'page': currentPage.toString()
    }).then((response) {
      if (response.statusCode == 200) {
        var jsonDat = (response.body);
        var jsonData = jsonDecode(response.body);
        print('Response Body: - ${response.body}');
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(response.body)['data'] as List;
          List<CategoryPharmacy> tagObjs = tagObjsJson
              .map((tagJson) => CategoryPharmacy.fromJson(tagJson))
              .toList();
          if (tagObjs != null && tagObjs.length > 0) {
            setState(() {
              categoryList.clear();
              categoryList2.clear();

              if (currentPage == 1) {
                tabs.clear();
                categoryList3.clear();
              }

              categoryList3Search.clear();
              categoryList = List.from(tagObjs);
              List<CategoryPharmacy> categoryListNew = List.from(tagObjs);
              categoryList2 = categoryListNew.toSet().toList();

              if (currentPage == 1) {
                List<Tab> tabss = <Tab>[];
                for (CategoryPharmacy parh in categoryList2) {
                  tabss.add(Tab(
                    text: parh.cat_name,
                  ));
                }
                tabs = tabss;
                tabController = TabController(length: tabs.length, vsync: this);
                tabController.addListener(() {
                  if (!tabController.indexIsChanging) {
                    setState(() {
                      categoryList3 = [];
                      categoryList3Search = [];
                      categoryList3 = categoryList
                          .where((element) =>
                              element.resturant_cat_id ==
                                  categoryList2[tabController.index]
                                      .resturant_cat_id &&
                              element.product_name != null)
                          .toList();
                      categoryList3Search = List.from(categoryList3);
                      setList(categoryList3);
                    });
                  }
                });
              }
              if (currentPage == 1) {
                categoryList3 = categoryList
                    .where((element) =>
                        element.resturant_cat_id ==
                        categoryList2[0].resturant_cat_id)
                    .toList();
              } else {
                List<CategoryPharmacy> list = categoryList
                    .where((element) =>
                        element.resturant_cat_id ==
                            categoryList2[tabController.index]
                                .resturant_cat_id &&
                        element.product_name != null)
                    .toList();
                categoryList3.addAll(list);
              }
              categoryList3Search = List.from(categoryList3);
              setList(categoryList3);

              isFetch = false;
              isFetchList = false;
            });
          } else {
            setState(() {
              isFetch = false;
              isFetchList = false;
            });
          }

          var pageInfoJson = jsonDecode(response.body)['page_info'];
          currentPage = pageInfoJson['page'];
          totalPage = pageInfoJson['total_page'];
        } else {
          setState(() {
            isFetch = false;
            isFetchList = false;
          });
        }
      } else {
        setState(() {
          isFetch = false;
          isFetchList = false;
        });
      }
    }).catchError((e) {
      print(e);
      setState(() {
        isFetch = false;
        isFetchList = false;
      });
    });
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

  void setList2() {
    if (searchController != null && searchController.text.length > 0) {
      setState(() {
        searchController.clear();
        categoryList3.clear();
        categoryList3 = List.from(categoryList3Search);
      });
    } else {
      setState(() {
        isSearchOpen = false;
        categoryList3.clear();
        categoryList3 = List.from(categoryList3Search);
      });
    }
  }

 /* // to show progressbar while loading data in background
  Widget _buildProgressIndicator() {
    return new Padding(
      padding: const EdgeInsets.all(8.0),
      child: new Center(
        child: new Opacity(
          opacity: isFetch ? 1.0 : 0.0,
          child: new CircularProgressIndicator(),
        ),
      ),
    );
  }*/

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return WillPopScope(
      onWillPop: () async {
        // bool valued = await handlePopBack();
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
                    height: 52,
                    padding: EdgeInsets.only(left: 5),
                    decoration: BoxDecoration(
                      color: scaffoldBgColor,
                      // borderRadius: BorderRadius.circular(50)
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
                        /* suffixIcon: IconButton(
                          onPressed: () {
                           */ /* setState(() {
                              isSearchOpen = !isSearchOpen;
                            });*/ /*

                          },
                          icon: Icon(
                            Icons.close,
                            color: kHintColor,
                          ),
                        ),*/
                      ),
                      cursorColor: kMainColor,
                      autofocus: false,
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SearchPage('["all"]', '3',
                                    '', widget.vendor_id, ''))).then((value) {
                          getCartCount();
                        });
                      },
                      /*onChanged: (value) {
                        setState(() {
                          categoryList3 = categoryList3Search
                              .where((element) => element.product_name
                              .toString()
                              .toLowerCase()
                              .contains(value.toLowerCase()))
                              .toList();
                        });
                      },*/
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
                          Text('${widget.vendorName}',
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
                              Expanded(
                                child: Text(
                                    '${locale.deliveryRangeText} - ${widget.deliveryRange} km',
                                    style:
                                        Theme.of(context).textTheme.overline),
                              ),
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
                              /* setState(() {
                              isSearchOpen = !isSearchOpen;
                            });*/
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SearchPage(
                                          '["all"]',
                                          'PHARMACY',
                                          '',
                                          widget.vendor_id,
                                          ''))).then((value) {
                                getCartCount();
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
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: <Widget>[
                    TabBar(
                      tabs: tabs,
                      isScrollable:
                          (categoryList2 != null && categoryList2.length > 3)
                              ? true
                              : false,
                      labelColor: kMainColor,
                      unselectedLabelColor: kLightTextColor,
                      controller: tabController,
                      indicatorColor:
                          (categoryList2 != null && categoryList2.length > 1)
                              ? kMainColor
                              : kWhiteColor,
                      indicatorPadding: EdgeInsets.symmetric(horizontal: 24.0),
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
                    physics: NeverScrollableScrollPhysics(),
                    controller: tabController,
                    children: tabs.map((Tab tab) {
                      return Column(
                        children: <Widget>[
                          // Positioned(
                          //     top: 0.0,
                          //     width: MediaQuery.of(context).size.width,
                          //     height: isCartCount
                          //         ? (MediaQuery.of(context).size.height - 190)
                          //         : (MediaQuery.of(context).size.height - 130),
                          //     child:
                          //         ),
                          Expanded(
                              child: (!isFetchList &&
                                      categoryList3 != null &&
                                      categoryList3.length > 0)
                                  ? /*ListView.separated(
                                          itemCount: categoryList3.length,
                                          itemBuilder: (context, index) {
                                            if (index ==
                                                (categoryList3.length - 1)) {
                                              print("index : " +
                                                  index.toString() +
                                                  "list : " +
                                                  categoryList3.length
                                                      .toString());
                                              if ((currentPage < totalPage) &&
                                                  !isFetch) {
                                                currentPage = currentPage + 1;
                                                hitPharmacyProductById(
                                                    categoryList2[
                                                            tabController.index]
                                                        .resturant_cat_id);
                                              }
                                            }*/
                                  LazyLoadScrollView(
                                      isLoading: isFetch,
                                      onEndOfPage: () => {
                                        currentPage = currentPage + 1,
                                        hitPharmacyProductById(
                                            categoryList2[tabController.index]
                                                .resturant_cat_id)
                                      },
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: categoryList3.length,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {},
                                            behavior: HitTestBehavior.opaque,
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Stack(
                                                  children: <Widget>[
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: <Widget>[
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 20.0,
                                                                  top: 30.0,
                                                                  right: 14.0),
                                                          child: (categoryList3 !=
                                                                      null &&
                                                                  categoryList3
                                                                          .length >
                                                                      0)
                                                              ? Container(
                                                                  height: 93.3,
                                                                  width: 93.3,
                                                                  child: Image
                                                                      .network(
                                                                    '${Uri.parse('${imageBaseUrl}${categoryList3[index].product_image}')}',
//                                scale: 2.5,
                                                                    height:
                                                                        93.3,
                                                                    width: 93.3,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                )
                                                              : Container(
                                                                  height: 93.3,
                                                                  width: 93.3,
                                                                  child: Image(
                                                                    image: AssetImage(
                                                                        'images/logos/logo_user1.png'),
                                                                    height:
                                                                        93.3,
                                                                    width: 93.3,
                                                                    fit: BoxFit
                                                                        .fill,
                                                                  ),
                                                                ),
                                                        ),
                                                        Expanded(
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: <Widget>[
                                                              Container(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        right:
                                                                            20),
                                                                child: Text(
                                                                    categoryList3[
                                                                            index]
                                                                        .product_name,
                                                                    style: bottomNavigationTextStyle.copyWith(
                                                                        fontSize:
                                                                            15)),
                                                              ),
                                                              SizedBox(
                                                                height: 8.0,
                                                              ),
                                                              Row(
                                                                crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                children: [
                                                                Text(
                                                                    '$currency ${(categoryList3[index].variant.length > 0) ? categoryList3[index].variant[categoryList3[index].selectPos].price : 0}',
                                                                    style: Theme.of(
                                                                        context)
                                                                        .textTheme
                                                                        .caption),
                                                                Positioned(
                                                                  height: 30,
                                                                  right: 20.0,
                                                                  bottom: 5,
                                                                  child: (categoryList3[
                                                                  index]
                                                                      .addOnQty ==
                                                                      0
                                                                      ? Container(
                                                                    height: 30.0,
                                                                    padding: EdgeInsets.only(right: 10),
                                                                    child: FlatButton(
                                                                      child: Text(
                                                                        locale
                                                                            .addText,
                                                                        style: Theme.of(
                                                                            context)
                                                                            .textTheme
                                                                            .caption
                                                                            .copyWith(
                                                                            color:
                                                                            kMainColor,
                                                                            fontWeight:
                                                                            FontWeight.bold),
                                                                      ),
                                                                      textTheme:
                                                                      ButtonTextTheme
                                                                          .accent,
                                                                      onPressed: () {
                                                                        setState(() {
                                                                          categoryList3[
                                                                          index]
                                                                              .addOnQty++;
                                                                          print(
                                                                              '${categoryList3[index].addOnQty}');
                                                                          addOrMinusProduct(
                                                                              categoryList3[index]
                                                                                  .product_name,
                                                                              categoryList3[index]
                                                                                  .variant[categoryList3[index]
                                                                                  .selectPos]
                                                                                  .unit,
                                                                              double.parse(
                                                                                  '${categoryList3[index].variant[categoryList3[index].selectPos].price}'),
                                                                              int.parse(
                                                                                  '${categoryList3[index].variant[categoryList3[index].selectPos].quantity}'),
                                                                              categoryList3[index]
                                                                                  .addOnQty,
                                                                              categoryList3[index]
                                                                                  .product_image,
                                                                              categoryList3[index]
                                                                                  .variant[categoryList3[index].selectPos]
                                                                                  .variant_id);
                                                                        });
                                                                      },
                                                                    ),
                                                                  )
                                                                      : Container(
                                                                    height: 30.0,
                                                                    margin: EdgeInsets.only(right: 10),
                                                                    padding: EdgeInsets
                                                                        .symmetric(
                                                                        horizontal:
                                                                        11.0),
                                                                    decoration:
                                                                    BoxDecoration(
                                                                      border: Border.all(
                                                                          color:
                                                                          kMainColor),
                                                                      borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                          30.0),
                                                                    ),
                                                                    child: Row(
                                                                      children: <
                                                                          Widget>[
                                                                        InkWell(
                                                                          onTap: () {
                                                                            setState(
                                                                                    () {
                                                                                  categoryList3[index]
                                                                                      .addOnQty--;
                                                                                  addOrMinusProduct(
                                                                                      categoryList3[index].product_name,
                                                                                      categoryList3[index].variant[categoryList3[index].selectPos].unit,
                                                                                      double.parse('${categoryList3[index].variant[categoryList3[index].selectPos].price}'),
                                                                                      int.parse('${categoryList3[index].variant[categoryList3[index].selectPos].quantity}'),
                                                                                      categoryList3[index].addOnQty,
                                                                                      categoryList3[index].product_image,
                                                                                      categoryList3[index].variant[categoryList3[index].selectPos].variant_id);
                                                                                });
                                                                          },
                                                                          child: Icon(
                                                                            Icons
                                                                                .remove,
                                                                            color:
                                                                            kMainColor,
                                                                            size:
                                                                            20.0,
                                                                            //size: 23.3,
                                                                          ),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                            8.0),
                                                                        Text(
                                                                            categoryList3[
                                                                            index]
                                                                                .addOnQty
                                                                                .toString(),
                                                                            style: Theme.of(
                                                                                context)
                                                                                .textTheme
                                                                                .caption),
                                                                        SizedBox(
                                                                            width:
                                                                            8.0),
                                                                        InkWell(
                                                                          onTap: () {
                                                                            setState(
                                                                                    () {
                                                                                  categoryList3[index]
                                                                                      .addOnQty++;
                                                                                  addOrMinusProduct(
                                                                                      categoryList3[index].product_name,
                                                                                      categoryList3[index].variant[categoryList3[index].selectPos].unit,
                                                                                      double.parse('${categoryList3[index].variant[categoryList3[index].selectPos].price}'),
                                                                                      int.parse('${categoryList3[index].variant[categoryList3[index].selectPos].quantity}'),
                                                                                      categoryList3[index].addOnQty,
                                                                                      categoryList3[index].product_image,
                                                                                      categoryList3[index].variant[categoryList3[index].selectPos].variant_id);
                                                                                });
                                                                          },
                                                                          child: Icon(
                                                                            Icons.add,
                                                                            color:
                                                                            kMainColor,
                                                                            size:
                                                                            20.0,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  )),
                                                                ),
                                                              ],),
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
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                                horizontal:
                                                                    12.0),
                                                        decoration:
                                                            BoxDecoration(
                                                          color:
                                                              kCardBackgroundColor,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      30.0),
                                                        ),
                                                        child: (categoryList3[index]
                                                                        .variant !=
                                                                    null &&
                                                                categoryList3[
                                                                            index]
                                                                        .variant
                                                                        .length >
                                                                    0)
                                                            ? DropdownButton<
                                                                    MedeniniVarient>(
                                                                underline:
                                                                    Container(
                                                                  height: 0.0,
                                                                  color:
                                                                      kCardBackgroundColor,
                                                                ),
                                                                value: categoryList3[
                                                                        index]
                                                                    .variant[categoryList3[
                                                                        index]
                                                                    .selectPos],
                                                                items: categoryList3[
                                                                        index]
                                                                    .variant
                                                                    .map((e) {
                                                                  return DropdownMenuItem<
                                                                      MedeniniVarient>(
                                                                    child: Text(
                                                                      '${e.quantity} ${e.unit}',
                                                                      style: Theme.of(
                                                                              context)
                                                                          .textTheme
                                                                          .caption,
                                                                    ),
                                                                    value: e,
                                                                  );
                                                                }).toList(),
                                                                onChanged:
                                                                    (vale) {
                                                                  setState(() {
                                                                    int indexd = categoryList3[
                                                                            index]
                                                                        .variant
                                                                        .indexOf(
                                                                            vale);
                                                                    if (indexd !=
                                                                        -1) {
                                                                      categoryList3[index]
                                                                              .selectPos =
                                                                          indexd;
                                                                      DatabaseHelper
                                                                          db =
                                                                          DatabaseHelper
                                                                              .instance;
                                                                      db
                                                                          .getVarientPharmaCount(categoryList3[index]
                                                                              .variant[categoryList3[index].selectPos]
                                                                              .variant_id)
                                                                          .then((value) {
                                                                        print(
                                                                            'print t val $value');
                                                                        if (value ==
                                                                            null) {
                                                                          setState(
                                                                              () {
                                                                            categoryList3[index].addOnQty =
                                                                                0;
                                                                          });
                                                                        } else {
                                                                          setState(
                                                                              () {
                                                                            categoryList3[index].addOnQty =
                                                                                value;
                                                                            isCartCount =
                                                                                true;
                                                                          });
                                                                        }
                                                                      });
                                                                      for (int j =
                                                                              0;
                                                                          j < categoryList3[index].addons.length;
                                                                          j++) {
                                                                        db.getPharmaCountAddon(categoryList3[index].addons[j].addon_id, categoryList3[index].variant[categoryList3[index].selectPos].variant_id).then(
                                                                            (valued) {
                                                                          if (valued != null &&
                                                                              valued > 0) {
                                                                            setState(() {
                                                                              categoryList3[index].addons[j].isAdd = true;
                                                                            });
                                                                          } else {
                                                                            setState(() {
                                                                              categoryList3[index].addons[j].isAdd = false;
                                                                            });
                                                                          }
                                                                        });
                                                                      }
                                                                    }
                                                                  });
                                                                })
                                                            : Text(''),
                                                      ),
                                                    ),

                                                  ],
                                                ),
                                                Visibility(
                                                  visible: (categoryList3[index]
                                                                  .addons !=
                                                              null &&
                                                          categoryList3[index]
                                                                  .addons
                                                                  .length >
                                                              0)
                                                      ? true
                                                      : false,
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 30,
                                                                bottom: 20,
                                                                top: 20),
                                                        child: Text(
                                                          locale.addonsText,
                                                          style: headingStyle,
                                                        ),
                                                      ),
                                                      ListView.separated(
                                                        itemCount:
                                                            categoryList3[index]
                                                                .addons
                                                                .length,
                                                        shrinkWrap: true,
                                                        primary: false,
                                                        itemBuilder:
                                                            (context, i) {
                                                          return Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    right: 30,
                                                                    left: 30),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: <
                                                                  Widget>[
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .start,
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .center,
                                                                  children: <
                                                                      Widget>[
                                                                    InkWell(
                                                                      onTap:
                                                                          () async {
                                                                        print(
                                                                            '${categoryList3[index].addOnQty}');
                                                                        if (categoryList3[index].addOnQty >
                                                                            0) {
                                                                          DatabaseHelper
                                                                              db =
                                                                              DatabaseHelper.instance;
                                                                          db.getPharmaCountAddon('${categoryList3[index].addons[i].addon_id}', '${categoryList3[index].variant[categoryList3[index].selectPos].variant_id}').then(
                                                                              (value) {
                                                                            print('addon countv $value');
                                                                            if (value != null &&
                                                                                value > 0) {
                                                                              deleteAddOn(index, i, db);
                                                                            } else {
                                                                              var vae = {
                                                                                DatabaseHelper.varientId: '${categoryList3[index].variant[categoryList3[index].selectPos].variant_id}',
                                                                                DatabaseHelper.addonid: '${categoryList3[index].addons[i].addon_id}',
                                                                                DatabaseHelper.price: categoryList3[index].addons[i].addon_price,
                                                                                DatabaseHelper.addonName: categoryList3[index].addons[i].addon_name
                                                                              };
                                                                              db.insertPharmaAddOn(vae).then((value) {
                                                                                print('addon add $value');
                                                                                if (value != null && value > 0) {
                                                                                  setState(() {
                                                                                    categoryList3[index].addons[i].isAdd = true;
                                                                                  });
                                                                                  getCatC();
                                                                                } else {
                                                                                  setState(() {
                                                                                    categoryList3[index].addons[i].isAdd = false;
                                                                                  });
                                                                                  getCatC();
                                                                                }
                                                                                return value;
                                                                              }).catchError((e) {
                                                                                return null;
                                                                              });
                                                                            }
                                                                          }).catchError(
                                                                              (e) {
                                                                            print(e);
                                                                          });
                                                                        } else {
                                                                          Toast.show(
                                                                              locale.addonsaddproductText,
                                                                              context,
                                                                              duration: Toast.LENGTH_SHORT);
                                                                        }
                                                                      },
                                                                      child:
                                                                          Container(
                                                                        width:
                                                                            26.0,
                                                                        height:
                                                                            26.0,
                                                                        decoration: BoxDecoration(
                                                                            color: (categoryList3[index].addons[i].isAdd)
                                                                                ? kMainColor
                                                                                : kWhiteColor,
                                                                            borderRadius:
                                                                                BorderRadius.circular(13.0),
                                                                            border: Border.all(width: 1.0, color: kHintColor.withOpacity(0.7))),
                                                                        child: Icon(
                                                                            Icons
                                                                                .check,
                                                                            color:
                                                                                kWhiteColor,
                                                                            size:
                                                                                15.0),
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                        width:
                                                                            10.0),
                                                                    Text(
                                                                      '${categoryList3[index].addons[i].addon_name}',
                                                                      style:
                                                                          listItemTitleStyle,
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  '${currency} ${categoryList3[index].addons[i].addon_price}',
                                                                  style:
                                                                      listItemTitleStyle,
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        separatorBuilder:
                                                            (context, d) {
                                                          return Divider(
                                                            color:
                                                                kCardBackgroundColor,
                                                            thickness: 6.7,
                                                          );
                                                        },
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Divider(
                                                  color: kCardBackgroundColor,
                                                  thickness: 4.0,
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                        /* separatorBuilder: (context, index) {
                                            return SizedBox(
                                              height: 5,
                                            );
                                          },*/
                                      ),
                                    )
                                  : Container(
                                      height:
                                          MediaQuery.of(context).size.height /
                                              2,
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
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
                                    )),
                          // Positioned(
                          //   bottom: 0.0,
                          //   width: MediaQuery.of(context).size.width,
                          //   child: ,
                          // )
                          /* Container(
                            alignment: Alignment.centerRight,
                            padding: EdgeInsets.only(right: 20),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (context) {
                                  return UploadPrescription(widget.vendor_id);
                                }));
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(40),
                                clipBehavior: Clip.hardEdge,
                                child: Container(
                                  height: 70,
                                  width: 70,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40), color: kMainColor),
                                  child: Icon(
                                    Icons.camera_enhance_outlined,
                                    size: 35,
                                    color: kWhiteColor,
                                  ),
                                ),
                              ),
                            ),
                          ),*/
                          Container(
                            height: 15,
                          ),
                          Visibility(
                            visible: isCartCount,
                            child: Align(
                              alignment: Alignment.bottomCenter,
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
                                    FlatButton(
                                      color: Colors.white,
                                      onPressed: () =>
                                          hitViewCart(context, locale),
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
                            ),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void deleteAddOn(parentindex, childindex, DatabaseHelper db) async {
    await db
        .deleteAddOnIdPharmaWithVid(
            '${categoryList3[parentindex].addons[childindex].addon_id}',
            '${categoryList3[parentindex].variant[categoryList3[parentindex].selectPos].variant_id}')
        .then((value) {
      print('addon delete $value');
      if (value != null && value > 0) {
        setState(() {
          categoryList3[parentindex].addons[childindex].isAdd = false;
        });
      } else {
        setState(() {
          categoryList3[parentindex].addons[childindex].isAdd = true;
        });
      }
      getCatC();
    }).catchError((e) {
      print(e);
    });
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
        setList(categoryList3);
        getCartCount();
      });
    } else {
      Toast.show(locale.noValueCartText, context, duration: Toast.LENGTH_SHORT);
    }
  }

  void setList(List<CategoryPharmacy> tagObjs) {
    for (int i = 0; i < tagObjs.length; i++) {
      if (tagObjs[i].variant.length > 0) {
        DatabaseHelper db = DatabaseHelper.instance;
        db
            .getVarientPharmaCount(
                tagObjs[i].variant[tagObjs[i].selectPos].variant_id)
            .then((value) {
          if (value == null) {
            setState(() {
              tagObjs[i].addOnQty = 0;
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
}
