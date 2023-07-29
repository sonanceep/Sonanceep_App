// flutter
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/ints.dart';
import 'package:sonanceep_sns/constants/lists.dart';
// domain
import 'package:sonanceep_sns/domain/timeline/timeline.dart';

final homeProvider = ChangeNotifierProvider(
  ((ref) => HomeModel()
));
class HomeModel extends ChangeNotifier {
  //フォローしているユーザーの投稿の取得に使用する
  List<DocumentSnapshot<Map<String,dynamic>>> postDocs = [];
  User currentUser = returnAuthUser()!;
  List<String> muteUids = [];
  List<String> mutePostIds= [];
  List<DocumentSnapshot<Map<String,dynamic>>> timelineDocs = [];
  // final RefreshController refreshController = RefreshController();

  Query<Map<String,dynamic>> returnQuery({required QuerySnapshot<Map<String,dynamic>> timelinesQshot}) {
    // timelineを取得したい
    final List<String> max10TimelinePostIds = timelinesQshot.docs.map((e) => Timeline.fromJson(e.data()).postId).toList();  //下のコメントアウトのような処理
    // List<String> max10TimelinePostIds = [];
    // for(final timelineDoc in timelinesQshot.docs) {
    //   final timeline = Timeline.fromJson(timelineDoc.data());
    //   max10TimelinePostIds.add(timeline.postId);
    // }
    if(max10TimelinePostIds.isEmpty) {
      max10TimelinePostIds.add('');  // whereInの中身が空だとエラーを返す
    }
    return FirebaseFirestore.instance.collectionGroup('posts').where('postId', whereIn: max10TimelinePostIds).limit(tenCount);
  }


  HomeModel() {
    init();
  }

  Future<void> init() async {
    final muteUidsAndMutePostIds = await returnMuteUidsAndMutePostIds();
    muteUids = muteUidsAndMutePostIds.first;
    mutePostIds = muteUidsAndMutePostIds.last;
    await onReload();
  }

  Future<void> onRefresh(RefreshController refreshController) async {
    final timelinesQshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('timelines').orderBy('createdAt', descending: true).endAtDocument(timelineDocs.first).limit(tenCount).get();
    for(final doc in timelinesQshot.docs.reversed.toList()) {
      timelineDocs.insert(0, doc);
    }
    refreshController.refreshCompleted();
    await voids.processNewDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(timelinesQshot: timelinesQshot));
    notifyListeners();
  }

  Future<void> onReload() async {
    final timelinesQshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('timelines').orderBy('createdAt', descending: true).limit(tenCount).get();
    timelineDocs = timelinesQshot.docs;
    if(timelineDocs.isNotEmpty) {
      await voids.processBasicDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(timelinesQshot: timelinesQshot));
    }
    notifyListeners();
  }

  Future<void> onLoading(RefreshController refreshController) async {
    final timelinesQshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('timelines').orderBy('createdAt', descending: true).startAfterDocument(timelineDocs.last).limit(tenCount).get();
    for(final doc in timelinesQshot.docs) {
      timelineDocs.add(doc);
    }
    refreshController.loadComplete();
    await voids.processOldDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(timelinesQshot: timelinesQshot));
    notifyListeners();
  }
}


















// // flutter
// import 'package:flutter/material.dart';
// // package
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:sonanceep_sns/constants/lists.dart';
// import 'package:pull_to_refresh/pull_to_refresh.dart';
// // constants
// import 'package:sonanceep_sns/constants/others.dart';
// import 'package:sonanceep_sns/constants/voids.dart' as voids;

// final homeProvider = ChangeNotifierProvider(
//   ((ref) => HomeModel()
// ));
// class HomeModel extends ChangeNotifier {
//   bool isLoading = false;
//   List<DocumentSnapshot<Map<String,dynamic>>> postDocs = [];
//   late User? currentUser;

//   // final RefreshController refreshController = RefreshController();  //初期化するたびに捨てる
//   List<String> muteUids = [];
//   Query<Map<String,dynamic>> returnQuery() {
//     final User? currentUser = returnAuthUser();
//     return FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).collection('posts').orderBy('createdAt', descending: true).limit(30);  // .doc(currentUser!.uid) 自分の投稿を取得
//   }

//   HomeModel() {
//     init();
//   }

//   Future<void> init() async {
//     muteUids = await returnMuteUids();
//     await onReload();
//   }

//   void startLoading() {
//     isLoading = true;
//     notifyListeners();
//   }

//   void endLoading() {
//     isLoading = false;
//     notifyListeners();
//   }

//   Future<void> onRefresh(RefreshController refreshController) async {
//     refreshController.refreshCompleted();
//     await voids.processNewDocs(muteUids: muteUids, docs: postDocs, query: returnQuery());
//     notifyListeners();
//   }

//   Future<void> onReload() async {
//     await voids.processBasicDocs(muteUids: muteUids, docs: postDocs, query: returnQuery());
//     notifyListeners();
//   }

//   Future<void> onLoading(RefreshController refreshController) async {
//     refreshController.loadComplete();
//     await voids.processOldDocs(muteUids: muteUids, docs: postDocs, query: returnQuery());
//     notifyListeners();
//   }
// }