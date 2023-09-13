// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/models/album_registration_model.dart';
// models
// components
import 'package:sonanceep_sns/details/rounded_text_field.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';

class AlbumRegistrationPage extends ConsumerWidget {
  const AlbumRegistrationPage({
    Key? key,
    required this.artistDoc,
  }) : super(key: key);

  final DocumentSnapshot<Map<String,dynamic>> artistDoc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // WidgetRef ref でグローバルに監視した橋を観測できる
    final AlbumRegistrationModel albumRegistrationModel = ref.watch(albumRegistrationProvider);
    //入力されたテキストをコントロールできるようになる
    final TextEditingController albumNameEditingController = TextEditingController(text: albumRegistrationModel.albumName);
    final TextEditingController releaseDateEditingController = TextEditingController(text: albumRegistrationModel.releaseDateString);

    return Scaffold(
      appBar: AppBar(  // AppBar 画面の一番上にあるバーのこと。アプリタイトルなど
        title: const Text(adminAlbumRegistrationTitle),
      ),
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //アルバムのアイコン
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                child: albumRegistrationModel.croppedFile == null ? 
                const Text('アルバムのアイコンを設定してください')
                : ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child: Image.file(albumRegistrationModel.croppedFile!,),// fit: BoxFit.fill, ),
                ),
                onTap: () async => await albumRegistrationModel.onImageTapped(),
              ),
            ),
            //アルバム名
            const Text(albumNameText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            RoundedTextField(
              keyboardType: TextInputType.text,  //キーボードのタイプ指定
              onChanged: (text) => albumRegistrationModel.albumName = text,  //変更されたテキストを代入
              controller: albumNameEditingController,
              borderColor: Colors.black,
              shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
              hintText: albumNameText,
            ),
            //アルバムリリース開始日
            const Text(songReleaseDateText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            RoundedTextField(
              keyboardType: TextInputType.text,  //キーボードのタイプ指定
              onChanged: (text) => albumRegistrationModel.releaseDateString = text,
              controller: releaseDateEditingController,
              borderColor: Colors.black,
              shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
              hintText: releaseDateExampleText,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: RoundedButton(
                onPressed:() async => await albumRegistrationModel.registrationalbum(context: context, artistDoc: artistDoc),
                widthRate: 0.8,
                color: Colors.red,
                text: signupText,
              ),
            ),
          ],
        ),
      )
    );
  }
}