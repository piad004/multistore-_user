import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/HomeOrderAccount/Account/UI/account_page.dart';
import 'package:user/HomeOrderAccount/Home/UI/home.dart';
import 'package:user/HomeOrderAccount/Order/UI/order_page.dart';
import 'package:user/HomeOrderAccount/offer/ui/offerui.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/providerlist/offerlistprovider.dart';


FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
);
Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  _showNotification(
      flutterLocalNotificationsPlugin,
      '${message.notification.title}',
      '${message.notification.body}');
}


class HomeStateless extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeOrderAccount(),
    );
  }
}

class HomeOrderAccount extends StatefulWidget {
  @override
  _HomeOrderAccountState createState() => _HomeOrderAccountState();
}

class _HomeOrderAccountState extends State<HomeOrderAccount> {
  int _currentIndex = 0;
  double bottomNavBarHeight = 60.0;
  CircularBottomNavigationController _navigationController;
  bool isRunning = false;
  NotificationListCubit notificationInit;

  @override
  void initState() {
    super.initState();
    notificationInit = BlocProvider.of<NotificationListCubit>(context);
    setFirebase();
    _navigationController =
    new CircularBottomNavigationController(_currentIndex);
    getCurrency();
  }

  void setFirebase() async {
    try{
      await Firebase.initializeApp();
    }catch(e){

    }
    messaging = FirebaseMessaging.instance;
    iosPermission(messaging);
    var initializationSettingsAndroid =
    AndroidInitializationSettings('logo_user');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
    messaging.getToken().then((value) {
      debugPrint('token: $value');
    });
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage message) {
      if (message != null) {
        _showNotification(
            flutterLocalNotificationsPlugin,
            '${message.notification.title}',
            '${message.notification.body}');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null && notification.body!=null) {
        notificationInit.hitNotification();
        print('notificatioin d d ');
        flutterLocalNotificationsPlugin.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channel.description,
                icon: 'logo_user',
              ),
            ));
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');

      // _showNotification(
      //     flutterLocalNotificationsPlugin,
      //     '${message.notification.title}',
      //     '${message.notification.body}');
    });
    FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  }

  void getCurrency() async {
    if(!isRunning){
      setState(() {
        isRunning = true;
      });
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var currencyUrl = currencyuri;
      var client = http.Client();
      client.get(currencyUrl).then((value) {
        print('${value.body}');
        var jsonData = jsonDecode(value.body);
        if (value.statusCode == 200 && jsonData['status'] == "1") {
          preferences.setString(
              'curency', '${jsonData['data'][0]['currency_sign']}');
        }
        setState(() {
          isRunning = false;
        });
      }).catchError((e) {
        print(e);
        setState(() {
          isRunning = false;
        });
      });
    }
  }

  List<TabItem> tabItems = List.of([
    new TabItem(Icons.home, "Home", Colors.blue,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    new TabItem(Icons.local_offer, "Update", Colors.orange,
        labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
    new TabItem(Icons.reorder, "Order", Colors.red),
    new TabItem(Icons.account_circle, "Account", Colors.cyan),
  ]);

  final List<Widget> _children = [
    HomePage(),
    OfferScreen(),
    OrderPage(),
    AccountPage(),
  ];

  void onTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    var locale = AppLocalizations.of(context);

    setState(() {
      tabItems = List.of([
        new TabItem(Icons.home, locale.homeText, Colors.blue,
            labelStyle: TextStyle(fontWeight: FontWeight.normal)),
        new TabItem(Icons.local_offer, locale.updateText, Colors.orange,
            labelStyle: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
        new TabItem(Icons.reorder, locale.orderText, Colors.red),
        new TabItem(Icons.account_circle, locale.accountText, Colors.cyan),
      ]);
    });


    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _children,
      ),
      bottomNavigationBar: bottomNav(context),
    );
  }

  Widget bottomNav(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 70,
      color: kWhiteColor,
      child: CircularBottomNavigation(
        tabItems,
        controller: _navigationController,
        barHeight: 45,
        circleSize: 40,
        barBackgroundColor: kWhiteColor,
        iconsSize: 20,
        circleStrokeWidth: 5,
        animationDuration: Duration(milliseconds: 300),
        selectedCallback: (int selectedPos) {
          setState(() {
            this._currentIndex = selectedPos;
          });
          getCurrency();
        },
      ),
    );
  }


  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    // var message = jsonDecode('${payload}');
    _showNotification(flutterLocalNotificationsPlugin, '${title}', '${body}');
  }

  Future selectNotification(String payload) async {}



  void iosPermission(FirebaseMessaging firebaseMessaging) {
    if(Platform.isIOS){
      firebaseMessaging.setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
    // firebaseMessaging.requestNotificationPermissions(
    //     IosNotificationSettings(sound: true, badge: true, alert: true));
    // firebaseMessaging.onIosSettingsRegistered.listen((event) {
    //   print('${event.provisional}');
    // });
  }
}

Future<void> _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    dynamic title,
    dynamic body) async {
  final Int64List vibrationPattern = Int64List(4);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails('7458', 'Notify', 'Notify On Shopping',
      vibrationPattern: vibrationPattern,
      importance: Importance.max,
      priority: Priority.high,
      enableLights: true,
      enableVibration: true,
      playSound: true,
      ticker: 'ticker');
  final IOSNotificationDetails iOSPlatformChannelSpecifics =
  IOSNotificationDetails(presentSound: true);
  final NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iOSPlatformChannelSpecifics,
  );
  await flutterLocalNotificationsPlugin.show(
      0, '${title}', '${body}', platformChannelSpecifics,
      payload: 'item x');
}
