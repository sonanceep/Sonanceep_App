import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'reply_mute.freezed.dart';
part 'reply_mute.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class ReplyMute with _$ReplyMute {
  const factory ReplyMute({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String postCommentReplyId,
    required dynamic postCommentReplyRef,
  }) = _ReplyMute;
  factory ReplyMute.fromJson(Map<String,dynamic> json) => _$ReplyMuteFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}