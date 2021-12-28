import 'dart:convert';
import 'dart:typed_data';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/notification_bean.dart';
import 'package:user/providerlist/offerlistprovider.dart';

// FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

class OfferScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return OfferScreenState();
  }
}

class OfferScreenState extends State<OfferScreen> {
  // List<Notificationd> notificationList = [];

  // AppLocalizations locale;

  @override
  void initState() {
    // setNotificationListner();
    super.initState();
  }

  // void setNotificationListner() async {
  //   flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  //   var initializationSettingsAndroid =
  //       AndroidInitializationSettings('logo_user');
  //   var initializationSettingsIOS = IOSInitializationSettings(
  //       onDidReceiveLocalNotification: onDidReceiveLocalNotification);
  //   var initializationSettings = InitializationSettings(
  //       android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  //   await flutterLocalNotificationsPlugin.initialize(initializationSettings,
  //       onSelectNotification: selectNotification);
  //   FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  //   firebaseMessagingListner(firebaseMessaging);
  // }
  //
  // void firebaseMessagingListner(firebaseMessaging) async {
  //   firebaseMessaging.configure(
  //       onMessage: (Map<String, dynamic> message) async {
  //     print('fcm 1 ${message.toString()}');
  //     _showNotification(
  //         flutterLocalNotificationsPlugin,
  //         '${message['notification']['title']}',
  //         '${message['notification']['body']}');
  //     if(locale!=null){
  //       getNotificationList(locale);
  //     }
  //   }, onResume: (Map<String, dynamic> message) async {
  //     print('fcm - 2 ${message.toString()}');
  //   }, onLaunch: (Map<String, dynamic> message) async {
  //     _showNotification(
  //         flutterLocalNotificationsPlugin,
  //         '${message['notification']['title']}',
  //         '${message['notification']['body']}');
  //     print('fcm -  3 ${message.toString()}');
  //   });
  // }
  //
  // void getNotificationList(AppLocalizations locale) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   int userId = prefs.getInt('user_id');
  //   var url = notificationlist;
  //   http.post(url, body: {
  //     'user_id': '${userId}',
  //   }).then((value) {
  //     if (value.statusCode == 200) {
  //       var jsonData = jsonDecode(value.body);
  //       if (jsonData['status'] == "1") {
  //         var tagObjsJson = jsonDecode(value.body)['data'] as List;
  //         List<Notificationd> tagObjs = tagObjsJson
  //             .map((tagJson) => Notificationd.fromJson(tagJson))
  //             .toList();
  //         setState(() {
  //           notificationList.clear();
  //           notificationList = tagObjs;
  //         });
  //       } else {
  //         Toast.show(jsonData['message'], context,
  //             duration: Toast.LENGTH_SHORT);
  //       }
  //     } else {
  //       Toast.show(locale.noNotificationFound, context,
  //           duration: Toast.LENGTH_SHORT);
  //     }
  //   }).catchError((e) {});
  // }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);
    // setState(() {
    //   this.locale = locale;
    // });
    return Scaffold(
      backgroundColor: kCardBackgroundColor,
      body: BlocBuilder<NotificationListCubit, List<Notificationd>>(
        builder: (context,notificationList){
          return (notificationList != null && notificationList.length > 0)
              ? SingleChildScrollView(
            primary: true,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                ListView.separated(
                    shrinkWrap: true,
                    primary: false,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 20, vertical: 20),
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        color: white_color,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${notificationList[index].noti_title}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: kMainTextColor),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              '${notificationList[index].noti_message}',
                              style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: kHintColor),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            (notificationList[index].image != null &&
                                notificationList[index].image != 'N/A')
                                ? Image.network(
                              '${imageBaseUrl + notificationList[index].image}',
                              height: 150,
                              width: MediaQuery.of(context).size.width,
                              fit: BoxFit.fitWidth,
                            )
                                : Container(
                              height: 0.0,
                            )
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) {
                      return Divider(
                        height: 8,
                        color: Colors.transparent,
                      );
                    },
                    itemCount: notificationList.length)
              ],
            ),
          )
              : Center(
            child: Text(
              locale.noOfferText,
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: kMainTextColor),
            ),
          );
        },
      ),
    );
  }
}
//
// Future onDidReceiveLocalNotification(
//     int id, String title, String body, String payload) async {}
//
// Future<void> _showNotification(
//     FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
//     dynamic title,
//     dynamic body) async {
//   final Int64List vibrationPattern = Int64List(4);
//   vibrationPattern[0] = 0;
//   vibrationPattern[1] = 1000;
//   vibrationPattern[2] = 5000;
//   vibrationPattern[3] = 2000;
//   final AndroidNotificationDetails androidPlatformChannelSpecifics =
//   AndroidNotificationDetails('7458', 'Notify', 'Notify On Shopping',
//       vibrationPattern: vibrationPattern,
//       importance: Importance.max,
//       priority: Priority.high,
//       enableLights: true,
//       enableVibration: true,
//       playSound: true,
//       ticker: 'ticker');
//   final IOSNotificationDetails iOSPlatformChannelSpecifics =
//   IOSNotificationDetails(presentSound: true);
//   // IOSNotificationDetails iosDetail = IOSNotificationDetails(presentAlert: true);
//
//   final NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//     iOS: iOSPlatformChannelSpecifics,
//   );
//   await flutterLocalNotificationsPlugin.show(
//       0, '${title}', '${body}', platformChannelSpecifics,
//       payload: 'item x');
// }
//
// Future selectNotification(String payload) async {
//   if (payload != null) {}
// }
//
// Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
//   debugPrint('ob notification payload:');
//   _showNotification(
//       flutterLocalNotificationsPlugin,
//       '${message['notification']['title']}',
//       '${message['notification']['body']}');
// }
