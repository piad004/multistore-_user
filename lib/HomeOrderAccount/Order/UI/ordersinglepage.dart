import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/orderbean.dart';

class SingleOrderPage extends StatefulWidget {
  final OngoingOrders ongoingOrders;

  SingleOrderPage(this.ongoingOrders);

  @override
  State<StatefulWidget> createState() {
    return SingleOrderPageState(ongoingOrders);
  }
}

class SingleOrderPageState extends State<SingleOrderPage> {
  final OngoingOrders ongoingOrders;

  SingleOrderPageState(this.ongoingOrders);

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Container(
          width: MediaQuery.of(context).size.width - 100,
          child: Text(
            'Order #${ongoingOrders.cart_id}',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyText1
                .copyWith(color: kMainTextColor.withOpacity(0.8)),
          ),
        ),
      ),
      body: SingleChildScrollView(
        primary: true,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              (ongoingOrders.data != null && ongoingOrders.data.length > 0)
                  ? ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemBuilder: (context, t) {
                        return Material(
                          borderRadius: BorderRadius.circular(10),
                          elevation: 3,
                          clipBehavior: Clip.hardEdge,
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: kWhiteColor),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Image.network(
                                  imageBaseUrl +
                                      ongoingOrders.data[t].varient_image,
                                  height: 90,
                                  width: 90,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Container(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${ongoingOrders.data[t].product_name}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600,
                                            color: kMainTextColor),
                                      ),
                                      SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            'Rs. ${ongoingOrders.data[t].price}',
                                            textAlign: TextAlign.start,
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            'Rs. ${ongoingOrders.data[t].total_mrp}',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.lineThrough),
                                          )
                                        ],
                                      ),
                                      Text(
                                        '${ongoingOrders.data[t].quantity} ${ongoingOrders.data[t].unit}',
                                        textAlign: TextAlign.start,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: kMainTextColor),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, t2) {
                        return Container(
                          height: 5,
                          margin: EdgeInsets.symmetric(horizontal: 10),
                        );
                      },
                      itemCount: ongoingOrders.data.length)
                  : Container(
                      child: Text(locale.noItemAssociatedWithThisOrder),
                    ),
              SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.orderDate,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                  Text(
                    '${ongoingOrders.delivery_date}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.orderStatus,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                  Text(
                    '${ongoingOrders.order_status}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.paymentMethod,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                  Text(
                    '${ongoingOrders.payment_method}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                   locale.paymentStatus,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                  Text(
                    '${ongoingOrders.payment_status}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.timeSlot,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                  Text(
                    '${ongoingOrders.time_slot}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    locale.orderAmt,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                  Text(
                    'Rs. ${ongoingOrders.price}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.deliveryCharge,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: kHintColor),
                    ),
                    Text(
                      '${ongoingOrders.delivery_charge}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: kHintColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.couponDiscount,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: kHintColor),
                    ),
                    Text(
                      '- ${ongoingOrders.coupon_discount}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: kHintColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      locale.paidByWallet,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: kHintColor),
                    ),
                    Text(
                      '${ongoingOrders.paid_by_wallet}',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: kHintColor),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Charges To be paid',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                  Text(
                    '${ongoingOrders.remaining_amount}',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w400,
                        color: kMainTextColor),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Visibility(
                visible: ('${ongoingOrders.order_status}'
                    .toUpperCase() ==
                    'COMPLETED'),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding:
                    const EdgeInsets.only(top: 8.0),
                    child: RaisedButton(
                      child: Text(
                        'Invoice',
                        style: TextStyle(
                            color: kWhiteColor,
                            fontSize: 14,
                            fontWeight:
                            FontWeight.w400),
                      ),
                      color: kMainColor,
                      highlightColor: kMainColor,
                      focusColor: kMainColor,
                      splashColor: kMainColor,
                      padding: EdgeInsets.symmetric(
                          vertical: 8, horizontal: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(30.0),
                      ),
                      onPressed: () {

                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
