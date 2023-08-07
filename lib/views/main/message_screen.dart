// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/models/main/message_model.dart';

class MessageScreen extends ConsumerWidget {
  const MessageScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MessageModel messageModel = ref.watch(messageProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(messageText),
      ),
    );
  }
}