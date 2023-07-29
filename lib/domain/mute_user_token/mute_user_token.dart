import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'mute_user_token.freezed.dart';
part 'mute_user_token.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class MuteUserToken with _$MuteUserToken {
  // DBに保存する
  // createdAtやIdが必要
  // 自分の投稿にいいねしたことの印
  const factory MuteUserToken({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String passiveUid,
    required String tokenId,
    required String tokenType,
  }) = _MuteUserToken;
  factory MuteUserToken.fromJson(Map<String,dynamic> json) => _$MuteUserTokenFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}