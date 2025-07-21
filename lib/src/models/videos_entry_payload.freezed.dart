// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'videos_entry_payload.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PlaylistCluster _$PlaylistClusterFromJson(Map<String, dynamic> json) {
  return _PlaylistCluster.fromJson(json);
}

/// @nodoc
mixin _$PlaylistCluster {
  String get selectedClipUuid => throw _privateConstructorUsedError;
  Map<String, List<VideosEntryPayload>> get payload =>
      throw _privateConstructorUsedError;
  String? get playerUuid => throw _privateConstructorUsedError;

  /// Serializes this PlaylistCluster to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of PlaylistCluster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $PlaylistClusterCopyWith<PlaylistCluster> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlaylistClusterCopyWith<$Res> {
  factory $PlaylistClusterCopyWith(
          PlaylistCluster value, $Res Function(PlaylistCluster) then) =
      _$PlaylistClusterCopyWithImpl<$Res, PlaylistCluster>;
  @useResult
  $Res call(
      {String selectedClipUuid,
      Map<String, List<VideosEntryPayload>> payload,
      String? playerUuid});
}

/// @nodoc
class _$PlaylistClusterCopyWithImpl<$Res, $Val extends PlaylistCluster>
    implements $PlaylistClusterCopyWith<$Res> {
  _$PlaylistClusterCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of PlaylistCluster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedClipUuid = null,
    Object? payload = null,
    Object? playerUuid = freezed,
  }) {
    return _then(_value.copyWith(
      selectedClipUuid: null == selectedClipUuid
          ? _value.selectedClipUuid
          : selectedClipUuid // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value.payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, List<VideosEntryPayload>>,
      playerUuid: freezed == playerUuid
          ? _value.playerUuid
          : playerUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PlaylistClusterImplCopyWith<$Res>
    implements $PlaylistClusterCopyWith<$Res> {
  factory _$$PlaylistClusterImplCopyWith(_$PlaylistClusterImpl value,
          $Res Function(_$PlaylistClusterImpl) then) =
      __$$PlaylistClusterImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String selectedClipUuid,
      Map<String, List<VideosEntryPayload>> payload,
      String? playerUuid});
}

/// @nodoc
class __$$PlaylistClusterImplCopyWithImpl<$Res>
    extends _$PlaylistClusterCopyWithImpl<$Res, _$PlaylistClusterImpl>
    implements _$$PlaylistClusterImplCopyWith<$Res> {
  __$$PlaylistClusterImplCopyWithImpl(
      _$PlaylistClusterImpl _value, $Res Function(_$PlaylistClusterImpl) _then)
      : super(_value, _then);

  /// Create a copy of PlaylistCluster
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? selectedClipUuid = null,
    Object? payload = null,
    Object? playerUuid = freezed,
  }) {
    return _then(_$PlaylistClusterImpl(
      selectedClipUuid: null == selectedClipUuid
          ? _value.selectedClipUuid
          : selectedClipUuid // ignore: cast_nullable_to_non_nullable
              as String,
      payload: null == payload
          ? _value._payload
          : payload // ignore: cast_nullable_to_non_nullable
              as Map<String, List<VideosEntryPayload>>,
      playerUuid: freezed == playerUuid
          ? _value.playerUuid
          : playerUuid // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PlaylistClusterImpl extends _PlaylistCluster {
  _$PlaylistClusterImpl(
      {required this.selectedClipUuid,
      required final Map<String, List<VideosEntryPayload>> payload,
      this.playerUuid})
      : _payload = payload,
        super._();

  factory _$PlaylistClusterImpl.fromJson(Map<String, dynamic> json) =>
      _$$PlaylistClusterImplFromJson(json);

  @override
  final String selectedClipUuid;
  final Map<String, List<VideosEntryPayload>> _payload;
  @override
  Map<String, List<VideosEntryPayload>> get payload {
    if (_payload is EqualUnmodifiableMapView) return _payload;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_payload);
  }

  @override
  final String? playerUuid;

  @override
  String toString() {
    return 'PlaylistCluster(selectedClipUuid: $selectedClipUuid, payload: $payload, playerUuid: $playerUuid)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PlaylistClusterImpl &&
            (identical(other.selectedClipUuid, selectedClipUuid) ||
                other.selectedClipUuid == selectedClipUuid) &&
            const DeepCollectionEquality().equals(other._payload, _payload) &&
            (identical(other.playerUuid, playerUuid) ||
                other.playerUuid == playerUuid));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, selectedClipUuid,
      const DeepCollectionEquality().hash(_payload), playerUuid);

  /// Create a copy of PlaylistCluster
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$PlaylistClusterImplCopyWith<_$PlaylistClusterImpl> get copyWith =>
      __$$PlaylistClusterImplCopyWithImpl<_$PlaylistClusterImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PlaylistClusterImplToJson(
      this,
    );
  }
}

abstract class _PlaylistCluster extends PlaylistCluster {
  factory _PlaylistCluster(
      {required final String selectedClipUuid,
      required final Map<String, List<VideosEntryPayload>> payload,
      final String? playerUuid}) = _$PlaylistClusterImpl;
  _PlaylistCluster._() : super._();

  factory _PlaylistCluster.fromJson(Map<String, dynamic> json) =
      _$PlaylistClusterImpl.fromJson;

  @override
  String get selectedClipUuid;
  @override
  Map<String, List<VideosEntryPayload>> get payload;
  @override
  String? get playerUuid;

  /// Create a copy of PlaylistCluster
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$PlaylistClusterImplCopyWith<_$PlaylistClusterImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

VideosEntryPayload _$VideosEntryPayloadFromJson(Map<String, dynamic> json) {
  return _VideosEntryPayload.fromJson(json);
}

/// @nodoc
mixin _$VideosEntryPayload {
  String get title => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  MatchInfos? get matchInfos => throw _privateConstructorUsedError;
  String get videoUrl => throw _privateConstructorUsedError;
  String? get tumbnail => throw _privateConstructorUsedError;
  ClipOffset? get offset => throw _privateConstructorUsedError;
  String get clipUuid => throw _privateConstructorUsedError;
  Spotlight? get spotlight => throw _privateConstructorUsedError;
  bool? get isWeakness => throw _privateConstructorUsedError;

  /// Serializes this VideosEntryPayload to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of VideosEntryPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $VideosEntryPayloadCopyWith<VideosEntryPayload> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $VideosEntryPayloadCopyWith<$Res> {
  factory $VideosEntryPayloadCopyWith(
          VideosEntryPayload value, $Res Function(VideosEntryPayload) then) =
      _$VideosEntryPayloadCopyWithImpl<$Res, VideosEntryPayload>;
  @useResult
  $Res call(
      {String title,
      String? description,
      MatchInfos? matchInfos,
      String videoUrl,
      String? tumbnail,
      ClipOffset? offset,
      String clipUuid,
      Spotlight? spotlight,
      bool? isWeakness});

  $MatchInfosCopyWith<$Res>? get matchInfos;
  $ClipOffsetCopyWith<$Res>? get offset;
  $SpotlightCopyWith<$Res>? get spotlight;
}

/// @nodoc
class _$VideosEntryPayloadCopyWithImpl<$Res, $Val extends VideosEntryPayload>
    implements $VideosEntryPayloadCopyWith<$Res> {
  _$VideosEntryPayloadCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of VideosEntryPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? matchInfos = freezed,
    Object? videoUrl = null,
    Object? tumbnail = freezed,
    Object? offset = freezed,
    Object? clipUuid = null,
    Object? spotlight = freezed,
    Object? isWeakness = freezed,
  }) {
    return _then(_value.copyWith(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      matchInfos: freezed == matchInfos
          ? _value.matchInfos
          : matchInfos // ignore: cast_nullable_to_non_nullable
              as MatchInfos?,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      tumbnail: freezed == tumbnail
          ? _value.tumbnail
          : tumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as ClipOffset?,
      clipUuid: null == clipUuid
          ? _value.clipUuid
          : clipUuid // ignore: cast_nullable_to_non_nullable
              as String,
      spotlight: freezed == spotlight
          ? _value.spotlight
          : spotlight // ignore: cast_nullable_to_non_nullable
              as Spotlight?,
      isWeakness: freezed == isWeakness
          ? _value.isWeakness
          : isWeakness // ignore: cast_nullable_to_non_nullable
              as bool?,
    ) as $Val);
  }

  /// Create a copy of VideosEntryPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MatchInfosCopyWith<$Res>? get matchInfos {
    if (_value.matchInfos == null) {
      return null;
    }

    return $MatchInfosCopyWith<$Res>(_value.matchInfos!, (value) {
      return _then(_value.copyWith(matchInfos: value) as $Val);
    });
  }

  /// Create a copy of VideosEntryPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ClipOffsetCopyWith<$Res>? get offset {
    if (_value.offset == null) {
      return null;
    }

    return $ClipOffsetCopyWith<$Res>(_value.offset!, (value) {
      return _then(_value.copyWith(offset: value) as $Val);
    });
  }

  /// Create a copy of VideosEntryPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $SpotlightCopyWith<$Res>? get spotlight {
    if (_value.spotlight == null) {
      return null;
    }

    return $SpotlightCopyWith<$Res>(_value.spotlight!, (value) {
      return _then(_value.copyWith(spotlight: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$VideosEntryPayloadImplCopyWith<$Res>
    implements $VideosEntryPayloadCopyWith<$Res> {
  factory _$$VideosEntryPayloadImplCopyWith(_$VideosEntryPayloadImpl value,
          $Res Function(_$VideosEntryPayloadImpl) then) =
      __$$VideosEntryPayloadImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String title,
      String? description,
      MatchInfos? matchInfos,
      String videoUrl,
      String? tumbnail,
      ClipOffset? offset,
      String clipUuid,
      Spotlight? spotlight,
      bool? isWeakness});

  @override
  $MatchInfosCopyWith<$Res>? get matchInfos;
  @override
  $ClipOffsetCopyWith<$Res>? get offset;
  @override
  $SpotlightCopyWith<$Res>? get spotlight;
}

/// @nodoc
class __$$VideosEntryPayloadImplCopyWithImpl<$Res>
    extends _$VideosEntryPayloadCopyWithImpl<$Res, _$VideosEntryPayloadImpl>
    implements _$$VideosEntryPayloadImplCopyWith<$Res> {
  __$$VideosEntryPayloadImplCopyWithImpl(_$VideosEntryPayloadImpl _value,
      $Res Function(_$VideosEntryPayloadImpl) _then)
      : super(_value, _then);

  /// Create a copy of VideosEntryPayload
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? title = null,
    Object? description = freezed,
    Object? matchInfos = freezed,
    Object? videoUrl = null,
    Object? tumbnail = freezed,
    Object? offset = freezed,
    Object? clipUuid = null,
    Object? spotlight = freezed,
    Object? isWeakness = freezed,
  }) {
    return _then(_$VideosEntryPayloadImpl(
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      matchInfos: freezed == matchInfos
          ? _value.matchInfos
          : matchInfos // ignore: cast_nullable_to_non_nullable
              as MatchInfos?,
      videoUrl: null == videoUrl
          ? _value.videoUrl
          : videoUrl // ignore: cast_nullable_to_non_nullable
              as String,
      tumbnail: freezed == tumbnail
          ? _value.tumbnail
          : tumbnail // ignore: cast_nullable_to_non_nullable
              as String?,
      offset: freezed == offset
          ? _value.offset
          : offset // ignore: cast_nullable_to_non_nullable
              as ClipOffset?,
      clipUuid: null == clipUuid
          ? _value.clipUuid
          : clipUuid // ignore: cast_nullable_to_non_nullable
              as String,
      spotlight: freezed == spotlight
          ? _value.spotlight
          : spotlight // ignore: cast_nullable_to_non_nullable
              as Spotlight?,
      isWeakness: freezed == isWeakness
          ? _value.isWeakness
          : isWeakness // ignore: cast_nullable_to_non_nullable
              as bool?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$VideosEntryPayloadImpl implements _VideosEntryPayload {
  _$VideosEntryPayloadImpl(
      {required this.title,
      required this.description,
      required this.matchInfos,
      required this.videoUrl,
      required this.tumbnail,
      required this.offset,
      required this.clipUuid,
      required this.spotlight,
      required this.isWeakness});

  factory _$VideosEntryPayloadImpl.fromJson(Map<String, dynamic> json) =>
      _$$VideosEntryPayloadImplFromJson(json);

  @override
  final String title;
  @override
  final String? description;
  @override
  final MatchInfos? matchInfos;
  @override
  final String videoUrl;
  @override
  final String? tumbnail;
  @override
  final ClipOffset? offset;
  @override
  final String clipUuid;
  @override
  final Spotlight? spotlight;
  @override
  final bool? isWeakness;

  @override
  String toString() {
    return 'VideosEntryPayload(title: $title, description: $description, matchInfos: $matchInfos, videoUrl: $videoUrl, tumbnail: $tumbnail, offset: $offset, clipUuid: $clipUuid, spotlight: $spotlight, isWeakness: $isWeakness)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$VideosEntryPayloadImpl &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.matchInfos, matchInfos) ||
                other.matchInfos == matchInfos) &&
            (identical(other.videoUrl, videoUrl) ||
                other.videoUrl == videoUrl) &&
            (identical(other.tumbnail, tumbnail) ||
                other.tumbnail == tumbnail) &&
            (identical(other.offset, offset) || other.offset == offset) &&
            (identical(other.clipUuid, clipUuid) ||
                other.clipUuid == clipUuid) &&
            (identical(other.spotlight, spotlight) ||
                other.spotlight == spotlight) &&
            (identical(other.isWeakness, isWeakness) ||
                other.isWeakness == isWeakness));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, title, description, matchInfos,
      videoUrl, tumbnail, offset, clipUuid, spotlight, isWeakness);

  /// Create a copy of VideosEntryPayload
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$VideosEntryPayloadImplCopyWith<_$VideosEntryPayloadImpl> get copyWith =>
      __$$VideosEntryPayloadImplCopyWithImpl<_$VideosEntryPayloadImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$VideosEntryPayloadImplToJson(
      this,
    );
  }
}

abstract class _VideosEntryPayload implements VideosEntryPayload {
  factory _VideosEntryPayload(
      {required final String title,
      required final String? description,
      required final MatchInfos? matchInfos,
      required final String videoUrl,
      required final String? tumbnail,
      required final ClipOffset? offset,
      required final String clipUuid,
      required final Spotlight? spotlight,
      required final bool? isWeakness}) = _$VideosEntryPayloadImpl;

  factory _VideosEntryPayload.fromJson(Map<String, dynamic> json) =
      _$VideosEntryPayloadImpl.fromJson;

  @override
  String get title;
  @override
  String? get description;
  @override
  MatchInfos? get matchInfos;
  @override
  String get videoUrl;
  @override
  String? get tumbnail;
  @override
  ClipOffset? get offset;
  @override
  String get clipUuid;
  @override
  Spotlight? get spotlight;
  @override
  bool? get isWeakness;

  /// Create a copy of VideosEntryPayload
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$VideosEntryPayloadImplCopyWith<_$VideosEntryPayloadImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
