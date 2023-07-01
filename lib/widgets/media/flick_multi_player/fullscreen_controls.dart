import 'package:channeler/widgets/media/flick_multi_player/flick_multi_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FullScreenControls extends StatelessWidget {
  const FullScreenControls({
    Key? key,
    this.flickMultiManager,
    this.flickManager,
    this.barColor = Colors.white,
  }) : super(key: key);

  final FlickMultiManager? flickMultiManager;
  final FlickManager? flickManager;
  final Color barColor;

  @override
  Widget build(BuildContext context) {
    FlickDisplayManager displayManager =
        Provider.of<FlickDisplayManager>(context);
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
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
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: FlickTogglePlayAction(
                    togglePlay: () {
                      flickMultiManager?.togglePlay(flickManager!);
                      // if (!(flickManager?.flickControlManager?.isFullscreen ??
                      //     false)) {
                      //   flickManager?.flickControlManager?.toggleFullscreen();
                      // }
                      displayManager.handleShowPlayerControls();
                    },
                    child: const FlickSeekVideoAction(
                      child: FlickVideoBuffer(),
                    ),
                  ),
                ),
              ),
              FlickAutoHideChild(
                showIfVideoNotInitialized: false,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.black38,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: FlickVideoProgressBar(
                        flickProgressBarSettings: FlickProgressBarSettings(
                          height: 10,
                          padding: const EdgeInsets.all(5),
                          handleRadius: 0,
                          curveRadius: 0,
                          backgroundColor: Colors.white24,
                          bufferedColor: barColor.withAlpha(100),
                          playedColor: barColor,
                          handleColor: barColor,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              FlickAutoHideChild(
                autoHide: true,
                showIfVideoNotInitialized: false,
                child: Container(
                  padding: const EdgeInsets.only(bottom: 10),
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      FlickSoundToggle(
                        toggleMute: () => flickMultiManager?.toggleMute(),
                        color: Colors.white,
                      ),
                      const FlickPlayToggle(),
                      const FlickFullScreenToggle(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Center(
            child: FlickAutoHideChild(
              showIfVideoNotInitialized: false,
              child: Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.black38,
                  borderRadius: BorderRadius.circular(100),
                ),
                child: const FlickPlayToggle(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
