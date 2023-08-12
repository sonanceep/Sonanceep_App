// intとかString以外のものreturn
// dart
import 'dart:io';
// flutter
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// packages
import 'package:video_player/video_player.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';

// ローカルの画像読み取り ---------------------------------------------------------------
Future<XFile> returnImageXFile() async {
  final ImagePicker picker = ImagePicker();
  final XFile? image = await picker.pickImage(source: ImageSource.gallery);
  return image!;
}

Future<File?> returnCroppedFile({ required XFile? xFile }) async {
  final instance = ImageCropper();
  final File? result = await instance.cropImage(
    sourcePath: xFile!.path,
    aspectRatioPresets: [CropAspectRatioPreset.square],
    iosUiSettings:  const IOSUiSettings(
      title: cropperTitle,
    ),
    androidUiSettings: const AndroidUiSettings(
      toolbarTitle: cropperTitle,
      toolbarColor: Colors.green,
      initAspectRatio: CropAspectRatioPreset.square,
      lockAspectRatio: false,
    )
  );
  return result;
}
// --------------------------------------------------------------------------------------

// ローカルの動画読み取り ---------------------------------------------------------------
Future<XFile> returnVideoXFile() async {
  final ImagePicker picker = ImagePicker();
  final XFile? video = await picker.pickVideo(source: ImageSource.gallery);
  return video!;
}

Future<VideoPlayerController> returnVideoController({ required XFile? xFile }) async {
  final VideoPlayerController controller = VideoPlayerController.file(File(xFile!.path));
  await controller.initialize();
  return controller;
}
// --------------------------------------------------------------------------------------

// 動画再生時の設定 ---------------------------------------------------------------------
ChewieController videoPlayerSettings({required String imageURL}) {
  VideoPlayerController videoPlayerController = VideoPlayerController.networkUrl(Uri.parse(imageURL));
    ChewieController chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      aspectRatio: 3 / 2,
      autoPlay: true,
      looping: true,
      deviceOrientationsAfterFullScreen: const [DeviceOrientation.portraitUp],  //動画の全画面を閉じた時に縦画面に戻す
    );
    return chewieController;
}
// --------------------------------------------------------------------------------------

User? returnAuthUser() => FirebaseAuth.instance.currentUser;

DocumentReference<Map<String,dynamic>> userDocToTokenDocRef({
  required DocumentSnapshot<Map<String,dynamic>> currentUserDoc,
  required String tokenId,
}) => currentUserDoc.reference.collection('tokens').doc(tokenId);

Query<Map<String,dynamic>> returnSearchQuery({required List<String> searchWords}) {
  Query<Map<String,dynamic>> query = FirebaseFirestore.instance.collection('users').limit(30);
  for(final searchWord in searchWords) {
    query = query.where('searchToken.$searchWord', isEqualTo:  true);
  }
  return query;
}

AppLocalizations returnL10n({required BuildContext context}) => AppLocalizations.of(context);