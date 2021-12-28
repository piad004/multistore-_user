import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer_animation/shimmer_animation.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/latlng.dart';
import 'package:user/parcel/pharmacybean/chargelistuser.dart';
import 'package:user/parcel/pharmacybean/parceladdress.dart';

class AddressFrom extends StatefulWidget {
  final dynamic vendor_name;
  final dynamic vendor_id;
  final dynamic distance;

  AddressFrom(this.vendor_name, this.vendor_id, this.distance);

  @override
  State<StatefulWidget> createState() {
    return AddressFromState();
  }
}

class AddressFromState extends State<AddressFrom> {
  TextEditingController houseno = TextEditingController();
  TextEditingController pincode = TextEditingController();
  TextEditingController city = TextEditingController();
  TextEditingController landmark = TextEditingController();
  TextEditingController address = TextEditingController();
  TextEditingController state = TextEditingController();
  TextEditingController sendername = TextEditingController();
  TextEditingController sendercontact = TextEditingController();

  bool isFetchStore = false;
  bool enterFirst = false;

  double lat = 0.0;
  double lng = 0.0;

  String currentAddress = '';

  String selectArea = 'Select your area please';
  ChargeListBean areaC;
  List<ChargeListBean> areaList = [];

  @override
  void initState() {
    // _getLocation(context,locale);
    super.initState();
    isFetchStore = true;
    areaC = ChargeListBean('', '', '', '', '', '', '', '', '', '');
  }

  void _getLocation(BuildContext context, AppLocalizations locale) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      bool isLocationServiceEnableds =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnableds) {
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        double lat = position.latitude;
        double lng = position.longitude;
        final coordinates = new Coordinates(lat, lng);
        await Geocoder.local
            .findAddressesFromCoordinates(coordinates)
            .then((value) {
          for (int i = 0; i < value.length; i++) {
            if (value[i].locality != null && value[i].locality.length > 1) {
              setState(() {
                city.text = value[i].locality;
                pincode.text = value[i].postalCode;
                state.text = value[i].adminArea;
              });
              break;
            }
          }
        });
      } else {
        await Geolocator.openLocationSettings().then((value) {
          if (value) {
            _getLocation(context, locale);
          } else {
            Toast.show(locale.locationPermissionIsRequired, context,
                duration: Toast.LENGTH_SHORT);
          }
        }).catchError((e) {
          Toast.show(locale.locationPermissionIsRequired, context,
              duration: Toast.LENGTH_SHORT);
        });
      }
    } else if (permission == LocationPermission.denied) {
      LocationPermission permissiond = await Geolocator.requestPermission();
      if (permissiond == LocationPermission.whileInUse ||
          permissiond == LocationPermission.always) {
        _getLocation(context, locale);
      } else {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      }
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings().then((value) {
        _getLocation(context, locale);
      }).catchError((e) {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      });
    }
  }

  void hitServiceCount() async {
    var chargeList = parcel_listcharges;
    var client = http.Client();
    client.post(chargeList, body: {'vendor_id': '${widget.vendor_id}'}).then(
        (value) {
      if (value.statusCode == 200) {
        print('${value.body}');
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var jsLst = jsonData['data'] as List;
          List<ChargeListBean> cityFetcjList =
              jsLst.map((e) => ChargeListBean.fromJson(e)).toList();
          if (cityFetcjList.length > 0) {
            areaList.clear();
            setState(() {
              areaList = List.from(cityFetcjList);
              selectArea = areaList[0].city_name;
              areaC = areaList[0];
            });
          }
        }
      }
      setState(() {
        isFetchStore = false;
      });
    }).catchError((e) {
      setState(() {
        isFetchStore = false;
      });
      print(e);
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    if (!enterFirst) {
      setState(() {
        enterFirst = true;
      });
      hitServiceCount();
      _getLocation(context, locale);
    }
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(52.0),
        child: AppBar(
          backgroundColor: kWhiteColor,
          titleSpacing: 0.0,
          title: Text(
            locale.addressNotFound,
            style: TextStyle(
                fontSize: 18, color: black_color, fontWeight: FontWeight.w400),
          ),
        ),
      ),
      body: isFetchStore
          ? SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10.0, top: 10, bottom: 10.0),
                    child: Shimmer(
                      duration: Duration(seconds: 3),
                      //Default value
                      color: Colors.white,
                      //Default value
                      enabled: true,
                      //Default value
                      direction: ShimmerDirection.fromLTRB(),
                      //Default Value
                      child: Container(
                        color: kTransparentColor,
                      ),
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
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            //Default value
                            color: Colors.white,
                            //Default value
                            enabled: true,
                            //Default value
                            direction: ShimmerDirection.fromLTRB(),
                            //Default Value
                            child: Container(
                              color: kTransparentColor,
                            ),
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
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              //Default value
                              color: Colors.white,
                              //Default value
                              enabled: true,
                              //Default value
                              direction: ShimmerDirection.fromLTRB(),
                              //Default Value
                              child: Container(
                                color: kTransparentColor,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            //Default value
                            color: Colors.white,
                            //Default value
                            enabled: true,
                            //Default value
                            direction: ShimmerDirection.fromLTRB(),
                            //Default Value
                            child: Container(
                              color: kTransparentColor,
                            ),
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
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              //Default value
                              color: Colors.white,
                              //Default value
                              enabled: true,
                              //Default value
                              direction: ShimmerDirection.fromLTRB(),
                              //Default Value
                              child: Container(
                                color: kTransparentColor,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            //Default value
                            color: Colors.white,
                            //Default value
                            enabled: true,
                            //Default value
                            direction: ShimmerDirection.fromLTRB(),
                            //Default Value
                            child: Container(
                              color: kTransparentColor,
                            ),
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
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              //Default value
                              color: Colors.white,
                              //Default value
                              enabled: true,
                              //Default value
                              direction: ShimmerDirection.fromLTRB(),
                              //Default Value
                              child: Container(
                                color: kTransparentColor,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            //Default value
                            color: Colors.white,
                            //Default value
                            enabled: true,
                            //Default value
                            direction: ShimmerDirection.fromLTRB(),
                            //Default Value
                            child: Container(
                              color: kTransparentColor,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigator.pushNamed(context, PageRoutes.searchloc).then((value){
                            //   if (value != null) {
                            //     print('${value.toString()}');
                            //     BackLatLng back = value;
                            //     _getCameraMoveLocation(LatLng(double.parse('${back.lat}'), double.parse('${back.lng}')),back.address);
                            //   }
                            // });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Card(
                            elevation: 2,
                            color: kWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(left: 10.0),
                              child: Shimmer(
                                duration: Duration(seconds: 3),
                                //Default value
                                color: Colors.white,
                                //Default value
                                enabled: true,
                                //Default value
                                direction: ShimmerDirection.fromLTRB(),
                                //Default Value
                                child: Container(
                                  color: kTransparentColor,
                                ),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            //Default value
                            color: Colors.white,
                            //Default value
                            enabled: true,
                            //Default value
                            direction: ShimmerDirection.fromLTRB(),
                            //Default Value
                            child: Container(
                              color: kTransparentColor,
                            ),
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
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              //Default value
                              color: Colors.white,
                              //Default value
                              enabled: true,
                              //Default value
                              direction: ShimmerDirection.fromLTRB(),
                              //Default Value
                              child: Container(
                                color: kTransparentColor,
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Shimmer(
                                      duration: Duration(seconds: 3),
                                      //Default value
                                      color: Colors.white,
                                      //Default value
                                      enabled: true,
                                      //Default value
                                      direction: ShimmerDirection.fromLTRB(),
                                      //Default Value
                                      child: Container(
                                        color: kTransparentColor,
                                      ),
                                    ),
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
                                      child: Shimmer(
                                        duration: Duration(seconds: 3),
                                        //Default value
                                        color: Colors.white,
                                        //Default value
                                        enabled: true,
                                        //Default value
                                        direction: ShimmerDirection.fromLTRB(),
                                        //Default Value
                                        child: Container(
                                          color: kTransparentColor,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Shimmer(
                                      duration: Duration(seconds: 3),
                                      //Default value
                                      color: Colors.white,
                                      //Default value
                                      enabled: true,
                                      //Default value
                                      direction: ShimmerDirection.fromLTRB(),
                                      //Default Value
                                      child: Container(
                                        color: kTransparentColor,
                                      ),
                                    ),
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
                                      child: Shimmer(
                                        duration: Duration(seconds: 3),
                                        //Default value
                                        color: Colors.white,
                                        //Default value
                                        enabled: true,
                                        //Default value
                                        direction: ShimmerDirection.fromLTRB(),
                                        //Default Value
                                        child: Container(
                                          color: kTransparentColor,
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
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            //Default value
                            color: Colors.white,
                            //Default value
                            enabled: true,
                            //Default value
                            direction: ShimmerDirection.fromLTRB(),
                            //Default Value
                            child: Container(
                              color: kTransparentColor,
                            ),
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
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              //Default value
                              color: Colors.white,
                              //Default value
                              enabled: true,
                              //Default value
                              direction: ShimmerDirection.fromLTRB(),
                              //Default Value
                              child: Container(
                                color: kTransparentColor,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            //Default value
                            color: Colors.white,
                            //Default value
                            enabled: true,
                            //Default value
                            direction: ShimmerDirection.fromLTRB(),
                            //Default Value
                            child: Container(
                              color: kTransparentColor,
                            ),
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
                            child: Shimmer(
                              duration: Duration(seconds: 3),
                              //Default value
                              color: Colors.white,
                              //Default value
                              enabled: true,
                              //Default value
                              direction: ShimmerDirection.fromLTRB(),
                              //Default Value
                              child: Container(
                                color: kTransparentColor,
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: GestureDetector(
                      onTap: () {

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
                          child: Shimmer(
                            duration: Duration(seconds: 3),
                            //Default value
                            color: Colors.white,
                            //Default value
                            enabled: true,
                            //Default value
                            direction: ShimmerDirection.fromLTRB(),
                            //Default Value
                            child: Container(
                              color: kTransparentColor,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            )
          : (areaList!=null && areaList.length>0)?SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.only(left: 10.0, top: 10, bottom: 10.0),
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
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            locale.senderName,
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
                            child: TextFormField(
                              maxLines: 1,
                              controller: sendername,
                              decoration: InputDecoration(
                                hintText: locale.senderName,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            locale.senderContactNo,
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
                            child: TextFormField(
                              maxLines: 1,
                              controller: sendercontact,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: locale.senderContactNo,
                                hintStyle: TextStyle(fontSize: 15),
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                focusedBorder: InputBorder.none,
                                counterText: '',
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            locale.selectNearByArea,
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
                            padding: EdgeInsets.only(left: 10.0, right: 10.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: DropdownButton<ChargeListBean>(
                              hint: Text(
                                selectArea,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                              ),
                              isExpanded: true,
                              underline: Container(
                                height: 0.0,
                                color: scaffoldBgColor,
                              ),
                              items: areaList.map((values) {
                                return DropdownMenuItem<ChargeListBean>(
                                  value: values,
                                  child: Text(
                                    values.city_name,
                                    maxLines: 1,
                                    overflow: TextOverflow.clip,
                                  ),
                                );
                              }).toList(),
                              onChanged: (area) {
                                setState(() {
                                  selectArea = area.city_name;
                                  areaC = area;
                                });
                              },
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            locale.address,
                            style: TextStyle(
                                fontSize: 18,
                                color: black_color,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, PageRoutes.searchloc)
                                .then((value) {
                              if (value != null) {
                                print('${value.toString()}');
                                BackLatLng back = value;
                                _getCameraMoveLocation(
                                    LatLng(double.parse('${back.lat}'),
                                        double.parse('${back.lng}')),
                                    back.address);
                              }
                            });
                          },
                          behavior: HitTestBehavior.opaque,
                          child: Card(
                            elevation: 2,
                            color: kWhiteColor,
                            shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              width: MediaQuery.of(context).size.width,
                              padding: EdgeInsets.only(left: 10.0),
                              child: TextFormField(
                                maxLines: 5,
                                controller: address,
                                enabled:
                                    (address.text.length == 0) ? false : true,
                                decoration: InputDecoration(
                                  hintText: locale.enteryouraddress,
                                  hintStyle: TextStyle(fontSize: 15),
                                  enabledBorder: InputBorder.none,
                                  errorBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.length == 1) {
                                    Navigator.pushNamed(
                                            context, PageRoutes.searchloc)
                                        .then((value) {
                                      if (value != null) {
                                        print('${value.toString()}');
                                        BackLatLng back = value;
                                        _getCameraMoveLocation(
                                            LatLng(double.parse('${back.lat}'),
                                                double.parse('${back.lng}')),
                                            back.address);
                                      }
                                    });
                                  }
                                },
                                onTap: () {},
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            locale.houseNoAndFlatNo,
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
                            child: TextFormField(
                              maxLines: 1,
                              controller: houseno,
                              decoration: InputDecoration(
                                hintText: locale.houseNoAndFlatNo,
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
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      locale.pinCode,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: black_color,
                                          fontWeight: FontWeight.w400),
                                    ),
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
                                        maxLines: 1,
                                        controller: pincode,
                                        textAlign: TextAlign.center,
                                        keyboardType: TextInputType.number,
                                        decoration: InputDecoration(
                                          hintText: locale.pinCode,
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
                              flex: 4,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      locale.city,
                                      style: TextStyle(
                                          fontSize: 15,
                                          color: black_color,
                                          fontWeight: FontWeight.w400),
                                    ),
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
                                        maxLines: 1,
                                        controller: city,
                                        textAlign: TextAlign.center,
                                        decoration: InputDecoration(
                                          hintText: locale.city,
                                          enabled: false,
                                          border: InputBorder.none,
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
                            locale.landMark,
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
                            child: TextFormField(
                              maxLines: 1,
                              controller: landmark,
                              decoration: InputDecoration(
                                hintText: locale.landMark,
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(left: 10.0),
                          child: Text(
                            locale.state,
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
                            child: TextFormField(
                              maxLines: 1,
                              controller: state,
                              decoration: InputDecoration(
                                hintText: locale.state,
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
                    height: 20,
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 10.0, right: 10.0),
                    child: GestureDetector(
                      onTap: () {
                        if (houseno.text != null &&
                            pincode.text != null &&
                            city.text != null &&
                            landmark.text != null &&
                            address.text != null &&
                            state.text != null &&
                            lat != null &&
                            lng != null &&
                            sendername.text != null &&
                            sendercontact.text != null &&
                            selectArea != null &&
                            selectArea != 'Select your area please' &&
                            areaC != null) {
                          ParcelAddress parcelAddress = ParcelAddress(
                              houseno.text,
                              pincode.text,
                              city.text,
                              landmark.text,
                              address.text,
                              state.text,
                              lat,
                              lng,
                              sendername.text,
                              sendercontact.text,
                              selectArea,
                              areaC.city_id,
                              areaC.parcel_charge);
                          // ParcelAddress parcelAddress = ParcelAddress(
                          //     '12',
                          //     '131001',
                          //     'sonipat',
                          //     'sonipat',
                          //     'sonipat',
                          //     'haryana',
                          //     12.8525,
                          //     27.8568,
                          //     'Ajit Singh',
                          //     '9467313652');
                          Navigator.of(context)
                              .pushNamed(PageRoutes.addressto, arguments: {
                            'par_from': parcelAddress,
                            'vendor_name': widget.vendor_name,
                            'vendor_id': widget.vendor_id,
                            'distance': widget.distance,
                            'arealist': areaList
                          });
                          // Navigator.push(
                          //     context,
                          //     MaterialPageRoute(
                          //         builder: (context) => AddressTo(
                          //             widget.vendor_name,
                          //             widget.vendor_id,
                          //             widget.distance,
                          //             parcelAddress)));
                        } else {
                          Toast.show(
                              locale.pleaseEnterAllDetailsToContinue, context,
                              duration: Toast.LENGTH_SHORT,
                              gravity: Toast.CENTER);
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
                    height: 20,
                  ),
                ],
              ),
            ):Center(
        child: Text('Temporarily out of service. please try again later.'),
      ),
    );
  }

  void _getCameraMoveLocation(LatLng data, addressd) async {
    setState(() {
      lat = data.latitude;
      lng = data.longitude;
      currentAddress = '${addressd}';
    });
    final coordinates = new Coordinates(lat, lng);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      for (int i = 0; i < value.length; i++) {
        print('${value[i].locality}');
        if (value[i].locality != null && value[i].locality.length > 1) {
          setState(() {
            city.text = value[i].locality;
            pincode.text = value[i].postalCode;
            state.text = value[i].adminArea;
            currentAddress =
                currentAddress.replaceAll('${value[i].locality},', '');
            currentAddress = currentAddress.replaceAll('${pincode.text},', '');
            currentAddress = currentAddress.replaceAll('${state.text},', '');
            currentAddress =
                currentAddress.replaceAll('${value[i].locality}', '');
            currentAddress = currentAddress.replaceAll('${pincode.text}', '');
            currentAddress = currentAddress.replaceAll('${state.text}', '');
            currentAddress =
                currentAddress.replaceAll('${value[i].countryName}', '');
            address.text = currentAddress;
          });
          break;
        }
      }
    });
  }
}
