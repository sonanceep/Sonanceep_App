// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = ChangeNotifierProvider(
  (ref) => ThemeModel()
);

class ThemeModel extends ChangeNotifier {
  late SharedPreferences preferences;
  bool isDarkTheme = true;

  ThemeModel() {
    init();
  }

  Future<void> init() async {
    //端末に保存されているフラグなどを全て取得する
    preferences = await SharedPreferences.getInstance();
    final x = preferences.getBool(isDarkThemePrefsKey);  //保存データの取得
    if(x != null) isDarkTheme = x;
    notifyListeners();
  }

  Future<void> setIsDarkTheme({required bool value}) async {
    isDarkTheme = value;
    await preferences.setBool(isDarkThemePrefsKey, value);  //保存
    notifyListeners();
  }
}