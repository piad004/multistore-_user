import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart' as http;
import 'package:mapbox_search/mapbox_search.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/entry_field.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Routes/routes.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/address.dart';
import 'package:user/bean/latlng.dart';

class AddAddressPage extends StatefulWidget {
  final dynamic vendorId;

  AddAddressPage(this.vendorId);

  @override
  State<StatefulWidget> createState() {
    return AddAddressState();
  }
}

class AddAddressState extends State<AddAddressPage> {
  var pincodeController = TextEditingController();
  var houseController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController streetController1 = TextEditingController();
  var stateController = TextEditingController();
  double lat = 0.0;
  double lng = 0.0;
  FocusScopeNode currentFocus;
  List<CityList> cityListt = [];
  List<AreaList> areaList = [];
  List<String> addressTyp = [
    'Home',
    'Office',
    'Other',
  ];
  String selectCity = 'Select city';
  String addressType = 'Select address type';
  String selectArea = 'Select near by area';
  bool showDialogBox = false;
  bool enteredFirst = false;
  bool isDispose = false;
  bool isLoading = false;
  dynamic selectAreaId;
  dynamic selectCityId;
  GoogleMapsPlaces places;
  PlacesSearch placesSearch;
  List<PlacesSearchResult> searchPredictions = [];
  List<MapBoxPlace> placePred = [];
  PlacesSearchResult pPredictions;
  MapBoxPlace mapboxPredictions;
  int mapType = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    isDispose = true;
    super.dispose();
  }

  void _getLocation(context, AppLocalizations locale) async {
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
        setState(() {
          this.lat = lat;
          this.lng = lng;
        });
        hitAddressPlace();
      }
    }
  }

  void hitAddressPlace() async{
    // setState(() {
    //   this.lat = latd;
    //   this.lng = lngd;
    // });
    print('$lat - $lng');
    final coordinates = new Coordinates(lat,lng);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      for (int i = 0; i < value.length; i++) {
        print('${value[i].locality}');
        if (value[i].locality != null && value[i].locality.length > 1) {
          setState(() {
            streetController.text = value[i].addressLine;
            pincodeController.text = value[i].postalCode;
            stateController.text = value[i].adminArea;
            streetController.text =
                streetController.text.replaceAll('${value[i].locality},', '');
            streetController.text = streetController.text
                .replaceAll('${pincodeController.text},', '');
            streetController.text = streetController.text
                .replaceAll('${stateController.text},', '');
            streetController.text =
                streetController.text.replaceAll('${value[i].locality}', '');
            streetController.text = streetController.text
                .replaceAll('${pincodeController.text}', '');
            streetController.text =
                streetController.text.replaceAll('${stateController.text}', '');
            streetController.text =
                streetController.text.replaceAll('${value[i].countryName}', '');
          });
          break;
        }
      }
    }).catchError((e) {
    });
  }

  void getCityList() async {
    print('${widget.vendorId}');
    var url = cityList;
    http.post(url, body: {
      'vendor_id': '${widget.vendorId}',
    }).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body)['data'] as List;
          List<CityList> tagObjs =
          tagObjsJson.map((tagJson) => CityList.fromJson(tagJson)).toList();
          setState(() {
            cityListt.clear();
            cityListt = tagObjs;
          });
        }
      }
    });
  }

  void getAreaList(dynamic city_id) async {
    var url = areaLists;
    http.post(url, body: {
      'vendor_id': '${widget.vendorId}',
      'city_id': '${city_id}',
    }).then((value) {
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body)['data'] as List;
          List<AreaList> tagObjs =
          tagObjsJson.map((tagJson) => AreaList.fromJson(tagJson)).toList();
          setState(() {
            areaList.clear();
            areaList = tagObjs;
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    currentFocus = FocusScope.of(context);
    double appbarsize = AppBar().preferredSize.height;
    double statusBarHeight = MediaQuery.of(context).padding.top;

    if (!enteredFirst) {
      setState(() {
        enteredFirst = true;
        addressTyp = [
          locale.homeText,
          locale.officetext,
          locale.othertext,
        ];
        selectCity = locale.selectcitytext;
        addressType = locale.selectaddresstypetext;
        selectArea = locale.selectNearByArea;
      });
      getCityList();
      _getLocation(context, locale);
    }
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        titleSpacing: 0.0,
        title: Text(
          locale.addaddresstext,
          style: Theme.of(context).textTheme.bodyText1,
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height:
        MediaQuery.of(context).size.height - (appbarsize + statusBarHeight),
        child: Column(
          children: [
            Expanded(
              child: Container(
                // height: (MediaQuery.of(context).size.height - (appbarsize+statusBarHeight)) * 0.9,
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      primary: true,
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(color: kHintColor, width: 1),
                            ),
                            child: DropdownButton<String>(
                              hint: Text(addressType),
                              isExpanded: true,
                              underline: Container(
                                height: 0.0,
                                color: scaffoldBgColor,
                              ),
                              items: addressTyp.map((value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  addressType = value;
                                });
                                print(addressType);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.95,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                              Border.all(color: kHintColor, width: 1),
                            ),
                            child: DropdownButton<CityList>(
                              hint: Text(
                                selectCity,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                              ),
                              isExpanded: true,
                              underline: Container(
                                height: 0.0,
                                color: scaffoldBgColor,
                              ),
                              items: cityListt.map((value) {
                                return DropdownMenuItem<CityList>(
                                  value: value,
                                  child: Text(value.city_name,
                                      overflow: TextOverflow.clip),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectCity = value.city_name;
                                  selectCityId = value.city_id;
                                  areaList.clear();
                                  selectArea = locale.selectNearByArea;
                                  selectAreaId = '';
                                });
                                getAreaList(value.city_id);
                                print(value);
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width*0.95,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border:
                              Border.all(color: kHintColor, width: 1),
                            ),
                            child: DropdownButton<AreaList>(
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
                                return DropdownMenuItem<AreaList>(
                                  value: values,
                                  child: Text(
                                    values.area_name,
                                    overflow: TextOverflow.clip,
                                  ),
                                );
                              }).toList(),
                              onChanged: (area) {
                                setState(() {
                                  selectArea = area.area_name;
                                  selectAreaId = area.area_id;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: EntryField(
                                    textCapitalization:
                                    TextCapitalization.words,
                                    hint: locale.housenotext,
                                    controller: houseController,
                                    maxLines: 1,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: kHintColor, width: 1),
                                    )),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.45,
                                child: EntryField(
                                    textCapitalization:
                                    TextCapitalization.words,
                                    hint: locale.enteryourpincode,
                                    controller: pincodeController,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                      borderSide: BorderSide(
                                          color: kHintColor, width: 1),
                                    )),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.95,
                            child: EntryField(
                                textCapitalization: TextCapitalization.words,
                                hint: locale.state,
                                controller: stateController,
                                maxLines: 1,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                  BorderSide(color: kHintColor, width: 1),
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: EntryField(
                                textCapitalization: TextCapitalization.words,
                                hint: locale.addressline1,
                                controller: streetController,
                                readOnly: true,
                                minLines: 2,
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, PageRoutes.searchloc)
                                      .then((value) {
                                    if (value != null) {
                                      BackLatLng back = value;
                                      _getCameraMoveLocation(
                                          LatLng(double.parse('${back.lat}'),
                                              double.parse('${back.lng}')),
                                          back.address);
                                    }
                                  });
                                },
                                contentPadding: EdgeInsets.only(
                                    left: 20, top: 20, bottom: 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                  BorderSide(color: kHintColor, width: 1),
                                )),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            child: EntryField(
                                textCapitalization: TextCapitalization.words,
                                hint: locale.addressline2,
                                controller: streetController1,
                                minLines: 5,
                                contentPadding: EdgeInsets.only(
                                    left: 20, top: 20, bottom: 0),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  borderSide:
                                  BorderSide(color: kHintColor, width: 1),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                        child: Visibility(
                          visible: showDialogBox,
                          child: GestureDetector(
                            onTap: () {},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 100,
                              alignment: Alignment.center,
                              child: SizedBox(
                                height: 120,
                                width: MediaQuery.of(context).size.width * 0.9,
                                child: Material(
                                  elevation: 5,
                                  borderRadius: BorderRadius.circular(20),
                                  clipBehavior: Clip.hardEdge,
                                  child: Container(
                                    color: white_color,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: <Widget>[
                                        CircularProgressIndicator(),
                                        SizedBox(
                                          width: 20,
                                        ),
                                        Text(
                                          locale.loadingPleaseWait,
                                          style: TextStyle(
                                              color: kMainTextColor,
                                              fontWeight: FontWeight.w500,
                                              fontSize: 20),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
            ),
            Container(
              // height: (MediaQuery.of(context).size.height - (appbarsize+statusBarHeight)) * 0.1,
              height: 52,
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: GestureDetector(
                  onTap: () {
                    if (addressType != null &&
                        addressType != locale.selectaddresstypetext &&
                        selectAreaId != null &&
                        selectAreaId != '' &&
                        selectAreaId != null &&
                        selectAreaId != '' &&
                        houseController.text != null &&
                        houseController.text != '' &&
                        streetController.text != null &&
                        streetController.text != '' &&
                        pincodeController.text != null &&
                        pincodeController.text != '' &&
                        stateController.text != null &&
                        stateController.text != '') {
                      setState(() {
                        showDialogBox = true;
                      });
                      addAddres(
                          selectAreaId,
                          selectCityId,
                          houseController.text,
                          '${streetController.text}',
                          streetController1.text,
                          pincodeController.text,
                          stateController.text,
                          context,
                          locale);
                    } else {
                      Toast.show(locale.enterAllDetailsCareFully, context,
                          duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
                    }
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 52,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: kMainColor),
                    child: Text(
                      locale.savedAddresses,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: kWhiteColor,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: statusBarHeight,
            ),
          ],
        ),
      ),
    );
  }

  void addAddres(
      dynamic area_id,
      dynamic city_id,
      house_no,
      String street,
      String street1,
      pincode,
      state,
      BuildContext context,
      AppLocalizations locale) async {
    List<String> addList = street.trim().split(',');
    String addressdd = '';
    if (addList.isNotEmpty) {
      addressdd + street1;
      addressdd.trim();
      for (String addj in addList) {
        if (addj.length > 0) {
          addressdd = addressdd + addj + ',';
        }
      }
    } else {
      addressdd + street1;
      addressdd.trim();
    }
    addressdd = addressdd.replaceFirst(',', '', addressdd.length - 1);
    var locale = AppLocalizations.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = addAddress;
    http.post(url, body: {
      'user_id': '${prefs.getInt('user_id')}',
      'user_name': '${prefs.getString('user_name')}',
      'user_number': '${prefs.getString('user_phone')}',
      'area_id': '$area_id',
      'city_id': '$city_id',
      'houseno': '$house_no',
      'street': '$addressdd',
      'state': '$state',
      'pin': '$pincode',
      'lat': '${lat}',
      'lng': '${lng}',
      'address_type': '${addressType}',
    }).then((value) {
      if (value.statusCode == 200) {
        print('Response Body: - ${value.body}');
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          prefs.setString("area_id", "$area_id");
          prefs.setString("city_id", "$city_id");
          setState(() {
            showDialogBox = false;
          });
          setState(() {
            selectCity = locale.selectcitytext;
            selectCityId = '';
            areaList.clear();
            selectArea = locale.selectNearByArea;
            addressType = locale.selectaddresstypetext;
            selectAreaId = '';
            houseController.clear();
            streetController.clear();
            pincodeController.clear();
            stateController.clear();
          });
          Toast.show(locale.addressSavedSuccessfully, context,
              duration: Toast.LENGTH_SHORT);
          Navigator.of(context).pop();
        } else {
          setState(() {
            showDialogBox = false;
          });
        }
      } else {
        setState(() {
          showDialogBox = false;
        });
      }
    }).catchError((e) {
      setState(() {
        showDialogBox = false;
      });
      print(e);
    });
  }

  void _getCameraMoveLocation(LatLng data, addressd) async {
    setState(() {
      lat = data.latitude;
      lng = data.longitude;
      streetController.text = '${addressd}';
    });
    final coordinates = new Coordinates(lat, lng);
    await Geocoder.local
        .findAddressesFromCoordinates(coordinates)
        .then((value) {
      for (int i = 0; i < value.length; i++) {
        print('${value[i].locality}');
        if (value[i].locality != null && value[i].locality.length > 1) {
          setState(() {
            // ci.text = value[i].locality;
            pincodeController.text = value[i].postalCode;
            stateController.text = value[i].adminArea;
            streetController.text =
                streetController.text.replaceAll('${value[i].locality},', '');
            streetController.text = streetController.text
                .replaceAll('${pincodeController.text},', '');
            streetController.text = streetController.text
                .replaceAll('${stateController.text},', '');
            streetController.text =
                streetController.text.replaceAll('${value[i].locality}', '');
            streetController.text = streetController.text
                .replaceAll('${pincodeController.text}', '');
            streetController.text =
                streetController.text.replaceAll('${stateController.text}', '');
            streetController.text =
                streetController.text.replaceAll('${value[i].countryName}', '');
          });
          break;
        }
      }
    });
  }
}
