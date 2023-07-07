import 'package:channeler/widgets/media/flick_multi_player/flick_multi_manager.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';

class PortraitControls extends StatelessWidget {
  const PortraitControls({
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
    return Container(
      color: Colors.transparent,
      padding: EdgeInsets.zero,
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              /* Remaining time bubble */
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 0),
                child: FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  autoHide: false,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 5),
                      decoration: BoxDecoration(
                        color: Colors.black38,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const FlickLeftDuration(),
                    ),
                  ),
                ),
              ),
              /* Fullscreen toggle in center of screen and seek */
              Expanded(
                child: FlickAutoHideChild(
                  showIfVideoNotInitialized: false,
                  autoHide: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: FlickToggleSoundAction(
                      toggleMute: () {
                        bool isPlaying =
                            flickManager?.flickVideoManager?.isPlaying ?? false;
                        if (!isPlaying) {
                          Scrollable.ensureVisible(context, alignment: 0.5);
                        }
                        if (flickManager?.flickControlManager?.isMute ??
                            false) {
                          flickMultiManager?.toggleMute();
                        }
                        flickMultiManager?.replay(flickManager);
                        flickManager?.flickControlManager?.enterFullscreen();
                      },
                      child: const FlickSeekVideoAction(),
                    ),
                  ),
                ),
              ),
              /* Mute button */
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
                child: FlickAutoHideChild(
                  autoHide: false,
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
                    ],
                  ),
                ),
              ),
            ],
          ),
          /* Buffering progress circle */
          const Center(
            child: FlickVideoBuffer(),
          ),
          /* Video progress */
          FlickAutoHideChild(
            showIfVideoNotInitialized: false,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: FlickVideoProgressBar(
                flickProgressBarSettings: FlickProgressBarSettings(
                  height: 5,
                  padding: EdgeInsets.zero,
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
        ],
      ),
    );
  }
}
