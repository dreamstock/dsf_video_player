import 'dart:async';

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/extensions/duration.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/material_desktop.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/methods/video_state.dart';
import 'package:media_kit_video/media_kit_video_controls/src/controls/widgets/fullscreen_inherited_widget.dart';

/// MaterialDesktop design position indicator.
class CustomDSFPositionIndicator extends StatefulWidget {
  /// Overriden [TextStyle] for the [CustomDSFPositionIndicator].
  final TextStyle? style;
  final Duration? start;
  final Duration? end;
  const CustomDSFPositionIndicator({
    super.key,
    this.style,
    this.end,
    this.start,
  });

  @override
  CustomDSFPositionIndicatorState createState() =>
      CustomDSFPositionIndicatorState();
}

class CustomDSFPositionIndicatorState
    extends State<CustomDSFPositionIndicator> {
  late Duration duration = controller(context).player.state.duration;

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
          // controller(context).player.stream.position.listen((event) {
          //   setState(() {
          //     position = event;
          //   });
          // }),
          controller(context).player.stream.duration.listen((event) {
            setState(() {
              duration = event;
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

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: controller(context).player.stream.position,
        builder: (context, snapshot) {
          final p = snapshot.data;
          if (p == null) {
            return Container();
          }

          final pos = p - (widget.start ?? const Duration());

          final totalDur = (widget.end != null && widget.start != null
              ? (widget.end! - widget.start!)
              : duration);

          return Text(
            '${pos.label(reference: totalDur)} / ${totalDur.label(reference: totalDur)}',
            style: widget.style ??
                TextStyle(
                  height: 1.0,
                  fontSize: 12.0,
                  color: _theme(context).buttonBarButtonColor,
                ),
          );
        });
  }
}

MaterialDesktopVideoControlsThemeData _theme(BuildContext context) =>
    FullscreenInheritedWidget.maybeOf(context) == null
        ? MaterialDesktopVideoControlsTheme.maybeOf(context)?.normal ??
            kDefaultMaterialDesktopVideoControlsThemeData
        : MaterialDesktopVideoControlsTheme.maybeOf(context)?.fullscreen ??
            kDefaultMaterialDesktopVideoControlsThemeDataFullscreen;
