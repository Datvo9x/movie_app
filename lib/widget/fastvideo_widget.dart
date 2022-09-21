import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';

// ignore: must_be_immutable
class Fastvideo extends StatefulWidget {
  String videoFast;
  late final int pageIndex;
  late final int currentIndex;
  Fastvideo({
    Key? key,
    required this.videoFast,
    required this.pageIndex,
    required this.currentIndex,
  }) : super(key: key);

  @override
  State<Fastvideo> createState() => _FastvideoState();
}

class _FastvideoState extends State<Fastvideo> {
  late VideoPlayerController? _videoPlayerController;
  late Future _initializeVideoPlayer;
  bool _isVideoPlaying = true;

  @override
  void initState() {
    _videoPlayerController = VideoPlayerController.network(widget.videoFast);
    _initializeVideoPlayer = _videoPlayerController!.initialize();
    _videoPlayerController!.setLooping(false);

    super.initState();
  }

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  void pauseplayvideo() {
    _isVideoPlaying
        ? _videoPlayerController!.pause()
        : _videoPlayerController!.play();
    setState(() {
      _isVideoPlaying = !_isVideoPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    (widget.pageIndex == widget.currentIndex && _isVideoPlaying)
        ? _videoPlayerController!.play()
        : _videoPlayerController!.pause();
    return Container(
      color: const Color.fromARGB(0, 216, 216, 216),
      child: FutureBuilder(
          future: _initializeVideoPlayer,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return GestureDetector(
                onTap: () => {pauseplayvideo()},
                child: Stack(
                  alignment: Alignment.bottomCenter,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 1),
                      child: VideoPlayer(_videoPlayerController!),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.maybeOf(context)!.size.height / 4),
                      child: IconButton(
                        onPressed: () => {pauseplayvideo()},
                        icon: Icon(
                          Icons.play_circle,
                          color: Colors.white
                              .withOpacity(_isVideoPlaying ? 0 : 0.8),
                          size: 50,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 8,
                      child: VideoProgressIndicator(
                        _videoPlayerController!,
                        allowScrubbing: true,
                        colors: const VideoProgressColors(
                            playedColor: Color.fromARGB(235, 230, 224, 224),
                            backgroundColor: Color.fromARGB(255, 90, 89, 89),
                            bufferedColor: Colors.transparent),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return Container(
                color: Colors.transparent,
                child: Center(
                  child: Lottie.asset('assets/images/loading.json', width: 60),
                ),
              );
            }
          }),
    );
  }
}
