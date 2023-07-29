// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// models
import 'package:sonanceep_sns/models/signup_model.dart';  //material design が入ったファイルをインポート  ( AppBar, ...etc)
// components
import 'package:sonanceep_sns/details/rounded_text_field.dart';
import 'package:sonanceep_sns/details/rounded_password_field.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';

class SignupPage extends ConsumerWidget {
  const SignupPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {  // WidgetRef ref でグローバルに監視した橋を観測できる
    final SignupModel signupModel = ref.watch(signupProvider);
    //入力されたテキストをコントロールできるようになる
    final TextEditingController emailEditingController = TextEditingController(text: signupModel.email);
    final TextEditingController passwordEditingController = TextEditingController(text: signupModel.password);

    return Scaffold(
      appBar: AppBar(  // AppBar 画面の一番上にあるバーのこと。アプリタイトルなど
        title: const Text(signupTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //メールアドレス
          RoundedTextField(
            keyboardType: TextInputType.emailAddress,  //キーボードのタイプ指定
            onChanged: (text) => signupModel.email = text,  //変更されたテキストを代入
            controller: emailEditingController,
            borderColor: Colors.black,
            shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
            hintText: mailAddressText,
          ),
          //パスワード
          RoundedPasswordField(
            onChanged: (text) => signupModel.password = text,
            passwordEditingController: passwordEditingController,  //入力内容を隠す
            obscureText:  signupModel.isObscure,
            toggleIsObscureText: () => signupModel.toggleIsObscure(),  //アイコンがタップされた時に切り替え
            borderColor: Colors.black,
            shadowColor: const Color(0xFFFE5D26).withOpacity(0.7),
          ),
          RoundedButton(
            onPressed:() async => await signupModel.createUser(context: context),  //ボタンが押された時に実行
            widthRate: 0.8,
            color: Colors.red,
            text: signupText,
          ),

          // Center(
          //   child: signupModel.currentUser == null ? Text('nullです。') : Text('nullじゃないです。'),
          // ),
        ],
      ),
    );
  }
}