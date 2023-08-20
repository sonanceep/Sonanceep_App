// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/details/rounded_button.dart';
import 'package:sonanceep_sns/models/main_model.dart';

class CreateScreen extends ConsumerWidget {
  const CreateScreen({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(createText),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: RoundedButton(
              onPressed: () => routes.toCreatePostPage(mainModel: mainModel, context: context),
              widthRate: 0.85,
              color: Colors.green,
              text: createPostText,
            ),
          ),
        ],
      ),
    );
  }
}