import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'created_rooms.freezed.dart';
part 'created_rooms.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class CreatedRooms with _$CreatedRooms {
  // DBに保存する
  // createdAtやIdが必要
  // ルームを作成したことの印
  const factory CreatedRooms({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,
    required String talkUserId,
    required String roomId,
  }) = _CreatedRooms;
  factory CreatedRooms.fromJson(Map<String,dynamic> json) => _$CreatedRoomsFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}