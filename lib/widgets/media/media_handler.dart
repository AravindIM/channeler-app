import 'package:channeler/widgets/media/flick_multi_player/flick_multi_manager.dart';
import 'package:channeler/widgets/media/flick_multi_player/flick_multi_player.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:insta_image_viewer/insta_image_viewer.dart';
import 'package:mime/mime.dart';

class MediaHandler extends StatelessWidget {
  const MediaHandler(
      {Key? key, required this.mediaUrl, required this.flickMultiManager})
      : super(key: key);
  final String mediaUrl;
  final FlickMultiManager flickMultiManager;

  @override
  Widget build(BuildContext context) {
    final mediaMime = lookupMimeType(mediaUrl) ?? '';
    final mediaType = mediaMime.split('/')[0];
    final colorScheme = Theme.of(context).colorScheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.maxWidth;
        final handler = switch (mediaType) {
          "image" => InstaImageViewer(
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
            ),
          "video" => FlickMultiPlayer(
              flickMultiManager: flickMultiManager,
              url: mediaUrl,
              barColor: colorScheme.primary,
            ),
          _ => Center(
              child: Text(
                'Unsupported media type: $mediaMime',
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
        };
        return Container(
          color: Colors.black,
          height: size,
          width: size,
          child: handler,
        );
      },
    );
  }
}
