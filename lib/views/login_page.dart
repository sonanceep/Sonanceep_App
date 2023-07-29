// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/details/forget_password_text.dart';
// model
import 'package:sonanceep_sns/models/login_model.dart';
// components
import 'package:sonanceep_sns/details/rounded_text_field.dart';
import 'package:sonanceep_sns/details/rounded_password_field.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;

class LoginPage extends ConsumerWidget {
  const LoginPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // WidgetRef ref でグローバルに監視した橋を観測できる
    final LoginModel loginModel = ref.watch(loginProvider);
    //入力されたテキストをコントロールできるようになる
    final TextEditingController emailEditingController = TextEditingController(text: loginModel.email);
    final TextEditingController passwordEditingController = TextEditingController(text: loginModel.password);

    return Scaffold(
      appBar: AppBar(  // AppBar 画面の一番上にあるバーのこと。アプリタイトルなど
        title: const Text(loginTitle),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //メールアドレス
          RoundedTextField(
            controller: emailEditingController,
            keyboardType: TextInputType.emailAddress,  //キーボードのタイプ指定
            onChanged: (text) => loginModel.email = text,  //変更されたテキストを代入
            borderColor: Colors.black,
            shadowColor: Colors.red.withOpacity(0.3),
            hintText: mailAddressText,
          ),

          //パスワード
          RoundedPasswordField(
            onChanged: (text) => loginModel.password = text,
            passwordEditingController: passwordEditingController,  //入力内容を隠す
            obscureText:  loginModel.isObscure,
            toggleIsObscureText: () => loginModel.toggleIsObscure(),  //アイコンがタップされた時に切り替え
            borderColor: Colors.black,
            shadowColor: Colors.blue.withOpacity(0.3),
          ),
          RoundedButton(
            onPressed:() async => await loginModel.login(context: context),  //ボタンが押された時に実行
            widthRate: 0.85,
            color: Colors.green,
            text: loginText,
          ),
          TextButton(
            onPressed: () => routes.toSignupPage(context: context),
            child: const Text(noAccountMsg),
          ),
          const ForgetPasswordText(),

          // Center(  ここでログイン状態を仮判定させた
          //   child: loginModel.currentUser == null ? Text('nullです。') : Text('nullじゃないです。'),
          // ),
        ],
      ),
    );
  }
}