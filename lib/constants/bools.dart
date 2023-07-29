import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/reply/reply.dart';

bool isValidUser({required List<String> muteUids, required Map<String,dynamic> map}) => !muteUids.contains(map['uid']);

bool isValidPost({required List<String> mutePostIds, required Map<String,dynamic> map}) => !mutePostIds.contains(map['postId']);

bool isValidComment({required List<String> muteUids, required Comment comment}) => !muteUids.contains(comment.postCommentId);

// muteしているreplyIdたちにReplyのIdが含まれていなければ、正しいリプライである
bool isValidReply({required List<String> muteReplyIds, required Reply reply}) => !muteReplyIds.contains(reply.postCommentReplyId);