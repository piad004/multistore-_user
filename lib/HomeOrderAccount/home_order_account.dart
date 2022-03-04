import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:circular_bottom_navigation/circular_bottom_navigation.dart';
import 'package:circular_bottom_navigation/tab_item.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/HomeOrderAccount/Account/UI/account_page.dart';
import 'package:user/HomeOrderAccount/Home/UI/home.dart';
import 'package:user/HomeOrderAccount/Order/UI/order_page.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/Themes/colors.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/providerlist/offerlistprovider.dart';
import 'package:user/walletrewardreffer/reffer/ui/reffernearn.dart';

import 'Home/UI/Stores/stores.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  'This channel is used for important notifications.', // description
  importance: Importance.high,
  playSound: true,
  sound: RawResourceAndroidNotificationSound('airtel'),
);

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  _showNotification(flutterLocalNotificationsPlugin,
      '${message.notification.title}', '${message.notification.body}');
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
    setMenuIndex();
    getCurrency();
  }

  void setFirebase() async {
    try {
      await Firebase.initializeApp();
    } catch (e) {}
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
        _showNotification(flutterLocalNotificationsPlugin,
            '${message.notification.title}', '${message.notification.body}');
      }
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null &&
          android != null &&
          notification.body != null) {
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
                playSound: true,
                sound: RawResourceAndroidNotificationSound('airtel'),
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
    if (!isRunning) {
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
    new TabItem(Icons.home, "Home", Colors.red,
        labelStyle: TextStyle(fontWeight: FontWeight.normal)),
    new TabItem(Icons.supervisor_account_rounded, "Refer & Earn", Colors.grey,
        labelStyle: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
    new TabItem(Icons.shopping_bag_outlined, "Order", Colors.grey),
    new TabItem(Icons.set_meal_outlined, "Meat & Fish", Colors.grey),
    new TabItem(Icons.account_circle_outlined, "Account", Colors.grey),
  ]);

  final List<Widget> _children = [
    HomePage(),
    //OfferScreen(),
    RefferScreen(),
    OrderPage(),
    StoresPage("Meat & Fish", 1, "1"),
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
        new TabItem(Icons.home, locale.homeText, Colors.red,
            labelStyle: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
        new TabItem(
            Icons.supervisor_account_rounded, "Refer & Earn", Colors.red,
            labelStyle: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
        new TabItem(Icons.shopping_bag_outlined, "Order", Colors.red,
            labelStyle: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
        new TabItem(Icons.set_meal_outlined, "Meat & Fish", Colors.red,
            labelStyle: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
        new TabItem(Icons.account_circle_outlined, "Account", Colors.red,
            labelStyle: TextStyle(
                color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
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
    if (Platform.isIOS) {
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

  Future<void> setMenuIndex() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOrder = prefs.getBool("isOrder");
    setState(() {
      if (isOrder != null && isOrder == true)
        _currentIndex=2;
      else
        _currentIndex=0;
    });

    prefs.setBool("isOrder", false);
  }
}

Future<void> _showNotification(
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin,
    dynamic title,
    dynamic body) async {
  final Int64List vibrationPattern = Int64List(5);
  vibrationPattern[0] = 0;
  vibrationPattern[1] = 1000;
  vibrationPattern[2] = 5000;
  vibrationPattern[3] = 2000;
  vibrationPattern[4] = 2000;
  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      AndroidNotificationDetails('7458', 'Notify', 'Notify On Shopping',
          vibrationPattern: vibrationPattern,
          importance: Importance.max,
          priority: Priority.high,
          enableLights: true,
          enableVibration: true,
          playSound: true,
          sound: RawResourceAndroidNotificationSound('airtel'),
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
