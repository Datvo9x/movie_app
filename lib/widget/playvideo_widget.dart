// ignore_for_file: must_be_immutable
import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoMovie extends StatefulWidget {
  String title, imageUrl, trailer;
  VideoMovie(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.trailer})
      : super(key: key);

  @override
  _VideoMovieState createState() => _VideoMovieState();
}

class _VideoMovieState extends State<VideoMovie> {
  late VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.trailer);
    await videoPlayerController!.initialize();

    chewieController = ChewieController(
      materialProgressColors: ChewieProgressColors(
        bufferedColor: Colors.white60,
        handleColor: Colors.white,
        playedColor: const Color.fromARGB(255, 238, 98, 16),
      ),
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: 'Tốc độ phát lại',
        subtitlesButtonText: 'Lời dịch',
        cancelButtonText: 'Hủy bỏ',
      ),
      videoPlayerController: videoPlayerController!,
      aspectRatio: 16 / 9,
      looping: false,
      autoPlay: false,
      autoInitialize: true,
    );
    setState(() {});
  }

  @override
  void dispose() {
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            children: <Widget>[
              SizedBox(
                height: MediaQuery.of(context).size.width / 1.8,
                child: chewieController != null
                    ? Container(
                        color: Colors.black,
                        child: Stack(
                          children: <Widget>[
                            Chewie(
                              controller: chewieController!,
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 10, left: 20),
                              child: GestureDetector(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: const Icon(
                                  Icons.arrow_back_ios,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : const Center(
                        child: SizedBox(
                          height: 30,
                          width: 30,
                          child: CircularProgressIndicator(
                            color: Color.fromARGB(255, 238, 98, 16),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
