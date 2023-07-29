// flutter
import 'package:flutter/cupertino.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/ints.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/strings.dart';
// domains
import 'package:sonanceep_sns/domain/mute_comment_token/mute_comment_token.dart';
import 'package:sonanceep_sns/domain/comment_mute/comment_mute.dart';
// domain
import 'package:sonanceep_sns/models/main_model.dart';

final muteCommentsProvider = ChangeNotifierProvider(
  ((ref) => MuteCommentsModel()
));
class MuteCommentsModel extends ChangeNotifier {

  bool showMuteComments = false;
  List<String> mutePostCommentIds = [];
  List<DocumentSnapshot<Map<String,dynamic>>> muteCommentDocs = [];
  final RefreshController refreshController = RefreshController();
  List<MuteCommentToken> newMuteCommentTokens = [];  //新しくミュートするユーザー
  // 新しくミュートするユーザー
  Query<Map<String, dynamic>> returnQuery({
    required List<String> max10MutePostCommentIds
  }) => FirebaseFirestore.instance.collectionGroup('postComments').where('postCommentId', whereIn: max10MutePostCommentIds);  // .orderBy()はクエリが必要

  Future<void> getMutePostComments({
    required MainModel mainModel,
  }) async {
    showMuteComments = true;
    mutePostCommentIds = mainModel.muteCommentIds;
    await process();
    notifyListeners();
  }

  Future<void> onRefresh({required MainModel mainModel}) async {
    refreshController.refreshCompleted();
    //複雑な処理
    //必ずしも実装する必要はない
    //新しく取得するのは能動的
    // mainModelでnewMutePostCommentIds
    // onRefreshされたら配列を空にする
    await processNewMutePostComments();
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

  Future<void> processNewMutePostComments() async {
    final List<String> newMutePostCommentIds = newMuteCommentTokens.map((e) => e.postCommentId).toList();  // newMuteCommentTokensをfor文で回してpostCommentIdだけをまとめている
    //新しくミュートしたコメントが10人以上の場合
    final List<String> max10MutePostCommentIds = newMutePostCommentIds.length > 10 ? 
    newMutePostCommentIds.sublist(0, tenCount)  // 10より大きかったら10個取り出す
    : newMutePostCommentIds;                    // 10より小さかったらそのまま適応
    if(max10MutePostCommentIds.isNotEmpty) {
      final qshot = await returnQuery(max10MutePostCommentIds: max10MutePostCommentIds).get();
      final reversed = qshot.docs.reversed.toList();  //いつもの新しいdocsに対して行う処理
      for(final mutePostCommentDoc in reversed) {
        muteCommentDocs.insert(0, mutePostCommentDoc);
        // mutemutePostCommentDocに加えたということはもう新しくない
        //新しいものリストから省く
        // tokenに含まれるpostCommentIdがミュートされるべきユーザーと同じpostCommentIdのものを取得
        final deleteNewMutePostCommentTokens = newMuteCommentTokens.where((element) => element.postCommentId == mutePostCommentDoc.id).toList().first;
        newMuteCommentTokens.remove(deleteNewMutePostCommentTokens);
      }
    }
    notifyListeners();
  }

  Future<void> process() async {
    if(mutePostCommentIds.length > muteCommentDocs.length) {
      final int mutePostCommentDocsLength = muteCommentDocs.length;  //序盤のmutemutePostCommentDocsの長さを保持
      // whereInで検索にかけたので、max10MutePostCommentIdsには10個までしかpostCommentIdを入れない
      final List<String> max10MutePostCommentIds = (mutePostCommentIds.length - muteCommentDocs.length) > 10 ? 
      mutePostCommentIds.sublist(mutePostCommentDocsLength, mutePostCommentDocsLength + tenCount) : mutePostCommentIds.sublist(mutePostCommentDocsLength, mutePostCommentIds.length);  // sublistはリストを分解
      if(max10MutePostCommentIds.isNotEmpty) {
        final qshot = await returnQuery(max10MutePostCommentIds: max10MutePostCommentIds).get();
        for(final mutePostCommentDoc in qshot.docs) {
          muteCommentDocs.add(mutePostCommentDoc);
        }
      }
    }
    notifyListeners();
  }

  Future<void> muteComment({
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,  // docsにはpostDocs、commentDocsが含まれる
    required List<DocumentSnapshot<Map<String,dynamic>>> commentDocs,
  }) async {
    final String tokenId = returnUuidV4();
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final Timestamp now = Timestamp.now();
    final postCommentRef = commentDoc.reference;
    final String postCommentId = commentDoc.id;
    final MuteCommentToken muteCommentToken = MuteCommentToken(
      activeUid: activeUid,
      createdAt: now,
      postCommentId: postCommentId,
      postCommentRef: postCommentRef,
      tokenId: tokenId,
      tokenType: muteCommentTokenTypeString,
    );
    newMuteCommentTokens.add(muteCommentToken);  //新しくミュートしたコメント
    mainModel.muteCommentTokens.add(muteCommentToken);  // muteCommentTokensに投稿のミュートした人のIdを含めた
    mainModel.muteCommentIds.add(postCommentId);
    commentDocs.remove(commentDoc);  //ミュートしたコメントを除外する
    notifyListeners();
    // currentUserDoc.ref...
    // 自分がミュートしたことの印
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: tokenId).set(muteCommentToken.toJson());
    //ミュートされたことの印
    final CommentMute commentMute = CommentMute(
      activeUid: activeUid,
      createdAt: now,
      postCommentId: postCommentId,
      postCommentRef: postCommentRef,
    );
    await commentDoc.reference.collection('postCommentMutes').doc(activeUid).set(commentMute.toJson());
  }

  void showMuteCommentDialog({
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,  // docsにはpostDocs、commentDocsが含まれる
    required List<DocumentSnapshot<Map<String,dynamic>>> commentDocs,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext innerContext) => CupertinoAlertDialog(
        // title: const Text('コメントをミュートする'),
        content: const Text(muteCommentAlertMsg),
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
              await muteComment(mainModel: mainModel, commentDoc: commentDoc, commentDocs: commentDocs);
            },
            child: const Text(yesText),
          ),
        ],
      ),
    );
  }

  // void showMuteCommentPopup({
  //   required BuildContext context,
  //   required MainModel mainModel,
  //   required DocumentSnapshot<Map<String,dynamic>> commentDoc,  // docsにはpostDocs、commentDocsが含まれる
  //   required List<DocumentSnapshot<Map<String,dynamic>>> commentDocs,
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
  //             showMuteCommentDialog(context: context, mainModel: mainModel, commentDoc: commentDoc, commentDocs: commentDocs);
  //           },
  //           child: const Text(muteCommentText),
  //         ),
  //         CupertinoActionSheetAction(
  //           onPressed: () => Navigator.pop(innerContext),
  //           child: const Text(backText),
  //         ),
  //       ],
  //     ) 
  //   );
  // }

  Future<void> unMuteComment({
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,  // docsにはpostDocs、commentDocsが含まれる
    required List<DocumentSnapshot<Map<String,dynamic>>> commentDocs,
  }) async {
    // nuteCommentsModel側の処理
    final String commentId = commentDoc.id;
    muteCommentDocs.remove(commentDoc);
    mainModel.muteCommentIds.remove(commentId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final MuteCommentToken deleteMuteCommentToken = mainModel.muteCommentTokens.where((element) => element.postCommentId == commentId).toList().first;
    if(newMuteCommentTokens.contains(deleteMuteCommentToken)) {  //もし削除するミュートコメントが新しいやつなら
      newMuteCommentTokens.remove(deleteMuteCommentToken);
    }
    mainModel.muteCommentTokens.remove(deleteMuteCommentToken);
    notifyListeners();
    //自分がミュートしたことの印を削除
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: deleteMuteCommentToken.tokenId).delete();
    //コメントのミュートされた印を削除
    final DocumentReference<Map<String,dynamic>> muteCommentRef = deleteMuteCommentToken.postCommentRef;
    await muteCommentRef.collection('postCommentMutes').doc(activeUid).delete();
  }

  void showUnMuteCommentDialog({
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,  // docsにはpostDocs、commentDocsが含まれる
    required List<DocumentSnapshot<Map<String,dynamic>>> commentDocs,
  }) {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext innerContext) => CupertinoAlertDialog(
        // title: const Text('ユーザーのミュートを解除する'),
        content: const Text(unMuteCommentAlertMsg),
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
              await unMuteComment(mainModel: mainModel, commentDoc: commentDoc, commentDocs: commentDocs);
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
  //   required DocumentSnapshot<Map<String,dynamic>> commentDoc,  // docsにはpostDocs、commentDocsが含まれる
  //   required List<DocumentSnapshot<Map<String,dynamic>>> commentDocs,
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
  //             showUnMuteUserDialog(context: context, mainModel: mainModel, commentDoc: commentDoc, commentDocs: commentDocs);
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