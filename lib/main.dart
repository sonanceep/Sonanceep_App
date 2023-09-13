// dart
import 'dart:async';
// flutter
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// packages
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
// models
import 'package:sonanceep_sns/models/main_model.dart';
import 'package:sonanceep_sns/models/mute_users_model.dart';
import 'package:sonanceep_sns/models/themes_model.dart';
import 'package:sonanceep_sns/views/auth/verify_email_page.dart';
import 'package:sonanceep_sns/views/main/create_screen.dart';
import 'package:sonanceep_sns/views/main/message_screen.dart';
// options
import 'firebase_options.dart';
// constants
import 'package:sonanceep_sns/constants/strings.dart';
import 'package:sonanceep_sns/constants/themes.dart';
// components
import 'package:sonanceep_sns/views/main/home_screen.dart';
import 'package:sonanceep_sns/views/main/search_page.dart';
import 'package:sonanceep_sns/views/main/profile_screen.dart';
// pages
import 'package:sonanceep_sns/views/login_page.dart';
import 'package:sonanceep_sns/constants/bottom_navigation_bar_elements.dart';
import 'package:sonanceep_sns/constants/ints.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sonanceep_sns/details/sns_bottom_navigation_bar.dart';
// import 'package:sonanceep_sns/models/sns_bottom_navigation_bar_model.dart';

Future<void> main() async {
  await runZonedGuarded(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await dotenv.load();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;  // Dartのエラーを報告
    runApp(const ProviderScope(child: MyApp()));  // runApp() が最初に動くことでアプリを走られることができる
  }, (error, stackTrace) {
    FirebaseCrashlytics.instance.recordError(error, stackTrace);
  });
}

class MyApp extends ConsumerWidget {  // StatelessWidget はウジェット内で値を変更できない
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final MainModel mainModel = ref.watch(mainProvider);
    // MyAppが起動した最初の時にユーザーがログインしているかどうか確認
    final User? onceUser = FirebaseAuth.instance.currentUser;
    final ThemeModel themeModel = ref.watch(themeProvider);
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,  //多言語化
      supportedLocales: AppLocalizations.supportedLocales,  //多言語化
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: themeModel.isDarkTheme ? darkThemeData(context: context) : lightThemeData(context: context),  //画面のテーマ色を設定
      home: onceUser == null ?   //最初に飛ばす画面を選択
      // //メールアドレス認証識別なし
      // const LoginPage() :   //ユーザーが存在していない
      // const LoginPage(),  //ユーザーは存在している

      // メールアドレス認証識別あり
      const LoginPage() :   //ユーザーが存在していない
      onceUser.emailVerified ? 
      MyHomePage(themeModel: themeModel,) :   //ユーザーは存在していて、メールアドレスが認証されている
      const VerifyEmailPage(),  //ユーザーは存在しているが、メールアドレスが認証されていない
    );
  }
}

class MyHomePage extends HookConsumerWidget {
  const MyHomePage({
    Key? key, 
    required this.themeModel,
  }) : super(key: key);

  final ThemeModel themeModel;

  @override  //上書きする  今回はbuild関数
  Widget build(BuildContext context,WidgetRef ref) {
    final MainModel mainModel = ref.watch(mainProvider);
    // lib/models/sns_bottom_navigation_bar_model.dart と lib/details/sns_bottom_navigation_bar.dart を削除
    // final SNSBottomNavigationBarModel snsBottomNavigationBarModel = ref.watch(snsBottomNavigationBarProvider);
    final MuteUsersModel muteUserModel = ref.watch(muteUsersProvider);
    final pageIndex = useState(0);  //ページ番号を設定。初期値は0
    final pageController = usePageController();

    return Scaffold(
      body: mainModel.isLoading ?
      // body: 1 == 1 ?
      const Center(
        child: Text(loadingText),
        // child: Text(returnL10n(context: context).loading),
      ) : 
      PageView(
        controller: pageController,
        onPageChanged: (index) => pageIndex.value = index,  //ページが変わったらページ番号を変更している
        // childrenの個数はElementsの数
        children: [
          // 注意：ページじゃないのでScaffold
          HomeScreen(mainModel: mainModel, muteUserModel: muteUserModel, themeModel: themeModel,),
          SearchPage(mainModel: mainModel,),
          CreateScreen(mainModel: mainModel,),
          MessageScreen(mainModel: mainModel),
          ProfileScreen(mainModel: mainModel,),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: bottomNavigationBarElements,
        currentIndex: pageIndex.value,
        // Tapされたらページを変える
        onTap: (index) => pageController.animateToPage(
          index,
          duration: const Duration(milliseconds: pageAnimationDuration),
          curve: Curves.easeIn
        ),
      ),
    );
  }
}