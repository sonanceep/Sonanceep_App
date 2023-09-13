// flutter
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/others.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/details/report_contents_list_view.dart';
// domain
import 'package:sonanceep_sns/domain/like_post_token/like_post_token.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
import 'package:sonanceep_sns/domain/post_like/post_like.dart';
import 'package:sonanceep_sns/domain/post_report/post_report.dart';
import 'package:sonanceep_sns/models/main_model.dart';

final postsProvider = ChangeNotifierProvider(
  ((ref) => PostsModel()
));

class PostsModel extends ChangeNotifier {
  Future<void> like({
    required Post post,
    required DocumentReference<Map<String,dynamic>> postRef,
    // required DocumentSnapshot<Map<String,dynamic>> currentUserDoc,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,
  }) async {
    // setting
    final String postId = post.postId;
    mainModel.likePostIds.add(postId);  // postId いいねを押した配列
    final currentUserDoc = mainModel.currentUserDoc;
    final String tokenId = returnUuidV4();
    final Timestamp now = Timestamp.now();
    final String activeUid = currentUserDoc.id;
    final String passiveUid = post.uid;
    //自分がいいねしたことの印
    final LikePostToken likePostToken = LikePostToken(
      activeUid: activeUid,
      createdAt: now,
      passiveUid: passiveUid,
      postRef: postRef,
      postId: postId,
      tokenId: tokenId,
      tokenType: likePostTokenTypeString,
    );
    mainModel.likePostTokens.add(likePostToken);
    notifyListeners();
    await currentUserDoc.reference.collection('tokens').doc(tokenId).set(likePostToken.toJson());
    //投稿がいいねされたことの印
    final PostLike postLike = PostLike(
      activeUid: activeUid,
      createdAt: now,
      passiveUid: passiveUid,
      postRef: postRef,
      postId: postId,
    );
    //いいねする人が重複しないようにUidをdocumentIdとする
    await postDoc.reference.collection('postLikes').doc(activeUid).set(postLike.toJson());
  }

  Future<void> unlike({
    required Post post,
    required DocumentReference<Map<String,dynamic>> postRef,
    // required DocumentSnapshot<Map<String,dynamic>> currentUserDoc,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,
  }) async {
    final String postId = post.postId;
    mainModel.likePostIds.remove(postId);  // postId いいねを押した配列
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final deleteLikePosrtToken = mainModel.likePostTokens.where((element) => element.postId == postId).toList().first;
    mainModel.likePostTokens.remove(deleteLikePosrtToken);
    notifyListeners();
    //自分がいいねした印を削除
    // // qshotというデータの塊の存在を取得
    // final QuerySnapshot<Map<String, dynamic>> qshot = await currentUserDoc.reference.collection('tokens').where('postId', isEqualTo: post.postId).get();
    // final List<DocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;  //一個しか取得していないが複数している扱い
    // final DocumentSnapshot<Map<String, dynamic>> token = docs.first;
    await currentUserDoc.reference.collection('tokens').doc(deleteLikePosrtToken.tokenId).delete();

    //投稿がいいねされたことの印を削除
    await postDoc.reference.collection('postLikes').doc(activeUid).delete();
  }

  void reportPost({
    required BuildContext context,
    required Post post,
    required DocumentSnapshot<Map<String,dynamic>> postDoc,
  }) {
    //選ばれたものを表示
    // valueNotifierは変更をすぐに検知してくれる
    final selectedReportContentsNotifier = ValueNotifier<List<String>>([]);
    final String postReportId = returnUuidV4();

    final postDocRef = postDoc.reference;
    voids.showFlashDialog(
      context: context,
      content: ReportContentsListView(selectedReportContentsNotifier: selectedReportContentsNotifier),
      onPressed: () async {
        //ドキュメントを作成
        final PostReport postReport = PostReport(
          activeUid: returnAuthUser()!.uid,
          createdAt: Timestamp.now(),
          others: '',
          reportContent: retrunReportContentString(selectedReportContents: selectedReportContentsNotifier.value),
          postCreatorUid: post.uid,
          passiveUserName: post.userName,
          postDocRef: postDoc.reference,
          postId: post.postId,
          postReportId: postReportId,
          text: post.text,
          textLanguageCode: post.textLanguageCode,
          textNegativeScore: post.textNegativeScore,
          textPositiveScore: post.textPositiveScore,
          textSentiment: post.textSentiment,
        );
        await voids.showFlutterToast(msg: reportedPostMsg);
        await postDocRef.collection('postReports').doc(postReportId).set(postReport.toJson());  // ドメインを形にする  rulesを作成
        Navigator.pop(context);
      },
      child: const Text(repostText, style: TextStyle(color: Colors.red),),
    );
  }
}