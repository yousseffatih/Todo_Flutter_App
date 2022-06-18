import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/instance_manager.dart';
import 'package:get_storage/get_storage.dart';

class ThemeServices {
  final GetStorage _box = GetStorage();
  final _key = 'isDarkMode';  

   _saveThemeToBox (bool isDarkMode) => _box.write(_key, isDarkMode);

  bool _loadThemefromBox () => _box.read<bool>(_key) ?? false;

  ThemeMode get theme => _loadThemefromBox() ? ThemeMode.dark:ThemeMode.light;

  void switchTheme()
  {
    Get.changeThemeMode(_loadThemefromBox()? ThemeMode.light : ThemeMode.dark);
    _saveThemeToBox(!_loadThemefromBox());
  }
}
