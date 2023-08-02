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