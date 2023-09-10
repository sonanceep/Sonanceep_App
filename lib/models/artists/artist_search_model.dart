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
import 'package:sonanceep_sns/domain/firestore_artist/firestore_artist.dart';

final artistSearchProvider = ChangeNotifierProvider(
  (ref) => ArtistSearchModel(),
);

class ArtistSearchModel extends ChangeNotifier {

  String searchTerm = '';
  List<DocumentSnapshot<Map<String,dynamic>>> artistDocs = [];

  QuerySnapshot<Map<String, dynamic>>? albumsQuerySnapshot;

  Future<void> operation({required List<String> muteUids, required List<String> mutePostIds}) async {
    if(searchTerm.length > maxSearchLength) {
      await voids.showFlutterToast(msg: maxSearchLengthMsg);
    } else if(searchTerm.isNotEmpty) {
      final List<String> searchWords = returnSearchWords(searchTerm: searchTerm);
      final Query<Map<String,dynamic>> query = returnArtistSearchQuery(searchWords: searchWords);  //文字数−1個のwhereが必要
      await voids.processBasicDocs(muteUids: muteUids, mutePostIds: mutePostIds, docs: artistDocs, query: query);
      notifyListeners();
    }
  }

  //必要に応じてアーティストを全員取得
  ArtistSearchModel() {
    init();
  }

  Future<void> init() async {
    final QuerySnapshot<Map<String, dynamic>> qshot = await FirebaseFirestore.instance.collection('artists').limit(30).get();
    //取得されたeをJsonの型に直してFirestoreartist.fromJsonで独自に作成したFirestoreartistクラスの配列に格納 ※
    artistDocs = qshot.docs;
    notifyListeners();
  }

  Future<void> getAlbumList({required BuildContext context, required FirestoreArtist firestoreArtist, required DocumentSnapshot<Map<String, dynamic>> artistDoc}) async {
    try {
      List<Map<String, bool>> albumIdAndBoolList = [];
      albumsQuerySnapshot = await FirebaseFirestore.instance.collection(artistsFieldKey).doc(firestoreArtist.artistId).collection('albums').get();
      for(final doc in albumsQuerySnapshot!.docs) {
        String albumId = doc['albumId'];
        Map<String, bool> albumData = {albumId : false};
        albumIdAndBoolList.add(albumData);
      }
      routes.toSongRegistrationPage(context: context, artistDoc: artistDoc, albumIdAndBoolList: albumIdAndBoolList);
    } catch(e) {
      voids.showFlutterToast(msg: e.toString());
    }
  }
}