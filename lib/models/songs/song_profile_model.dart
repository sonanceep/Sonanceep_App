// flutter
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';

final songProfileProvider = ChangeNotifierProvider(
  ((ref) => SongProfileModel()
));

class SongProfileModel extends ChangeNotifier {
  //PassiveUserProfileModelを参照する
}