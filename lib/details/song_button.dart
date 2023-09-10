// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
// components
import 'package:sonanceep_sns/details/rounded_button.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/routes.dart' as routes;
// model
import 'package:sonanceep_sns/models/main_model.dart';

class SongButton extends ConsumerWidget {
  const SongButton({
    Key? key,
    required this.mainModel,
  }) : super(key: key);

  final MainModel mainModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return RoundedButton(
      onPressed: () => routes.toCreatePostPage(context: context, mainModel: mainModel),
      widthRate: 0.85,
      color: Colors.purple,
      text: createPostText,
    );
  }
}