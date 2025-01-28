// SEEK BAR

// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/material_desktop.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/widgets/fullscreen_inherited_widget.dart';

/// Material design seek bar.
class DSFSeekBar extends StatefulWidget {
  final VoidCallback? onSeekStart;
  final VoidCallback? onSeekEnd;
  final Duration start;
  final Duration end;

  const DSFSeekBar({
    super.key,
    this.onSeekStart,
    this.onSeekEnd,
    required this.start,
    required this.end,
  });

  @override
  DSFSeekBarState createState() => DSFSeekBarState();
}

class DSFSeekBarState extends State<DSFSeekBar> {
  bool hover = false;
  bool click = false;
  double slider = 0.0;

  late bool playing = controller(context).player.state.playing;
  late Duration position = controller(context).player.state.position;
  late Duration duration = controller(context).player.state.duration;
  late Duration buffer = controller(context).player.state.buffer;

  final List<StreamSubscription> subscriptions = [];

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (subscriptions.isEmpty) {
      subscriptions.addAll(
        [
          controller(context).player.stream.playing.listen((event) {
            setState(() {
              playing = event;
            });
          }),
          controller(context).player.stream.completed.listen((event) {
            setState(() {
              position = Duration.zero;
            });
          }),
          controller(context).player.stream.position.listen((event) {
            setState(() {
              if (!click) position = event;
            });
          }),
          controller(context).player.stream.duration.listen((event) {
            final newStartDuration = widget.start;
            final newEndDuration = widget.end;
            final dur = event > newEndDuration
                ? newEndDuration
                : (event < newStartDuration ? newStartDuration : event);
            setState(() {
              duration = dur;
            });
          }),
          controller(context).player.stream.buffer.listen((event) {
            setState(() {
              buffer = event;
            });
          }),
        ],
      );
    }
  }

  @override
  void dispose() {
    for (final subscription in subscriptions) {
      subscription.cancel();
    }
    super.dispose();
  }

  void onPointerMove(PointerMoveEvent e, BoxConstraints constraints) {
    final percent = e.localPosition.dx / constraints.maxWidth;
    setState(() {
      hover = true;
      slider = percent.clamp(0.0, 1.0);
    });
  }

  void onPointerDown() {
    widget.onSeekStart?.call();
    setState(() {
      click = true;
    });
  }

  void onPointerUp() {
    widget.onSeekEnd?.call();
    setState(() {
      click = false;
    });
    final clipAmount = newEndDuration - widget.start;
    final newDur = widget.start + (clipAmount * slider);
    controller(context).player.seek(newDur).then((_) {
      controller(context).player.play();
    });

    setState(() {
      // Explicitly set the position to prevent the slider from jumping.
      position = newDur;
    });
  }

  void onHover(PointerHoverEvent e, BoxConstraints constraints) {
    final percent = e.localPosition.dx / constraints.maxWidth;
    setState(() {
      hover = true;
      slider = percent.clamp(0.0, 1.0);
    });
  }

  void onEnter(PointerEnterEvent e, BoxConstraints constraints) {
    final percent = e.localPosition.dx / constraints.maxWidth;
    setState(() {
      hover = true;
      slider = percent.clamp(0.0, 1.0);
    });
  }

  void onExit(PointerExitEvent e, BoxConstraints constraints) {
    setState(() {
      hover = false;
      slider = 0.0;
    });
  }

  /// Returns the current playback position in percentage.
  double get positionPercent {
    if (position == Duration.zero || duration == Duration.zero) {
      return widget.start.inMilliseconds.toDouble();
    } else {
      final p = position.inMilliseconds;
      final pos = p < widget.start.inMilliseconds
          ? widget.start.inMilliseconds
          : (p > widget.end.inMilliseconds ? widget.end.inMilliseconds : p);

      final val = adjustScale(
        value: pos.toDouble(),
        originalMin: widget.start.inMilliseconds.toDouble(),
        originalMax: widget.end.inMilliseconds.toDouble(),
        newMin: 0,
        newMax: 1,
      );
      return val.clamp(0.0, 1.0);
    }
  }

  Duration get newEndDuration => widget.end;

  /// Returns the current playback buffer position in percentage.
  double get bufferPercent {
    if (buffer == Duration.zero || duration == Duration.zero) {
      return widget.start.inMilliseconds.toDouble();
    } else {
      final p = buffer.inMilliseconds;
      final pos = p < widget.start.inMilliseconds
          ? widget.start.inMilliseconds
          : (p > widget.end.inMilliseconds ? widget.end.inMilliseconds : p);
      final val = adjustScale(
        value: pos.toDouble(),
        originalMin: widget.start.inMilliseconds.toDouble(),
        originalMax: widget.end.inMilliseconds.toDouble(),
        newMin: 0,
        newMax: 1,
      );
      return val.clamp(0.0, 1.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.none,
      margin: _theme(context).seekBarMargin,
      child: LayoutBuilder(
        builder: (context, constraints) => MouseRegion(
          cursor: SystemMouseCursors.click,
          onHover: (e) => onHover(e, constraints),
          onEnter: (e) => onEnter(e, constraints),
          onExit: (e) => onExit(e, constraints),
          child: Listener(
            onPointerMove: (e) => onPointerMove(e, constraints),
            onPointerDown: (e) => onPointerDown(),
            onPointerUp: (e) => onPointerUp(),
            child: Container(
              color: const Color(0x00000000),
              width: constraints.maxWidth,
              height: _theme(context).seekBarContainerHeight,
              child: Stack(
                clipBehavior: Clip.none,
                alignment: Alignment.centerLeft,
                children: [
                  AnimatedContainer(
                    width: constraints.maxWidth,
                    height: hover
                        ? _theme(context).seekBarHoverHeight
                        : _theme(context).seekBarHeight,
                    alignment: Alignment.centerLeft,
                    duration: _theme(context).seekBarThumbTransitionDuration,
                    color: _theme(context).seekBarColor,
                    child: Stack(
                      clipBehavior: Clip.none,
                      alignment: Alignment.centerLeft,
                      children: [
                        Container(
                          width: constraints.maxWidth * slider,
                          color: _theme(context).seekBarHoverColor,
                        ),
                        Container(
                          width: constraints.maxWidth * bufferPercent,
                          color: _theme(context).seekBarBufferColor,
                        ),
                        Container(
                          width: click
                              ? constraints.maxWidth * slider
                              : constraints.maxWidth * positionPercent,
                          color: _theme(context).seekBarPositionColor,
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: click
                        ? (constraints.maxWidth -
                                _theme(context).seekBarThumbSize / 2) *
                            slider
                        : (constraints.maxWidth -
                                _theme(context).seekBarThumbSize / 2) *
                            positionPercent,
                    child: AnimatedContainer(
                      width: hover || click
                          ? _theme(context).seekBarThumbSize
                          : 0.0,
                      height: hover || click
                          ? _theme(context).seekBarThumbSize
                          : 0.0,
                      duration: _theme(context).seekBarThumbTransitionDuration,
                      decoration: BoxDecoration(
                        color: _theme(context).seekBarThumbColor,
                        borderRadius: BorderRadius.circular(
                          _theme(context).seekBarThumbSize / 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
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

double adjustScale(
    {required double value, // The value in the original scale to be converted
    required double originalMin, // Minimum value of the original scale
    required double originalMax, // Maximum value of the original scale
    required double newMin, // Minimum value of the new scale
    required double newMax // Maximum value of the new scale
    }) {
  // Step 1: Normalize the value in the original scale (0 to 1)
  double normalizedValue = (value - originalMin) / (originalMax - originalMin);

  // Step 2: Map the normalized value to the new scale
  double newValue = normalizedValue * (newMax - newMin) + newMin;

  return newValue;
}
