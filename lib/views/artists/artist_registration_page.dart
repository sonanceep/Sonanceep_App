// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// models
import 'package:sonanceep_sns/models/artists/artist_registration_model.dart';
// components
import 'package:sonanceep_sns/details/rounded_text_field.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';

class ArtistRegistrationPage extends ConsumerWidget {
  const ArtistRegistrationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {  // WidgetRef ref でグローバルに監視した橋を観測できる
    final ArtistRegistrationModel artistRegistrationModel = ref.watch(artistRegistrationProvider);
    final List<Map<String, bool>> artistGenreTextList = artistRegistrationModel.artistGenreTextList;
    //入力されたテキストをコントロールできるようになる
    final TextEditingController artistNameEditingController = TextEditingController(text: artistRegistrationModel.artistName);
    final TextEditingController artistNationalityEditingController = TextEditingController(text: artistRegistrationModel.artistNationality);
    final TextEditingController activityStartYearEditingController = TextEditingController(text: artistRegistrationModel.activityStartYearString);

    return Scaffold(
      appBar: AppBar(  // AppBar 画面の一番上にあるバーのこと。アプリタイトルなど
        title: const Text(adminArtistRegistrationTitle),
      ),
      body: SingleChildScrollView(
        // physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //アーティストのアイコン
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                child: artistRegistrationModel.croppedFile == null ? 
                const Text('アーティストのアイコンを設定してください')
                : ClipRRect(
                  borderRadius: BorderRadius.circular(80.0),
                  child: Image.file(artistRegistrationModel.croppedFile!,),// fit: BoxFit.fill, ),
                ),
                onTap: () async => await artistRegistrationModel.onImageTapped(),
              ),
            ),
            //アーティスト名
            const Text(artistNameText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            RoundedTextField(
              keyboardType: TextInputType.text,  //キーボードのタイプ指定
              onChanged: (text) => artistRegistrationModel.artistName = text,  //変更されたテキストを代入
              controller: artistNameEditingController,
              borderColor: Colors.black,
              shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
              hintText: artistNameText,
            ),
            //アーティスト形態
            const Text(artistFormText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.15,
              child: ListView.builder(
                itemCount: artistFormTextList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.black,
                    height: 48,
                    child: RadioListTile(
                      title: Text(artistFormTextList[index]),
                      value: index,
                      groupValue: artistRegistrationModel.artistFormValue,
                      onChanged: (value) {
                        artistRegistrationModel.artistFormSetValue(value: value);
                      },
                    ),
                  );
                },
              ),
            ),
            //アーティストジャンル
            const Text(artistGenreText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.75,
              child: ListView.builder(
                itemCount: artistGenreTextList.length,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  return Row(
                    children: [
                      Checkbox(
                        activeColor: Colors.blue, // Onになった時の色を指定
                        value: artistGenreTextList[index].values.first, // チェックボックスのOn/Offを保持する値
                        onChanged: (value) {
                          artistRegistrationModel.checkBoxSetValue(value: value, index: index); // チェックボックスを押下した際に行う処理
                        },
                      ),
                      Text(artistGenreTextList[index].keys.first, style: const TextStyle(fontSize: 18.0)),
                    ],
                  );
                },
              ),
            ),
            //アーティスト国籍
            const Text(artistNationalityText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            RoundedTextField(
              keyboardType: TextInputType.text,  //キーボードのタイプ指定
              onChanged: (text) => artistRegistrationModel.artistNationality = text,  //変更されたテキストを代入
              controller: artistNationalityEditingController,
              borderColor: Colors.black,
              shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
              hintText: artistNationalityText,
            ),
            //アーティスト活動開始日
            const Text(activityStartYearText, style: TextStyle(fontSize: 18.0, color: Colors.orange)),
            RoundedTextField(
              keyboardType: TextInputType.number,  //キーボードのタイプ指定
              onChanged: (text) => artistRegistrationModel.activityStartYearString = text,  //変更されたテキストを代入
              controller: activityStartYearEditingController,
              borderColor: Colors.black,
              shadowColor: const Color(0xFF20A39E).withOpacity(0.7),
              hintText: activityStartYearText,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 80.0),
              child: RoundedButton(
                onPressed:() async => await artistRegistrationModel.registrationArtist(context: context),
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