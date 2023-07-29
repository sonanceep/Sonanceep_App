// flutter
import 'package:flutter/material.dart';
// package
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;

final loginProvider = ChangeNotifierProvider(
  ((ref) => LoginModel()
));

class LoginModel extends ChangeNotifier {
  // auth  email,passwordの変数を作成
  String email = '';
  String password = '';
  bool isObscure = true;  //アカウント作成時等、入力を隠すかどうか

  //ログイン
  Future<void> login({required BuildContext context}) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);  //サインイン
      routes.toMyApp(context: context);
    } on FirebaseAuthException catch(e) {
      String msg = '';
      switch(e.code) {
        // caseのエラーコードは視認性を高めるために変数には格納しない
        // 国際化に対応する必要がないstring
        case 'wrong-password':
          msg = wrongPasswordMsg;
        break;
        case 'user-not-found':
          msg = userNotFoundMsg;
        break;
        case 'user-disabled':
          msg = userDisabledMsg;
        break;
        case 'invalid-email':
          msg = invalidEmailMsg;
        break;
      }
      await voids.showFlutterToast(msg: msg);
    }
  }
  void toggleIsObscure() {
    isObscure = !isObscure;
    notifyListeners();
  }

  //ログアウト
  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}