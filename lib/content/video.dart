import 'package:flutter/widgets.dart';
import 'package:player/content/content.dart';
import 'package:ext_video_player/ext_video_player.dart';

class ConcertoVideo extends ConcertoContent {
  final String videoUrl;

  ConcertoVideo({VoidCallback onFinish, this.videoUrl})
      : super(onFinish: onFinish);

  ConcertoVideoWidget get widget {
    return new ConcertoVideoWidget(
        videoUrl: this.videoUrl, onFinish: this.onFinish);
  }

  void play() {}
}

class ConcertoVideoWidget extends StatefulWidget {
  ConcertoVideoWidget({Key key, this.videoUrl, this.onFinish})
      : super(key: key);
  final String videoUrl;
  final VoidCallback onFinish;

  @override
  _ConcertoVideoWidgetState createState() => _ConcertoVideoWidgetState();
}

class _ConcertoVideoWidgetState extends State<ConcertoVideoWidget> {
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl);
    _controller.addListener(() {
      if (_controller.value.position == _controller.value.duration) {
        widget.onFinish();
        return;
      }

      setState(() {
        if (!_controller.value.isPlaying) {
          _controller.play();
        }
      });
    });
    _controller.initialize();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    );
  }
}
