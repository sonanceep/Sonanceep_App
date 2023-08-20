// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/ints.dart';
import 'package:sonanceep_sns/constants/lists.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;

final userSearchProvider = ChangeNotifierProvider(
  (ref) => UserSearchModel(),
);

class UserSearchModel extends ChangeNotifier {

  String searchTerm = '';
  List<DocumentSnapshot<Map<String,dynamic>>> userDocs = [];

  Future<void> operation({required List<String> muteUids, required List<String> mutePostIds}) async {
    if(searchTerm.length > maxSearchLength) {
      await voids.showFlutterToast(msg: maxSearchLengthMsg);
    } else if(searchTerm.isNotEmpty) {
      final List<String> searchWords = returnSearchWords(searchTerm: searchTerm);
      final Query<Map<String,dynamic>> query = returnSearchQuery(searchWords: searchWords);  //文字数−1個のwhereが必要
      await voids.processBasicDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: userDocs, query: query);
      notifyListeners();
    }
  }

  // //必要に応じてユーザーを全員取得
  // UserSearchModel() {
  //   init();
  // }
  // Future<void> init() async {
  //   final QuerySnapshot<Map<String, dynamic>> qshot = await FirebaseFirestore.instance.collection('users').limit(30).get();
  //   //取得されたeをJsonの型に直してFirestoreUser.fromJsonで独自に作成したFirestoreUserクラスの配列に格納 ※
  //   userDocs = qshot.docs;
  //   notifyListeners();
  // }
}