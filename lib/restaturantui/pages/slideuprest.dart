import 'package:flutter/material.dart';
import 'package:toast/toast.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/bean/resturantbean/orderhistorybean.dart';

class SlideUpPanelRest extends StatefulWidget {
  final OrderHistoryRestaurant ongoingOrders;
  final dynamic currency;

  SlideUpPanelRest(this.ongoingOrders, this.currency);

  @override
  _SlideUpPanelRestState createState() => _SlideUpPanelRestState();
}

class _SlideUpPanelRestState extends State<SlideUpPanelRest> {
//  List<String> weight = [
//    '1kg x 1',
//    '1kg x 1',
//    '1kg x 1',
//  ];
//  List<double> prices = [
//    3.00,
//    4.50,
//    2.50,
//  ];
//
//  double sum() {
//    double total = 0.00;
//    for (int i = 0; i < prices.length; i++) {
//      total += prices[i];
//    }
//    return total;
//  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    return DraggableScrollableSheet(
      minChildSize: 0.20,
      initialChildSize: 0.20,
      maxChildSize: 1.0,
      builder: (context, controller) {
        return Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(left: 4.0),
          color: kCardBackgroundColor,
          child: SingleChildScrollView(
            controller: controller,
            child: Container(
              child: Column(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.white,
                    child: Stack(
                      children: <Widget>[
                        Hero(
                          tag: locale.deliveryBoy,
                          child: Padding(
                            padding: EdgeInsets.only(bottom: 10.0, top: 14.0),
                            child: ListTile(
                              leading: CircleAvatar(
                                radius: 22.0,
                                backgroundImage:
                                AssetImage('images/profile.png'),
                              ),
                              title: Text(
                                widget.ongoingOrders.delivery_boy_name != null
                                    ? '${widget.ongoingOrders.delivery_boy_name}'
                                    : locale.deliveryBoyNotAssignYet,
                                style: Theme.of(context).textTheme.headline4,
                              ),
                              subtitle: Text(
                                locale.deliveryPartner,
                                style: Theme.of(context)
                                    .textTheme
                                    .headline6
                                    .copyWith(
                                    fontSize: 11.7,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xffc2c2c2)),
                              ),
                              trailing: FittedBox(
                                fit: BoxFit.fill,
                                child: Row(
                                  children: <Widget>[
//                                    IconButton(
//                                      icon: Icon(Icons.message,
//                                          color: kMainColor),
//                                      onPressed: () {
//                                        Navigator.pushNamed(
//                                            context, PageRoutes.chatPage);
//                                      },
//                                    ),
                                    IconButton(
                                      icon:
                                      Icon(Icons.phone, color: kMainColor),
                                      onPressed: () {
                                        if (widget.ongoingOrders
                                            .delivery_boy_phone !=
                                            null &&
                                            widget.ongoingOrders
                                                .delivery_boy_phone
                                                .toString()
                                                .length >
                                                5) {
                                          /*_launchURL(
                                              "tel://${widget.ongoingOrders.delivery_boy_phone}");*/
                                          _launchURL("${widget.ongoingOrders.delivery_boy_phone}");
                                        } else {
                                          Toast.show(
                                              locale.deliveryBoyNotAssignYet,
                                              context,
                                              duration: Toast.LENGTH_SHORT);
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Center(
                          child: Hero(
                            tag: locale.arrow,
                            child: Icon(
                              Icons.keyboard_arrow_up,
                              color: kMainColor,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 6.0),
                  ListView.builder(
                    shrinkWrap: true,
                    primary: false,
                    itemCount: widget.ongoingOrders.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        color: Colors.white,
                        child: ListTile(
                          title: Text(
                            widget.ongoingOrders.data[index].product_name,
                            style: Theme.of(context)
                                .textTheme
                                .headline4
                                .copyWith(
                                fontWeight: FontWeight.w500,
                                fontSize: 15.0),
                          ),
                          subtitle: Text(
                            '${widget.ongoingOrders.data[index].quantity} ${widget.ongoingOrders.data[index].unit} x ${widget.ongoingOrders.data[index].qty}',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 13.3),
                          ),
                          trailing: Text(
                            '${widget.currency} ${widget.ongoingOrders.data[index].price}',
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 13.3),
                          ),
                        ),
                      );
                    },
                  ),
//                  SizedBox(height: 6.0),
//                  Container(
//                    padding: EdgeInsets.symmetric(horizontal: 8.0),
//                    color: Colors.white,
//                    child: EntryField(
//                      image: 'images/custom/ic_instruction.png',
//                      initialValue: 'Keep tomatoes in separate bag please.',
//                      readOnly: true,
//                      border: InputBorder.none,
//                    ),
//                  ),
                  SizedBox(height: 6.0),
                  Container(
                    width: double.infinity,
                    padding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Text(locale.paymentInfo,
                        style: Theme.of(context).textTheme.headline4.copyWith(
                            color: kDisabledColor,
                            fontSize: 13.3,
                            letterSpacing: 0.67)),
                    color: Colors.white,
                  ),
                  Container(
                    color: Colors.white,
                    padding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            locale.subTotal,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            '${widget.currency} ${widget.ongoingOrders.price}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ]),
                  ),
                  Container(
                    color: Colors.white,
                    padding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            locale.deliveryCharge,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            '${widget.currency} ${widget.ongoingOrders.del_charge}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ]),
                  ),
                  Container(
                    color: Colors.white,
                    padding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            locale.couponDiscount,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            '- ${widget.currency} ${widget.ongoingOrders.coupon_discount}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ]),
                  ),
                  Container(
                    color: Colors.white,
                    padding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            locale.paidByWallet,
                            style: Theme.of(context).textTheme.caption,
                          ),
                          Text(
                            '${widget.currency} ${widget.ongoingOrders.paid_by_wallet}',
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ]),
                  ),
                  Container(
                    color: Colors.white,
                    padding:
                    EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                    child: (widget.ongoingOrders.payment_method == "Card" ||
                        widget.ongoingOrders.payment_method == "Wallet")
                        ? Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            locale.paymentStatus,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            '${widget.ongoingOrders.payment_status}',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ])
                        : Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            locale.cashOnDelivery,
                            style: Theme.of(context).textTheme.headline4,
                          ),
                          Text(
                            '${widget.currency} ${widget.ongoingOrders.remaining_amount}',
                            style: Theme.of(context).textTheme.headline4,
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  _launchURL(url) async {
   /* if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }*/
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: url,
    );
    await launch(launchUri.toString());
  }
}
