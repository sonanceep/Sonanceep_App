// flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
// packages
import 'package:hooks_riverpod/hooks_riverpod.dart';

class DawMobilePage extends HookConsumerWidget {
  const DawMobilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    useEffect(() {
      // ページ遷移するときに横画面にする
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ]);
      return () {
        // ページを戻る時に縦画面に戻す
        SystemChrome.setPreferredOrientations([
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
        ]);
      };
    }, const []);

    return Scaffold(
      appBar: AppBar(title: const Text('DAW')),
      // body: ,
    );
  }
}