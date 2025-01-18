import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController{
  final _isdarkMode=false.obs;
  @override

  final _box = GetStorage(); // Store theme preference
  void _onInit(){
    super.onInit();
    _isdarkMode.value=_box.read('theme')??false;
    Get.changeThemeMode(_isdarkMode.value?ThemeMode.dark:ThemeMode.light);

  }
  void toggletheme(){
    _isdarkMode.value=!_isdarkMode.value;
    Get.changeThemeMode(_isdarkMode.value?ThemeMode.dark:ThemeMode.light);
    _box.write('theme', _isdarkMode.value);
  }

  RxBool get isDarkMode => _isdarkMode;
}