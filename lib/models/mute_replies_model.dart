// flutter
import 'package:flutter/cupertino.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/domain/reply_mute/reply_mute.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/ints.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/strings.dart';
// domains
import 'package:sonanceep_sns/domain/mute_reply_token/mute_reply_token.dart';
// domain
import 'package:sonanceep_sns/models/main_model.dart';

final muteRepliesProvider = ChangeNotifierProvider(
  ((ref) => MuteRepliesModel()
));
class MuteRepliesModel extends ChangeNotifier {

  bool showMuteReplies = false;
  List<String> mutePostCommentReplyIds = [];
  List<DocumentSnapshot<Map<String,dynamic>>> muteReplyDocs = [];
  final RefreshController refreshController = RefreshController();
  List<MuteReplyToken> newMuteReplyTokens = [];  //新しくミュートするユーザー
  // 新しくミュートするユーザー
  Query<Map<String, dynamic>> returnQuery({
    required List<String> max10MutePostCommentReplyIds
  }) => FirebaseFirestore.instance.collectionGroup('postCommentReplies').where('postCommentReplyId', whereIn: max10MutePostCommentReplyIds);  // .orderBy()はクエリが必要

  Future<void> getMutePostCommentReplies({
    required MainModel mainModel,
  }) async {
    showMuteReplies = true;
    mutePostCommentReplyIds = mainModel.muteReplyIds;
    await process();
    notifyListeners();
  }

  Future<void> onRefresh({required MainModel mainModel}) async {
    refreshController.refreshCompleted();
    //複雑な処理
    //必ずしも実装する必要はない
    //新しく取得するのは能動的
    // mainModelでnewMutePostCommentReplyIds
    // onRefreshされたら配列を空にする
    await processNewMutePostCommentReplies();
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

  Future<void> processNewMutePostCommentReplies() async {
    final List<String> newMutePostCommentReplyIds = newMuteReplyTokens.map((e) => e.postCommentReplyId).toList();  // newMuteReplyTokensをfor文で回してpostCommentReplyIdだけをまとめている
    //新しくミュートしたコメントが10人以上の場合
    final List<String> max10MutePostCommentReplyIds = newMutePostCommentReplyIds.length > 10 ? 
    newMutePostCommentReplyIds.sublist(0, tenCount)  // 10より大きかったら10個取り出す
    : newMutePostCommentReplyIds;                    // 10より小さかったらそのまま適応
    if(max10MutePostCommentReplyIds.isNotEmpty) {
      final qshot = await returnQuery(max10MutePostCommentReplyIds: max10MutePostCommentReplyIds).get();
      final reversed = qshot.docs.reversed.toList();  //いつもの新しいdocsに対して行う処理
      for(final mutePostCommentReplyDoc in reversed) {
        muteReplyDocs.insert(0, mutePostCommentReplyDoc);
        // mutemutePostCommentReplyDocに加えたということはもう新しくない
        //新しいものリストから省く
        // tokenに含まれるpostCommentReplyIdがミュートされるべきユーザーと同じpostCommentReplyIdのものを取得
        final deleteNewMutePostCommentReplyTokens = newMuteReplyTokens.where((element) => element.postCommentReplyId == mutePostCommentReplyDoc.id).toList().first;
        newMuteReplyTokens.remove(deleteNewMutePostCommentReplyTokens);
      }
    }
    notifyListeners();
  }

  Future<void> process() async {
    if(mutePostCommentReplyIds.length > muteReplyDocs.length) {
      final int mutePostCommentReplyDocsLength = muteReplyDocs.length;  //序盤のmutemutePostCommentReplyDocsの長さを保持
      // whereInで検索にかけたので、max10MutePostCommentReplyIdsには10個までしかpostCommentReplyIdを入れない
      final List<String> max10MutePostCommentReplyIds = (mutePostCommentReplyIds.length - muteReplyDocs.length) > 10 ? 
      mutePostCommentReplyIds.sublist(mutePostCommentReplyDocsLength, mutePostCommentReplyDocsLength + tenCount) : mutePostCommentReplyIds.sublist(mutePostCommentReplyDocsLength, mutePostCommentReplyIds.length);  // sublistはリストを分解
      if(max10MutePostCommentReplyIds.isNotEmpty) {
        final qshot = await returnQuery(max10MutePostCommentReplyIds: max10MutePostCommentReplyIds).get();
        for(final mutePostCommentReplyDoc in qshot.docs) {
          muteReplyDocs.add(mutePostCommentReplyDoc);
        }
      }
    }
    notifyListeners();
  }

  Future<void> muteReply({
    required MainModel mainModel,
    required DocumentSnapshot replyDoc,  // docsにはpostDocs、ReplyDocsが含まれる
  }) async {
    final String tokenId = returnUuidV4();
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final Timestamp now = Timestamp.now();
    final postCommentReplyRef = replyDoc.reference;
    final String postCommentReplyId = replyDoc.id;
    final MuteReplyToken muteReplyToken = MuteReplyToken(
      activeUid: activeUid,
      createdAt: now,
      postCommentReplyId: postCommentReplyId,
      postCommentReplyRef: postCommentReplyRef,
      tokenId: tokenId,
      tokenType: muteReplyTokenTypeString,
    );
    newMuteReplyTokens.add(muteReplyToken);  //新しくミュートしたコメント
    mainModel.muteReplyTokens.add(muteReplyToken);  // muteReplyTokensに投稿のミュートした人のIdを含めた
    mainModel.muteReplyIds.add(postCommentReplyId);
    // replyDocs.remove(replyDoc);  //ミュートしたコメントを除外する    フロントエンドで非表示にしているので除外する必要はない
    notifyListeners();
    // currentUserDoc.ref...
    // 自分がミュートしたことの印
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: tokenId).set(muteReplyToken.toJson());
    //ミュートされたことの印
    final ReplyMute replyMute = ReplyMute(
      activeUid: activeUid,
      createdAt: now,
      postCommentReplyId: postCommentReplyId,
      postCommentReplyRef: postCommentReplyRef,
    );
    await replyDoc.reference.collection('postCommentReplyMutes').doc(activeUid).set(replyMute.toJson());
  }

  void showMuteReplyDialog({
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot replyDoc,  // docsにはpostDocs、ReplyDocsが含まれる
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext innerContext) => CupertinoAlertDialog(
        // title: const Text('コメントをミュートする'),
        content: const Text(muteReplyAlertMsg),
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
              await muteReply(mainModel: mainModel, replyDoc: replyDoc);
            },
            child: const Text(yesText),
          ),
        ],
      ),
    );
  }

  // void showMuteReplyPopup({
  //   required BuildContext context,
  //   required MainModel mainModel,
  //   required DocumentSnapshot ReplyDoc,  // docsにはpostDocs、ReplyDocsが含まれる
  //   required List<DocumentSnapshot<Map<String,dynamic>>> ReplyDocs,
  // }) {
  //   showCupertinoModalPopup(
  //     context: context,
  //     //中で別のcontextのinnerContextを生成する
  //     builder: (BuildContext innerContext) => CupertinoActionSheet(  // contextとは違う名前にする方が良い
  //       // title: const Text('行う操作を選択'),
  //       actions: <CupertinoActionSheetAction>[
  //         CupertinoActionSheetAction(
  //           isDestructiveAction: true,
  //           onPressed: () {
  //             Navigator.pop(innerContext);
  //             showMuteReplyDialog(context: context, mainModel: mainModel, ReplyDoc: ReplyDoc, ReplyDocs: ReplyDocs);
  //           },
  //           child: const Text(muteReplyText),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () => Navigator.pop(innerContext),
  //           child: const Text(backText),
  //         ),
  //       ],
  //     ) 
  //   );
  // }

  Future<void> unMuteReply({
    required MainModel mainModel,
    required DocumentSnapshot replyDoc,  // docsにはpostDocs、ReplyDocsが含まれる
  }) async {
    // nuteRepliesModel側の処理
    final String ReplyId = replyDoc.id;
    muteReplyDocs.remove(replyDoc);
    mainModel.muteReplyIds.remove(ReplyId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final MuteReplyToken deleteMuteReplyToken = mainModel.muteReplyTokens.where((element) => element.postCommentReplyId == ReplyId).toList().first;
    if(newMuteReplyTokens.contains(deleteMuteReplyToken)) {  //もし削除するミュートコメントが新しいやつなら
      newMuteReplyTokens.remove(deleteMuteReplyToken);
    }
    mainModel.muteReplyTokens.remove(deleteMuteReplyToken);
    notifyListeners();
    //自分がミュートしたことの印を削除
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: deleteMuteReplyToken.tokenId).delete();
    //コメントのミュートされた印を削除
    final DocumentReference<Map<String,dynamic>> muteReplyRef = deleteMuteReplyToken.postCommentReplyRef;
    await muteReplyRef.collection('postCommentReplyMutes').doc(activeUid).delete();
  }

  void showUnMuteReplyDialog({
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot replyDoc,  // docsにはpostDocs、ReplyDocsが含まれる
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext innerContext) => CupertinoAlertDialog(
        // title: const Text('ユーザーのミュートを解除する'),
        content: const Text(unMuteReplyAlertMsg),
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
              await unMuteReply(mainModel: mainModel, replyDoc: replyDoc);
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
  //   required DocumentSnapshot ReplyDoc,  // docsにはpostDocs、ReplyDocsが含まれる
  //   required List<DocumentSnapshot<Map<String,dynamic>>> ReplyDocs,
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
  //             showUnMuteUserDialog(context: context, mainModel: mainModel, ReplyDoc: ReplyDoc, ReplyDocs: ReplyDocs);
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