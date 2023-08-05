// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
import 'package:sonanceep_sns/details/rounded_text_field.dart';
import 'package:sonanceep_sns/details/user_image.dart';
import 'package:sonanceep_sns/domain/firestore_user/firestore_user.dart';
import 'package:sonanceep_sns/models/edit_profile_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final EditProfileModel editProfileModel = ref.watch(editProfileProvider);
    final FirestoreUser firestoreUser = mainModel.firestoreUser;  // firestoreの情報が表示できるようになる
    final TextEditingController textEditingController = TextEditingController(text: editProfileModel.userName);

    return Scaffold(
      appBar: AppBar(title: const Text(editProfilePageTitle),),
      body: SingleChildScrollView(  //画面をスクロールできるように？
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: InkWell(
                child: editProfileModel.croppedFile == null ? 
                UserImage(userImageURL: firestoreUser.userImageURL, length: 180.0)
                  : ClipRRect(
                  borderRadius: BorderRadius.circular(160.0),
                  child: Image.file(editProfileModel.croppedFile!,),// fit: BoxFit.fill, ),
                ),
                onTap: () async => await editProfileModel.onImageTapped(),
              ),
            ),
            //ユーザー名を編集したい
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: RoundedTextField(
                keyboardType: TextInputType.name,
                onChanged: (value) => editProfileModel.userName = value,
                controller: textEditingController,
                borderColor: Colors.black,
                shadowColor: Colors.red.withOpacity(0.3),
                hintText: firestoreUser.userName,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
                child: Center(
                child: RoundedButton( //プロフィールの更新に必要
                  onPressed: () => editProfileModel.updateUserInfo(context: context, mainModel: mainModel),
                  widthRate: 0.95,
                  color: Colors.green,
                  text: updateText,
                ),
              ),
            ),
          ],
        ),
      )
    );
  }
}