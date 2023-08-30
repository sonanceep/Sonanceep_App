import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'message.freezed.dart';
part 'message.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class Message with _$Message {
  // DBに保存する
  // createdAtやIdが必要
  // 自分がフォローしたことの印
  const factory Message({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic createdAt,
    required String senderId,
    required String message,
    required bool isRead,
  }) = _Message;
  factory Message.fromJson(Map<String,dynamic> json) => _$MessageFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}