// flutter
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';

final createProvider = ChangeNotifierProvider(
  ((ref) => CreateModel()
));
class CreateModel extends ChangeNotifier {}