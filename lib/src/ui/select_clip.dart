import 'package:dio/dio.dart';
import 'package:dsf_video_player/src/logic/switch_frames_controller.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:dsf_video_player/src/ui/video_select_components/video_display_tile.dart';
import 'package:dsf_video_player/src/ui/video_select_components/video_group_button.dart';
import 'package:enchanted_collection/enchanted_collection.dart';
import 'package:flutter/material.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class SelectClip extends StatefulWidget {
  final SwitchFramesController controller;
  const SelectClip({super.key, required this.controller});

  @override
  State<SelectClip> createState() => _SelectClipState();
}

class _SelectClipState extends State<SelectClip> {
  late final ScrollController _scrollController;
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final yt = YoutubeExplode();
    final dio = Dio();

    return ValueListenableBuilder(
        valueListenable: widget.controller.payload,
        builder: (context, data, _) {
          final selectedPayloadEntry = data.selectedGroupName;

          return ListView(
            controller: _scrollController,
            children: [
              if (data.payload.keys.length > 1) ...[
                Text(
                  'Other Video Groups:',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 6),
                ...data.payload.keys.splitIntoGroups(2).map(
                      (group) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: group
                              .map((GroupName name) {
                                final isSelected = name == selectedPayloadEntry;
                                return VideoGroupButton(
                                  groupName: name,
                                  isSelected: isSelected,
                                  onTap: () {
                                    widget.controller.selectGroup(name);
                                  },
                                );
                              })
                              .toList()
                              .addBetween(
                                const SizedBox(width: 12),
                              ),
                        ),
                      ),
                    ),
              ],
              Text(
                'Videos:',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 6),
              ...data.payload[selectedPayloadEntry]!.map(
                (VideosEntryPayload videoPayload) {
                  return VideoDisplayTile(
                    dio: dio,
                    yt: yt,
                    data: videoPayload,
                    isSelected: videoPayload.clipUuid == data.selectedClipUuid,
                    onTap: () {
                      widget.controller.selectClip(videoPayload.clipUuid);
                    },
                  );
                },
              ),
            ],
          );
        });
  }
}

extension on List<Widget> {
  List<Widget> addBetween(Widget child) {
    final List<Widget> result = [];
    for (var i = 0; i < length; i++) {
      result.add(this[i]);
      if (i != length - 1) {
        result.add(child);
      }
    }
    return result;
  }
}
