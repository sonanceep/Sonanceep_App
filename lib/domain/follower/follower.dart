import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'follower.freezed.dart';
part 'follower.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class Follower with _$Follower {
  // DBに保存する
  // createdAtやIdが必要
  // 自分がフォローしたことの印
  const factory Follower({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,
    required String followedUid,
    required String followerUid,
  }) = _Follower;
  factory Follower.fromJson(Map<String,dynamic> json) => _$FollowerFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}