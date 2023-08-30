// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
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
    final roomId = returnRoomId(activeUid: activeUid, passiveUid: passiveUser.uid);
    final firestoreInstance = FirebaseFirestore.instance;
    String messageId = returnUuidV4();
    final Message message = Message(
      createdAt: Timestamp.now(),
      senderId: activeUid,
      message: text,
      isRead: false,
    );
    await firestoreInstance.collection(roomsFieldKey).doc(roomId).collection('message').doc(messageId).set(message.toJson());

    await firestoreInstance.collection(roomsFieldKey).doc(roomId).update({
      'lastMessage': text,
    });
  }

  Stream<QuerySnapshot> fetchMessageSnapshot({required MainModel mainModel, required FirestoreUser passiveUser}) {
    final currentUserDoc = mainModel.currentUserDoc;
    final String activeUid = currentUserDoc.id;
    final roomId = returnRoomId(activeUid: activeUid, passiveUid: passiveUser.uid);
    return roomCollection.doc(roomId).collection('message').orderBy('createdAt', descending: true).snapshots();  // orderBy('send_time', descending: true)  新しいメッセージが下に来るように調整
  }
}