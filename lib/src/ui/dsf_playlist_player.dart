import 'dart:async';
import 'package:dsf_video_player/src/models/frame_payload.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';



class DsfPlaylistPlayer extends StatefulWidget {
  final PlaylistCluster payload;

  const DsfPlaylistPlayer({
    super.key,
    required this.payload,
  });

  @override
  State<DsfPlaylistPlayer> createState() => _DsfPlaylistPlayerState();
}

// Will tween opacity between two players, the current playing one will be visible
// and the other will be loading in the background, with opacity 0.0.
class _DsfPlaylistPlayerState extends State<DsfPlaylistPlayer> {
  late final FramePayloadController frame1;
  late final FramePayloadController frame2;

  @override
  void initState() {
    super.initState();
    final curr = widget.payload.current;
    frame1 = FramePayloadController.initialize(
      payload: curr,
    );
    frame1 = FramePayloadController.initialize(
      payload: widget.payload.next,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SizedBox(
          width: constraints.maxWidth,
          height: constraints.maxWidth * 9.0 / 16.0,
          child: 
        );
      },
    );
  }
}
