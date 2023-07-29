// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/constants/lists.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/details/report_contents_list_view.dart';
import 'package:sonanceep_sns/domain/post_comment_report/post_comment_report.dart';
// package
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/enums.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/comment_like/comment_like.dart';
import 'package:sonanceep_sns/domain/like_comment_token/like_comment_token.dart';
// domain
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';

final commentsProvider = ChangeNotifierProvider(
  ((ref) => CommentsModel()
));
class CommentsModel extends ChangeNotifier {

  final TextEditingController textEditingController = TextEditingController();
  RefreshController refreshController = RefreshController();  //初期化するたびに捨てる
  List<String> muteUids = [];
  bool isLoading = false;
  String commentString = '';
  List<DocumentSnapshot<Map<String,dynamic>>> commentDocs = [];
  Query<Map<String,dynamic>> returnQuery({
    required DocumentSnapshot<Map<String,dynamic>> postDoc,
  }) {
    // postに紐ずくコメントが欲しい
    return postDoc.reference.collection('postComments').orderBy('likeCount', descending: true);
  }

  //同じデータを無駄に取得しないようにする
  String indexPostCommentId = '';

  CommentsModel() {
    //なぜならmuteUidsを読み込むのは一回だけでいい
    init();
  }
  Future<void> init() async {
    final muteUidsAndMutePostIds = await returnMuteUidsAndMutePostIds();
    muteUids = muteUidsAndMutePostIds.first;
  } 

  //コメントボタンが押された時の処理
  Future<void> onCommentButtonPressed({
    required BuildContext context,
    required Post post,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,
    required MainModel mainModel,
  }) async {
    refreshController = RefreshController();  //上書き
    routes.toCommentsPage(context: context, post: post, postDoc: postDoc, mainModel: mainModel);
    final String postId = post.postId;
    if(indexPostCommentId != postId) {
      await onReload(postDoc: postDoc);
    }
    indexPostCommentId = postId;  // post.postIdと同じ
  }

  void startLoading() {
    isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    isLoading = false;
    notifyListeners();
  }

  Future<void> onRefresh({required DocumentSnapshot<Map<String,dynamic>> postDoc,}) async {
    refreshController.refreshCompleted();
    await voids.processNewDocs(muteUids: muteUids, mutePostIds: [], docs: commentDocs, query: returnQuery(postDoc: postDoc));
    notifyListeners();
  }

  Future<void> onReload({required DocumentSnapshot<Map<String,dynamic>> postDoc,}) async {
    await voids.processBasicDocs(muteUids: muteUids, mutePostIds: [], docs: commentDocs, query: returnQuery(postDoc: postDoc));
    notifyListeners();
  }

  Future<void> onLoading({required DocumentSnapshot<Map<String,dynamic>> postDoc,}) async {
    refreshController.loadComplete();
    await voids.processOldDocs(muteUids: muteUids, mutePostIds: [], docs: commentDocs, query: returnQuery(postDoc: postDoc));
    notifyListeners();
  }

  void showCommentFlashBar({
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,
  }) {

    voids.showFlashBar(
      context: context,
      mainModel: mainModel,
      textEditingController: textEditingController,
      onChanged: (value) => commentString = value,
      titleString: createCommentText,
      primaryActionColor: Colors.orange,
      primaryActionBuilder: (_, controller, __) {
        return InkWell(
          child: Icon(Icons.send, color: Colors.orange,),
          onTap: () async {
            if(textEditingController.text.isNotEmpty) {
              //メインの動作
              await createComment(currentUserDoc: mainModel.currentUserDoc, firestoreUser: mainModel.firestoreUser, postDoc: postDoc);
              await controller.dismiss();
              commentString = '';
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

  Future<void> createComment({
    required DocumentSnapshot<Map<String,dynamic>> currentUserDoc,
    required FirestoreUser firestoreUser,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,
  }) async {

    final Timestamp now = Timestamp.now();
    final String activeUid = currentUserDoc.id;
    final String postCommentId = returnUuidV4();
    final Comment comment = Comment(
      createdAt: now,
      comment: commentString,
      commentLanguageCode: '',
      commentNegativeScore: 0,
      commentPositiveScore: 0,
      commentSentiment: '',
      likeCount: 0,
      postCommentId: postCommentId,
      postCommentReplyCount: 0,
      postRef: postDoc.reference,
      muteCount: 0,
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
    await postDoc.reference.collection('postComments').doc(postCommentId).set(comment.toJson());
  }

  Future<void> like({
    required Comment comment,
    required MainModel mainModel,
    required Post post,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,
  }) async {
    // setting
    final String postCommentId = comment.postCommentId;
    mainModel.likeCommentIds.add(postCommentId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String tokenId = returnUuidV4();
    final Timestamp now = Timestamp.now();
    final String activeUid = currentUserDoc.id;
    final String passiveUid = post.uid;

    //自分がコメントにいいねしたことの印
    final LikeCommentToken likeCommentToken = LikeCommentToken(
      activeUid: activeUid,
      createdAt: now,
      passiveUid: passiveUid,
      postCommentRef: commentDoc.reference,
      postCommentId: postCommentId,
      tokenId: tokenId,
      tokenType: likeCommentTokenTypeString,
    );
    mainModel.likeCommentTokens.add(likeCommentToken);
    notifyListeners();
    await currentUserDoc.reference.collection('tokens').doc(tokenId).set(likeCommentToken.toJson());

    //コメントにいいねがついたことの印
    final CommentLike commentLike = CommentLike(
      activeUid: activeUid,
      createdAt: now,
      postCommentCreatorUid: comment.uid,
      postCommentRef: commentDoc.reference,
      postCommentId: postCommentId,
    );
    await commentDoc.reference.collection('postCommentLikes').doc(activeUid).set(commentLike.toJson());
  }

  Future<void> unlike({
    required Comment comment,
    required MainModel mainModel,
    required Post post,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,
  }) async {
    final String postCommentId = comment.postCommentId;
    mainModel.likeCommentIds.remove(postCommentId);
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final deleteLikeCommentToken = mainModel.likeCommentTokens.where((element) => element.postCommentId == postCommentId).toList().first;  //一致するidは一つしかないがリストにして取得
    mainModel.likeCommentTokens.remove(deleteLikeCommentToken);
    notifyListeners();
    //自分がいいねしたことの印を削除
    await userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: deleteLikeCommentToken.tokenId).delete();
    //コメントにいいねがついたことの印を削除
    final DocumentReference<Map<String,dynamic>> postCommentRef = deleteLikeCommentToken.postCommentRef;
    await postCommentRef.collection('postCommentLikes').doc(activeUid).delete();
  }

  void reportComment({
    required BuildContext context,
    required Comment comment,
    required DocumentSnapshot<Map<String,dynamic>> commentDoc,
  }) {
    //選ばれたものを表示
    // valueNotifierは変更をすぐに検知してくれる
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final String postCommentReportId = returnUuidV4();

    voids.showFlashDialog(
      context: context,
      content: ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier),
      positiveActionBuilder: (_, controller, __) {
        final commentDocRef = commentDoc.reference;
        return TextButton(
          onPressed: () async {
            final PostCommentReport postCommentReport = PostCommentReport(
              activeUid: returnAuthUser()!.uid,
              createdAt: Timestamp.now(),
              others: '',
              reportContent: retrunReportContentString(selectedReportContents: selectedReportContentsNotifier.value),
              postCommentCreatorUid: comment.uid,
              passiveUserName: comment.userName,
              postCommentDocRef: commentDoc.reference,
              postCommentId: comment.postCommentId,
              postCommentReportId: postCommentReportId,
              comment: comment.comment,
              commentLanguageCode: comment.commentLanguageCode,
              commentNegativeScore: comment.commentNegativeScore,
              commentPositiveScore: comment.commentPositiveScore,
              commentSentiment: comment.commentSentiment,
            );
            await controller.dismiss();
            await voids.showFlutterToast(msg: 'コメントを報告しました');
            await commentDoc.reference.collection('postCommentReports').doc(postCommentReportId).set(postCommentReport.toJson());
          },
          child: const Text('送信', style: TextStyle(color: Colors.red),),
        );
      },
    );
  }
}