import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';

class ImageHandler extends StatelessWidget {
  const ImageHandler({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InstaImageViewer(
      child: FastCachedImage(
        url: imageUrl,
        color: Colors.white,
        colorBlendMode: BlendMode.dstOver,
        fit: BoxFit.contain,
        errorBuilder: (context, exception, stacktrace) {
          return Text(stacktrace.toString());
        },
        loadingBuilder: (context, progress) {
          return Center(
            child: SizedBox(
              height: 50,
              width: 50,
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                value: progress.progressPercentage.value,
              ),
            ),
          );
        },
      ),
    );
  }
}
