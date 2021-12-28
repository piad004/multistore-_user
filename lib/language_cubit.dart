
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<Locale> {

  LanguageCubit():super(Locale('en')){
   setLanguage();
  }

  void setLanguage() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    if(preferences.containsKey('language')){
      emit(Locale(preferences.getString('language')));
    }else{
      emit(Locale('en'));
    }
  }

  void selectLanguage(dynamic code) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('language', '${code}');
    emit(Locale('${code}'));
  }
}
