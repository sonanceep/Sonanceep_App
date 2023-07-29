import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'post_comment_report.freezed.dart';
part 'post_comment_report.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class PostCommentReport with _$PostCommentReport {
  //メールで送信
  const factory PostCommentReport({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String others,  //その他の報告内容
    required String reportContent,  //メインの報告内容
    required String postCommentCreatorUid,
    required String passiveUserName,
    required dynamic postCommentDocRef,
    required String postCommentId,
    required String postCommentReportId,
    required String comment,
    required String commentLanguageCode,
    required double commentNegativeScore,
    required double commentPositiveScore,
    required String commentSentiment,
  }) = _PostCommentReport;
  factory PostCommentReport.fromJson(Map<String,dynamic> json) => _$PostCommentReportFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}