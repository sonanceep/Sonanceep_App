import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter/foundation.dart';
// packeges
part 'quita_user.freezed.dart';
part 'quita_user.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class QuitaUser with _$QuitaUser {
  const factory QuitaUser({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
  required String description,
  required int followees_count,
  required int followers_count,
  required String id,
  required int items_count,
  required String name,
  required int permanent_id,
  required String profile_image_url,
  }) = _QuitaUser;
  factory QuitaUser.fromJson(Map<String,dynamic> json) => _$QuitaUserFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}