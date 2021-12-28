import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:user/Locale/locales.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/bottom_bar.dart';
import 'package:user/Components/custom_appbar.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/Themes/constantfile.dart';
import 'package:user/bean/latlng.dart';
import 'package:user/Routes/routes.dart';

class LocationPage extends StatelessWidget {
  final dynamic lat;
  final dynamic lng;

  LocationPage(this.lat, this.lng);

  @override
  Widget build(BuildContext context) {
    return SetLocation(lat, lng);
  }
}

class SetLocation extends StatefulWidget {
  final dynamic lat;
  final dynamic lng;

  SetLocation(this.lat, this.lng);

  @override
  SetLocationState createState() => SetLocationState(lat, lng);
}

GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class SetLocationState extends State<SetLocation> {
  bool pageDistroy = false;
  dynamic lat;
  dynamic lng;
  CameraPosition kGooglePlex;
  SetLocationState(this.lat, this.lng) {
    kGooglePlex = CameraPosition(
      target: LatLng(lat, lng),
      zoom: 12.151926,
    );
  }
  bool enteredFirst = false;
  bool enteredSearch = false;
  bool locGranted = false;
  bool isCard = false;
  Completer<GoogleMapController> _controller = Completer();
  var isVisible = false;
  bool inLake = false;
  var currentAddress = '';

  Future<void> _goToTheLake(double latf, double lngf) async {
    final CameraPosition _kLake = CameraPosition(
        // bearing: 192.8334901395799,
        target: LatLng(latf, lngf),
        // tilt: 59.440717697143555,
        zoom: 19.15);
    _controller.future.then((value){
      value.moveCamera(CameraUpdate.newCameraPosition(_kLake)).then((value){
        print('done motion.');
        Geocoder.local
            .findAddressesFromCoordinates(Coordinates(lat, lng))
            .then((value) {
          for (int i = 0; i < value.length; i++) {
            if (value[i].locality != null && value[i].locality.length > 1) {
              if(!pageDistroy){
                setState(() {
                  currentAddress = value[i].addressLine;
                  enteredSearch = false;
                });
              }
              break;
            }
          }
        });
      });
    });
   // _controller.future.then((value){
   //   print('hello progress done');
   //   value.animateCamera(CameraUpdate.newCameraPosition(_kLake)).then((value){
   //     inLake = false;
   //   });
   //  });


  }


  @override
  void initState() {
    super.initState();
    // _getLocation();
  }

  @override
  void dispose() {
    pageDistroy = true;
    super.dispose();
  }

  void _getLocation(BuildContext context, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      bool isLocationServiceEnableds =
          await Geolocator.isLocationServiceEnabled();
      if (isLocationServiceEnableds) {
        if(!pageDistroy){
          setState(() {
            locGranted = true;
          });
        }
        Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high).then((position){
              if(position!=null){
                setState(() {
                  inLake = true;
                });
                double lat = position.latitude;
                double lng = position.longitude;
                _goToTheLake(lat,lng);
              }
        });
      } else {
        showAlertDialog(context, locale, 'opens');
      }
    } else if (permission == LocationPermission.denied) {
      showAlertDialog(context, locale, 'openp');
    } else if (permission == LocationPermission.deniedForever) {
      showAlertDialog(context, locale, 'openas');
    }
  }
  //
  // void _getCameraMoveLocation(LatLng data) async {
  //   Timer(Duration(seconds: 5), () async {
  //     // lat = data.latitude;
  //     // lng = data.longitude;
  //     // SharedPreferences prefs = await SharedPreferences.getInstance();
  //     // prefs.setString("lat", '${data.latitude}');
  //     // prefs.setString("lng", '${data.longitude}');
  //     // final coordinates = new Coordinates(data.latitude, data.longitude);
  //     Geocoder.local
  //         .findAddressesFromCoordinates(Coordinates(data.latitude, data.longitude))
  //         .then((value) {
  //       for (int i = 0; i < value.length; i++) {
  //         if (value[i].locality != null && value[i].locality.length > 1) {
  //           if(!pageDistroy){
  //             setState(() {
  //               currentAddress = value[i].addressLine;
  //             });
  //
  //           }
  //           break;
  //         }
  //       }
  //     });
  //   });
  // }


  void performAction(BuildContext context, AppLocalizations locale, String type) async{
    if(type == 'opens'){
      Geolocator.openLocationSettings().then((value) {
        if (value) {
          _getLocation(context,locale);
        } else {
          Toast.show(locale.locationPermissionIsRequired, context,
              duration: Toast.LENGTH_SHORT);
        }
      }).catchError((e) {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      });
    }else if(type == 'openp'){
      Geolocator.requestPermission().then((permissiond){
        if (permissiond == LocationPermission.whileInUse ||
            permissiond == LocationPermission.always) {
          _getLocation(context,locale);
        } else {
          Toast.show(locale.locationPermissionIsRequired, context,
              duration: Toast.LENGTH_SHORT);
        }
      });
    }else if(type == 'openas'){
      Geolocator.openAppSettings().then((value) {
        _getLocation(context,locale);
      }).catchError((e) {
        Toast.show(locale.locationPermissionIsRequired, context,
            duration: Toast.LENGTH_SHORT);
      });
    }
  }

  showAlertDialog(BuildContext context, AppLocalizations locale, String type) {
    Widget clear = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
        performAction(context,locale,type);
      },
      behavior: HitTestBehavior.opaque,
      child: Material(
        elevation: 2,
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            locale.ok,
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );

    Widget no = GestureDetector(
      onTap: () {
        Navigator.of(context, rootNavigator: true).pop('dialog');
      },
      behavior: HitTestBehavior.opaque,
      child: Material(
        elevation: 2,
        borderRadius: BorderRadius.all(Radius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.red,
              borderRadius: BorderRadius.all(Radius.circular(20))),
          child: Text(
            locale.noText,
            style: TextStyle(fontSize: 13, color: kWhiteColor),
          ),
        ),
      ),
    );
    AlertDialog alert = AlertDialog(
      insetPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 10.0),
      contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
      title: Text(locale.locationheading),
      content: Text(locale.locationheadingSub),
      actions: [clear, no],
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  void setCameraLoc(LatLng data) async {
    Timer(Duration(seconds: 1), () async {
      _goToTheLake(data.latitude,data.longitude);
    });
  }
  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    if(!enteredFirst){
      setState(() {
        enteredFirst = true;
      });
      _getLocation(context,locale);
    }
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(110.0),
        child: CustomAppBar(
          titleWidget: Text(locale.setDeliveryLocation,
            style: TextStyle(fontSize: 16.7, color: black_color),
          ),
          actions: [
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: IconButton(
                  icon: Icon(
                    Icons.my_location,
                    color: kMainColor,
                  ),
                  iconSize: 30,
                  onPressed: () {
                    _getLocation(context,locale);
                  },
                ))
          ],
          bottom: PreferredSize(
              child: GestureDetector(
                onTap: (){
                  if(locGranted){
                    setState(() {
                      enteredSearch = true;
                    });
                    Navigator.pushNamed(context, PageRoutes.searchloc).then((value){
                      if (value != null) {
                        print('${value.toString()}');
                        BackLatLng back = value;
                        print('daa ta  - ${back.toString()}');
                        print('daa ta  - ${back.lat}');
                        print('daa ta  - ${back.lng}');
                        print('daa ta  - ${back.address}');
                        setState(() {
                          currentAddress = back.address;
                          lat = double.parse('${back.lat}');
                          lng = double.parse('${back.lng}');
                        });
                        setCameraLoc(LatLng(lat, lng));
                      }
                    });
                  }else{
                    _getLocation(context, locale);
                  }
                },
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  height: 52,
                  padding: EdgeInsets.only(left: 20),
                  decoration: BoxDecoration(
                      color: scaffoldBgColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: Row(
                    children: [
                      Icon(Icons.search,size: 25,),
                      SizedBox(width: 20,),
                      Text(locale.enterLocation
                      ),
                    ],
                  ),
                ),
              ),
              preferredSize:
              Size(MediaQuery.of(context).size.width * 0.85, 52)),
        ),
      ),
      body: locGranted?Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          SizedBox(
            height: 8.0,
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                GoogleMap(
                  mapType: MapType.normal,
                  initialCameraPosition: kGooglePlex,
                  zoomControlsEnabled: false,
                  myLocationButtonEnabled: false,
                  compassEnabled: false,
                  mapToolbarEnabled: false,
                  buildingsEnabled: false,
                  onMapCreated: (GoogleMapController controller) {
                    print('map created.');
                    _controller.complete(controller);
                  },
                  onCameraIdle: () {
                    // getMapLoc();
                    print('c move 1');
                  },
                  onCameraMove: (post) {
                    print('c move 3');
                    lat = post.target.latitude;
                    lng = post.target.longitude;
                    _goToTheLake(lat,lng);
                  },
                ),
                Align(
                    alignment: Alignment.center,
                    child: Padding(
                      padding: EdgeInsets.only(bottom: 36.0),
                      child: Image.asset(
                        'images/map_pin.png',
                        height: 36,
                      ),
                    ))
              ],
            ),
          ),
          Container(
            color: kCardBackgroundColor,
            padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: Row(
              children: <Widget>[
                Image.asset(
                  'images/map_pin.png',
                  scale: 3,
                ),
                SizedBox(
                  width: 16.0,
                ),
                Expanded(
                  child: Text(
                    '${currentAddress}',
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.caption,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          BottomBar(
              text: locale.continueField,
              onTap: () {
                Navigator.pop(context, BackLatLng(lat, lng,currentAddress));
              }),
        ],
      ):Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                locale.alertloc11,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 25,
                  color: kMainTextColor,
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(
                      left: 20.0,
                      top: 10.0,
                      bottom: 50,
                      right: 20.0),
                  child: Text(
                    locale.locationheadingSub,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 18,
                      color: kHintColor,
                    ),
                  )),
              RaisedButton(
                onPressed: () {
                  _getLocation(context, locale);
                },
                child: Text(
                  locale.presstoallow,
                  style: TextStyle(
                      color: kWhiteColor,
                      fontWeight: FontWeight.w400),
                ),
                color: kMainColor,
                highlightColor: kMainColor,
                focusColor: kMainColor,
                splashColor: kMainColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  // void getMapLoc() async {
  //   _getCameraMoveLocation(LatLng(lat, lng));
  // }
}

class Uuid {
  final Random _random = Random();

  String generateV4() {
    final int special = 8 + _random.nextInt(4);
    return '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}-'
        '${_bitsDigits(16, 4)}-'
        '4${_bitsDigits(12, 3)}-'
        '${_printDigits(special, 1)}${_bitsDigits(12, 3)}-'
        '${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}${_bitsDigits(16, 4)}';
  }

  String _bitsDigits(int bitCount, int digitCount) =>
      _printDigits(_generateBits(bitCount), digitCount);

  int _generateBits(int bitCount) => _random.nextInt(1 << bitCount);

  String _printDigits(int value, int count) =>
      value.toRadixString(16).padLeft(count, '0');
}
