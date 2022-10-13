import 'package:flutter/material.dart';
import 'package:flick_video_player/flick_video_player.dart';
import 'package:video_player/video_player.dart';
import 'package:skule_news_admin_panel/helper/common_import.dart';

class VideoPlayer extends StatefulWidget {
  final BlogPostModel videoObject;

  const VideoPlayer({Key? key, required this.videoObject}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState();
}

class _VideoPlayerState extends State<VideoPlayer> {
  FlickManager? flickManager;

  @override
  void initState() {
    super.initState();

    flickManager = FlickManager(
      videoPlayerController:
      VideoPlayerController.network(widget.videoObject.videoUrl!),
    );
  }

  @override
  void dispose() {
    flickManager?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            widget.videoObject.title,
            style: const TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.black,
        ),
        body: FlickVideoPlayer(
          flickManager: flickManager!,
          flickVideoWithControls: FlickVideoWithControls(
            controls: FlickPortraitControls(
              iconSize: 30,
              fontSize: 20,
              progressBarSettings: FlickProgressBarSettings(
                handleRadius: 10,
                handleColor: Theme.of(context).primaryColor,
                height: 5,
              ),
            ),
            videoFit: BoxFit.contain,
          ),
        ));
  }
}
