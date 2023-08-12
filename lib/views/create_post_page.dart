// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
import 'package:sonanceep_sns/details/rounded_text_field.dart';
import 'package:sonanceep_sns/models/create_post_model.dart';
import 'package:sonanceep_sns/models/main_model.dart';

import 'package:sonanceep_sns/models/main/create_model.dart';
import 'package:video_player/video_player.dart';

class CreatePostPage extends ConsumerWidget {
  const CreatePostPage({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final CreatePostModel createPostModel = ref.watch(createPostProvider);
    final TextEditingController textEditingController = TextEditingController(text: createPostTitle);

    return Scaffold(
      appBar: AppBar(
        title: const Text(createText),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //画像・ TODO 動画
            Padding(
              padding: const EdgeInsets.all(32.0),
              child: InkWell(
                child: createPostModel.croppedFile == null ? 
                const Text('画像、動画を貼り付けよう！')
                : ClipRRect(
                  child: Image.file(createPostModel.croppedFile!,),
                ),
                // onTap: ()async => await createPostModel.onImageTapped(),
                onTap: ()async => await createPostModel.onVideoTapped(),
              ),
            ),
            //テキスト
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: RoundedTextField(
                keyboardType: TextInputType.name,
                onChanged: (value) => createPostModel.text = value,
                controller: textEditingController,
                borderColor: Colors.black,
                shadowColor: Colors.red.withOpacity(0.3),
                hintText: createPostTitle,
              ),
            ),
            //投稿する
            Padding(
              padding: const EdgeInsets.all(16.0),
                child: Center(
                child: RoundedButton(
                  onPressed: () async => await createPostModel.showPost(context: context, mainModel: mainModel),
                  widthRate: 0.85,
                  color: Colors.green,
                  text: createPostTitle,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}