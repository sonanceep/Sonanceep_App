// package
import 'package:flutter/material.dart';
import 'package:sonanceep_sns/domain/message/message.dart';
import 'package:uuid/uuid.dart';
import 'package:intl/intl.dart' as intel;

// titles
const String appTitle = 'SNS';
const String signupTitle = '新規登録';
const String loginTitle = 'ログイン';
const String cropperTitle = 'Cropper';
const String accountTitle = 'アカウント';
const String themeTitle = 'テーマ';
const String profileTitle = 'プロフィール';
const String artistTitle = 'アーティスト';
const String artistSearchTitle = 'アーティスト検索';
const String songTitle = '楽曲';
const String adminTitle = '管理者';
const String adminArtistRegistrationTitle = 'アーティスト登録';
const String adminEditArtistProfileTitle = 'アーティストを編集';
const String adminSongRegistrationTitle = '曲を登録';
const String adminEditSongProfileTitle = '曲を編集';
const String adminAlbumRegistrationTitle = 'アルバムを登録';
const String commentTitle = 'コメント';
const String replyTitle = 'リプライ';
const String editProfilePageTitle = 'プロフィール編集ページ';
const String muteUsersPageTitle = 'ミュートしているユーザー';
const String muteCommentsPageTitle = 'ミュートしているコメント';
const String mutePostsPageTitle = 'ミュートしている投稿';
const String muteRepliesPageTitle = 'ミュートしているリプライ';
const String reauthenticationPageTitle = '再認証';
const String updatePasswordPageTitle = '新しいパスワード';
const String updateEmailPageTitle = '新しいメールアドレス';
const String searchScreenTitle = 'Search';
// texts
const String artistNameText = 'アーティスト名';
const String artistFormText = 'アーティスト形態';
const String artistGenreText = 'アーティストジャンル';
const String artistNationalityText = 'アーティスト国籍';
const String activityStartYearText = 'アーティスト活動開始年';
const String albumNameText = 'アルバム名';
const String albumReleaseDateText = 'アルバムリリース日';
const String songNameText = '楽曲名';
const String songAlbumTypeText = '楽曲のアルバム形態';
const String songGenreText = '楽曲ジャンル';
const String songbpmText = '楽曲のBPM';
const String songKeyText = '楽曲の調';
const String songDurationText = '楽曲の長さ';
const String songReleaseDateText = '楽曲リリース日';
const String minuteText = '分';
const String secondText = '秒';
const String releaseDateExampleText = '年/月/日';
const String mailAddressText = 'メールアドレス';
const String passwordText = 'パスワード';
const String signupText = '新規登録します！';
const String loginText = 'ログインする';
const String logoutText = 'ログアウト';
const String loadingText = 'Loading';
const String uploadText = 'アップロード';
const String reloadText = '再読み込みを行う';
const String createPostText = '投稿を作成する';
const String deletePostText = '投稿を削除する';
const String createCommentText = 'コメントを作成';
const String deleteCommentText = 'コメントを削除';
const String createReplyText = 'リプライを作成';
const String deleteReplyText = 'リプライを削除';
const String editProfileText = 'プロフィールを編集する';
const String updateText = '更新する';
const String showMuteUsersText = 'ミュートしているユーザーを表示する';
const String showMuteCommentsText = 'ミュートしているコメントを表示する';
const String showMutePostsText = 'ミュートしている投稿を表示する';
const String showMuteRepliesText = 'ミュートしているリプライを表示する';
const String yesText = 'Yes';
const String noText = 'No';
const String backText = '戻る';
const String muteUserText = 'ユーザーをミュート';
const String muteCommentText = 'コメントをミュート';
const String mutePostText = '投稿をミュート';
const String reportPostText = '投稿を報告';
const String reportCommentText = 'コメントを報告';
const String reportReplyText = 'リプライを報告';
const String muteReplyText = 'リプライをミュート';
const String unMuteUserText = 'ユーザーのミュートを解除';
const String unMuteCommentText = 'コメントのミュートを解除';
const String unMutePostText = '投稿のミュートを解除';
const String unMuteReplyText = 'リプライのミュートを解除';
const String reauthenticateText = '再認証をする';
const String updatePasswordText = 'パスワードをアップデートする';
const String updateEmailText = 'メールアドレスをアップデートするメールを送信';
const String usersText = 'Users';
const String postsText = 'Posts';
// alert message
const String muteUserAlertMsg = 'ユーザーをミュートしますが本当によろしいですか？';
const String muteCommentAlertMsg = 'コメントをミュートしますが本当によろしいですか？';
const String mutePostAlertMsg = '投稿をミュートしますが本当によろしいですか？';
const String muteReplyAlertMsg = 'リプライをミュートしますが本当によろしいですか？';
const String unMuteUserAlertMsg = 'ユーザーのミュートを解除しますが本当によろしいですか？';
const String unMuteCommentAlertMsg = 'コメントのミュートを解除しますが本当によろしいですか？';
const String unMutePostAlertMsg = '投稿のミュートを解除しますが本当によろしいですか？';
const String unMuteReplyAlertMsg = 'リプライのミュートを解除しますが本当によろしいですか？';
const String reauthenticatedMsg= '再認証が完了しました';
// const String requiresRecentLoginMsg= '再認証を行ってください';
const String updatedPasswordMsg= 'パスワードのアップデートが完了しました';
const String maxSearchLengthMsg= '検索できるのは100文字までです';
// name
const String aliceName = 'Alice';
// FieldKey
const String usersFieldKey = 'users';
const String roomsFieldKey = 'rooms';
const String artistsFieldKey = 'artists';
const String songsFieldKey = 'songs';
// message
const String userCreatedMsg = 'ユーザーが作成できました';
const String artistRegisteredMsg = 'アーティストを登録できました';
const String albumRegisteredMsg = 'アルバムが登録できました';
const String songRegisteredMsg = '楽曲を登録できました';
const String noAccountMsg = 'アカウントをお持ちでない場合';
const String emailAlreadyInUseMsg = 'そのメースアドレスは既に使用されています';
const String firebaseAuthEmailOperationNotAllowed = 'Firebaseでemail/passwordが許可されていません';
const String weakPasswordMsg = 'パスワードが弱すぎます';
const String invalidEmailMsg = 'そのメールアドレスはふさわしくありません';
const String wrongPasswordMsg = 'パスワードが違います';
const String userNotFoundMsg = 'そのメールアドレスを使用しているユーザーが見つかりません';
const String userDisabledMsg = 'そのユーザーは無効化されています';
const String userMismaticMsg = '与えたれたクレデンシャルがユーザーに対応していません';
const String invailCredentialMsg = 'プロバイダのクレデンシャルが有効ではありません';
const String emailSendedMsg = 'メールが送信されました';
const String missingAndroidPkgNameMsg = 'Android Pkg Nameがありません';
const String missingIosBundleIdMsg = 'Ios Bandle Idがありません';
const String createdPostMsg = '投稿が完了しました！';
const String pleaseSelectMsg = '形態を選択してください';
const String notEnoughMsg = '情報が足りません。';
const String notSetAlbumMsg = 'アルバムを選択してください。';
const String formatErrorMsg = 'フォーマットを間違えています。';
// prefs key
const String isDarkThemePrefsKey = 'isDarkTheme';
// bottom navigation bar
const String homeText = 'Home';
const String searchText = 'Search';
const String profileText = 'Profile';
const String articleText = 'Article';
const String createText = 'Create';
const String messageText = 'Message';
// radio botann list
const List<String> artistFormTextList = ['solo', 'group', 'band'];
const List<String> albumTypeList = ['album_track', 'single', 'compilation_album'];
const List<String> songKeyList = ['C', 'C# / D♭', 'D', 'D# / E♭', 'E', 'F', 'F# / G♭', 'G', 'G# / A♭', 'A', 'A# / B♭', 'B'];
// check botann list
const List<String> genreTextList = ['J-POP', 'ロック', 'K-POP', 'ボカロ', 'アニソン', 'ポップス', 'ジャズ', 'クラシック', 'R & B', 'メタル', 'ブルース', '演歌', 'EDM', 'その他'];

String returnUuidV4() {
  const Uuid uuid = Uuid();
  return uuid.v4();
}

String returnJpgFileName() => '${returnUuidV4()}.jpg';

String returnMp4FileName() => '${returnUuidV4()}.mp4';

String returnTalkRoomId({required String activeUid, required String passiveUid}) {
  List<String> dictionaryOrderList = [activeUid, passiveUid];
  dictionaryOrderList.sort((a, b) => a.compareTo(b));
  return dictionaryOrderList.join("-");
}

String returnMessageTime({required Message message}) {
  return intel.DateFormat('HH:mm').format(message.createdAt.toDate());
}

String returnMessageDate({required Message message}) {
  DateTime date = message.createdAt.toDate();
  if(date.month >= 1 && date.month <= 9) {
    if(date.day >= 1 && date.day <= 9) {
      return intel.DateFormat('M / d').format(message.createdAt.toDate());
    } else {
      return intel.DateFormat('M / dd').format(message.createdAt.toDate());
    }
  } else {
    if(date.day >= 1 && date.day <= 9) {
      return intel.DateFormat('MM / d').format(message.createdAt.toDate());
    } else {
      return intel.DateFormat('MM / dd').format(message.createdAt.toDate());
    }
  }
}

String updateEmailLagMsg({required String email}) => "$email('更新が反映されるまで時間がかかる可能性がございます)";

String retrunReportContentString({required List<String> selectedReportContents}) {
  String reportContentString = '';
  for(final content in selectedReportContents) {
    reportContentString += '.$content,';  //メールにしたときに見やすいように加工
  }
  return reportContentString;
}

String returnArtistStorageName({required String artistName}) => '$artistName---${returnUuidV4()}';

String returnAlbumStorageName({required String albumName}) => '$albumName---${returnUuidV4()}';

String returnSongStorageName({required String songName}) => '$songName---${returnUuidV4()}';