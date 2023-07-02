import 'package:channeler/widgets/media/flick_multi_player/flick_multi_manager.dart';
import 'package:channeler/widgets/media/flick_multi_player/flick_multi_player.dart';
import 'package:channeler/widgets/media/image_handler.dart';
import 'package:flutter/material.dart';
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
          "image" => ImageHandler(imageUrl: mediaUrl),
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
