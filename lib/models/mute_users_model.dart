// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/ints.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart';
// domain
import 'package:sonanceep_sns/domain/mute_user_token/mute_user_token.dart';
import 'package:sonanceep_sns/domain/user_mute/user_mute.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';

final muteUsersProvider = ChangeNotifierProvider(
  ((ref) => MuteUsersModel()
));
class MuteUsersModel extends ChangeNotifier {

  bool showMuteUsers = false;
  List<String> muteUids = [];
  List<DocumentSnapshot<Map<String,dynamic>>> muteUserDocs = [];
  final RefreshController refreshController = RefreshController();
  List<MuteUserToken> newMuteUserTokens = [];  //新しくミュートするユーザー
  // uidがmuteUidsに含まれているユーザーを全取得  ⚠️10人までしか取得できない
  // .whereと.createdAtの二つ以上のフィールドで絞っている
  // indexをfirestoreで作成する必要がある
  Query<Map<String, dynamic>> returnQuery({
    required List<String> max10MuteUids
  }) => FirebaseFirestore.instance.collection('users').where('uid', whereIn: max10MuteUids).orderBy('createdAt', descending: true);  // .orderBy()はクエリが必要

  Future<void> getMuteUsers({
    required MainModel mainModel,
  }) async {
    showMuteUsers = true;
    muteUids = mainModel.muteUids;
    await process();
    notifyListeners();
  }

  Future<void> onRefresh({required MainModel mainModel}) async {
    refreshController.refreshCompleted();
    //複雑な処理
    //必ずしも実装する必要はない
    //新しく取得するのは能動的
    // mainModelでnewMuteUids
    // onRefreshされたら配列を空にする
    await processNewMuteUsers();
    notifyListeners();
  }

  Future<void> onReload() async {
    await process();
    notifyListeners();
  }

  Future<void> onLoading() async {
    refreshController.loadComplete();
    await process();
    notifyListeners();
  }

  Future<void> processNewMuteUsers() async {
    final List<String> newMuteUids = newMuteUserTokens.map((e) => e.passiveUid).toList();  // newMuteUserTokensをfor文で回してpassiveUidだけをまとめている
    //新しくミュートしたユーザーが10人以上の場合
    final List<String> max10MuteUids = newMuteUids.length > 10 ? 
    newMuteUids.sublist(0, tenCount)  // 10より大きかったら10個取り出す
    : newMuteUids;                    // 10より小さかったらそのまま適応
    if(max10MuteUids.isNotEmpty) {
      final qshot = await returnQuery(max10MuteUids: max10MuteUids).get();
      final reversed = qshot.docs.reversed.toList();  //いつもの新しいdocsに対して行う処理
      for(final muteUserDoc in reversed) {
        muteUserDocs.insert(0, muteUserDoc);
        // muteUserDocに加えたということはもう新しくない
        //新しいものリストから省く
        // tokenに含まれるpassiveUidがミュートされるべきユーザーと同じuidのものを取得
        final deleteNewMuteUserTokens = newMuteUserTokens.where((element) => element.passiveUid == muteUserDoc.id).toList().first;
        newMuteUserTokens.remove(deleteNewMuteUserTokens);
      }
    }
    notifyListeners();
  }

  Future<void> process() async {
    if(muteUids.length > muteUserDocs.length) {
      final int userDocsLength = muteUserDocs.length;  //序盤のmuteUserDocsの長さを保持
      // whereInで検索にかけたので、max10MuteUidsには10個までしかUidを入れない
      final List<String> max10MuteUids = (muteUids.length - muteUserDocs.length) > 10 ? 
      muteUids.sublist(userDocsLength, userDocsLength + tenCount) : muteUids.sublist(userDocsLength, muteUids.length);  // sublistはリストを分解
      if(max10MuteUids.isNotEmpty) {
        final qshot = await returnQuery(max10MuteUids: max10MuteUids).get();
        for(final userDoc in qshot.docs) {
          muteUserDocs.add(userDoc);
        }
      }
    }
    notifyListeners();
  }

  Future<void> muteUser({
    required MainModel mainModel,
    required String passiveUid,
    required List<DocumentSnapshot<Map<String,dynamic>>> docs,  // docsにはpostDocs、commentDocsが含まれる
  }) async {
    final String tokenId = returnUuidV4();
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final Timestamp now = Timestamp.now();
    final passiveUserDoc = await FirebaseFirestore.instance.collection('users').doc(passiveUid).get();
    final MuteUserToken muteUserToken = MuteUserToken(
      activeUid: activeUid,
      createdAt: now,
      passiveUid: passiveUid,
      tokenId: tokenId,
      tokenType: muteUserTokenTypeString,
    );
    // newMuteUserTokens.add(muteUserToken);  //新しくミュートしたユーザー
    mainModel.muteUserTokens.add(muteUserToken);
    mainModel.muteUids.add(passiveUid);  // muteUidsに投稿のミュートした人のUidを含めた
    docs.removeWhere((element) => element.data()!['uid'] == passiveUid,);  //ミュートしたいユーザーが作成したコンテンツを除外する
    notifyListeners();
    // currentUserDoc.ref...
    // 自分がミュートしたことの印
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: tokenId).set(muteUserToken.toJson());
    //ミュートされたことの印
    final UserMute userMute = UserMute(
      activeUid: activeUid,
      createdAt: now,
      passiveUid: passiveUid,
      passiveUserRef: passiveUserDoc.reference,
    );
    await passiveUserDoc.reference.collection('userMutes').doc(activeUid).set(userMute.toJson());
  }

  void showMuteUserDialog({
    required BuildContext context,
    required MainModel mainModel,
    required String passiveUid,
    required List<DocumentSnapshot<Map<String,dynamic>>> docs,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext innerContext) => CupertinoAlertDialog(
        // title: const Text('ユーザーをミュートする'),
        content: const Text(muteUserAlertMsg),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(innerContext),
            child: const Text(noText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(innerContext);
              await muteUser(mainModel: mainModel, passiveUid: passiveUid, docs: docs);
            },
            child: const Text(yesText),
          ),
        ],
      ),
    );
  }

  // void showMuteUserPopup({
  //   required BuildContext context,
  //   required MainModel mainModel,
  //   required String passiveUid,
  //   required List<DocumentSnapshot<Map<String,dynamic>>> docs,
  // }) {
  //   voids.showPopup(
  //     context: context,
  //     builder: (BuildContext innerContext) => CupertinoActionSheet(
  //     )
  //   );
  // }

  Future<void> unMuteUser({
    required MainModel mainModel,
    required String passiveUid,
    required DocumentSnapshot<Map<String,dynamic>> muteUserDoc,
  }) async {
    // nuteUsersModel側の処理
    muteUserDocs.remove(muteUserDoc);
    mainModel.muteUids.remove(passiveUid);
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final deleteMuteUserToken = mainModel.muteUserTokens.where((element) => element.passiveUid == passiveUid).toList().first;
    if(newMuteUserTokens.contains(deleteMuteUserToken)) {  //もし削除するミュートユーザーが新しいやつなら
      newMuteUserTokens.remove(deleteMuteUserToken);
    }
    mainModel.muteUserTokens.remove(deleteMuteUserToken);
    notifyListeners();
    //自分がミュートしたことの印を削除
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: deleteMuteUserToken.tokenId).delete();
    //ユーザーのミュートされた印を削除
    final DocumentReference<Map<String,dynamic>> muteUserRef = FirebaseFirestore.instance.collection('users').doc(passiveUid);
    await muteUserRef.collection('userMutes').doc(activeUid).delete();
  }

  void showUnMuteUserDialog({
    required BuildContext context,
    required MainModel mainModel,
    required String passiveUid,
    required DocumentSnapshot<Map<String,dynamic>> muteUserDoc,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext innerContext) => CupertinoAlertDialog(
        // title: const Text('ユーザーのミュートを解除する'),
        content: const Text(unMuteUserAlertMsg),
        actions: <CupertinoDialogAction>[
          CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () => Navigator.pop(innerContext),
            child: const Text(noText),
          ),
          CupertinoDialogAction(
            isDestructiveAction: true,
            onPressed: () async {
              Navigator.pop(innerContext);
              await unMuteUser(mainModel: mainModel, passiveUid: passiveUid, muteUserDoc: muteUserDoc);
            },
            child: const Text(yesText),
          ),
        ],
      ),
    );
  }

  // void showUnMuteUserPopup({
  //   required BuildContext context,
  //   required MainModel mainModel,
  //   required String passiveUid,
  //   required DocumentSnapshot<Map<String,dynamic>> muteUserDoc,
  // }) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     //中で別のcontextのinnerContextを生成する
  //     builder: (BuildContext innerContext) => CupertinoActionSheet(  // contextとは違う名前にする方が良い
  //       // title: const Text('行う操作を選択'),
  //       actions: <CupertinoActionSheetAction>[
  //         CupertinoActionSheetAction(
  //           onPressed: () {
  //             Navigator.pop(innerContext);
  //             showUnMuteUserDialog(context: context, mainModel: mainModel, passiveUid: passiveUid, muteUserDoc: muteUserDoc);
  //           },
  //           child: const Text(unMuteUserText),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () => Navigator.pop(innerContext),
  //           child: const Text(backText),
  //         ),
  //       ],
  //     ) 
  //   );
  // }
}