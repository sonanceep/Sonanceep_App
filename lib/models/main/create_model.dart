// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// package
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

final createProvider = ChangeNotifierProvider(
  ((ref) => CreateModel()
));
class CreateModel extends ChangeNotifier {
  //あなたへのおすすめ音源の取得に使用する
  List<DocumentSnapshot<Map<String,dynamic>>> soundSourceDocs = [];

  CreateModel() {
    init();
  }

  Future<void> init() async {
    await onReload();
  }

  Future<void> onRefresh(RefreshController refreshController) async {
    // final timelinesQshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('timelines').orderBy('createdAt', descending: true).endAtDocument(timelineDocs.first).limit(tenCount).get();
    // for(final doc in timelinesQshot.docs.reversed.toList()) {
    //   timelineDocs.insert(0, doc);
    // }
    // refreshController.refreshCompleted();
    // await voids.processNewDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(timelinesQshot: timelinesQshot));
    // notifyListeners();
  }

  Future<void> onReload() async {
    // final timelinesQshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('timelines').orderBy('createdAt', descending: true).limit(tenCount).get();
    // timelineDocs = timelinesQshot.docs;
    // if(timelineDocs.isNotEmpty) {
    //   await voids.processBasicDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(timelinesQshot: timelinesQshot));
    // }
    // notifyListeners();
  }

  Future<void> onLoading(RefreshController refreshController) async {
    // final timelinesQshot = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).collection('timelines').orderBy('createdAt', descending: true).startAfterDocument(timelineDocs.last).limit(tenCount).get();
    // for(final doc in timelinesQshot.docs) {
    //   timelineDocs.add(doc);
    // }
    // refreshController.loadComplete();
    // await voids.processOldDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: postDocs, query: returnQuery(timelinesQshot: timelinesQshot));
    // notifyListeners();
  }
}