// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// package
import 'package:flash/flash.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:fluttertoast/fluttertoast.dart' as fluttertoast;
import 'package:cloud_firestore/cloud_firestore.dart';
// constants
import 'package:sonanceep_sns/constants/bools.dart';
// models
import 'package:sonanceep_sns/models/main_model.dart';

void showFlashBar({
    required BuildContext context,
    required MainModel mainModel,
    required TextEditingController textEditingController,
    required void Function(String)? onChanged,
    // required String titleString,
    required Color primaryActionColor,
    required Widget Function(BuildContext, FlashController<Object?>, void Function(void Function()))? primaryActionBuilder,
  }) {
  //   context.showFlashBar(
  //   content: Form(
  //     child: TextFormField(
  //       controller: textEditingController,
  //       style: const TextStyle(fontWeight: FontWeight.bold),
  //       onChanged: onChanged,
  //       maxLength: 10,
  //     ),
  //   ),
  //   // title: Text(titleString),
  //   primaryActionBuilder: primaryActionBuilder,
  //   // 閉じる時の動作
  //   negativeActionBuilder: (context, controller, _) {
  //     return InkWell(
  //       child: const Icon(Icons.close),
  //       onTap: () async => await controller.dismiss(),
  //     );
  //   },
  // );
}

// onRefreshの内容
Future<void> processNewDocs({
  required List<String> muteUids,
  required List<String> mutePostIds,
  required List<DocumentSnapshot<Map<String, dynamic>>> docs,
  required Query<Map<String, dynamic>> query,
}) async {
  if(docs.isNotEmpty) {  //中身が空じゃないなら  ポストが何かしらある時
    final qshot = await query.limit(30).endBeforeDocument(docs.first).get();  //一番新しいポストを入れる  一番新しいポストのさらに新しいポストができるとそれを取得
    final reversed = qshot.docs.reversed.toList();
    for(final doc in reversed) {
      final map = doc.data();
      if(isValidUser(muteUids: muteUids, map: map) && !reversed.contains(doc) && isValidPost(mutePostIds: mutePostIds, map: map)) docs.insert(0, doc);
    } 
  }
}

// onReloadの内容
Future<void> processBasicDocs({
  required List<String> muteUids,
  required List<String> mutePostIds,
  required List<DocumentSnapshot<Map<String, dynamic>>> docs,
  required Query<Map<String, dynamic>> query,
}) async {
  final qshot = await query.limit(30).get();  // postの下のコメントがいいね順で
  final basicDocs = qshot.docs;
  docs.removeWhere((element) => true);  //中身を全部削除
  for(final doc in basicDocs) {  // postDocs = qshot.docs;では反応しない
    final map = doc.data();
    if(isValidUser(muteUids: muteUids, map: map) && !docs.contains(doc) && isValidPost(mutePostIds: mutePostIds, map: map)) docs.add(doc);
  }
}

// onLoadingの内容
Future<void> processOldDocs({
  required List<String> muteUids,
  required List<String> mutePostIds,
  required List<DocumentSnapshot<Map<String, dynamic>>> docs,
  required Query<Map<String, dynamic>> query,
}) async {
  if(docs.isNotEmpty) {  //中身が空じゃないなら  ポストが何かしらある時
    final qshot = await query.limit(30).startAfterDocument(docs.last).get();  //
    final oldDocs = qshot.docs;
    for(final doc in oldDocs) {
      final map = doc.data();
      if(isValidUser(muteUids: muteUids, map: map) && !docs.contains(doc) && isValidPost(mutePostIds: mutePostIds, map: map)) docs.add(doc);
    }
  }
}

void showPopup({
  required BuildContext context,
  required Widget Function(BuildContext) builder,
}) {
  showCupertinoModalPopup(
    context: context,
    builder: builder,
  );
}

Future<void> showFlutterToast({required String msg}) async {
  // flsashにToastが定義されているので分ける
  await fluttertoast.Fluttertoast.showToast(  //context依存ではないがメッセージを伝えられる
      msg: msg,
      toastLength: fluttertoast.Toast.LENGTH_SHORT,
      gravity: fluttertoast.ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.purple,
      textColor: Colors.white,
      fontSize: 16.0
    );
}

void showFlashDialog({
  required BuildContext context,
  required Widget content,
  required void Function()? onPressed,
  required Widget child,
}) {
  showDialog(
    barrierColor: const Color.fromRGBO(23, 23, 59, 0.9),
    context: context,
    builder: (_) {
      return AlertDialog(
        content: content,
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(backText),
          ),
          TextButton(
            onPressed: onPressed,
            child: child,
          ),
        ],
      );
    },
  );
}