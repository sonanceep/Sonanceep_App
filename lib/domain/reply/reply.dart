import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'reply.freezed.dart';
part 'reply.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class Reply with _$Reply {
  const factory Reply({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,  // dynamic型 なんでも許す
    required String reply,
    required String replyLanguageCode,
    required double replyNegativeScore,
    required double replyPositiveScore,
    required String replySentiment,
    required int likeCount,
    required dynamic postRef,
    required dynamic postCommentRef,
    required String postCommentReplyId,
    required int reportCount,
    required String userName,
    required String userNameLanguageCode,
    required double userNameNegativeScore,
    required double userNamePositiveScore,
    required String userNameSentiment,
    required String uid,
    required String userImageURL,
    required dynamic updatedAt,
  }) = _Reply;
  factory Reply.fromJson(Map<String,dynamic> json) => _$ReplyFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}