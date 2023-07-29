import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'reply_like.freezed.dart';
part 'reply_like.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class ReplyLike with _$ReplyLike {
  const factory ReplyLike({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String postCommentReplyCreatorUid,
    required dynamic postCommentReplyRef,
    required String postCommentReplyId,
  }) = _ReplyLike;
  factory ReplyLike.fromJson(Map<String,dynamic> json) => _$ReplyLikeFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}