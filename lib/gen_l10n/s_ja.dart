// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class SJa extends S {
  SJa([String locale = 'ja']) : super(locale);

  @override
  String get video_groups => '動画グループ：';

  @override
  String get videos => '動画：';

  @override
  String get weak => '未成功';

  @override
  String get weak_description => 'こちらは、未成功のアクション動画です';

  @override
  String get loading => '読み込み中...';
}
