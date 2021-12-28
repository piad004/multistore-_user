import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:user/Locale/locales.dart';
import 'package:user/baseurlp/baseurl.dart';
import 'package:user/bean/notification_bean.dart';
import 'package:http/http.dart' as http;

class NotificationListCubit extends Cubit<List<Notificationd>> {
  NotificationListCubit() : super([]){
    getNotificationList();
  }

  hitNotification() async{
    getNotificationList();
  }

  void getNotificationList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('user_id');
    var url = notificationlist;
    http.post(url, body: {
      'user_id': '${userId}',
    }).then((value) {
      print('noti list - ${value.body}');
      if (value.statusCode == 200) {
        var jsonData = jsonDecode(value.body);
        if (jsonData['status'] == "1") {
          var tagObjsJson = jsonDecode(value.body)['data'] as List;
          List<Notificationd> tagObjs = tagObjsJson
              .map((tagJson) => Notificationd.fromJson(tagJson))
              .toList();
          emit(tagObjs);
        }
      }
    }).catchError((e) {});
  }

}