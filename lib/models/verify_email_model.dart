// flutter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;

final verifyEmailProvider = ChangeNotifierProvider(
  ((ref) => VerifyEmailModel()
));

class VerifyEmailModel extends ChangeNotifier {

  VerifyEmailModel() {
    init();
  }

  Future<void> init() async {
    User user = returnAuthUser()!;
    await user.reload();  // FireabaseAuthのユーザーのリロードを行う
    user = returnAuthUser()!;
    // ユーザーのメールアドレス宛にメールが送信される
    if(!user.emailVerified) {
      await user.sendEmailVerification();
      await voids.showFlutterToast(msg: '認証が完了していません。メールを送信しました！');
    } else {
      await voids.showFlutterToast(msg: '認証が完了しています');
    }
  }
}