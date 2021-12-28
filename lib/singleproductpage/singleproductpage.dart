import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/productlistvarient.dart';
import 'package:user/databasehelper/dbhelper.dart';

class SingleProductPage extends StatefulWidget {
  final ProductWithVarient productWithVarient;
  final dynamic currency;
  List<VarientList> productVarintList = [];

  SingleProductPage(this.productWithVarient, this.currency) {
    productVarintList = List.from(productWithVarient.data);
  }

  @override
  State<StatefulWidget> createState() {
    return SingleProductState(productVarintList);
  }
}

class SingleProductState extends State<SingleProductPage> {
  var currentIndex = 0;

  bool isCartCount = false;

  var cartCount = 0;

  SingleProductState(List<VarientList> productVarintList) {
    setList(productVarintList);
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
            isCartCount = true;
          });
        }
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCartCount();
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
            '${widget.productWithVarient.product_name}',
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
                          Navigator.pushNamed(context, PageRoutes.viewCart)
                              .then((value) {
                            setList(widget.productVarintList);
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
        ),
      ),
      body: Column(
        children: [
          Expanded(
              flex: 4,
              child: Container(
                alignment: Alignment.center,
                child:
                    Padding(
                  padding: EdgeInsets.only(bottom: 10.0),
                  child: Image(
                    image: NetworkImage(imageBaseUrl +
                        widget.productWithVarient.products_image),
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
                  )
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
                    ProductDescription(
                        widget.productWithVarient.data[0].description),
                    (widget.productVarintList.length > 0)
                        ? ListView.builder(
                            itemCount: widget.productVarintList.length,
                            itemBuilder: (context, index) {
                              return Stack(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Padding(
                                        padding: EdgeInsets.only(
                                            left: 20.0, top: 30.0, right: 14.0),
                                        child: Container(
                                          height: 93.3,
                                          width: 93.3,
                                          child:
                                          (widget.productVarintList != null &&
                                              widget.productVarintList
                                                  .length >
                                                  0)
                                              ? Image.network(
                                            imageBaseUrl +
                                                widget
                                                    .productVarintList[
                                                index]
                                                    .varient_image,
//                                scale: 2.5
                                            height: 93.3,
                                            width: 93.3,
                                            fit: BoxFit.fill,
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
                                              padding:
                                                  EdgeInsets.only(right: 20),
                                              child: Text(
                                                  widget.productWithVarient
                                                      .product_name,
                                                  style:
                                                      bottomNavigationTextStyle
                                                          .copyWith(
                                                              fontSize: 15)),
                                            ),
                                            SizedBox(
                                              height: 8.0,
                                            ),
                                            Text(
                                                '${widget.currency} ${widget.productVarintList[index].price}',
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
                                    child: InkWell(
                                      onTap: () {},
                                      child: Container(
                                        height: 30.0,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20.0),
                                        decoration: BoxDecoration(
                                          color: kCardBackgroundColor,
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              '${widget.productVarintList[index].quantity} ${widget.productVarintList[index].unit}',
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .caption,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                      height: 30,
                                      right: 20.0,
                                      bottom: 5,
                                      child: widget.productVarintList[index]
                                                  .add_qnty ==
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
                                                        '${widget.productVarintList[index].stock}');
                                                    if (stock >
                                                        widget
                                                            .productVarintList[
                                                                index]
                                                            .add_qnty) {
                                                      widget
                                                          .productVarintList[
                                                              index]
                                                          .add_qnty++;
                                                      addOrMinusProduct(
                                                          widget
                                                              .productWithVarient
                                                              .product_name,
                                                          widget
                                                              .productVarintList[
                                                                  index]
                                                              .unit,
                                                          double.parse(
                                                              '${widget.productVarintList[index].price}'),
                                                          int.parse(
                                                              '${widget.productVarintList[index].quantity}'),
                                                          widget
                                                              .productVarintList[
                                                                  index]
                                                              .add_qnty,
                                                          widget
                                                              .productVarintList[
                                                                  index]
                                                              .varient_image,
                                                          widget
                                                              .productVarintList[
                                                                  index]
                                                              .varient_id);
                                                    } else {
                                                      Toast.show(
                                                          locale.noMoreStockAvailable,
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
                                                        widget
                                                            .productVarintList[
                                                                index]
                                                            .add_qnty--;
                                                      });
                                                      addOrMinusProduct(
                                                          widget
                                                              .productWithVarient
                                                              .product_name,
                                                          widget
                                                              .productVarintList[
                                                                  index]
                                                              .unit,
                                                          double.parse(
                                                              '${widget.productVarintList[index].price}'),
                                                          int.parse(
                                                              '${widget.productVarintList[index].quantity}'),
                                                          widget
                                                              .productVarintList[
                                                                  index]
                                                              .add_qnty,
                                                          widget
                                                              .productVarintList[
                                                                  index]
                                                              .varient_image,
                                                          widget
                                                              .productVarintList[
                                                                  index]
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
                                                      widget
                                                          .productVarintList[
                                                              index]
                                                          .add_qnty
                                                          .toString(),
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .caption),
                                                  SizedBox(width: 8.0),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        var stock = int.parse(
                                                            '${widget.productVarintList[index].stock}');
                                                        if (stock >
                                                            widget
                                                                .productVarintList[
                                                                    index]
                                                                .add_qnty) {
                                                          widget
                                                              .productVarintList[
                                                                  index]
                                                              .add_qnty++;
                                                          addOrMinusProduct(
                                                              widget
                                                                  .productWithVarient
                                                                  .product_name,
                                                              widget
                                                                  .productVarintList[
                                                                      index]
                                                                  .unit,
                                                              double.parse(
                                                                  '${widget.productVarintList[index].price}'),
                                                              int.parse(
                                                                  '${widget.productVarintList[index].quantity}'),
                                                              widget
                                                                  .productVarintList[
                                                                      index]
                                                                  .add_qnty,
                                                              widget
                                                                  .productVarintList[
                                                                      index]
                                                                  .varient_image,
                                                              widget
                                                                  .productVarintList[
                                                                      index]
                                                                  .varient_id);
                                                        } else {
                                                          Toast.show(
                                                              locale.noMoreStockAvailable,
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
//    addMinus = true;
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
        DatabaseHelper.varientId: int.parse('${varient_id}')
      };
      if (value == 0) {
        db.insert(vae);
      } else {
        if (itemCount == 0) {
          db.delete(int.parse('${varient_id}'));
        } else {
          db.updateData(vae, int.parse('${varient_id}')).then((vay) {
            print('vay - $vay');
          });
        }
      }
      getCartCount();
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
