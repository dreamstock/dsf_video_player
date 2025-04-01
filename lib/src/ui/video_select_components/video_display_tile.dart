// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:player_source_models/models/player_label.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class VideoDisplayTile extends StatelessWidget {
  final bool isSelected;
  final YoutubeExplode yt;
  final Dio dio;
  final VideosEntryPayload data;
  final void Function()? onTap;
  final bool haveButtons;
  const VideoDisplayTile({
    super.key,
    required this.isSelected,
    required this.data,
    required this.yt,
    required this.dio,
    this.onTap,
    this.haveButtons = true,
  });

  @override
  Widget build(BuildContext context) {
    final videoUrl = data.videoUrl;
    final title = data.title;
    final description = data.description;
    final matchInfo = data.matchInfos;
    // final match
    final isYoutube = videoUrl.contains('youtube') == true;

    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color.fromARGB(66, 187, 53, 0)
                // ? const Color(0xFF1E1D1D).withOpacity(0.8)
                : const Color(0xFF1E1D1D).withOpacity(0.5),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFFF4A01).withOpacity(0.4)
                  : const Color(0xFF1E1D1D).withOpacity(0.8),
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: FutureBuilder(future: () async {
            if (!isYoutube) return null;
            return yt.videos.get(videoUrl);
          }(), builder: (context, snapshot) {
            final youtubeData = snapshot.data;
            final isLoading = snapshot.connectionState != ConnectionState.done;

            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: SizedBox(
                      height: 52,
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Builder(builder: (context) {
                          final String tumb;
                          if (youtubeData != null) {
                            tumb = youtubeData.thumbnails.highResUrl;
                          } else {
                            tumb = data.tumbnail ?? '';
                          }

                          if (tumb.isEmpty) {
                            if (isLoading) {
                              return const Center(
                                child: Icon(Icons.insert_photo_rounded),
                              );
                            }

                            return const Center(
                              child: Text('Loading...'),
                            );
                          }

                          return Image.network(
                            tumb,
                            fit: BoxFit.cover,
                            loadingBuilder: _hangleImageLoading,
                            errorBuilder: _handleImageError,
                          );
                        }),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Wrap(
                          children: [
                            Text(
                              isYoutube
                                  ? (isLoading
                                      ? 'Loading...'
                                      : (youtubeData?.title ?? title))
                                  : title,
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : Colors.grey[300],
                                fontSize: 15,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w300,
                              ),
                              maxLines: 2,
                            ),
                            if (data.isWeakness == true)
                              const Padding(
                                padding: EdgeInsets.all(4.0),
                                child: LabelWidget(
                                  title: "WEAK",
                                  message: "This is a weak video",
                                  color: Colors.white,
                                  backgroundColor: Colors.cyan,
                                ),
                              ),
                          ],
                        ),
                        if (youtubeData != null)
                          Text(
                            /// Max of 60 caracters
                            '${youtubeData.description.replaceAll('\n', '').substring(
                                  0,
                                  youtubeData.description
                                              .replaceAll('\n', '')
                                              .length >
                                          60
                                      ? 60
                                      : null,
                                )}...',
                            // title,
                            style: TextStyle(
                              color: Colors.grey[500],
                              fontSize: 12,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w300,
                            ),
                            maxLines: 2,
                          ),
                        if (youtubeData == null &&
                            description != null &&
                            description.isNotEmpty)
                          FittedBox(
                            child: Text(
                              description,
                              // title,
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 12,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.w300,
                              ),
                            ),
                          ),
                        if (matchInfo != null) ...[
                          Text(
                            matchInfo.date.namedDisplayDate,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 13,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  if (haveButtons) ...[
                    Tooltip(
                      message: 'Download clip',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () async {
                          try {
                            await EasyLoading.show(status: 'Downloading...');
                            final fileName =
                                'video_clip_${const Uuid().v4().split('-').first}.mp4';
                            final String? outputFile =
                                await FilePicker.platform.saveFile(
                              dialogTitle: 'Please select an output file:',
                              fileName: fileName,
                            );

                            await dio.download(
                              videoUrl,
                              outputFile,
                              onReceiveProgress: (received, total) {
                                final progress = received / total;
                                EasyLoading.showProgress(progress);
                              },
                            );
                            await Future.delayed(
                              const Duration(milliseconds: 700),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                duration: const Duration(milliseconds: 800),
                                backgroundColor: Colors.green[400],
                                content: Text(
                                  'Clip downloaded',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            );
                            await EasyLoading.dismiss();
                          } catch (e, s) {
                            debugPrint('Error: $e\n$s');
                            await EasyLoading.dismiss();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                                content: Text(
                                  'Error downloading clip',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.onError,
                                  ),
                                ),
                              ),
                            );
                          }
                        },
                        child: Icon(
                          Icons.download,
                          size: 28,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                    const SizedBox(width: 20),
                    Tooltip(
                      message: 'Open in browser',
                      child: InkWell(
                        borderRadius: BorderRadius.circular(30),
                        onTap: () {
                          launchUrl(Uri.parse(videoUrl));
                        },
                        child: Icon(
                          Icons.open_in_new,
                          size: 28,
                          color: Colors.grey[400],
                        ),
                      ),
                    ),
                  ] else ...[
                    Icon(
                      Icons.open_in_new,
                      size: 28,
                      color: Colors.grey[400],
                    ),
                  ],
                  const SizedBox(width: 20),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

Widget _hangleImageLoading(
  BuildContext context,
  Widget child,
  ImageChunkEvent? loadingProgress,
) {
  final expectedTotalBytes = loadingProgress?.expectedTotalBytes;
  final cumulativeBytesLoaded = loadingProgress?.cumulativeBytesLoaded;

  if (loadingProgress == null ||
      expectedTotalBytes == null ||
      cumulativeBytesLoaded == null) {
    return child;
  }

  final isCompleted = cumulativeBytesLoaded == expectedTotalBytes;

  if (isCompleted) {
    return child;
  }

  return Center(
    child: SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        value: cumulativeBytesLoaded / expectedTotalBytes,
      ),
    ),
  );
}

Widget _handleImageError(
  BuildContext context,
  Object error,
  StackTrace? stackTrace,
) {
  return const SizedBox.expand(
    child: Center(
      child: Icon(Icons.error),
    ),
  );
}

extension DateTimeExt on DateTime {
  String get namedDisplayDate {
    final month = _EMonth.fromDateTime(this);

    return '$day of ${month.name}, $year';
  }
}

enum _EMonth {
  january,
  february,
  march,
  april,
  may,
  june,
  july,
  august,
  september,
  october,
  november,
  december;

  _EMonth get previousMonth {
    switch (this) {
      case _EMonth.january:
        return _EMonth.december;
      case _EMonth.february:
        return _EMonth.january;
      case _EMonth.march:
        return _EMonth.february;
      case _EMonth.april:
        return _EMonth.march;
      case _EMonth.may:
        return _EMonth.april;
      case _EMonth.june:
        return _EMonth.may;
      case _EMonth.july:
        return _EMonth.june;
      case _EMonth.august:
        return _EMonth.july;
      case _EMonth.september:
        return _EMonth.august;
      case _EMonth.october:
        return _EMonth.september;
      case _EMonth.november:
        return _EMonth.october;
      case _EMonth.december:
        return _EMonth.november;
    }
  }

  int get number => index + 1;

  static _EMonth fromDateTime(DateTime time) {
    return switch (time.month) {
      DateTime.january => _EMonth.january,
      DateTime.february => _EMonth.february,
      DateTime.march => _EMonth.march,
      DateTime.april => _EMonth.april,
      DateTime.may => _EMonth.may,
      DateTime.june => _EMonth.june,
      DateTime.july => _EMonth.july,
      DateTime.august => _EMonth.august,
      DateTime.september => _EMonth.september,
      DateTime.october => _EMonth.october,
      DateTime.november => _EMonth.november,
      DateTime.december => _EMonth.december,
      int() => throw UnimplementedError(),
    };
  }

  String get shortName {
    return switch (this) {
      _EMonth.january => 'Jan',
      _EMonth.february => 'Feb',
      _EMonth.march => 'Mar',
      _EMonth.april => 'Apr',
      _EMonth.may => 'May',
      _EMonth.june => 'Jun',
      _EMonth.july => 'Jul',
      _EMonth.august => 'Aug',
      _EMonth.september => 'Sep',
      _EMonth.october => 'Oct',
      _EMonth.november => 'Nov',
      _EMonth.december => 'Dec',
    };
  }
}
