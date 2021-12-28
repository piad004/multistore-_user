import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/style.dart';
import 'package:user/parcel/parcelcancel.dart';
import 'package:user/parcel/pharmacybean/parcelorderhistorybean.dart';
import 'package:user/parcel/slideupparcel.dart';
import 'package:user/Routes/routes.dart';

class OrderMapParcelPage extends StatelessWidget {
  final String instruction;
  final String pageTitle;
  final TodayOrderParcel ongoingOrders;
  final dynamic currency;

  OrderMapParcelPage(
      {this.instruction, this.pageTitle, this.ongoingOrders, this.currency});

  @override
  Widget build(BuildContext context) {
    return OrderMapParcel(pageTitle, ongoingOrders, currency);
  }
}

class OrderMapParcel extends StatefulWidget {
  final String pageTitle;
  final TodayOrderParcel ongoingOrders;
  final dynamic currency;

  OrderMapParcel(this.pageTitle, this.ongoingOrders, this.currency);

  @override
  _OrderMapParcelState createState() => _OrderMapParcelState();
}

class _OrderMapParcelState extends State<OrderMapParcel> {
  bool showAction = false;

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
          title: Text(locale.order+""+widget.ongoingOrders.cart_id,
           // 'Order #${widget.ongoingOrders.cart_id}',
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
                      return CancelParcel(widget.ongoingOrders.cart_id);
                    })).then((value){
                      if(value){
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
              visible: ('${widget.ongoingOrders.order_status}'.toUpperCase() == 'COMPLETED')
                  ? true
                  : false,
              child: Padding(
                padding: EdgeInsets.only(right: 10, top: 10, bottom: 10),
                child: RaisedButton(
                  onPressed: () {
                    Navigator.of(context)
                        .pushNamed(
                        PageRoutes.invoiceparcel,
                        arguments: {
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
                                    (widget.ongoingOrders.pickup_date !=
                                        "null" &&
                                        widget.ongoingOrders.pickup_time !=
                                            "null" && widget.ongoingOrders.pickup_date !=
                                        null &&
                                        widget.ongoingOrders.pickup_time !=
                                            null)
                                        ? '${widget.ongoingOrders.pickup_date} | ${widget.ongoingOrders.pickup_time}'
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
                                      SizedBox(height: 5.0),
                                      Text(
                                        '1 items | ${widget.currency} ${(double.parse('${widget.ongoingOrders.distance}')>1)?double.parse('${widget.ongoingOrders.charges}')*double.parse('${widget.ongoingOrders.distance}'):double.parse('${widget.ongoingOrders.charges}')}\n',
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
//                              Text(
//                                '${widget.ongoingOrders.vendor_name}\t',
//                                style: orderMapAppBarTextStyle.copyWith(
//                                    fontSize: 10.0, letterSpacing: 0.05),
//                              ),
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
//                              Expanded(
//                                child: Text(
//                                  '${widget.ongoingOrders.address}\t',
//                                  style: orderMapAppBarTextStyle.copyWith(
//                                      fontSize: 10.0, letterSpacing: 0.05),
//                                ),
//                              ),
                              Expanded(
                                child: Text(
                                  '${widget.ongoingOrders.vendor_loc}\t',
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
                SlideUpPanelParcel(widget.ongoingOrders, widget.currency),
              ],
            ),
          ),
          Container(
            height: 60.0,
            color: kCardBackgroundColor,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  '1 items | ${widget.currency} ${(double.parse('${widget.ongoingOrders.distance}')>1)?double.parse('${widget.ongoingOrders.charges}')*double.parse('${widget.ongoingOrders.distance}'):double.parse('${widget.ongoingOrders.charges}')}',
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .copyWith(fontWeight: FontWeight.w500, fontSize: 15),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
