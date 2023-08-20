// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:sonanceep_sns/constants/lists.dart';
import 'package:sonanceep_sns/constants/maps.dart';
import 'package:sonanceep_sns/constants/voids.dart';
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/follower/follower.dart';
import 'package:sonanceep_sns/domain/following_token/following_token.dart';
import 'package:sonanceep_sns/domain/mute_user_token/mute_user_token.dart';
import 'package:sonanceep_sns/domain/user_mute/user_mute.dart';
import 'package:sonanceep_sns/models/mute_users_model.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/post/post.dart';
// constants
import 'package:sonanceep_sns/constants/others.dart';

final adminProvider = ChangeNotifierProvider(
  ((ref) => AdminModel()
));



//管理者だけにできる処理
class AdminModel extends ChangeNotifier {

  //管理者がオケをデータベースに保存
  Future<void> adminAddSounds({
    required FirestoreUser firestoreUser,
  }) async {
    
  }


  Future<void> admin({
    // required DocumentSnapshot<Map<String,dynamic>> currentUserDoc,
    required FirestoreUser firestoreUser,
    // required MuteUsersModel muteUsersModel,
  }) async {

    // // commentにreportCountを設置
    // final WriteBatch batch = FirebaseFirestore.instance.batch();
    // // posts
    // final postsQshot = await FirebaseFirestore.instance.collectionGroup('posts').get();
    // for(final post in postsQshot.docs) {
    //   batch.update(post.reference, {
    //     'reportCount': 0,
    //   });
    // }
    // // comments全削除
    // final commentsQshot = await FirebaseFirestore.instance.collectionGroup('postComments').get();
    // for(final comment in commentsQshot.docs) {
    //   batch.delete(comment.reference);
    // }
    // // replies全削除
    // final repliesQshot = await FirebaseFirestore.instance.collectionGroup('postCommentReplies').get();
    // for(final reply in repliesQshot.docs) {
    //   batch.delete(reply.reference);
    // }
    // await batch.commit();
    // await showFlutterToast(msg: '作業が完了しました');




    // // postにuserNameの解析Fieldを入れる
    // final WriteBatch batch = FirebaseFirestore.instance.batch();
    // // posts
    // final postsQshot = await FirebaseFirestore.instance.collectionGroup('posts').get();
    // for(final post in postsQshot.docs) {
    //   batch.update(post.reference, {
    //     // // userName
    //     // 'userNameLanguageCode': firestoreUser.userNameLanguageCode,
    //     // 'userNameNegativeScore': firestoreUser.userNameNegativeScore,
    //     // 'userNamePositiveScore': firestoreUser.userNamePositiveScore,
    //     // 'userNameSentiment': firestoreUser.userNameSentiment,
    //     // // text
    //     // 'textLanguageCode': '',
    //     // 'textNegativeScore': '',
    //     // 'textPositiveScore': '',
    //     // 'textSentiment': '',

    //     // userName
    //     'userNameLanguageCode': '',
    //     'userNameNegativeScore': 0,
    //     'userNamePositiveScore': 0,
    //     'userNameSentiment': '',
    //     // text
    //     'textLanguageCode': '',
    //     'textNegativeScore': 0,
    //     'textPositiveScore': 0,
    //     'textSentiment': '',
    //   });
    // }
    // // comments全削除
    // final commentsQshot = await FirebaseFirestore.instance.collectionGroup('postComments').get();
    // for(final comment in commentsQshot.docs) {
    //   batch.delete(comment.reference);
    // }
    // // replies全削除
    // final repliesQshot = await FirebaseFirestore.instance.collectionGroup('postCommentReplies').get();
    // for(final reply in repliesQshot.docs) {
    //   batch.delete(reply.reference);
    // }
    // await batch.commit();
    // await showFlutterToast(msg: '作業が完了しました');




    // // adminで作成した71人を取得
    // // フィールドの追加
    // final userDocs = await FirebaseFirestore.instance.collection('users').limit(71).get();
    // final WriteBatch batch = FirebaseFirestore.instance.batch();  // batchをセット
    // for(final userDoc in userDocs.docs) {
    //   batch.update(userDoc.reference, {
    //     'searchToken': returnSearchToken(searchWords: returnSearchWords(searchTerm: userDoc['userName'])),
    //     'postCount': 0,
    //     'userNameLanguageCode': 'en',
    //     'userNameNegativeScore': 0,
    //     'userNamePositiveScore': 0,
    //     'userNameSentiment': 'POSITIVE',
    //   });
    // }
    // await batch.commit();
    // await showFlutterToast(msg: '処理が終わりました');




    // // followerを作成する
    // // adminで作成した70人を取得
    // final userDocs = await FirebaseFirestore.instance.collection('users').limit(70).get();
    // final WriteBatch batch = FirebaseFirestore.instance.batch();  // batchをセット
    // final User currentUser = returnAuthUser()!;
    // final String currentUid = currentUser.uid;
    // for(final userDoc in userDocs.docs) {
    //   final Timestamp now = Timestamp.now();
    //   final String tokenId = returnUuidV4();
    //   //フォローした証
    //   final FollowingToken followingToken = FollowingToken(
    //     createdAt: now,
    //     passiveUid: currentUser.uid,
    //     tokenId: tokenId,
    //     tokenType: followingTokenTypeString,
    //   );
    //   batch.set(userDocToTokenDocRef(currentUserDoc: userDoc, tokenId: tokenId), followingToken.toJson());
    //   // フォローされた証
    //   final Follower follower = Follower(createdAt: now, followedUid: currentUid, followerUid: userDoc.id);
    //   batch.set(FirebaseFirestore.instance.collection('users').doc(currentUid).collection('followers').doc(follower.followerUid), follower.toJson());
    //   await Future.delayed(Duration(microseconds: 100));  // 0.1秒のdelayをかける
    // }
    // await batch.commit();
    // await showFlutterToast(msg: '処理が終わりました');




    // // ユーザーを一気に作成
    // final WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    // final String activeUid = returnAuthUser()!.uid;
    // for(int i = 0; i < 35; i++) {
    //   final Timestamp now = Timestamp.now();
    //   final String passiveUid = 'newMuteUser${i.toString()}';
    //   //ユーザーを作成
    //   final FirestoreUser firestoreUser = FirestoreUser(
    //     createdAt: now,
    //     updatedAt: now,
    //     followerCount: 0,
    //     followingCount: 0,
    //     isAdmin: false,
    //     muteCount: 0,
    //     userName: passiveUid,
    //     uid: passiveUid,
    //     userImageURL: '',
    //   );
    //   final ref = FirebaseFirestore.instance.collection('users').doc(passiveUid);
    //   writeBatch.set(ref, firestoreUser.toJson());
      
    //   final MuteUserToken muteUserToken = MuteUserToken(
    //     activeUid: activeUid,
    //     createdAt: now,
    //     passiveUid: passiveUid,
    //     tokenId: returnUuidV4(),
    //     tokenType: muteUserTokenTypeString,
    //   );
    //   muteUsersModel.newMuteUserTokens.add(muteUserToken);  //フロントだけ
    //   await Future.delayed(const Duration(milliseconds: 500));
    // }




    // // ユーザーを一気に作成
    // final WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    // for(int i = 0; i < 35; i++) {
    //   final String passiveUid = i.toString();
    //   final Timestamp now = Timestamp.now();
    //   //ユーザーを作成
    //   final FirestoreUser firestoreUser = FirestoreUser(
    //     createdAt: now,
    //     updatedAt: now,
    //     followerCount: 0,
    //     followingCount: 0,
    //     isAdmin: false,
    //     muteCount: 0,
    //     userName: passiveUid,
    //     uid: passiveUid,
    //     userImageURL: '',
    //   );
    //   final passiveUserDocRef = FirebaseFirestore.instance.collection('users').doc(passiveUid);
    //   writeBatch.set(passiveUserDocRef, firestoreUser.toJson());




    //   //ミュートした印を作成
    //   final String tokenId = returnUuidV4();
    //   final String activeUid = currentUserDoc.id;
    //   final MuteUserToken muteUserToken = MuteUserToken(
    //     activeUid: activeUid,
    //     createdAt: now,
    //     passiveUid: passiveUid,
    //     tokenId: tokenId,
    //     tokenType: muteUserTokenTypeString,
    //   );
    //   notifyListeners();
    //   // currentUserDoc.ref...
    //   // 自分がミュートしたことの印
    //   writeBatch.set(userDocToTokenDocRef(currentUserDoc: currentUserDoc, tokenId: tokenId), muteUserToken.toJson());
    //   //ミュートされたことの印
    //   final UserMute userMute = UserMute(
    //     activeUid: activeUid,
    //     createdAt: now,
    //     passiveUid: passiveUid,
    //     passiveUserRef: passiveUserDocRef,
    //   );
    //   writeBatch.set(passiveUserDocRef.collection('userMutes').doc(activeUid), userMute.toJson());
    // }




    // //
    // final usersQshot = await FirebaseFirestore.instance.collection('users').get();
    // final WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    // for(final user in usersQshot.docs) {
    //   writeBatch.update(user.reference, {
    //     'muteCount': 0,
    //   });
    // }

    // await writeBatch.commit();




    // // 投稿消し
    // final WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    // final postsQshot = await currentUserDoc.reference.collection('posts').orderBy('createdAt', descending: false).limit(100).get();  //古い順に取得
    // for(final postDoc in postsQshot.docs) {
    //   writeBatch.delete(postDoc.reference);
    // }
    // await  writeBatch.commit();




    // // コメント全消し
    // final WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    // final commentsQshot = await FirebaseFirestore.instance.collectionGroup('postComments').get();
    // for(final commentDoc in commentsQshot.docs) {
    //   writeBatch.delete(commentDoc.reference);
    // }
    // await  writeBatch.commit();




    // // commentCount の追加
    // final WriteBatch writeBatch = FirebaseFirestore.instance.batch();
    // final postsQshot = await currentUserDoc.reference.collection('posts').get();
    // for(final post in postsQshot.docs) {
    //   writeBatch.update(post.reference, {
    //     'commentCount': 0,
    //   });
    // }
    // await writeBatch.commit();




    // //ユーザーのemailの削除
    // final WriteBatch batch = FirebaseFirestore.instance.batch();
    // final usersQshot = await FirebaseFirestore.instance.collection('users').get();
    // for(final user in usersQshot.docs) {
    //   final FirestoreUser firestoreUser = FirestoreUser.fromJson(user.data());
    //   batch.update(user.reference, {
    //     'email': FieldValue.delete(),
    //   });
    // }
    // // postにuserNameの追加、userImageの追加
    // final postsQshot = await currentUserDoc.reference.collection('posts').get();
    // for(final post in postsQshot.docs) {
    //   batch.update(post.reference, {
    //     'userName': firestoreUser.userName,
    //     'userImageURL': firestoreUser.userImageURL,
    //   });
    // }
    // await batch.commit();




    //100 個ほど投稿を生成
    // WriteBatch batch = FirebaseFirestore.instance.batch();
    // final String activeUid = returnAuthUser()!.uid;
    // for(int i = 0; i < 99; i++) {
    //   final Timestamp now = Timestamp.now();
    //   final String postId = returnUuidV4();
    //   final Post post = Post(
    //     createdAt: now,
    //     hashTags: [],
    //     imageURL: '',
    //     likeCount: 0,
    //     text: i.toString(),
    //     postId: postId,
    //     uid: activeUid,
    //     updatedAt: now,
    //   );
    //   final DocumentReference<Map<String, dynamic>> ref = FirebaseFirestore.instance.collection('users').doc(activeUid).collection('posts').doc(postId);
    //   batch.set(ref, post.toJson());
    // }
    // await batch.commit();
  }
}