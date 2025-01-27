// BUTTON: PLAY/PAUSE

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/material_desktop.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/widgets/fullscreen_inherited_widget.dart';

/// A material design play/pause button.
class CustomDSFPlayOrPauseButton extends StatefulWidget {
  final Player player;
  final Duration startDuration;
  final Duration maxDuration;

  /// Overriden icon size for [MaterialDesktopSkipPreviousButton].
  final double? iconSize;

  /// Overriden icon color for [MaterialDesktopSkipPreviousButton].
  final Color? iconColor;

  const CustomDSFPlayOrPauseButton({
    super.key,
    required this.player,
    required this.startDuration,
    required this.maxDuration,
    this.iconSize,
    this.iconColor,
  });

  @override
  CustomDSFPlayOrPauseButtonState createState() =>
      CustomDSFPlayOrPauseButtonState();
}

class CustomDSFPlayOrPauseButtonState extends State<CustomDSFPlayOrPauseButton>
    with SingleTickerProviderStateMixin {
  late final animation = AnimationController(
    vsync: this,
    value: widget.player.state.playing ? 1 : 0,
    duration: const Duration(milliseconds: 200),
  );

  StreamSubscription<bool>? subscription;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    subscription ??= widget.player.stream.playing.listen((event) {
      if (event) {
        animation.forward();
      } else {
        animation.reverse();
      }
    });
  }

  @override
  void dispose() {
    animation.dispose();
    subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        final currDur = widget.player.state.position;
        final didPassMax =
            widget.maxDuration.inMilliseconds <= currDur.inMilliseconds;

        if (didPassMax) {
          widget.player.seek(widget.startDuration).then(
            (_) {
              Future.delayed(const Duration(milliseconds: 200), () {
                widget.player.play();
              });
            },
          );
        } else {
          widget.player.playOrPause();
        }
      },
      iconSize: widget.iconSize ?? _theme(context).buttonBarButtonSize,
      color: widget.iconColor ?? _theme(context).buttonBarButtonColor,
      icon: AnimatedIcon(
        progress: animation,
        icon: AnimatedIcons.play_pause,
        size: widget.iconSize ?? _theme(context).buttonBarButtonSize,
        color: widget.iconColor ?? _theme(context).buttonBarButtonColor,
      ),
    );
  }
}

MaterialDesktopVideoControlsThemeData _theme(BuildContext context) =>
    FullscreenInheritedWidget.maybeOf(context) == null
        ? MaterialDesktopVideoControlsTheme.maybeOf(context)?.normal ??
            kDefaultMaterialDesktopVideoControlsThemeData
        : MaterialDesktopVideoControlsTheme.maybeOf(context)?.fullscreen ??
            kDefaultMaterialDesktopVideoControlsThemeDataFullscreen;
