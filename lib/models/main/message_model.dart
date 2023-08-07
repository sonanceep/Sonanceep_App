// flutter
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';

final messageProvider = ChangeNotifierProvider(
  ((ref) => MessageModel()
));
class MessageModel extends ChangeNotifier {}