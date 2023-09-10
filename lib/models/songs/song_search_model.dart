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
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/domain/firestore_song/firestore_song.dart';

final songSearchProvider = ChangeNotifierProvider(
  (ref) => SongSearchModel(),
);

class SongSearchModel extends ChangeNotifier {

  String searchTerm = '';
  List<DocumentSnapshot<Map<String,dynamic>>> songDocs = [];

  QuerySnapshot<Map<String, dynamic>>? albumsQuerySnapshot;

  Future<void> operation({required List<String> muteUids, required List<String> mutePostIds}) async {
    if(searchTerm.length > maxSearchLength) {
      await voids.showFlutterToast(msg: maxSearchLengthMsg);
    } else if(searchTerm.isNotEmpty) {
      final List<String> searchWords = returnSearchWords(searchTerm: searchTerm);
      final Query<Map<String,dynamic>> query = returnSongSearchQuery(searchWords: searchWords);  //文字数−1個のwhereが必要
      await voids.processBasicDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: songDocs, query: query);
      notifyListeners();
    }
  }

  //必要に応じてアーティストを全員取得
  SongSearchModel() {
    init();
  }

  Future<void> init() async {
    final QuerySnapshot<Map<String, dynamic>> qshot = await FirebaseFirestore.instance.collection('songs').limit(30).get();
    //取得されたeをJsonの型に直してFirestoreSong.fromJsonで独自に作成したFirestoreSongクラスの配列に格納 ※
    songDocs = qshot.docs;
    notifyListeners();
  }
}