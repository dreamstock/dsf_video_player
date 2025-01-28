import 'package:dsf_video_player/src/models/videos_entry_payload.dart';
import 'package:flutter/material.dart';

class VideoDisplayTile extends StatelessWidget {
  final bool isSelected;
  final VideosEntryPayload data;
  final void Function() onTap;
  const VideoDisplayTile(
      {super.key,
      required this.isSelected,
      required this.data,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    // final isYoutube = videoUrl?.contains('youtube') == true;
    return InkWell(
      onTap: onTap,
      child: AnimatedContainer(
        margin: const EdgeInsets.symmetric(horizontal: 4),
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
        child: Row(
          children: [
            const SizedBox(width: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 52,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Builder(builder: (context) {
                    final tumb = data.tumbnail;
                    if (tumb == null) {
                      return const Center(
                        child: Icon(Icons.error),
                      );
                    }

                    return Image.network(
                      tumb,
                      loadingBuilder: _hangleImageLoading,
                      errorBuilder: _handleImageError,
                    );
                  }),
                ),
              ),
            ),
            const SizedBox(width: 12),
          ],
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
