import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'user_mute.freezed.dart';
part 'user_mute.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class UserMute with _$UserMute {
  const factory UserMute({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String passiveUid,
    required dynamic passiveUserRef,
  }) = _UserMute;
  factory UserMute.fromJson(Map<String,dynamic> json) => _$UserMuteFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}