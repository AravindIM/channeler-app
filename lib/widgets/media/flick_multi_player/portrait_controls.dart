import 'package:channeler/widgets/media/flick_multi_player/flick_multi_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FeedPlayerPortraitControls extends StatelessWidget {
  const FeedPlayerPortraitControls({
    Key? key,
    this.flickMultiManager,
    this.flickManager,
    this.barColor = Colors.white,
    this.raiseBar = false,
  }) : super(key: key);

  final FlickMultiManager? flickMultiManager;
  final FlickManager? flickManager;
  final Color barColor;
  final bool raiseBar;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: FlickAutoHideChild(
              showIfVideoNotInitialized: false,
              child: Align(
                alignment: Alignment.topRight,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20)),
                  child: const FlickLeftDuration(),
                ),
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: FlickToggleSoundAction(
                toggleMute: () {
                  flickMultiManager?.toggleMute();
                  // if (!(flickManager?.flickControlManager?.isFullscreen ??
                  //     false)) {
                  //   flickManager?.flickControlManager?.toggleFullscreen();
                  // }
                  displayManager.handleShowPlayerControls();
                },
                child: const FlickSeekVideoAction(
                  child: Center(
                    child: FlickVideoBuffer(),
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 15),
            child: FlickAutoHideChild(
              autoHide: true,
              showIfVideoNotInitialized: false,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: FlickSoundToggle(
                      toggleMute: () => flickMultiManager?.toggleMute(),
                      color: Colors.white,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black38,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const FlickFullScreenToggle(),
                  ),
                ],
              ),
            ),
          ),
          FlickAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Align(
                alignment: Alignment.bottomCenter,
                child: Padding(
                  padding: raiseBar
                      ? const EdgeInsets.fromLTRB(30, 0, 30, 50)
                      : EdgeInsets.zero,
                  child: FlickVideoProgressBar(
                    flickProgressBarSettings: FlickProgressBarSettings(
                      height: 5,
                      padding: EdgeInsets.zero,
                      handleRadius: raiseBar ? 5 : 0,
                      curveRadius: raiseBar ? 50 : 0,
                      backgroundColor: Colors.white24,
                      bufferedColor: barColor.withAlpha(100),
                      playedColor: barColor,
                      handleColor: barColor,
                    ),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
