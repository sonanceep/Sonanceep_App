import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'following_token.freezed.dart';
part 'following_token.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class FollowingToken with _$FollowingToken {
  // DBに保存する
  // createdAtやIdが必要
  // 自分がフォローしたことの印
  const factory FollowingToken({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,
    required String passiveUid,
    required String tokenId,
    required String tokenType,
  }) = _FollowingToken;
  factory FollowingToken.fromJson(Map<String,dynamic> json) => _$FollowingTokenFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}