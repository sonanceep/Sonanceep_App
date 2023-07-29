import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'mute_post_token.freezed.dart';
part 'mute_post_token.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class MutePostToken with _$MutePostToken {
  // DBに保存する
  // createdAtやIdが必要
  // 自分の投稿にいいねしたことの印
  const factory MutePostToken({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String postId,
    required dynamic postRef,
    required String tokenId,
    required String tokenType,
  }) = _MutePostToken;
  factory MutePostToken.fromJson(Map<String,dynamic> json) => _$MutePostTokenFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}