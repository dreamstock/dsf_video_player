import 'package:flutter/material.dart';
import 'package:player_source_models/models/spreedsheet/clips/spotlight.dart';

class SpotlightWidget extends StatefulWidget {
  const SpotlightWidget({
    super.key,
    required this.constraints,
    required this.spotlight,
  });
  final Spotlight spotlight;
  final BoxConstraints constraints;

  @override
  State<SpotlightWidget> createState() => _SpotlightWidgetState();
}

class _SpotlightWidgetState extends State<SpotlightWidget> {
  late final ValueNotifier<bool> isBigVN;
  @override
  void initState() {
    super.initState();
    isBigVN = ValueNotifier(true);
    Future.delayed(
      const Duration(milliseconds: 40),
      () {
        if (mounted) {
          isBigVN.value = false;
        }
      },
    );
  }

  @override
  void dispose() {
    isBigVN.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColorFiltered(
      colorFilter: ColorFilter.mode(
        Colors.black.withOpacity(0.72),
        BlendMode.srcOut,
      ), // This one will create the magic
      child: Stack(
        // clipBehavior: Clip.none,
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              color: Colors.black,
              backgroundBlendMode: BlendMode.dstOut,
            ),
          ),
          Align(
            alignment: Alignment(widget.spotlight.x, widget.spotlight.y),
            child: ValueListenableBuilder(
              valueListenable: isBigVN,
              builder: (context, isBig, child) {
                final circleAvatarSize = widget.constraints.maxWidth * 0.1;
                return AnimatedScale(
                  scale: isBig ? 11 : 1,
                  duration: const Duration(
                    milliseconds: 350,
                  ),
                  child: SizedBox(
                    height: circleAvatarSize,
                    width: circleAvatarSize,
                    // height: circleAvatarSize,
                    // width: circleAvatarSize,
                    child: const CircleAvatar(
                      backgroundColor: Colors.amber,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
