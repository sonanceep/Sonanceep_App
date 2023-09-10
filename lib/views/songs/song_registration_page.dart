// flutter
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/colors.dart';
import 'package:sonanceep_sns/constants/others.dart';
import 'package:sonanceep_sns/constants/voids.dart' as voids;
import 'package:sonanceep_sns/domain/firestore_artist/firestore_artist.dart';
// models
import 'package:sonanceep_sns/models/songs/song_registration_model.dart';
// components
import 'package:sonanceep_sns/details/rounded_text_field.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';

class SongRegistrationPage extends ConsumerWidget {
  const SongRegistrationPage({
    Key? key,
    required this.artistDoc,
    required this.albumIdAndBoolList,
  }) : super(key: key);

  final DocumentSnapshot<Map<String,dynamic>> artistDoc;
  final List<Map<String, bool>> albumIdAndBoolList;

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // WidgetRef ref でグローバルに監視した橋を観測できる
    final SongRegistrationModel songRegistrationModel = ref.watch(songRegistrationProvider);
    final List<Map<String, bool>> songGenreTextList = songRegistrationModel.songGenreTextList;
    //入力されたテキストをコントロールできるようになる
    final TextEditingController songNameEditingController = TextEditingController(text: songRegistrationModel.songName);
    final TextEditingController songBpmEditingController = TextEditingController(text: songRegistrationModel.songBpmString);
    final TextEditingController minutesEditingController = TextEditingController(text: songRegistrationModel.minutesString);
    final TextEditingController secondsEditingController = TextEditingController(text: songRegistrationModel.secondsString);
    final TextEditingController releaseDateEditingController = TextEditingController(text: songRegistrationModel.releaseDateString);

    return Scaffold(
      appBar: AppBar(  // AppBar 画面の一番上にあるバーのこと。アプリタイトルなど
        title: const Text(adminSongRegistrationTitle),
      ),
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //楽曲名
            const Text(songNameText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            RoundedTextField(
              keyboardType: TextInputType.text,  //キーボードのタイプ指定
              onChanged: (text) => songRegistrationModel.songName = text,  //変更されたテキストを代入
              controller: songNameEditingController,
              borderColor: Colors.black,
              shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
              hintText: songNameText,
            ),
            //楽曲 アルバム形態
            const Text(songAlbumTypeText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.2,
              child: ListView.builder(
                itemCount: albumTypeList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.black,
                    height: 48,
                    child: RadioListTile(
                      title: Text(albumTypeList[index]),
                      value: index,
                      groupValue: songRegistrationModel.albumTypeValue,
                      onChanged: (value) {
                        songRegistrationModel.songFormSetValue(value: value);
                      },
                    ),
                  );
                },
              ),
            ),
            songRegistrationModel.albumTypeValue == 1 ? 
            //シングル曲のアイコン
            Padding(
              padding: const EdgeInsets.only(bottom: 32.0),
              child: InkWell(
                child: songRegistrationModel.croppedFile == null ? 
                const Text('ここを押してシングル曲のアイコンを設定', style: TextStyle(fontSize: 18.0, color: Colors.red)) : ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child: Image.file(songRegistrationModel.croppedFile!,),// fit: BoxFit.fill, ),
                ),
                onTap: () async => await songRegistrationModel.onImageTapped(),
              ),
            ) : albumIdAndBoolList.isNotEmpty ? SizedBox(
              height: albumIdAndBoolList.length * 60,
              child: ListView.builder(
                itemCount: albumIdAndBoolList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      children: [
                        Checkbox(
                          activeColor: Colors.blue, // Onになった時の色を指定
                          value: albumIdAndBoolList[index].values.first, // チェックボックスのOn/Offを保持する値
                          onChanged: (value) {
                            songRegistrationModel.checkBoxSetValue(value: value, index: index, stringAndBoolList: albumIdAndBoolList); // チェックボックスを押下した際に行う処理
                          },
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Text(albumIdAndBoolList[index].keys.first, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18.0))
                        ),
                        const Divider(
                          color: dividerColor,
                          thickness: 1.0,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ) : const Padding(
              padding: EdgeInsets.only(bottom: 32.0),
              child: Text('アルバムを登録してください', style: TextStyle(fontSize: 24.0, color: Colors.red)),
            ),
            //楽曲ジャンル
            const Text(songGenreText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                itemCount: songGenreTextList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.blue, // Onになった時の色を指定
                        value: songGenreTextList[index].values.first, // チェックボックスのOn/Offを保持する値
                        onChanged: (value) {
                          songRegistrationModel.checkBoxSetValue(value: value, index: index, stringAndBoolList: songGenreTextList); // チェックボックスを押下した際に行う処理
                        },
                      ),
                      Text(songGenreTextList[index].keys.first, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 18.0)),
                    ],
                  );
                },
              ),
            ),
            //楽曲BPM
            const Text(songbpmText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            RoundedTextField(
              keyboardType: TextInputType.number,  //キーボードのタイプ指定
              onChanged: (text) => songRegistrationModel.songBpmString = text,  //変更されたテキストを代入
              controller: songBpmEditingController,
              borderColor: Colors.black,
              shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
              hintText: songbpmText,
            ),
            //楽曲 調
            const Text(songKeyText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.65,
              child: ListView.builder(
                itemCount: songKeyList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.black,
                    height: 48,
                    child: RadioListTile(
                      title: Text(songKeyList[index]),
                      value: index,
                      groupValue: songRegistrationModel.songKeyValue,
                      onChanged: (value) {
                        songRegistrationModel.songKeySetValue(value: value);
                      },
                    ),
                  );
                },
              ),
            ),
            //楽曲の長さ
            const Text(songDurationText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: RoundedTextField(
                    keyboardType: TextInputType.number,  //キーボードのタイプ指定
                    onChanged: (text) => songRegistrationModel.minutesString = text,  //変更されたテキストを代入
                    controller: minutesEditingController,
                    borderColor: Colors.black,
                    shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
                    hintText: minuteText,
                  ),
                ),
                const Text(':', style: TextStyle(fontSize: 18.0, color: Colors.orange)),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.35,
                  child: RoundedTextField(
                    keyboardType: TextInputType.number,  //キーボードのタイプ指定
                    onChanged: (text) => songRegistrationModel.secondsString = text,  //変更されたテキストを代入
                    controller: secondsEditingController,
                    borderColor: Colors.black,
                    shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
                    hintText: secondText,
                  ),
                ),
              ],
            ),
            //楽曲リリース日
            const Text(songReleaseDateText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            RoundedTextField(
              keyboardType: TextInputType.text,  //キーボードのタイプ指定
              onChanged: (text) => songRegistrationModel.releaseDateString = text,
              controller: releaseDateEditingController,
              borderColor: Colors.black,
              shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
              hintText: releaseDateExampleText,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: RoundedButton(
                onPressed:() async => await songRegistrationModel.registrationSong(context: context, artistDoc: artistDoc, stringAndBoolList: albumIdAndBoolList),
                widthRate: 0.8,
                color: Colors.red,
                text: signupText,
              ),
            ),
          ],
        ),
      ),
    );
  }
}