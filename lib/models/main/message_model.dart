// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/domain/firestore_room/firestore_room.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/views/message/message_page.dart';

final messageProvider = ChangeNotifierProvider(
  ((ref) => MessageModel()
));


class MessageModel extends ChangeNotifier {

  final roomCollection = FirebaseFirestore.instance.collection('rooms');
  // final roomId = FirebaseFirestore.instance.collection('rooms').roomId;
  final joinedRoomSnapshot = FirebaseFirestore.instance.collection('rooms').where('joinedUserIds').snapshots();


  // //トークルーム作成
  // Future<void> createFirestoreRoom({required BuildContext context, required String uid}) async {
  //   final String roomId = returnUuidV4();
  //   //クラス化されたjson形式の取得
  //   final Timestamp now = Timestamp.now();
  //   final FirestoreRoom firestoreRoom = FirestoreRoom(
  //     createdAt: now,
  //     joinedUserIds: [],
  //     roomId: roomId,
  //     lastMessage: '',
  //   );
  //   //ルーム情報の取得
  //   final Map<String,dynamic> userData = firestoreRoom.toJson();  //firestoreRoom.toJson() でルーム情報を得る
  //   // Cloud Firestore に格納
  //   await FirebaseFirestore.instance.collection(roomsFieldKey).doc(uid).set(userData);
  //   //ルーム作成完了のバナー
  //   await voids.showFlutterToast(msg: "ルームの作成成功！");
  //   notifyListeners();
  // }

  Future<void> sendMessage({required String roomId, required String message}) async {
    try {
      final messageCollection = roomCollection.doc(roomId).collection('message');
      await messageCollection.add({
        'message': message,
        'sender_id': "", //SharedPrefs.fetchUid(),
        'send_time': Timestamp.now(),
      });

      //最後のメッセージを更新
      await roomCollection.doc(roomId).update({
        'last_message': message,
      });
    } catch (e) {
      await voids.showFlutterToast(msg: "送信失敗" + e.toString());
    }
  }
}