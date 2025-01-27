import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class LoadingBufferComponent extends StatelessWidget {
  const LoadingBufferComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.sizeOf(context).width > 899 ? 200 : 140;

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: SvgPicture.asset(
              'asset/dsf.svg',
              width: size,
              height: size,
            ),
          ),
          Text(
            'Loading...',
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontStyle: FontStyle.italic,
                ),
          ),
          Text(
            '( this first loading may take a while )',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                ),
          ),
        ],
      ),
    );
  }
}
