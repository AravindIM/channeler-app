import 'dart:io';

import 'package:channeler/widgets/media/flick_multi_player/flick_multi_manager.dart';
import 'package:channeler/widgets/media/flick_multi_player/fullscreen_controls.dart';
import 'package:channeler/widgets/media/flick_multi_player/portrait_controls.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:video_player/video_player.dart';

class FlickMultiPlayer extends StatefulWidget {
  const FlickMultiPlayer(
      {Key? key,
      required this.url,
      this.image,
      required this.flickMultiManager,
      this.barColor = Colors.white})
      : super(key: key);

  final String url;
  final String? image;
  final FlickMultiManager flickMultiManager;
  final Color barColor;

  @override
  State<FlickMultiPlayer> createState() => _FlickMultiPlayerState();
}

class _FlickMultiPlayerState extends State<FlickMultiPlayer> {
  late FlickManager flickManager;

  @override
  void initState() {
    flickManager = FlickManager(
      videoPlayerController:
          VideoPlayerController.networkUrl(Uri.parse(widget.url))
            ..setLooping(true),
      autoPlay: false,
    );
    widget.flickMultiManager.init(flickManager);

    super.initState();
  }

  @override
  void dispose() {
    widget.flickMultiManager.remove(flickManager);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final loadingCircle = Center(
      child: Stack(
        children: [
          Center(
            child: CircularProgressIndicator(
              color: colorScheme.primary,
            ),
          ),
          Center(
            child: Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: Colors.black38,
                borderRadius: BorderRadius.circular(100),
              ),
              child: const FlickPlayToggle(),
            ),
          ),
        ],
      ),
    );

    return VisibilityDetector(
      key: ObjectKey(flickManager),
      onVisibilityChanged: (visibility) {
        if (visibility.visibleFraction > 0.9) {
          widget.flickMultiManager.play(flickManager);
        } else if (visibility.visibleFraction < 0.2) {
          widget.flickMultiManager.pause(flickManager);
        }
      },
      child: FlickVideoPlayer(
        wakelockEnabled: !Platform.isLinux,
        wakelockEnabledFullscreen: !Platform.isLinux,
        preferredDeviceOrientationFullscreen: const [
          DeviceOrientation.landscapeLeft,
          DeviceOrientation.landscapeRight,
          DeviceOrientation.portraitUp,
          DeviceOrientation.portraitDown,
        ],
        flickManager: flickManager,
        flickVideoWithControls: FlickVideoWithControls(
          videoFit: BoxFit.contain,
          playerLoadingFallback: loadingCircle,
          controls: PortraitControls(
            flickMultiManager: widget.flickMultiManager,
            flickManager: flickManager,
            barColor: widget.barColor,
          ),
        ),
        flickVideoWithControlsFullscreen: FlickVideoWithControls(
          videoFit: BoxFit.contain,
          playerLoadingFallback: loadingCircle,
          controls: FullScreenControls(
            flickMultiManager: widget.flickMultiManager,
            flickManager: flickManager,
            barColor: widget.barColor,
          ),
          iconThemeData: const IconThemeData(
            size: 40,
            color: Colors.white,
          ),
          textStyle: const TextStyle(fontSize: 16, color: Colors.white),
        ),
      ),
    );
  }
}