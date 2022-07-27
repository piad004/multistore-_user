import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';
import 'package:toast/toast.dart';
import 'package:user/HomeOrderAccount/Home/UI/slide_up_panel.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/orderbean.dart';
import 'package:user/cancelproduct/cancelproduct.dart';
import 'package:http/http.dart' as http;

class OrderMapPage extends StatelessWidget {
  final String instruction;
  final String pageTitle;
  final OngoingOrders ongoingOrders;
  final dynamic currency;

  OrderMapPage(
      {this.instruction, this.pageTitle, this.ongoingOrders, this.currency});

  @override
  Widget build(BuildContext context) {
    return OrderMap(pageTitle, ongoingOrders, currency);
  }
}

class OrderMap extends StatefulWidget {
  final String pageTitle;
  final OngoingOrders ongoingOrders;
  final dynamic currency;

  OrderMap(this.pageTitle, this.ongoingOrders, this.currency);

  @override
  _OrderMapState createState() => _OrderMapState();
}

class _OrderMapState extends State<OrderMap> {
  bool showAction = false;
  bool isFetch = true;

  @override
  void initState() {
    super.initState();
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
            'Order #${widget.ongoingOrders.cart_id}',
            style: TextStyle(
                fontSize: 18, color: black_color, fontWeight: FontWeight.w400),
          ),
          actions: [
            Visibility(
              visible: (widget.ongoingOrders.order_status == 'Pending' ||
                      widget.ongoingOrders.order_status == 'Confirmed')
                  ? true
                  : false,
              child: Padding(
                padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (context) {
                      return CancelProduct(widget.ongoingOrders.cart_id);
                    })).then((value) {
                      if (value != null) {
                        setState(() {
                          widget.ongoingOrders.order_status = "Cancelled";
                        });
                      }
                    });
                  },
                  child: Text(
                    locale.cancel,
                    style: TextStyle(
                        color: kWhiteColor, fontWeight: FontWeight.w400),
                  ),
                  color: kMainColor,
                  highlightColor: kMainColor,
                  focusColor: kMainColor,
                  splashColor: kMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            ),
            Visibility(
              visible: ('${widget.ongoingOrders.order_status}'.toUpperCase() ==
                      'COMPLETED')
                  ? true
                  : false,
              child: Padding(
                padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(PageRoutes.invoice, arguments: {
                          'inv_details': widget.ongoingOrders,
                        })
                        .then((value) {})
                        .catchError((e) {});
                  },
                  child: Text(
                    locale.invoiceprint,
                    style: TextStyle(
                        color: kWhiteColor, fontWeight: FontWeight.w400),
                  ),
                  color: kMainColor,
                  highlightColor: kMainColor,
                  focusColor: kMainColor,
                  splashColor: kMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                Image.asset(
                  'images/map.png',
                  width: MediaQuery.of(context).size.width,
                  height: (MediaQuery.of(context).size.height)-120,
                  fit: BoxFit.fitWidth,
                ),
                Positioned(
                  top: 0.0,
                  width: MediaQuery.of(context).size.width,
                  child: Container(
                    color: white_color,
                    width: MediaQuery.of(context).size.width,
                    child: PreferredSize(
                      preferredSize: Size.fromHeight(0.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.only(left: 16.3),
                                child: Image.asset(
                                  'images/maincategory/vegetables_fruitsact.png',
                                  height: 42.3,
                                  width: 33.7,
                                ),
                              ),
                              Expanded(
                                child: ListTile(
                                  title: Text(
                                    '${widget.ongoingOrders.vendor_name}',
                                    style: orderMapAppBarTextStyle.copyWith(
                                        letterSpacing: 0.07),
                                  ),
                                  subtitle: Text(
                                    (widget.ongoingOrders.delivery_date !=
                                                "null" &&
                                            widget.ongoingOrders.time_slot !=
                                                "null" &&
                                            widget.ongoingOrders
                                                    .delivery_date !=
                                                null &&
                                            widget.ongoingOrders.time_slot !=
                                                null)
                                        ? '${widget.ongoingOrders.delivery_date} | ${widget.ongoingOrders.time_slot}'
                                        : '',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headline6
                                        .copyWith(
                                            fontSize: 11.7,
                                            letterSpacing: 0.06,
                                            color: Color(0xffc1c1c1)),
                                  ),
                                  trailing: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Text(
                                        '${widget.ongoingOrders.order_status}',
                                        style: orderMapAppBarTextStyle.copyWith(
                                            color: kMainColor),
                                      ),
                                      SizedBox(height: 7.0),
                                      Text(
                                        '${widget.ongoingOrders.data.length} items | ${widget.currency} ${widget.ongoingOrders.price}',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline6
                                            .copyWith(
                                                fontSize: 11.7,
                                                letterSpacing: 0.06,
                                                color: Color(0xffc1c1c1)),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          Divider(
                            color: kCardBackgroundColor,
                            thickness: 1.0,
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 36.0,
                                    bottom: 6.0,
                                    top: 6.0,
                                    right: 12.0),
                                child: ImageIcon(
                                  AssetImage(
                                      'images/custom/ic_pickup_pointact.png'),
                                  size: 13.3,
                                  color: kMainColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${widget.ongoingOrders.vendor_name}\t',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          fontSize: 10.0, letterSpacing: 0.05),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 36.0,
                                    bottom: 12.0,
                                    top: 12.0,
                                    right: 12.0),
                                child: ImageIcon(
                                  AssetImage(
                                      'images/custom/ic_droppointact.png'),
                                  size: 13.3,
                                  color: kMainColor,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  '${widget.ongoingOrders.address}\t',
                                  style: Theme.of(context)
                                      .textTheme
                                      .caption
                                      .copyWith(
                                          fontSize: 10.0, letterSpacing: 0.05),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SlideUpPanel(widget.ongoingOrders, widget.currency),
              ],
            ),
          ),
          Container(
            height: 60.0,
            color: kCardBackgroundColor,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '${widget.ongoingOrders.data.length} items  |  ${widget.currency} ${widget.ongoingOrders.price}',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                ),
                Visibility(
                  visible:
                      ('${widget.ongoingOrders.order_status}'.toUpperCase() ==
                              'COMPLETED')
                          ? true
                          : false,
                  child: Padding(
                    padding: EdgeInsets.only( top: 10, bottom: 10),
                    child: RaisedButton(
                      onPressed: () {
                        _showRatingDialog(widget.ongoingOrders.cart_id,widget.ongoingOrders.vendor_id,widget.ongoingOrders.delivery_boy_id,
                        widget.ongoingOrders.reviewRatingVendor,widget.ongoingOrders.reviewRatingDelvboy);
                       /* Navigator.of(context)
                            .pushNamed(PageRoutes.invoice, arguments: {
                              'inv_details': widget.ongoingOrders,
                            })
                            .then((value) {})
                            .catchError((e) {});*/
                      },
                      child: Text(
                        'Rating',
                        style: TextStyle(
                            color: kWhiteColor, fontWeight: FontWeight.w400),
                      ),
                      color: kMainColor,
                      highlightColor: kMainColor,
                      focusColor: kMainColor,
                      splashColor: kMainColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Future<void> _showRatingDialog(var cartId, var vendorId, var deliveryBoyId,
      ReviewRatingVendor reviewRatingVendor, ReviewRatingDelvboy reviewRatingDelvboy) async {
    var rating=0.0;
    var review="";
    var dBoyRating=0.0;
    var dBoyReview="";
    var isVisible=true;
    if(reviewRatingVendor.review != null) {
      review = reviewRatingVendor.review;
      isVisible=false;
    }
    if(reviewRatingVendor.rating != null){
      rating = (reviewRatingVendor.rating).toDouble();
    isVisible=false;
  }
    if(reviewRatingDelvboy.review != null){
      dBoyReview = reviewRatingDelvboy.review;
    isVisible=false;
  }
    if(reviewRatingDelvboy.rating != null){
      dBoyRating = (reviewRatingDelvboy.rating).toDouble();
    isVisible=false;
  }

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0)), //this right here
            child: Container(
              height: 500,
              child: Padding(
                padding: const EdgeInsets.only(left:12.0,right: 12,bottom: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Vendor Rating',style: TextStyle(color: Colors.green,fontSize: 16,
                      fontWeight: FontWeight.bold, ),),
                /*SizedBox(
                  height: 10,
                ),*/
                TextFormField(
                  minLines: 4,
                      maxLines: 4,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                         // hintText: 'Review',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: 'Review',
                      ),
                      initialValue: review,
                      //validator: widget.ongoingOrders,
                      onChanged: (String newValue) {
                        review=newValue;
                      },
                ),
                   /* SizedBox(
                      height: 10,
                    ),*/
                    Container(
                      child:  SmoothStarRating(
                        rating: rating,
                        size: 45,
                        starCount: 5,
                        onRated:(value) {
                          setState(() {
                            rating = value;
                          });
                        },
                      )),
                    SizedBox(
                      height: 5,
                    ),
                    Container(color: kMainColor,
                    width: MediaQuery.of(context).size.width-80,
                    height: 1,),
                    SizedBox(
                  height: 5,
                ),
                    Text('Delivery Boy Rating',style: TextStyle(color: Colors.green,fontSize: 16,
                      fontWeight: FontWeight.bold, ),),
                TextFormField(
                  minLines: 4,
                      maxLines: 4,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.all(Radius.circular(5.0)),
                              borderSide: BorderSide(color: Colors.blue)),
                         // hintText: 'Review',
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5.0)),
                          borderSide: BorderSide(color: Colors.blue)),
                        filled: true,
                        contentPadding:
                        EdgeInsets.only(bottom: 10.0, left: 10.0, right: 10.0),
                        labelText: 'Review',
                      ),
                      //validator: widget.ongoingOrders,
                  initialValue: dBoyReview,
                      onChanged: (String newValue) {
                        dBoyReview=newValue;
                      },
                ),
                   /* SizedBox(
                      height: 10,
                    ),*/
                    Container(
                      child:  SmoothStarRating(
                        rating: rating,
                        size: 45,
                        starCount: 5,
                        onRated:(value) {
                          setState(() {
                            dBoyRating = value;
                          });
                        },
                      )),
                    Visibility(
                      visible: isVisible,
                        child: SizedBox(
                      width: 320.0,
                      height: 40,
                      child: RaisedButton(
                        onPressed: () {
                          getReviewOrders(cartId,vendorId,review,dBoyReview,rating,dBoyRating,deliveryBoyId);
                        },
                        child: Text(
                          "Save",
                          style: TextStyle(color: Colors.white),
                        ),
                        color: const Color(0xFF1BC0C5),
                      ),
                    )
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  getReviewOrders(var cartId,var vendorId,var review,var dBoyReview,var rating,var dBoyRating,var dboyId) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var userId = preferences.getInt('user_id');
    var url = ratingOrders;
    http.post(url, body: {'user_id': '$userId','cart_id': '$cartId',
      'vendor_id': '$vendorId','vreview': '$review','vrating': '$rating',
      'dreview': '$dBoyReview','drating': '$dBoyRating',
      'dboy_id': '$dboyId'}).then((value) {
      print('${value.body}');
        //{"status":"1","message":"Thanks you for feedback."}
      var body = value.body;
        var jsonData = jsonDecode(value.body);
        if (value.statusCode == 200 && value.body != null && jsonData['status'] == "1") {
          Toast.show(jsonData['message'], context,
              duration: Toast.LENGTH_LONG);
        setState(() {
          isFetch = false;
        });
      }
      Navigator.pop(context);
    }).catchError((e) {
      Navigator.pop(context);
        setState(() {
          isFetch = false;
        });
      print(e);
    });
  }
}
