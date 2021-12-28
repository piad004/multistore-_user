import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:horizontal_calendar_widget/date_helper.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Components/bottom_bar.dart';
import 'package:user/HomeOrderAccount/Account/UI/ListItems/saved_addresses_page.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/address.dart';

class UploadPrescription extends StatefulWidget {
  final dynamic vendor_id;
  UploadPrescription(this.vendor_id);

  @override
  State<StatefulWidget> createState() {
    return UploadPrescriptionState();
  }
}

class UploadPrescriptionState extends State<UploadPrescription> {
  ShowAddressNew addressDelivery;
  bool isFetchingTime = false;
  bool enterFirst = false;
  DateTime firstDate;
  DateTime lastDate;
  List<DateTime> dateList = [];
  List<dynamic> radioList = [];
  String dateTimeSt = '';
  File _image;
  final picker = ImagePicker();
  int idd = 0;
  int idd1 = 0;
  dynamic storeName;
  bool showDialogBox = false;

  _imgFromCamera() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  _imgFromGallery() async {
    picker.getImage(source: ImageSource.gallery).then((pickedFile) {
      setState(() {
        if (pickedFile != null) {
          _image = File(pickedFile.path);
        } else {
          print('No image selected.');
        }
      });
    }).catchError((e) => print(e));
  }

  void _showPicker(context) {
    var locale = AppLocalizations.of(context);
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  new ListTile(
                      leading: new Icon(Icons.photo_library),
                      title: new Text(locale.photoLibrary),
                      onTap: () {
                        _imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  new ListTile(
                    leading: new Icon(Icons.photo_camera),
                    title: new Text(locale.camera),
                    onTap: () {
                      _imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  void getStoreName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String storename = prefs.getString('store_name');
    setState(() {
      storeName = storename;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  void prepareData(firstDate) {

    // lastDate = toDateMonthYear(firstDate.add(Duration(days: 9)));
    lastDate = DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(firstDate.add(Duration(days: 9))));
    dateList.add(firstDate);
    for(int i=0;i<9;i++){
      dateList.add(DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(firstDate.add(Duration(days: i+1)))));
    }
    // dateList = getDateList(firstDate, lastDate);
  }

  void hitDateCounter(date) async {
    setState(() {
      isFetchingTime = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    String vendorId = pref.getString('vendor_id');
    var url = timeSlots;
    http.post(url,
        body: {'vendor_id': vendorId, 'selected_date': '$date'}).then((value) {
      if (value != null && value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var rdlist = jsonData['data'] as List;
          print('list $rdlist');
          setState(() {
            radioList.clear();
            radioList = rdlist;
          });
        } else {
          setState(() {
            radioList = [];
          });
          Toast.show(jsonData['message'], context,
              duration: Toast.LENGTH_SHORT);
        }
      } else {
        setState(() {
          radioList = [];
          // radioList = rdlist;
        });
      }
      setState(() {
        isFetchingTime = false;
      });
    }).catchError((e) {
      setState(() {
        isFetchingTime = false;
      });
      print(e);
    });
  }

  void getAddress(BuildContext context, AppLocalizations locale) async {
    // var locale = AppLocalizations.of(context);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    String vendorId = prefs.getString('vendor_id');
    var url = address_selection;
    http.post(url, body: {
      'user_id': '${userId}',
      'vendor_id': '${vendorId}'
    }).then((value) {
      if (value.statusCode == 200) {
        var jsonData = json.decode(value.body);
        if (jsonData['status'] == "1" &&
            jsonData['data'] != null &&
            jsonData['data'] != 'null') {
          AddressSelected addressWelcome = AddressSelected.fromJson(jsonData);
          if (addressWelcome.data != null) {
            setState(() {
              addressDelivery = addressWelcome.data;
            });
          } else {
            addressDelivery = null;
          }
        } else {
          setState(() {
            addressDelivery = null;
          });
          Toast.show(locale.noAddressFound, context,
              duration: Toast.LENGTH_SHORT);
        }
      } else {
        setState(() {
          addressDelivery = null;
        });
        Toast.show(locale.noAddressFound, context, duration: Toast.LENGTH_SHORT);
      }
    }).catchError((e) {
      setState(() {
        addressDelivery = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    var size = MediaQuery.of(context).size;
    final double itemHeight = (size.height - kToolbarHeight - 24) / 7;
    final double itemWidth = size.width / 2;
    if(!enterFirst){
      setState(() {
        enterFirst = true;
      });
      getAddress(context,locale);
      firstDate = DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(DateTime.now()));
      prepareData(firstDate);
      dateTimeSt =
      '${firstDate.year}-${(firstDate.month.toString().length == 1) ? '0' + firstDate.month.toString() : firstDate.month}-${firstDate.day}';
      // lastDate = toDateMonthYear(firstDate.add(Duration(days: 9)));
      lastDate = DateFormat('dd/MM/yyyy').parse(DateFormat('dd/MM/yyyy').format(firstDate.add(Duration(days: 9))));
      getStoreName();
      dynamic date =
          '${firstDate.day}-${(firstDate.month.toString().length == 1) ? '0' + firstDate.month.toString() : firstDate.month}-${firstDate.year}';
      hitDateCounter(date);
    }
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppBar(
              automaticallyImplyLeading: true,
              backgroundColor: kWhiteColor,
              title: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    locale.uploadprescriptionText,
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: kMainTextColor),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                            child: Container(
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.stretch,
                                  children: [
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(left: 20.0),
                                      child: Center(
                                        child: Container(
                                          height: 400,
                                          width: MediaQuery.of(context).size.width * 0.75,
                                          alignment: Alignment.center,
                                          child: GestureDetector(
                                            onTap: () {
                                              _showPicker(context);
                                            },
                                            behavior: HitTestBehavior.opaque,
                                            child: Stack(
                                              children: <Widget>[
                                                Container(
                                                  height: 400,
                                                  width:
                                                  MediaQuery.of(context).size.width * 0.75,
                                                  color: kCardBackgroundColor,
                                                  child: _image != null
                                                      ? Image.file(_image)
                                                      : Container(),
                                                ),
                                                Align(
                                                  alignment: Alignment.center,
                                                  child: Row(
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.camera_alt,
                                                        color: kMainColor,
                                                        size: 19.0,
                                                      ),
                                                      SizedBox(width: 14.3),
                                                      Text(locale.uploadPhotoText,
                                                          style: Theme.of(context)
                                                              .textTheme
                                                              .caption
                                                              .copyWith(color: kMainColor)),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 6.7,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      color: kCardBackgroundColor,
                                      child: Text(locale.dateSlotText,
                                          style: Theme.of(context).textTheme.headline6.copyWith(
                                              color: Color(0xff616161), letterSpacing: 0.67)),
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 6.7,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      height: 35,
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(right: 5, left: 5),
                                      child: ListView.builder(
                                          itemCount: dateList.length,
                                          shrinkWrap: true,
                                          scrollDirection: Axis.horizontal,
                                          itemBuilder: (context, index) {
                                            var dateCount1 =
                                                '${dateList[index].day.toString()}/${(dateList[index].month.toString().length == 1) ? '0' + dateList[index].month.toString() : dateList[index].month}/${dateList[index].year}';
                                            DateFormat formatter = DateFormat('dd MMM yyyy');
                                            var dateCount = formatter.format(dateList[index]);
                                            return GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  idd1 = -1;
                                                  idd = index;
                                                  dateTimeSt =
                                                  '${dateList[index].year}-${(dateList[index].month.toString().length == 1) ? '0' + dateList[index].month.toString() : dateList[index].month}-${dateList[index].day}';
                                                  dynamic date =
                                                      '${dateList[index].day}-${(dateList[index].month.toString().length == 1) ? '0' + dateList[index].month.toString() : dateList[index].month}-${dateList[index].year}';

                                                  hitDateCounter(date);
                                                  print('${dateTimeSt}');
                                                });
                                              },
                                              child: Container(
                                                padding: EdgeInsets.only(right: 10, left: 10),
                                                margin: EdgeInsets.only(right: 5, left: 5),
                                                height: 30,
                                                width: MediaQuery.of(context).size.width / 3,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: (idd == index)
                                                        ? kMainColor
                                                        : kWhiteColor,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius: BorderRadius.circular(20),
                                                    border: Border.all(
                                                        color: (idd == index)
                                                            ? kMainColor
                                                            : kMainColor)),
                                                child: Text(
                                                  '${dateCount}',
                                                  style: TextStyle(
                                                      color: (idd == index)
                                                          ? kWhiteColor
                                                          : kMainTextColor,
                                                      fontSize: 14),
                                                ),
                                              ),
                                            );
                                          }),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 6.7,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      color: kCardBackgroundColor,
                                      child: Text(locale.timeSlotText,
                                          style: Theme.of(context).textTheme.headline6.copyWith(
                                              color: Color(0xff616161), letterSpacing: 0.67)),
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 6.7,
                                    ),
                                    (!isFetchingTime && radioList.length > 0)
                                        ? Container(
                                      width: MediaQuery.of(context).size.width,
                                      padding: EdgeInsets.only(right: 5, left: 5),
                                      child: GridView.builder(
                                        itemCount: radioList.length,
                                        gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3,
                                          crossAxisSpacing: 4.0,
                                          mainAxisSpacing: 4.0,
                                          childAspectRatio: (itemWidth / itemHeight),
                                        ),
                                        controller:
                                        ScrollController(keepScrollOffset: false),
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                idd1 = index;
                                                print('${radioList[idd1]}');
                                              });
                                            },
                                            child: SizedBox(
                                              height: 100,
                                              child: Container(
                                                margin: EdgeInsets.only(
                                                    right: 5, left: 5, top: 5, bottom: 5),
                                                height: 30,
                                                width: 100,
                                                alignment: Alignment.center,
                                                decoration: BoxDecoration(
                                                    color: (idd1 == index)
                                                        ? kMainColor
                                                        : kWhiteColor,
                                                    shape: BoxShape.rectangle,
                                                    borderRadius:
                                                    BorderRadius.circular(20),
                                                    border: Border.all(
                                                        color: (idd1 == index)
                                                            ? kMainColor
                                                            : kMainColor)),
                                                child: Text(
                                                  '${radioList[index].toString()}',
                                                  style: TextStyle(
                                                      color: (idd1 == index)
                                                          ? kWhiteColor
                                                          : kMainTextColor,
                                                      fontSize: 12),
                                                ),
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    )
                                        : Container(
                                      height: 120,
                                      width: MediaQuery.of(context).size.width,
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          isFetchingTime
                                              ? CircularProgressIndicator()
                                              : Container(
                                            width: 0.5,
                                          ),
                                          isFetchingTime
                                              ? SizedBox(
                                            width: 10,
                                          )
                                              : Container(
                                            width: 0.5,
                                          ),
                                          (isFetchingTime)
                                              ? Text(
                                            locale.fetchingTimeSlotText,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: kMainTextColor),
                                          )
                                              : Expanded(
                                            child: Text(
                                              locale.noTimeSlotText,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: kMainTextColor),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 6.7,
                                    ),
                                    Container(
                                      padding: EdgeInsets.all(10.0),
                                      color: kCardBackgroundColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(locale.deliveryAddressText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .headline6
                                                  .copyWith(
                                                  color: Color(0xff616161),
                                                  letterSpacing: 0.67)),
                                          Visibility(
                                            visible: (addressDelivery != null) ? true : false,
                                            child: GestureDetector(
                                                onTap: () async {
                                                  SharedPreferences prefs =
                                                  await SharedPreferences.getInstance();
                                                  String vendorId =
                                                  prefs.getString('vendor_id');
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(builder: (context) {
                                                        return SavedAddressesPage(vendorId);
                                                      })).then((value) {
                                                    getAddress(context,locale);
                                                  });
                                                },
                                                behavior: HitTestBehavior.opaque,
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 25,
                                                )),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(
                                      color: kCardBackgroundColor,
                                      thickness: 6.7,
                                    ),
                                    (addressDelivery != null)
                                        ? Container(
                                      padding: EdgeInsets.all(10.0),
                                      color: kWhiteColor,
                                      child: Text(
                                          addressDelivery != null
                                              ? '${addressDelivery.address != null ? '${addressDelivery.address})' : ''} \n ${(addressDelivery.delivery_charge != null) ? addressDelivery.delivery_charge : ''}'
                                              : '',
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                              fontSize: 11.7,
                                              color: Color(0xffb7b7b7))),
                                    )
                                        : GestureDetector(
                                      onTap: () async {
                                        SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                        String vendorId = prefs.getString('vendor_id');
                                        Navigator.of(context)
                                            .push(MaterialPageRoute(builder: (context) {
                                          return SavedAddressesPage(vendorId);
                                        })).then((value) {
                                          getAddress(context,locale);
                                        });
                                      },
                                      behavior: HitTestBehavior.opaque,
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 50),
                                        alignment: Alignment.center,
                                        child: Text(locale.clickaddressText,
                                            style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: kMainTextColor)),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )),
                        BottomBar(text: locale.placeOrderRequestText, onTap: () {

                          // dateTimeSt
                          if((_image!=null && _image.path!=null)&&(addressDelivery!=null && addressDelivery.addressId!=null)){
                            setState(() {
                              showDialogBox = !showDialogBox;
                            });
                            hitUploadService(dateTimeSt, radioList[idd1], context,locale);
                          }else{
                            if((_image!=null && _image.path!=null)){
                              Toast.show(locale.pleaseuploadlistText, context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                            }else if((addressDelivery!=null && addressDelivery.addressId!=null)){
                              Toast.show(locale.pleaseselectaddressText, context,duration: Toast.LENGTH_SHORT,gravity: Toast.CENTER);
                            }

                          }
                        }),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: showDialogBox,
                    child: GestureDetector(
                      onTap: (){},
                      behavior: HitTestBehavior.opaque,
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        alignment: Alignment.center,
                        child: CircularProgressIndicator(),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  void hitUploadService(dateSlot, timeSlot, BuildContext context, AppLocalizations locale) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    String fid = _image.path.split('/').last;
    var url = orderList;
    var request = http.MultipartRequest("POST", url);
    request.fields["user_id"] = '${userId}';
    request.fields["address_id"] = '${addressDelivery.addressId}';
    request.fields["vendor_id"] = '${widget.vendor_id}';
    request.fields["delivery_date"] = '${dateSlot}';
    request.fields["time_slot"] = '${timeSlot}';
    http.MultipartFile.fromPath("orderlist", _image.path, filename: fid).then((pic){
      request.files.add(pic);
      request.send().then((values) {
        values.stream.toBytes().then((value) {
          var responseString = String.fromCharCodes(value);
          var jsonData = jsonDecode(responseString);
          print('${jsonData}');
          if (jsonData['status'] == "1") {
            Toast.show(jsonData['message'], context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
            Navigator.of(context).pop();
          } else {
            Toast.show(locale.someThingWentText, context,
                duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
          }
          setState(() {
            showDialogBox = false;
          });
        }).catchError((e){
          setState(() {
            showDialogBox = false;
          });
          print(e);
        });
      }).catchError((e) {
        setState(() {
          showDialogBox = false;
        });
        print(e);
        Toast.show(locale.someThingWentText, context,
            duration: Toast.LENGTH_SHORT, gravity: Toast.CENTER);
      });
    }).catchError((e){
      setState(() {
        showDialogBox = false;
      });
      print(e);
    });
  }
}
