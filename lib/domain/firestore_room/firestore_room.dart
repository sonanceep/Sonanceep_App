import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'firestore_room.freezed.dart';
part 'firestore_room.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class FirestoreRoom with _$FirestoreRoom {
  const factory FirestoreRoom({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,  // dynamic型 なんでも許す
    required List<String> joinedUserIds,
    required String roomId,
    required String lastMessage,
  }) = _FirestoreRoom;
  factory FirestoreRoom.fromJson(Map<String,dynamic> json) => _$FirestoreRoomFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}