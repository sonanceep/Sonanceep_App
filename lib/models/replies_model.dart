// flutter
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/details/report_contents_list_view.dart';
import 'package:sonanceep_sns/domain/post_comment_reply_report/post_comment_reply_report.dart';
// package
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/strings.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/domain/like_reply_token/like_reply_token.dart';
// domain
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/reply/reply.dart';
import 'package:sonanceep_sns/domain/reply_like/reply_like.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';

final repliesProvider = ChangeNotifierProvider(
  ((ref) => RepliesModel()
));

class RepliesModel extends ChangeNotifier {
  final TextEditingController textEditingController = TextEditingController();
  RefreshController refreshController = RefreshController();  //初期化するたびに捨てる
  String replyString = "";
  // リアルタイム取得で不必要に
  // List<DocumentSnapshot<Map<String,dynamic>>> replyDocs = [];
  // Query<Map<String,dynamic>> returnQuery({
  //   required DocumentSnapshot<Map<String,dynamic>> commentDoc,
  // }) {
  //   // postに紐ずくコメントが欲しい
  //   return commentDoc.reference.collection('postCommentReplies').orderBy('likeCount', descending: true);
  // }
  // //同じデータを無駄に取得しないようにする
  // String indexPostCommentId = '';

  // // リプライボタンが押された時の処理
  // Future<void> init({
  //   required BuildContext context,
  //   required Comment comment,
  //   required DocumentSnapshot<Map<String,dynamic>> commentDoc,
  //   required MainModel mainModel,
  // }) async {
  //   refreshController = RefreshController();  //上書き
  //   routes.toRepliesPage(
  //     context: context,
  //     comment: comment,
  //     commentDoc: commentDoc,
  //     mainModel: mainModel
  //   );
  //   final String postCommentId = comment.postCommentId;
  //   if(indexPostCommentId != postCommentId) {
  //     await onReload(commentDoc: commentDoc);
  //   }
  //   indexPostCommentId = postCommentId;
  // }

  // // リアルタイム取得で不必要に
  // Future<void> onRefresh({required DocumentSnapshot<Map<String,dynamic>> commentDoc,}) async {
  //   refreshController.refreshCompleted();
  //   if(replyDocs.isNotEmpty) {  //中身が空じゃないなら  ポストが何かしらある時
  //     final qshot = await returnQuery(commentDoc: commentDoc).endBeforeDocument(replyDocs.first).get();  //一番新しいポストを入れる  一番新しいポストのさらに新しいポストができるとそれを取得
  //     final reversed = qshot.docs.reversed.toList();
  //     for(final commentDoc in reversed) {
  //       replyDocs.insert(0, commentDoc);  //一番新しいのを０番目に
  //     }
  //   }
  //   notifyListeners();
  // }

  // Future<void> onReload({required DocumentSnapshot<Map<String,dynamic>> commentDoc,}) async {
  //   // startLoading();
  //   final qshot = await returnQuery(commentDoc: commentDoc).get();  // postの下のコメントがいいね順で
  //   replyDocs = qshot.docs;
  //   notifyListeners();
  //   // endLoading();
  // }
  // Future<void> onLoading({required DocumentSnapshot<Map<String,dynamic>> commentDoc,}) async {
  //   refreshController.loadComplete();
  //   if(replyDocs.isNotEmpty) {  //中身が空じゃないなら  ポストが何かしらある時
  //     final qshot = await returnQuery(commentDoc: commentDoc).startAfterDocument(replyDocs.last).get();  //
  //     for(final commentDoc in qshot.docs) {
  //       replyDocs.add(commentDoc);
  //     }
  //   }
  //   notifyListeners();
  // }

  void showReplyFlashBar({
    required BuildContext context,
    required MainModel mainModel,
    required Comment comment,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,
  }) {

    voids.showFlashBar(
      context: context,
      mainModel: mainModel,
      textEditingController: textEditingController,
      onChanged: (value) => replyString = value,
      titleString: createReplyText,
      primaryActionColor: Colors.purple,
      primaryActionBuilder: (_, controller, __) {
        return InkWell(
          child: const Icon(Icons.send, color: Colors.purple,),
          onTap: () async {
            if(textEditingController.text.isNotEmpty) {
              //メインの動作
              await createReply(
                currentUserDoc: mainModel.currentUserDoc,
                firestoreUser: mainModel.firestoreUser,
                comment: comment,
                commentDoc: commentDoc
              );
              await controller.dismiss();
              replyString = '';
              textEditingController.text = '';
            } else {
              //何もしない
              await controller.dismiss();
            }
          },
        );
      }
    );
  }

  Future<void> createReply({
    required DocumentSnapshot<Map<String,dynamic>> currentUserDoc,
    required FirestoreUser firestoreUser,
    required Comment comment,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,
  }) async {

    final Timestamp now = Timestamp.now();
    final String activeUid = currentUserDoc.id;
    final String postCommentReplyId = returnUuidV4();
    final Reply reply = Reply(
      createdAt: now,
      reply: replyString,
      replyLanguageCode: '',
      replyNegativeScore: 0,
      replyPositiveScore: 0,
      replySentiment: '',
      likeCount: 0,
      postRef: comment.postRef,
      postCommentRef: commentDoc.reference,
      postCommentReplyId: postCommentReplyId,
      reportCount: 0,
      userName: firestoreUser.userName,
      userNameLanguageCode: firestoreUser.userNameLanguageCode,
      userNameNegativeScore: firestoreUser.userNameNegativeScore,
      userNamePositiveScore: firestoreUser.userNamePositiveScore,
      userNameSentiment: firestoreUser.userNameSentiment,
      uid: activeUid,
      userImageURL: firestoreUser.userImageURL,
      updatedAt: now,
    );
    await commentDoc.reference.collection('postCommentReplies').doc(postCommentReplyId).set(reply.toJson());
  }

  Future<void> like({
    required Reply reply,
    required MainModel mainModel,
    required Comment comment,
    required DocumentSnapshot replyDoc,
  }) async {
    // setting
    final String postCommentReplyId = reply.postCommentReplyId;
    mainModel.likeReplyIds.add(postCommentReplyId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String tokenId = returnUuidV4();
    final Timestamp now = Timestamp.now();
    final String activeUid = currentUserDoc.id;
    final String passiveUid = comment.uid;
    final DocumentReference postCommentReplyRef = replyDoc.reference;
    final LikeReplyToken likeReplyToken = LikeReplyToken(
      activeUid: activeUid,
      createdAt: now,
      passiveUid: passiveUid,
      postCommentReplyRef: postCommentReplyRef,
      postCommentReplyId: postCommentReplyId,
      tokenId: tokenId,
      tokenType: likeReplyTokenTypeString,
    );
    mainModel.likeReplyTokens.add(likeReplyToken);
    notifyListeners();
    //自分がリプライにいいねしたことの印
    await currentUserDoc.reference.collection('tokens').doc(tokenId).set(likeReplyToken.toJson());
    //リプライにいいねがついたことの印
    final ReplyLike replyLike = ReplyLike(
      activeUid: activeUid,
      createdAt: now,
      postCommentReplyCreatorUid: reply.uid,
      postCommentReplyRef: postCommentReplyRef,
      postCommentReplyId: postCommentReplyId,
    );
    await postCommentReplyRef.collection('postCommentReplyLikes').doc(activeUid).set(replyLike.toJson());
  }

  Future<void> unlike({
    required Reply reply,
    required MainModel mainModel,
    required Comment comment,
    required DocumentSnapshot replyDoc,
  }) async {
    final String postCommentReplyId = reply.postCommentReplyId;
    mainModel.likeReplyIds.remove(postCommentReplyId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final LikeReplyToken deleteLikeReplyToken = mainModel.likeReplyTokens.where((element) => element.postCommentReplyId == postCommentReplyId).toList().first;  // whereは複数取得
    mainModel.likeReplyTokens.remove(deleteLikeReplyToken);
    notifyListeners();
    //自分がいいねしたことの印を削除
    await currentUserDoc.reference.collection('tokens').doc(deleteLikeReplyToken.tokenId).delete();
    //リプライにいいねがついたことの印を削除
    final DocumentReference<Map<String,dynamic>> postCommentReplyRef = deleteLikeReplyToken.postCommentReplyRef;
    await postCommentReplyRef.collection("postCommentReplyLikes").doc(activeUid).delete();
  }

  void reportReply({
    required BuildContext context,
    required Reply reply,
    required DocumentSnapshot replyDoc,
  }) {
    //選ばれたものを表示
    // valueNotifierは変更をすぐに検知してくれる
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final String reportId = returnUuidV4();

    voids.showFlashDialog(
      context: context,
      content: ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier),
      positiveActionBuilder: (_, controller, __) {
        final replyDocRef = replyDoc.reference;
        return TextButton(
          onPressed: () async {
            final PostCommentReplyReport postCommentReplyReport = PostCommentReplyReport(
              activeUid: returnAuthUser()!.uid,
              createdAt: Timestamp.now(),
              others: '',
              reportContent: retrunReportContentString(selectedReportContents: selectedReportContentsNotifier.value),
              postCommentReplyCreatorUid: reply.uid,
              passiveUserName: reply.userName,
              postCommentReplyDocRef: replyDocRef,
              postCommentReplyId: replyDoc.id,
              postCommentReplyReportId: reportId,
              reply: reply.reply,
              replyLanguageCode: reply.replyLanguageCode,
              replyNegativeScore: reply.replyNegativeScore,
              replyPositiveScore: reply.replyPositiveScore,
              replySentiment: reply.replySentiment,
            );
            await controller.dismiss();
            await voids.showFlutterToast(msg: 'リプライを報告しました');
            await replyDocRef.collection('postCommentReplyReports').doc(reportId).set(postCommentReplyReport.toJson());
          },
          child: const Text('送信', style: TextStyle(color: Colors.red),),
        );
      },
    );
  }
}