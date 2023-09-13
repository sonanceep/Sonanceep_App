// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
// models
// import 'package:sonanceep_sns/models/admin_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;

class AdminPage extends ConsumerWidget {
  const AdminPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final AdminModel adminModel = ref.watch(adminProvider);
    return Scaffold(
      appBar: AppBar(title: const Text(adminTitle),),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //アーティストを登録
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: RoundedButton(
                onPressed: () => routes.toArtistRegistrationPage(context: context),  //管理者権限を使用しない場合ここを変更
                widthRate: 0.85,
                color: Colors.blue,
                text: adminArtistRegistrationTitle,
              ),
            ),
          ),
          //アーティストを検索
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: RoundedButton(
                onPressed: () => routes.toArtistSearchPage(context: context, mainModel: mainModel),  //管理者権限を使用しない場合ここを変更
                widthRate: 0.85,
                color: Colors.purple,
                text: artistSearchTitle,
              ),
            ),
          ),
          const SizedBox(height: 200,),  //空虚なウェジットを作成してスペースを作る
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Center(
              child: RoundedButton(
                onPressed: () {},  //adminModel.admin(firestoreUser: mainModel.firestoreUser),  //管理者権限を使用しない場合ここを変更
                widthRate: 0.85,
                color: Colors.red.shade700,
                text: adminTitle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}