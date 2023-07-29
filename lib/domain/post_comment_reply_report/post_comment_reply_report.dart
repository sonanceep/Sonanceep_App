import 'package:freezed_annotation/freezed_annotation.dart';
// packeges
part 'post_comment_reply_report.freezed.dart';
part 'post_comment_reply_report.g.dart';

//jsonをクラスにする
@freezed  //パッケージの型は使えない（Timestampなど）ので dynamic型 を使用する  エディターでエラー表示はされない
abstract class PostCommentReplyReport with _$PostCommentReplyReport {
  //メールで送信
  const factory PostCommentReplyReport({  // const factory 違うクラスのインスタンスを返すことができるコンストラクタ
    required String activeUid,
    required dynamic createdAt,
    required String others,  //その他の報告内容
    required String reportContent,  //メインの報告内容
    required String postCommentReplyCreatorUid,
    required String passiveUserName,
    required dynamic postCommentReplyDocRef,
    required String postCommentReplyId,
    required String postCommentReplyReportId,
    required String reply,
    required String replyLanguageCode,
    required double replyNegativeScore,
    required double replyPositiveScore,
    required String replySentiment,
  }) = _PostCommentReplyReport;
  factory PostCommentReplyReport.fromJson(Map<String,dynamic> json) => _$PostCommentReplyReportFromJson(json);  //fromJsonと同時にtoJsonもメソッドされる
}