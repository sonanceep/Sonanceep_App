// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/domain/created_rooms/created_rooms.dart';
import 'package:sonanceep_sns/domain/firestore_room/firestore_room.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/domain/message/message.dart';
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/views/message/message_page.dart';

final messageProvider = ChangeNotifierProvider(
  ((ref) => MessageModel()
));


class MessageModel extends ChangeNotifier {

  final TextEditingController textEditingController = TextEditingController();
  RefreshController refreshController = RefreshController();  //初期化するたびに捨てる
  String messageString = "";

  final userCollection = FirebaseFirestore.instance.collection(usersFieldKey);
  final roomCollection = FirebaseFirestore.instance.collection(roomsFieldKey);

  Message messageSnapshot({
    required AsyncSnapshot<QuerySnapshot> snapshot,
    required int index,
  }) {
    final doc = snapshot.data!.docs[index];
    final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;  //型変換
    final Message message = Message(
      createdAt: data['createdAt'],
      message: data['message'],
      senderId: data['senderId'],  //自分のIDとmessageの送信者のIDが一致するか
      isRead: data['isRead'],
    );
    return message;
  }

  Future<void> sendMessage({
    required MainModel mainModel,
    required FirestoreUser passiveUser,
    required String text,
  }) async {
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final talkRoomId = returnTalkRoomId(activeUid: activeUid, passiveUid: passiveUser.uid);
    final firestoreInstance = FirebaseFirestore.instance;
    final roomsCollection = firestoreInstance.collection(roomsFieldKey);
    String messageId = returnUuidV4();
    final Message message = Message(
      createdAt: Timestamp.now(),
      senderId: activeUid,
      message: text,
      isRead: false,
    );
    final QuerySnapshot<Map<String, dynamic>> qshot = await roomsCollection.where('talkRoomId', isEqualTo: talkRoomId).get();

    if(qshot.docs.isEmpty) {
      //個人チャットルームを作成する
      await createRoom(mainModel: mainModel, passiveUser : passiveUser, talkRoomId: talkRoomId);
      await roomsCollection.doc(talkRoomId).collection('message').doc(messageId).set(message.toJson());
      await roomsCollection.doc(talkRoomId).update({
        'lastMessage': text,
        'updateAt': Timestamp.now(),
      });
    } else {
      await roomsCollection.doc(talkRoomId).collection('message').doc(messageId).set(message.toJson());
      await roomsCollection.doc(talkRoomId).update({
        'lastMessage': text,
        'updateAt': Timestamp.now(),
      });
    }
  }

  Future<void> createRoom({required MainModel mainModel, required FirestoreUser passiveUser, required String talkRoomId}) async {

    final DocumentSnapshot<Map<String, dynamic>> currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final String passiveUid = passiveUser.uid;
    final firestoreInstance = FirebaseFirestore.instance;
    final passiveUserDoc = await FirebaseFirestore.instance.collection(usersFieldKey).doc(passiveUid).get();
    //クラス化されたjson形式の取得
    final Timestamp now = Timestamp.now();
    final FirestoreRoom firestoreRoom = FirestoreRoom(
      createdAt: now,
      joinedUsers: [activeUid, passiveUid],
      talkRoomId: talkRoomId,
      lastMessage: "",
      updateAt: '',
    );
    // Cloud Firestore に格納
    await firestoreInstance.collection(roomsFieldKey).doc(talkRoomId).set(firestoreRoom.toJson());

    notifyListeners();
    final CreatedRooms activeSideCreatedRooms = CreatedRooms(
      createdAt: now,
      talkUid: passiveUid,
      uid: activeUid,
      talkRoomId: talkRoomId,
    );
    final CreatedRooms passiveSideCreatedRooms = CreatedRooms(
      createdAt: now,
      talkUid: activeUid,
      uid: passiveUid,
      talkRoomId: talkRoomId,
    );
    // Cloud Firestore に格納
    await currentUserDoc.reference.collection('createdRooms').doc(talkRoomId).set(activeSideCreatedRooms.toJson());
    await passiveUserDoc.reference.collection('createdRooms').doc(talkRoomId).set(passiveSideCreatedRooms.toJson());
  }

  //自分が参加しているルームを取得
  Future<List<FirestoreRoom>?> fetchJoindTalkrooms({
    required QuerySnapshot querySnapshot,
  }) async {
    try {
      List<FirestoreRoom> talkRooms = [];
      for(var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        final FirestoreRoom firestoreRoom = FirestoreRoom(
          createdAt: data['createdAt'],
          joinedUsers: [data['joinedUsers'][0].toString(), data['joinedUsers'][1].toString()],
          talkRoomId: data['talkRoomId'].toString(),
          lastMessage: data['lastMessage'].toString(),
          updateAt: data['updateAt'],
        );
        talkRooms.add(firestoreRoom);
      }
      // voids.showFlutterToast(msg: talkRooms.length.toString());
      return talkRooms;
    } catch(e) {
      return null;
    }
  }

  Future<List<FirestoreUser>?> fetchPassiveUser({
    required List<FirestoreRoom> talkRooms,
    required MainModel mainModel,
  }) async {
    try {
      List<FirestoreUser> talkUsers = [];
      final currentUserDoc = mainModel.currentUserDoc;
      final String activeUid = currentUserDoc.id;
      // final firestoreUser = mainModel.firestoreUser;
      for(FirestoreRoom talkRoom in talkRooms) {
        final String passiveUid;
        if(activeUid != talkRoom.joinedUsers[0]) {
          passiveUid = talkRoom.joinedUsers[0];
        } else {
          passiveUid = talkRoom.joinedUsers[1];
        }
        final DocumentSnapshot<Map<String, dynamic>> passiveUserDoc = await userCollection.doc(passiveUid).get();
        final FirestoreUser firestoreUser = FirestoreUser(
          createdAt: passiveUserDoc['createdAt'],
          updatedAt: passiveUserDoc['updatedAt'],
          followerCount: passiveUserDoc['followerCount'].toInt(),
          followingCount: passiveUserDoc['followingCount'].toInt(),
          isAdmin: passiveUserDoc['isAdmin'],
          muteCount: passiveUserDoc['muteCount'].toInt(),
          searchToken: passiveUserDoc['searchToken'],
          postCount: passiveUserDoc['postCount'].toInt(),
          talkRoomCount: passiveUserDoc['talkRoomCount'].toInt(),
          userName: passiveUserDoc['userName'].toString(),
          userNameLanguageCode: passiveUserDoc['userNameLanguageCode'].toString(),
          userNameNegativeScore: passiveUserDoc['userNameNegativeScore'].toDouble(),
          userNamePositiveScore: passiveUserDoc['userNamePositiveScore'].toDouble(),
          userNameSentiment: passiveUserDoc['userNameSentiment'].toString(),
          uid: passiveUserDoc['uid'].toString(),
          userImageURL: passiveUserDoc['userImageURL'].toString(),
        );
        talkUsers.add(firestoreUser);
      }
      return talkUsers;
    } catch (e) {
      voids.showFlutterToast(msg: e.toString());
      return null;
    }
  }

  Stream<QuerySnapshot> fetchMessageSnapshot({required MainModel mainModel, required FirestoreUser passiveUser}) {
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final talkRoomId = returnTalkRoomId(activeUid: activeUid, passiveUid: passiveUser.uid);
    return roomCollection.doc(talkRoomId).collection('message').orderBy('createdAt', descending: true).snapshots();  // orderBy('send_time', descending: true)  新しいメッセージが下に来るように調整
  }

  Stream<QuerySnapshot> fetchTalkroomSnapshot({required MainModel mainModel}) {
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    // return userCollection.doc(activeUid).collection('createdRooms').snapshots();
    return roomCollection.where('joinedUsers', arrayContains: activeUid).snapshots();
  }
}