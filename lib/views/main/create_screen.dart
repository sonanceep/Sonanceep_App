// flutter
import 'package:flutter/material.dart';
// packages
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/models/main/create_model.dart';

class CreateScreen extends ConsumerWidget {
  const CreateScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final CreateModel createModel = ref.watch(createProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(createText),
      ),
    );
  }
}


// // flutter
// import 'package:flutter/material.dart';
// // packages
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sonanceep_sns/constants/strings.dart';
// import 'package:sonanceep_sns/details/rounded_button.dart';
// import 'package:sonanceep_sns/models/create_post_model.dart';
// import 'package:sonanceep_sns/models/main/create_model.dart';
// import 'package:sonanceep_sns/models/main_model.dart';

// class CreateScreen extends ConsumerWidget {
//   const CreateScreen({
//     Key? key,
//     required this.mainModel,
//   }) : super(key: key);

//   final MainModel mainModel;

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {

//     final CreateModel createModel = ref.watch(createProvider);
//     final CreatePostModel createPostModel = ref.watch(createPostProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(createText),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Center(
//             child: RoundedButton(
//               onPressed: () => createPostModel.showPostFlashBar(context: context, mainModel: mainModel),
//               widthRate: 0.85,
//               color: Colors.green,
//               text: createPostTitle,
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }