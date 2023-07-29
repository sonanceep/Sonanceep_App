// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/models/verify_email_model.dart';

class VerifyEmailPage extends ConsumerWidget {
  const VerifyEmailPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {

    // modelそのものは使用しないので呼び出すだけで良い
    ref.watch(verifyEmailProvider);

    return Scaffold(
      //戻る機能をつけないようにAppbarは使用しない
      body: Container(
        alignment: Alignment.center,
        child: const Text('メールアドレスを認証するメールを送信しました'),
      ),
    );
  }
}