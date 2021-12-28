import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/paymentstatus.dart';
import 'package:user/parcel/parcelpaymentpage.dart';
import 'package:user/parcel/pharmacybean/parceladdress.dart';
import 'package:user/parcel/pharmacybean/parceldetail.dart';

class ParcelCheckOut extends StatefulWidget {
  final dynamic vendor_name;
  final dynamic vendor_id;
  final dynamic distance;
  final ParcelAddress senderAddress;
  final ParcelAddress receiverAddress;
  final ParcelDetailBean beanDetails;
  final dynamic distanced;
  final dynamic charges;
  final dynamic cart_id;

  ParcelCheckOut(
      this.vendor_id,
      this.vendor_name,
      this.distance,
      this.senderAddress,
      this.receiverAddress,
      this.beanDetails,
      this.distanced,
      this.charges,
      this.cart_id);

  @override
  State<StatefulWidget> createState() {
    return ParcelCheckoutState();
  }
}

class ParcelCheckoutState extends State<ParcelCheckOut> {
  dynamic currency = '';

  @override
  void initState() {
    getCurrency();
    super.initState();
  }

  void getCurrency() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: true, showLogs: true);
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: AppBar(
          backgroundColor: kWhiteColor,
          titleSpacing: 0.0,
          title: Text(
            locale.checkout,
            style: TextStyle(
                fontSize: 18, color: black_color, fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.senderAddress,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              color: kWhiteColor,
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10),
              child: Text('${widget.senderAddress.toString()}'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.receiverAddress,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              color: kWhiteColor,
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10),
              child: Text('${widget.receiverAddress.toString()}'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.parcelDescription,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              color: kWhiteColor,
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(top: 20.0, bottom: 20.0, left: 10),
              child: Text('${widget.beanDetails.toString()}'),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.distaceInfo,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              color: kWhiteColor,
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(locale.distace),
                      Text(
                          '${(double.parse('${double.parse('${widget.distanced}').toStringAsFixed(2)}') > 1) ? double.parse('${double.parse('${widget.distanced}').toStringAsFixed(2)}') : 1} KM'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.paymentInfo,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
            Container(
              color: kWhiteColor,
              alignment: Alignment.centerLeft,
              width: MediaQuery.of(context).size.width,
              padding:
                  EdgeInsets.only(top: 20.0, bottom: 20.0, left: 20, right: 20),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(locale.parcelCharges),
                      Text(
                          '${currency} ${(double.parse('${double.parse('${widget.distanced}').toStringAsFixed(2)}') > 1) ? (double.parse('${double.parse('${widget.distanced}').toStringAsFixed(2)}') * double.parse('${widget.charges}')) : double.parse('${widget.charges}')}'),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: GestureDetector(
                onTap: () {
                  showProgressDialog(
                      'please wait while we loading your request!', pr);
                  getVendorPayment(widget.vendor_id, pr, context);
                },
                child: Card(
                  elevation: 2,
                  color: kMainColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Container(
                    height: 52,
                    padding: EdgeInsets.all(10.0),
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width - 100,
                    child: Text(
                      locale.proceedToPayment,
                      style: TextStyle(fontSize: 18, color: kWhiteColor),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }

  showProgressDialog(String text, ProgressDialog pr) {
    pr.style(
        message: '${text}',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600));
  }

  void getVendorPayment(
      dynamic vendorId, ProgressDialog pr, BuildContext context) async {
    pr.show();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      currency = preferences.getString('curency');
    });
    var url = paymentvia;
    var client = http.Client();
    client.get(url).then((value) {
      pr.hide();
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          print('${value.statusCode} - ${value.body}');
          var tagObjsJson = jsonDecode(value.body);
          PaymentVia tagObjs = PaymentVia.fromJson(tagObjsJson);
          double amout = (double.parse(
                      '${double.parse('${widget.distanced}').toStringAsFixed(2)}') >
                  1)
              ? (double.parse(
                      '${double.parse('${widget.distanced}').toStringAsFixed(2)}') *
                  double.parse('${widget.charges}'))
              : double.parse('${widget.charges}');
          print(
              '${amout} - ${widget.vendor_id} - ${widget.cart_id} - ${widget.charges} - ${double.parse('${widget.distanced}').toStringAsFixed(2)} - ${tagObjs.toString()}');
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PaymentParcelPage(
                widget.vendor_id,
                widget.cart_id,
                amout,
                tagObjs,
                widget.charges,
                (double.parse(
                            '${double.parse('${widget.distanced}').toStringAsFixed(2)}') >
                        1)
                    ? double.parse('${widget.distanced}').toStringAsFixed(2)
                    : 1,widget.senderAddress);
          }));
        }
      }
    }).catchError((e) {
      pr.hide();
      print(e);
    });
  }
}
