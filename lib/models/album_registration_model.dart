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
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/domain/album/album.dart';
// domain
import 'package:sonanceep_sns/domain/firestore_artist/firestore_artist.dart';

final albumRegistrationProvider =
    ChangeNotifierProvider(((ref) => AlbumRegistrationModel()));

class AlbumRegistrationModel extends ChangeNotifier {
  File? croppedFile = null;
  String albumName = '';
  String releaseDateString = '';

  //アルバム登録
  Future<void> registrationFirestorealbum({
    required BuildContext context,
    required DocumentSnapshot<Map<String,dynamic>> artistDoc,
    required Timestamp releaseDate,
  }) async {
    final FirestoreArtist firestoreArtist = FirestoreArtist.fromJson(artistDoc.data()!);
    final String artistId = firestoreArtist.artistId;
    final String albumId = returnAlbumStorageName(albumName: albumName);
    String albumImageURL = croppedFile == null ? firestoreArtist.artistImageURL : await uploadImageAndGetURL(file: croppedFile!, artistId: artistId, albumId: albumId);
    //クラス化されたjson形式の取得
    final Timestamp now = Timestamp.now();
    final Album album = Album(
      createdAt: now,
      updatedAt: now,
      artistId: artistId,
      searchToken: returnSearchToken(searchWords: returnSearchWords(searchTerm: albumName)),
      albumName: albumName,
      albumId: albumId,
      albumSongs: [],
      albumImageURL: albumImageURL,
      releaseDate: releaseDate,
      artistRef: artistDoc.reference,
    );
    Navigator.pop(context); //ひとつ前のページに戻る
    //アルバム情報の取得
    final Map<String, dynamic> albumData = album.toJson(); //firestorealbum.toJson() でアルバム情報を得る
    // Cloud Firestore に格納
    await FirebaseFirestore.instance.collection(artistsFieldKey).doc(artistId).collection('albums').doc(albumId).set(albumData); //doc(空) ランダムなIDとなるがalbumDataにuidを含めない
    await resetInformation();
    //アルバム登録完了のバナー
    await voids.showFlutterToast(msg: albumRegisteredMsg);
    notifyListeners();
  }

  //アルバム登録
  Future<void> registrationalbum({required BuildContext context, required DocumentSnapshot<Map<String,dynamic>> artistDoc}) async {
    if( albumName.isNotEmpty &&
        releaseDateString.isNotEmpty) {
      try {
        // 文字列を'/'で分割して年、月、日の部分を取得
        List<String> dateParts = releaseDateString.split('/');
        int year = int.parse(dateParts[0]);
        int month = int.parse(dateParts[1]);
        int day = int.parse(dateParts[2]);
        DateTime dateTime = DateTime(year, month, day);
        Timestamp releaseDate = Timestamp.fromDate(dateTime);

        await registrationFirestorealbum(context: context, artistDoc: artistDoc, releaseDate: releaseDate,);
      } catch(e) {
        voids.showFlutterToast(msg: formatErrorMsg);
      }
    } else {
      voids.showFlutterToast(msg: notEnoughMsg);
    }
  }

  String? validateAndReturnFourDigitInt({required String checkString}) {
    final RegExp regex = RegExp(r'^\d{4}$');
    if (regex.hasMatch(checkString)) {
      return checkString;
    } else {
      return null;
    }
  }

  Future<void> resetInformation() async {
    croppedFile = null;
    albumName = '';
    releaseDateString = '';
  }

  Future<String> uploadImageAndGetURL({
    required File file,
    required String artistId,
    required String albumId,
  }) async {
    //Fileを使うには import 'dart:io';
    final String fileName = returnJpgFileName();
    final Reference storageRef = FirebaseStorage.instance.ref().child(artistsFieldKey).child(artistId).child(albumId).child(fileName);
    // users/uid/ファイル名 にアップロード
    await storageRef.putFile(file);
    // users/uid/ファイル名 のURLを取得している
    return await storageRef.getDownloadURL(); // Future の場合時間がかかる処理のため await が必要
  }

  Future<void> onImageTapped() async {
    final XFile xFile = await returnImageXFile();
    croppedFile = await returnCroppedFile(xFile: xFile);
    notifyListeners();
  }
}
