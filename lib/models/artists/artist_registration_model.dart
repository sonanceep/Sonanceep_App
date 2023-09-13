// flutter
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
// packages
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sonanceep_sns/constants/lists.dart';
import 'package:sonanceep_sns/constants/maps.dart';
import 'package:sonanceep_sns/constants/others.dart';
// constants
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/constants/strings.dart';
// domain
import 'package:sonanceep_sns/domain/firestore_artist/firestore_artist.dart';

final artistRegistrationProvider = ChangeNotifierProvider(
  ((ref) => ArtistRegistrationModel()
));

class ArtistRegistrationModel extends ChangeNotifier {
  File? croppedFile = null;
  String artistName = '';
  String artistNationality = '';
  String activityStartYearString = '';

  int artistFormValue = 0;

  List<Map<String, bool>> artistGenreTextList = [];

  ArtistRegistrationModel() {
    for(var genre in genreTextList) {
      artistGenreTextList.add({genre: false});
    }
  }

  //アーティスト登録
  Future<void> registrationFirestoreArtist({
    required BuildContext context,
    required String artistForm,
    required List<String> artistGenre,
    required int activityStartYear,
  }) async {
    final String artistId = returnArtistStorageName(artistName: artistName);
    String artistImageURL = await uploadImageAndGetURL(file: croppedFile!, artistId: artistId);
    //クラス化されたjson形式の取得
    final Timestamp now = Timestamp.now();
    final FirestoreArtist firestoreArtist = FirestoreArtist(
      createdAt: now,
      updatedAt: now,
      searchToken: returnSearchToken(searchWords: returnSearchWords(searchTerm: artistName)),
      albumCount: 0,
      songCount: 0,
      artistName: artistName,
      artistId: artistId,
      artistImageURL: artistImageURL,
      artistForm: artistForm,
      artistGenre: artistGenre,
      artistNationality: artistNationality,
      activityStartYear: activityStartYear,
    );
    Navigator.pop(context);  //ひとつ前のページに戻る
    //アーティスト情報の取得
    final Map<String,dynamic> artistData = firestoreArtist.toJson();  //firestoreArtist.toJson() でアーティスト情報を得る
    // Cloud Firestore に格納
    await FirebaseFirestore.instance.collection(artistsFieldKey).doc(artistId).set(artistData);  //doc(空) ランダムなIDとなるがartistDataにuidを含めない
    await resetInformation();
    //アーティスト登録完了のバナー
    await voids.showFlutterToast(msg: artistRegisteredMsg);
    notifyListeners();
  }

  //アーティスト登録
  Future<void> registrationArtist({required BuildContext context}) async {
    List<String> artistGenre = extractSelectedGenres(genreList: artistGenreTextList);
    if( croppedFile != null && 
        artistName.isNotEmpty && 
        artistGenre.isNotEmpty && 
        artistNationality.isNotEmpty && 
        activityStartYearString.isNotEmpty) {
      String artistForm = artistFormTextList[artistFormValue];
      final RegExp regex = RegExp(r'^\d{4}$');
      if(regex.hasMatch(activityStartYearString)) {
        int activityStartYear = int.parse(activityStartYearString);

        await registrationFirestoreArtist(context: context, artistForm: artistForm, artistGenre: artistGenre, activityStartYear: activityStartYear);
      } else {
        voids.showFlutterToast(msg: formatErrorMsg);
      }
    } else {
      voids.showFlutterToast(msg: notEnoughMsg);
    }
  }

  String? validateAndReturnFourDigitInt({required String checkString}) {
    final RegExp regex = RegExp(r'^\d{4}$');
    if(regex.hasMatch(checkString)) {
      return checkString;
    } else {
      return null;
    }
  }

  Future<void> resetInformation() async {
    croppedFile = null;
    artistName = '';
    artistNationality = '';
    activityStartYearString = '';
  }

  Future<String> uploadImageAndGetURL({required File file, required String artistId}) async {  //Fileを使うには import 'dart:io';
    final String fileName = returnJpgFileName();
    final Reference storageRef = FirebaseStorage.instance.ref().child(artistsFieldKey).child(artistId).child(fileName);
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

  Future<void> artistFormSetValue({int? value}) async {
    artistFormValue = value!;
    notifyListeners();
  }

  Future<void> checkBoxSetValue({required bool? value, required int index}) async {
    final Map<String, bool> genreMap = artistGenreTextList[index];
    final String genreName = genreMap.keys.first;
    final Map<String, bool> updatedGenreMap = {genreName: value!};
    artistGenreTextList[index] = updatedGenreMap;
    notifyListeners();
  }
}