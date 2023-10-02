// flutter
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// package
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/enums.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/routes.dart' as routes;
// domain
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/domain/follower/follower.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/following_token/following_token.dart';
// model
import 'package:sonanceep_sns/models/main_model.dart';

final passiveUserProfileProvider = ChangeNotifierProvider(
  ((ref) => PassiveUserProfileModel()
));

class PassiveUserProfileModel extends ChangeNotifier {

  //相手の投稿を取得する
  List<DocumentSnapshot<Map<String,dynamic>>> postDocs = [];
  SortState sortState = SortState.byNewestFirst;
  RefreshController refreshController = RefreshController();  //初期化するたびに捨てる
  String indexUid = '';

  Query<Map<String,dynamic>> returnQuery({required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc}) {
    final query = passiveUserDoc.reference.collection('users').doc().collection('posts');
    switch(sortState) {
      case SortState.byLikeUidCount:
        return query.orderBy('likeCount', descending: true);
      case SortState.byNewestFirst:
        return query.orderBy('createdAt', descending: true);
      case SortState.byOldestfirst:
        return query.orderBy('createdAt', descending: false);
    }
  }

  Future<void> onUserPostIconPressed({
    required BuildContext context,
    required MainModel mainModel,
    required String passiveUid,
  }) async {
    final QuerySnapshot<Map<String, dynamic>> qshot = await FirebaseFirestore.instance.collection(usersFieldKey).where('uid', isEqualTo: passiveUid).get();
    final List<DocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;
    final passiveUserDoc = docs.first;
    await onUserIconPressed(context: context, mainModel: mainModel, passiveUserDoc: passiveUserDoc);
  }

  Future<void> onUserIconPressed({
    // required RefreshController refreshController,
    required BuildContext context,
    required MainModel mainModel,
    required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc,
  }) async {
    refreshController = RefreshController();
    routes.toPassiveUserProfilePage(context: context, passiveUserDoc: passiveUserDoc, mainModel: mainModel);
    final String passiveUid = passiveUserDoc.id;
    if(indexUid != passiveUid) {
      await onReload(muteUids: mainModel.muteUids, mutePostIds: mainModel.mutePostIds, passiveUserDoc: passiveUserDoc);
    }
    indexUid = passiveUid;
  }

  Future<void> onRefresh({required List<String> muteUids, required List<String> mutePostIds, required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc}) async {
    refreshController.refreshCompleted();
    await voids.processNewDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(passiveUserDoc: passiveUserDoc));
    notifyListeners();
  }

  Future<void> onReload({required List<String> muteUids, required List<String> mutePostIds, required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc}) async {
    await voids.processBasicDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(passiveUserDoc: passiveUserDoc));
    notifyListeners();
  }

  Future<void> onLoading({required List<String> muteUids, required List<String> mutePostIds, required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc}) async {
    refreshController.loadComplete();
    await voids.processOldDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(passiveUserDoc: passiveUserDoc));
    notifyListeners();
  }

  Future<void> follow({required MainModel mainModel, required FirestoreUser passiveUser}) async {
    mainModel.followingUids.add(passiveUser.uid);  //リストに加える
    final Timestamp now = Timestamp.now();
    final String tokenId = returnUuidV4();
    final FollowingToken followingToken = FollowingToken(
      createdAt: now,
      passiveUid: passiveUser.uid,
      tokenId: tokenId,
      tokenType: followingTokenTypeString,
    );
    final FirestoreUser activeUser = mainModel.firestoreUser;
    final FirestoreUser newActiveUser = activeUser.copyWith(followingCount: activeUser.followingCount + 1);
    mainModel.firestoreUser = newActiveUser;
    notifyListeners();

    //自分がフォローした印
    await FirebaseFirestore.instance.collection('users').doc(activeUser.uid).collection('tokens').doc(tokenId).set(followingToken.toJson());

    // //危険な例  フォローしているユーザーの数を+１する
    // await FirebaseFirestore.instance.collection('users').doc(activeUser.uid).update({
    //   // Firestore上の値に+1
    //   'followingCount': FieldValue.increment(1),  //フロントエンド側がデータベースに関わってこないので安全になる
    // });

    //受動的なユーザーがフォローされたdataを生成する
    final Follower follower = Follower(
      createdAt: now,
      followedUid: passiveUser.uid,  //フォローされた人のuid
      followerUid: activeUser.uid,  //フォローした人のuid
    );
    await FirebaseFirestore.instance.collection('users').doc(passiveUser.uid).collection('followers').doc(activeUser.uid).set(follower.toJson());

    // //危険な例  フォロワーの数を+１する
    // await FirebaseFirestore.instance.collection('users').doc(passiveUser.uid).update({
    //   // Firestore上の値に+1
    //   'followerCount': FieldValue.increment(1),  //フロントエンド側がデータベースに関わってこないので安全になる
    // });

    //個人チャットルームを作成する
    // createRoom(mainModel: mainModel, passiveUser : passiveUser);
  }

  Future<void> unfollow({required MainModel mainModel, required FirestoreUser passiveUser}) async {
    mainModel.followingUids.remove(passiveUser.uid);

    //フォローしているTokenを取得する
    final FirestoreUser activeUser = mainModel.firestoreUser;
    final FirestoreUser newActiveUser = activeUser.copyWith(followingCount: activeUser.followingCount - 1);
    mainModel.firestoreUser = newActiveUser;
    notifyListeners();

    // qshotというデータの塊の存在を取得
    final QuerySnapshot<Map<String, dynamic>> qshot = await FirebaseFirestore.instance.collection(usersFieldKey).doc(activeUser.uid).collection('tokens').where('passiveUid', isEqualTo: passiveUser.uid).get();
    final List<DocumentSnapshot<Map<String, dynamic>>> docs = qshot.docs;  //一個しか取得していないが複数している扱い
    final DocumentSnapshot<Map<String, dynamic>> token = docs.first;

    await token.reference.delete();

    // //危険な例  フォローしているユーザーの数を-１する
    // await FirebaseFirestore.instance.collection('users').doc(activeUser.uid).update({
    //   // Firestore上の値に-1
    //   'followingCount': FieldValue.increment(-1),  //フロントエンド側がデータベースに関わってこないので安全になる
    // });

    //受動的なユーザーがフォローされたdataを削除する
    await FirebaseFirestore.instance.collection('users').doc(passiveUser.uid).collection('followers').doc(activeUser.uid).delete();

    //  //危険な例  フォロワーの数を-１する
    // await FirebaseFirestore.instance.collection('users').doc(passiveUser.uid).update({
    //   // Firestore上の値に-1
    //   'followerCount': FieldValue.increment(-1),  //フロントエンド側がデータベースに関わってこないので安全になる
    // });
  }

  // Future<void> createRoom({required MainModel mainModel, required FirestoreUser passiveUser}) async {

  //   final DocumentSnapshot<Map<String, dynamic>> currentUserDoc = mainModel.currentUserDoc;
  //   final String activeUid = currentUserDoc.id;
  //   final String passiveUid = passiveUser.uid;
  //   // qshotというデータの塊の存在を取得
  //   final QuerySnapshot<Map<String, dynamic>> qshot = await FirebaseFirestore.instance.collection('users').doc(activeUid).collection('createdRooms').where('talkUid', isEqualTo: passiveUid).get();

  //   //既にルームが作成されているか
  //   if(qshot.docs.isEmpty) {
  //     final String talkRoomId = returnTalkRoomId(activeUid: activeUid, passiveUid: passiveUid);
  //     final firestoreInstance = FirebaseFirestore.instance;
  //     final currentUserDoc = mainModel.currentUserDoc;
  //     final passiveUserDoc = await FirebaseFirestore.instance.collection(usersFieldKey).doc(passiveUid).get();
  //     //クラス化されたjson形式の取得
  //     final Timestamp now = Timestamp.now();
  //     final FirestoreRoom firestoreRoom = FirestoreRoom(
  //       createdAt: now,
  //       joinedUsers: [activeUid, passiveUid],
  //       talkRoomId: talkRoomId,
  //       lastMessage: "",
  //       updateAt: '',
  //     );
  //     // Cloud Firestore に格納
  //     await firestoreInstance.collection(roomsFieldKey).doc(talkRoomId).set(firestoreRoom.toJson());

  //     notifyListeners();
  //     final CreatedRooms activeSideCreatedRooms = CreatedRooms(
  //       createdAt: now,
  //       talkUid: passiveUid,
  //       uid: activeUid,
  //       talkRoomId: talkRoomId,
  //     );
  //     final CreatedRooms passiveSideCreatedRooms = CreatedRooms(
  //       createdAt: now,
  //       talkUid: activeUid,
  //       uid: passiveUid,
  //       talkRoomId: talkRoomId,
  //     );
  //     // Cloud Firestore に格納
  //     await currentUserDoc.reference.collection('createdRooms').doc(talkRoomId).set(activeSideCreatedRooms.toJson());
  //     await passiveUserDoc.reference.collection('createdRooms').doc(talkRoomId).set(passiveSideCreatedRooms.toJson());
  //     //ルーム作成完了のバナー
  //     await voids.showFlutterToast(msg: "ルームの作成に成功！");
  //   } else {
  //     await voids.showFlutterToast(msg: "ルームはもうあるよ！");
  //   }
  // }

  void onMenuPressed({
    required BuildContext context,
    required List<String> muteUids,
    required List<String> mutePostIds,
    required DocumentSnapshot<Map<String,dynamic>> passiveUserDoc,
  }) {
    voids.showPopup(
      context: context,
      builder: (innerContext) {
        return CupertinoActionSheet(
          message: const Text('操作を選択'),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                if(sortState != SortState.byLikeUidCount) {
                  sortState = SortState.byLikeUidCount;
                  await onReload(muteUids: muteUids, mutePostIds: mutePostIds, passiveUserDoc: passiveUserDoc);
                }
                Navigator.pop(innerContext);
              },
              isDestructiveAction: true,
              child: const Text('いいね順に並び替え',),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                if(sortState != SortState.byNewestFirst) {
                  sortState = SortState.byNewestFirst;
                  await onReload(muteUids: muteUids, mutePostIds: mutePostIds, passiveUserDoc: passiveUserDoc);
                }
                Navigator.pop(innerContext);
              },
              isDestructiveAction: true,
              child: const Text('新しい順に並び替え',),
            ),
            CupertinoActionSheetAction(
              onPressed: () async {
                if(sortState != SortState.byOldestfirst) {
                  sortState = SortState.byOldestfirst;
                  await onReload(muteUids: muteUids, mutePostIds: mutePostIds, passiveUserDoc: passiveUserDoc);
                }
                Navigator.pop(innerContext);
              },
              isDestructiveAction: true,
              child: const Text('古い順に並び替え',),
            ),
            CupertinoActionSheetAction(
              onPressed: () => Navigator.pop(innerContext),
              child: const Text(backText),
            ),
          ],
        );
      }
    );
  }
}
