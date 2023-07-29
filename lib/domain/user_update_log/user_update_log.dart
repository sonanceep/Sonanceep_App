//主にユーザーにupdateさせたい要素を含ませる
// followerCountを含めない updateさせないことができる

import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'user_update_log.freezed.dart';
part 'user_update_log.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class UserUpdateLog with _$UserUpdateLog {
  const factory UserUpdateLog({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required dynamic logCreatedAt,  //順番がわからなくなるので妥協して入れる  userのupdateには使用させない
    required String userName,
    required Map<String,dynamic> searchToken,
    required String userImageURL,
    required dynamic userRef,
    required String uid,
  }) = _UserUpdateLog;
  factory UserUpdateLog.fromJson(Map<String,dynamic> json) => _$UserUpdateLogFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}