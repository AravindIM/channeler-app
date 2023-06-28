import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:mime/mime.dart';

class MediaHandler extends StatelessWidget {
  const MediaHandler({Key? key, required this.mediaUrl}) : super(key: key);
  final String mediaUrl;

  @override
  Widget build(BuildContext context) {
    final mediaMime = lookupMimeType(mediaUrl) ?? '';
    final mediaType = mediaMime.split('/')[0];
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        return Container(
          color: Colors.black,
          height: size,
          width: size,
          child: mediaType == 'image'
              ? InstaImageViewer(
                  child: FastCachedImage(
                    url: mediaUrl,
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
                )
              : Center(
                  child: Text(
                    'Unsupported media type: $mediaMime',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
        );
      },
    );
  }
}
