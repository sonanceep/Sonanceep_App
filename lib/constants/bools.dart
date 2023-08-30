import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/domain/comment/comment.dart';
import 'package:sonanceep_sns/domain/reply/reply.dart';
import 'package:sonanceep_sns/models/main/message_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';

bool isValidUser({required List<String> muteUids, required Map<String,dynamic> map}) => !muteUids.contains(map['uid']);

bool isValidPost({required List<String> mutePostIds, required Map<String,dynamic> map}) => !mutePostIds.contains(map['postId']);

bool isValidComment({required List<String> muteUids, required Comment comment}) => !muteUids.contains(comment.postCommentId);

// muteしているreplyIdたちにReplyのIdが含まれていなければ、正しいリプライである
bool isValidReply({required List<String> muteReplyIds, required Reply reply}) => !muteReplyIds.contains(reply.postCommentReplyId);

bool messageIsMine({
  required MainModel mainModel,
  required AsyncSnapshot<QuerySnapshot> snapshot,
  required int index,
  // required String senderId,
}) {
  final doc = snapshot.data!.docs[index];
  final Map<String, dynamic> data = doc.data() as Map<String, dynamic>;  //型変換
  final currentUserDoc = mainModel.currentUserDoc;
  final String activeUid = currentUserDoc.id;
  return activeUid == data['senderId'] ? true : false;
}