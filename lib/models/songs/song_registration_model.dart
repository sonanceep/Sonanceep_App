// flutter
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonanceep_sns/constants/bools.dart';
import 'package:sonanceep_sns/constants/lists.dart';
import 'package:sonanceep_sns/constants/maps.dart';
import 'package:sonanceep_sns/constants/others.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/domain/album/album.dart';
import 'package:sonanceep_sns/domain/firestore_artist/firestore_artist.dart';
// domain
import 'package:sonanceep_sns/domain/firestore_song/firestore_song.dart';

final songRegistrationProvider = ChangeNotifierProvider(
  ((ref) => SongRegistrationModel()
));

class SongRegistrationModel extends ChangeNotifier {
  File? croppedFile = null;
  String songName = '';
  String songBpmString = '';
  String minutesString = '';
  String secondsString = '';
  String releaseDateString = '';

  int albumTypeValue = 0;
  int songKeyValue = 0;

  List<Map<String, bool>> songGenreTextList = [];

  SongRegistrationModel() {
    for(var genre in genreTextList) {
      songGenreTextList.add({genre: false});
    }
  }

  //楽曲登録
  Future<void> registrationFirestoreSong({
    required BuildContext context,
    required DocumentSnapshot<Map<String,dynamic>> artistDoc,
    required String albumType,
    required String songId,
    required double songBpm,
    required List<String> songGenre,
    required List<String> songAlbums,
    required List<String> songImageURL,
    required Duration songDuration,
    required Timestamp releaseDate,
  }) async {
    final FirestoreArtist firestoreArtist = FirestoreArtist.fromJson(artistDoc.data()!);
    final String artistId = firestoreArtist.artistId;
    //クラス化されたjson形式の取得
    final Timestamp now = Timestamp.now();
    final FirestoreSong firestoreSong = FirestoreSong(
      createdAt: now,
      updatedAt: now,
      searchToken: returnSearchToken(searchWords: returnSearchWords(searchTerm: songName)),
      artistId: artistId,
      albumType: albumType,
      songName: songName,
      songId: songId,
      songBpm: songBpm,
      songKey: songKeyValue,
      songGenre: songGenre,
      songAlbums: songAlbums,
      songImageURL: songImageURL,
      songDuration: songDuration.inSeconds,
      releaseDate: releaseDate,
      artistRef: artistDoc.reference,
    );
    Navigator.pop(context);  //ひとつ前のページに戻る
    //楽曲情報の取得
    final Map<String,dynamic> songData = firestoreSong.toJson();  //firestoresong.toJson() で楽曲情報を得る
    // Cloud Firestore に格納
    await FirebaseFirestore.instance.collection(songsFieldKey).doc(songId).set(songData);  //doc(空) ランダムなIDとなるがsongDataにuidを含めない
    //アルバムに楽曲IDを追加
    for(final albumId in songAlbums) {
      DocumentReference<Map<String, dynamic>> docReference = FirebaseFirestore.instance.collection(artistsFieldKey).doc(artistId).collection('albums').doc(albumId);
      DocumentSnapshot<Map<String, dynamic>> docSnapshot = await docReference.get();
      List<String> currentAlbumSongs = List<String>.from(docSnapshot.data()!['albumSongs'] ?? []);
      currentAlbumSongs.add(songId);
      await docReference.update({
        'albumSongs': currentAlbumSongs,
      });
    }
    await resetInformation();
    //楽曲登録完了のバナー
    await voids.showFlutterToast(msg: songRegisteredMsg);
    notifyListeners();
  }

  //楽曲登録
  Future<void> registrationSong({
    required BuildContext context,
    required DocumentSnapshot<Map<String,dynamic>> artistDoc,
    required List<Map<String, bool>> stringAndBoolList,
  }) async {
    List<String> songGenre = extractSelectedGenres(genreList: songGenreTextList);
    if( songBpmString.isNotEmpty && 
        songName.isNotEmpty && 
        songGenre.isNotEmpty && 
        minutesString.isNotEmpty && 
        secondsString.isNotEmpty && 
        releaseDateString.isNotEmpty) {
      List<String> songImageURL = [];
      List<String> songAlbums = [];
      String songId = returnSongStorageName(songName: songName);

      if((albumTypeValue == 1 && croppedFile == null) || (albumTypeValue != 1 && extractSelectedGenres(genreList: stringAndBoolList).isEmpty)) {
        voids.showFlutterToast(msg: notSetAlbumMsg);
      } else {
        albumTypeValue == 1 ? songImageURL.add(await uploadImageAndGetURL(file: croppedFile!, songId: songId)) : songAlbums = extractSelectedGenres(genreList: stringAndBoolList);
        for(final albumId in songAlbums) {
          DocumentSnapshot<Map<String, dynamic>> albumDoc = await artistDoc.reference.collection('albums').doc(albumId).get();
          songImageURL.add(albumDoc.data()!['albumImageURL']);
        }

        try {
          //楽曲の長さ
          int minutes = int.parse(minutesString);
          int seconds = int.parse(secondsString);
          Duration songDuration = Duration(minutes: minutes, seconds: seconds);
          //アルバムタイプ
          String albumType = albumTypeList[albumTypeValue];
          //楽曲BPM
          double songBpm = double.parse(songBpmString);
          // 文字列を'/'で分割して年、月、日の部分を取得
          List<String> dateParts = releaseDateString.split('/');
          int year = int.parse(dateParts[0]);
          int month = int.parse(dateParts[1]);
          int day = int.parse(dateParts[2]);
          DateTime dateTime = DateTime(year, month, day);
          Timestamp releaseDate = Timestamp.fromDate(dateTime);

          await registrationFirestoreSong(
            context: context,
            artistDoc: artistDoc,
            albumType: albumType,
            songId: songId,
            songBpm: songBpm,
            songGenre: songGenre,
            songAlbums: songAlbums,
            songImageURL: songImageURL,
            songDuration: songDuration,
            releaseDate: releaseDate
          );
        } catch(e) {
          voids.showFlutterToast(msg: formatErrorMsg);
        }
      }
    } else {
      voids.showFlutterToast(msg: notEnoughMsg);
    }
  }

  Future<void> resetInformation() async {
    songName = '';
    songBpmString = '';
    minutesString = '';
    secondsString = '';
    releaseDateString = '';
  }

  Future<String> uploadImageAndGetURL({required File file, required String songId}) async {  //Fileを使うには import 'dart:io';
    final String fileName = returnJpgFileName();
    final Reference storageRef = FirebaseStorage.instance.ref().child(songsFieldKey).child(songId).child(fileName);
    // users/uid/ファイル名 にアップロード
    await storageRef.putFile(file);
    // users/uid/ファイル名 のURLを取得している
    return await storageRef.getDownloadURL();  // Future の場合時間がかかる処理のため await が必要
  }

  Future<void> onImageTapped() async {
    final XFile xFile = await returnImageXFile();
    croppedFile = await returnCroppedFile(xFile: xFile);
    notifyListeners();
  }

  Future<void> songFormSetValue({int? value}) async {
    albumTypeValue = value!;
    notifyListeners();
  }

  Future<void> songKeySetValue({int? value}) async {
    songKeyValue = value!;
    notifyListeners();
  }

  Future<void> checkBoxSetValue({required bool? value, required int index, required List<Map<String, bool>> stringAndBoolList}) async {
    final Map<String, bool> map = stringAndBoolList[index];
    final String name = map.keys.first;
    final Map<String, bool> updatedMap = {name: value!};
    stringAndBoolList[index] = updatedMap;
    notifyListeners();
  }
}