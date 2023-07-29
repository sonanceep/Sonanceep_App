// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_comment_report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_PostCommentReport _$$_PostCommentReportFromJson(Map<String, dynamic> json) =>
    _$_PostCommentReport(
      activeUid: json['activeUid'] as String,
      createdAt: json['createdAt'],
      others: json['others'] as String,
      reportContent: json['reportContent'] as String,
      postCommentCreatorUid: json['postCommentCreatorUid'] as String,
      passiveUserName: json['passiveUserName'] as String,
      postCommentDocRef: json['postCommentDocRef'],
      postCommentId: json['postCommentId'] as String,
      postCommentReportId: json['postCommentReportId'] as String,
      comment: json['comment'] as String,
      commentLanguageCode: json['commentLanguageCode'] as String,
      commentNegativeScore: (json['commentNegativeScore'] as num).toDouble(),
      commentPositiveScore: (json['commentPositiveScore'] as num).toDouble(),
      commentSentiment: json['commentSentiment'] as String,
    );

Map<String, dynamic> _$$_PostCommentReportToJson(
        _$_PostCommentReport instance) =>
    <String, dynamic>{
      'activeUid': instance.activeUid,
      'createdAt': instance.createdAt,
      'others': instance.others,
      'reportContent': instance.reportContent,
      'postCommentCreatorUid': instance.postCommentCreatorUid,
      'passiveUserName': instance.passiveUserName,
      'postCommentDocRef': instance.postCommentDocRef,
      'postCommentId': instance.postCommentId,
      'postCommentReportId': instance.postCommentReportId,
      'comment': instance.comment,
      'commentLanguageCode': instance.commentLanguageCode,
      'commentNegativeScore': instance.commentNegativeScore,
      'commentPositiveScore': instance.commentPositiveScore,
      'commentSentiment': instance.commentSentiment,
    };
