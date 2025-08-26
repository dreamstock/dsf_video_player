// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 's.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class SKo extends S {
  SKo([String locale = 'ko']) : super(locale);

  @override
  String get video_groups => '비디오 그룹';

  @override
  String get videos => '비디오';

  @override
  String get weak => '실패';

  @override
  String get new_tag => 'NEW';

  @override
  String get new_tag_description => '이 비디오는 새로 생성된 비디오입니다';

  @override
  String get weak_description => '이 비디오는 실패한 액션 장면입니다';

  @override
  String get loading => '로딩 중...';
}
