import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:http/http.dart' as http;
import 'package:progress_dialog/progress_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/parcel/checkoutparcel.dart';
import 'package:user/parcel/pharmacybean/parceladdress.dart';
import 'package:user/parcel/pharmacybean/parceldetail.dart';

class ParcelDetails extends StatefulWidget {
  final dynamic vendor_name;
  final dynamic vendor_id;
  final dynamic distance;
  final dynamic city_id;
  final dynamic charges;
  final dynamic distanced;
  final ParcelAddress senderAddress;
  final ParcelAddress receiverAddress;

  ParcelDetails(
      this.vendor_id,
      this.vendor_name,
      this.distance,
      this.senderAddress,
      this.receiverAddress,
      this.city_id,
      this.charges,
      this.distanced);

  @override
  State<StatefulWidget> createState() {
    return ParcelDetailsState();
  }
}

class ParcelDetailsState extends State<ParcelDetails> {
  TextEditingController parcelweight = TextEditingController();
  TextEditingController length = TextEditingController();
  TextEditingController width = TextEditingController();
  TextEditingController height = TextEditingController();
  TextEditingController parcelDescription = TextEditingController();

  var pickuptime = 'Pick Time';

  var pickupdate = 'Pick Date';

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    final ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: AppBar(
          backgroundColor: kWhiteColor,
          titleSpacing: 0.0,
          title: Text(
            locale.parcelDetailFrom,
            style: TextStyle(
                fontSize: 18, color: black_color, fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      locale.parcelWeight,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 8,
                        child: Card(
                          elevation: 2,
                          color: kWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Container(
                            height: 52,
                            alignment: Alignment.centerLeft,
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.only(left: 10.0),
                            child: TextFormField(
                              minLines: 1,
                              controller: parcelweight,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Parcel weight',
                                hintStyle: TextStyle(fontSize: 15),
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Card(
                          elevation: 2,
                          color: kWhiteColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Container(
                            height: 52,
                            alignment: Alignment.center,
                            width: MediaQuery.of(context).size.width,
                            child: Text(locale.KG, style: TextStyle(fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  )
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
                  DatePicker.showDatePicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (date) {
                    print('confirm $date');
                    pickupdate = '${date.year}-${date.month}-${date.day}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                        locale.pickupDate,
                        style: TextStyle(
                            fontSize: 18,
                            color: black_color,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 2,
                      color: kWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        height: 52,
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          '${pickupdate}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: GestureDetector(
                onTap: () {
                  DatePicker.showTime12hPicker(context,
                      theme: DatePickerTheme(
                        containerHeight: 210.0,
                      ),
                      showTitleActions: true, onConfirm: (date) {
                    print('confirm $date');
                    pickuptime = '${date.hour} : ${date.minute}';
                    setState(() {});
                  }, currentTime: DateTime.now(), locale: LocaleType.en);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 20.0),
                      child: Text(
                       locale.pickupTime,
                        style: TextStyle(
                            fontSize: 18,
                            color: black_color,
                            fontWeight: FontWeight.w400),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Card(
                      elevation: 2,
                      color: kWhiteColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Container(
                        height: 52,
                        alignment: Alignment.centerLeft,
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.only(left: 10.0),
                        child: Text(
                          '${pickuptime}',
                          style: TextStyle(fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              padding: EdgeInsets.only(left: 10.0, right: 10.0),
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              locale.length,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: black_color,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                              elevation: 2,
                              color: kWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                padding: EdgeInsets.only(left: 10.0),
                                child: TextFormField(
                                  minLines: 1,
                                  controller: length,
                                  keyboardType: TextInputType.number,
                                  textAlign: TextAlign.center,
                                  decoration: InputDecoration(
                                    hintText: 'Length',
                                    hintStyle: TextStyle(fontSize: 15),
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              locale.width,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: black_color,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                              elevation: 2,
                              color: kWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  minLines: 1,
                                  controller: width,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Width',
                                    hintStyle: TextStyle(fontSize: 15),
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Column(
                          children: [
                            Text(
                              locale.height,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: black_color,
                                  fontWeight: FontWeight.w400),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Card(
                              elevation: 2,
                              color: kWhiteColor,
                              shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              child: Container(
                                height: 52,
                                alignment: Alignment.center,
                                width: MediaQuery.of(context).size.width,
                                child: TextFormField(
                                  minLines: 1,
                                  controller: height,
                                  textAlign: TextAlign.center,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: 'Height',
                                    hintStyle: TextStyle(fontSize: 15),
                                    enabledBorder: InputBorder.none,
                                    errorBorder: InputBorder.none,
                                    focusedBorder: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(
                      locale.parcelDetail,
                      style: TextStyle(
                          fontSize: 18,
                          color: black_color,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Card(
                    elevation: 2,
                    color: kWhiteColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Container(
                      alignment: Alignment.centerLeft,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(left: 10.0),
                      child: TextFormField(
                        maxLines: 8,
                        controller: parcelDescription,
                        decoration: InputDecoration(
                          hintText: 'Enter your parcel detail here....',
                          hintStyle: TextStyle(fontSize: 15),
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                        ),
                      ),
                    ),
                  )
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
                  if (parcelweight.text != null &&
                      pickupdate != null &&
                      pickuptime != null &&
                      length.text != null &&
                      width.text != null &&
                      height.text != null &&
                      parcelDescription.text != null) {
                    ParcelDetailBean beanDetails = ParcelDetailBean(
                        parcelweight.text,
                        pickupdate,
                        pickuptime,
                        length.text,
                        width.text,
                        height.text,
                        parcelDescription.text);
                    showProgressDialog(
                        locale.pleaseWaitWhileWeLoadingYourRequest, pr);
                    hiService(beanDetails, pr);
                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => ParcelCheckOut(
                    //             widget.vendor_id,
                    //             widget.vendor_name,
                    //             widget.distance,
                    //             widget.senderAddress,
                    //             widget.receiverAddress,
                    //             beanDetails,
                    //             widget.distanced,
                    //             widget.charges,
                    //             'jgd2458')));
                  } else {
                    Toast.show('please enter all details to continue!', context,
                        duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                  }
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
                    width: MediaQuery.of(context).size.width,
                    child: Text(
                      locale.submit,
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

  void hiService(ParcelDetailBean beanDetails, pr) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dynamic userId = prefs.getInt('user_id');
    pr.show();
    var chargeList = parcel_detail;
    var client = http.Client();
    client.post(chargeList, body: {
      'vendor_id': '${widget.vendor_id}',
      'weight': '${parcelweight.text}',
      'length': '${length.text}',
      'height': '${height.text}',
      'width': '${width.text}',
      'pickup_time': '${pickuptime}',
      'pickup_date': '${pickupdate}',
      'city_id': '${widget.city_id}',
      'lat': '${widget.senderAddress.lat}',
      'lng': '${widget.senderAddress.lng}',
      'charges': '${widget.charges}',
      'distance': '${double.parse('${widget.distanced}').toStringAsFixed(2)}',
      'source_pincode': '${widget.senderAddress.pincode}',
      'source_houseno': '${widget.senderAddress.houseno}',
      'source_landmark': '${widget.senderAddress.landmark}',
      'source_address': '${widget.senderAddress.address}',
      'source_state': '${widget.senderAddress.state}',
      'source_city': '${widget.senderAddress.city}',
      'destination_pincode': '${widget.receiverAddress.pincode}',
      'destination_houseno': '${widget.receiverAddress.houseno}',
      'destination_landmark': '${widget.receiverAddress.landmark}',
      'destination_address': '${widget.receiverAddress.address}',
      'destination_state': '${widget.receiverAddress.state}',
      'destination_city': '${widget.receiverAddress.city}',
      'user_id': '${userId}',
      'description': '${parcelDescription.text}',
      'source_lat': '${widget.senderAddress.lat}',
      'source_lng': '${widget.senderAddress.lng}',
      'source_phone': '${widget.senderAddress.sendercontact}',
      'source_name': '${widget.senderAddress.sendername}',
      'destination_lat': '${widget.receiverAddress.lat}',
      'destination_lng': '${widget.receiverAddress.lng}',
      'destination_phone': '${widget.receiverAddress.sendercontact}',
      'destination_name': '${widget.receiverAddress.sendername}',
    }).then((value) {
      pr.hide();
      print(value.body);
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var cart_id = jsonData['cart_id'];
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ParcelCheckOut(
                      widget.vendor_id,
                      widget.vendor_name,
                      widget.distance,
                      widget.senderAddress,
                      widget.receiverAddress,
                      beanDetails,
                      widget.distanced,
                      widget.charges,
                      cart_id)));
        }
      }
    }).catchError((e) {
      pr.hide();
      print(e);
    });
  }
}
