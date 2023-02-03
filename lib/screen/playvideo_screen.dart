import 'dart:async';
import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/widget/relate_widgett.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import '../modal/timeago.dart';

// ignore: must_be_immutable
class VideoMovie extends StatefulWidget {
  String title,
      trailer,
      id,
      uid,
      name,
      year,
      category,
      description,
      duration,
      rating,
      photoUrl,
      imageUrl;
  int view;
  VideoMovie(
      {Key? key,
      required this.category,
      required this.name,
      required this.duration,
      required this.imageUrl,
      required this.photoUrl,
      required this.rating,
      required this.year,
      required this.description,
      required this.uid,
      required this.view,
      required this.title,
      required this.trailer,
      required this.id})
      : super(key: key);

  @override
  _VideoMovieState createState() => _VideoMovieState();
}

class _VideoMovieState extends State<VideoMovie> {
  late VideoPlayerController? videoPlayerController;
  ChewieController? chewieController;
  bool cmtNew = true;
  CollectionReference getcmt = FirebaseFirestore.instance.collection('movie');
  CollectionReference getcmt1 = FirebaseFirestore.instance.collection('movie');
  CollectionReference getfar = FirebaseFirestore.instance.collection('users');
  final _controller = TextEditingController();

  late int _playBackTime = 0;
  finaldelete(String document) {
    getcmt.doc(widget.id).collection('comment').doc(document).delete();
  }

  @override
  void initState() {
    super.initState();
    // addHistory();
    getData();
    _initializePlayer();
  }

  getData() async {
    final QuerySnapshot checkerv = await getfar
        .doc(widget.uid)
        .collection('historyView')
        .where('id', isEqualTo: widget.id)
        .get();
    if (checkerv.docs.isEmpty) {
      _playBackTime = 0;
    } else {
      _playBackTime = (checkerv.docs.first['playBackTime']);
    }
    return _playBackTime;
  }

  addHistory() async {
    QuerySnapshot checker = await getfar
        .doc(widget.uid)
        .collection('historyView')
        .where('id', isEqualTo: widget.id)
        .get();

    if (checker.docs.isEmpty) {
      print('add');
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection('historyView')
          .add(
        {
          'title': widget.title,
          'trailer': widget.trailer,
          'year': widget.year,
          'category': widget.category,
          'description': widget.description,
          'duration': widget.duration,
          'rating': widget.rating,
          'imageUrl': widget.imageUrl,
          'view': widget.view,
          "timeview": DateTime.now(),
          "id": widget.id,
          "uid": widget.uid,
          "playBackTime": _playBackTime,
        },
      );
    } else {
      FirebaseFirestore.instance
          .collection("users")
          .doc(widget.uid)
          .collection('historyView')
          .doc(checker.docs.first.id)
          .update(
        {
          'title': widget.title,
          'trailer': widget.trailer,
          'year': widget.year,
          'category': widget.category,
          'description': widget.description,
          'duration': widget.duration,
          'rating': widget.rating,
          'imageUrl': widget.imageUrl,
          'view': widget.view,
          "timeview": DateTime.now(),
          "id": widget.id,
          "uid": widget.uid,
          "playBackTime": _playBackTime,
        },
      );
      print('update');
    }
  }

  Future myFuture() async {
    try {
      await Future.delayed(const Duration(seconds: 10));
      setState(() {
        FirebaseFirestore.instance
            .collection("movie")
            .doc(widget.id)
            .update({
              "view": widget.view + 1,
            })
            .then((value) => print(" add view"))
            .catchError((error) => print("Failed to add user: $error"));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _initializePlayer() async {
    videoPlayerController = VideoPlayerController.network(widget.trailer);
    await videoPlayerController!.initialize();

    videoPlayerController!.addListener(() {
      try {
        setState(() {
          _playBackTime = videoPlayerController!.value.position.inSeconds;
          print(_playBackTime);
        });
      } catch (e) {
        print(e);
      }
    });

    chewieController = ChewieController(
      startAt: Duration(seconds: _playBackTime),
      materialProgressColors: ChewieProgressColors(
        bufferedColor: Colors.white,
        handleColor: Colors.white,
        playedColor: const Color.fromARGB(255, 238, 98, 16),
      ),
      optionsTranslation: OptionsTranslation(
        playbackSpeedButtonText: 'Tốc độ phát lại',
        subtitlesButtonText: 'Lời dịch',
        cancelButtonText: 'Hủy bỏ',
      ),
      videoPlayerController: videoPlayerController!,
      aspectRatio: 18 / 9,
      looping: false,
      autoPlay: true,
      autoInitialize: true,
    );

    myFuture();
    setState(() {});
  }

  @override
  void dispose() {
    addHistory();
    videoPlayerController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(
            MediaQuery.of(context).size.width / 2,
          ), // Set this height
          child: SizedBox(
            child: chewieController != null
                ? Container(
                    color: Colors.black,
                    child: Stack(
                      children: <Widget>[
                        Chewie(
                          controller: chewieController!,
                        ),
                        Center(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  child: Container(
                                    color: Colors.transparent,
                                    width: 120,
                                    height: 70,
                                  ),
                                  onDoubleTap: () {
                                    _playBackTime = _playBackTime - 5;
                                    chewieController = ChewieController(
                                      startAt: Duration(seconds: _playBackTime),
                                      materialProgressColors:
                                          ChewieProgressColors(
                                        bufferedColor: Colors.white,
                                        handleColor: Colors.white,
                                        playedColor: const Color.fromARGB(
                                            255, 238, 98, 16),
                                      ),
                                      optionsTranslation: OptionsTranslation(
                                        playbackSpeedButtonText:
                                            'Tốc độ phát lại',
                                        subtitlesButtonText: 'Lời dịch',
                                        cancelButtonText: 'Hủy bỏ',
                                      ),
                                      videoPlayerController:
                                          videoPlayerController!,
                                      aspectRatio: 18 / 9,
                                      looping: false,
                                      autoPlay: false,
                                      autoInitialize: true,
                                    );
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(
                                          const Duration(milliseconds: 220),
                                          () {
                                            Navigator.of(context).pop(true);
                                          },
                                        );
                                        return const SimpleDialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding:
                                              EdgeInsets.only(bottom: 580),
                                          title: Text(
                                            '10 giây',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                GestureDetector(
                                  child: Container(
                                    color: Colors.transparent,
                                    width: 120,
                                    height: 70,
                                  ),
                                  onDoubleTap: () {
                                    _playBackTime = _playBackTime + 5;
                                    chewieController = ChewieController(
                                      startAt: Duration(seconds: _playBackTime),
                                      materialProgressColors:
                                          ChewieProgressColors(
                                        bufferedColor: Colors.white,
                                        handleColor: Colors.white,
                                        playedColor: const Color.fromARGB(
                                            255, 238, 98, 16),
                                      ),
                                      optionsTranslation: OptionsTranslation(
                                        playbackSpeedButtonText:
                                            'Tốc độ phát lại',
                                        subtitlesButtonText: 'Lời dịch',
                                        cancelButtonText: 'Hủy bỏ',
                                      ),
                                      videoPlayerController:
                                          videoPlayerController!,
                                      aspectRatio: 18 / 9,
                                      looping: false,
                                      autoPlay: false,
                                      autoInitialize: true,
                                    );

                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        Future.delayed(
                                          const Duration(milliseconds: 220),
                                          () {
                                            Navigator.of(context).pop(true);
                                          },
                                        );
                                        return const SimpleDialog(
                                          backgroundColor: Colors.transparent,
                                          insetPadding: EdgeInsets.only(
                                              bottom: 580, left: 240),
                                          title: Text(
                                            '10 giây',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              ]),
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
                      height: 25,
                      width: 25,
                      child: CircularProgressIndicator(
                        color: Color.fromARGB(255, 238, 98, 16),
                      ),
                    ),
                  ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                color: const Color.fromARGB(255, 18, 18, 18),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (BuildContext context) {
                              return Container(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 0, 10, 0),
                                color: const Color.fromARGB(255, 16, 16, 16),
                                height: MediaQuery.of(context).size.height,
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1.5,
                                          child: Text(
                                            widget.title,
                                            style: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                                fontSize: 18,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.white),
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          icon: Container(
                                            height: 26,
                                            width: 26,
                                            decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  162, 46, 46, 47),
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                            ),
                                            child: const Center(
                                                child: Icon(Icons.close,
                                                    color: Colors.white)),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Container(
                                          color: const Color.fromARGB(
                                              255, 57, 57, 57),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 3, 5, 3),
                                            child: Text(
                                              widget.category,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          color: const Color.fromARGB(
                                              255, 57, 57, 57),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                5, 3, 5, 3),
                                            child: Text(
                                              widget.duration,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          color: const Color.fromARGB(
                                              255, 57, 57, 57),
                                          child: Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                8, 3, 8, 3),
                                            child: Text(
                                              widget.year,
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w400,
                                                  color: Colors.white),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          decoration: const BoxDecoration(
                                            color: Color.fromARGB(
                                                255, 234, 153, 60),
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(0),
                                            ),
                                          ),
                                          padding: const EdgeInsets.fromLTRB(
                                              4, 2.8, 4, 2.8),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.rating,
                                                style: const TextStyle(
                                                    fontSize: 9,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w400),
                                              ),
                                              const SizedBox(
                                                width: 2,
                                              ),
                                              const Padding(
                                                padding: EdgeInsets.only(
                                                    bottom: 1.0),
                                                child: Icon(
                                                  Icons.star,
                                                  size: 10,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: const [
                                        Text(
                                          "Mô tả:",
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 144, 144, 144),
                                              fontSize: 14),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 8,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          0, 0, 23, 0),
                                      child: Text(
                                        widget.description,
                                        style: const TextStyle(
                                            letterSpacing: 0.6,
                                            color: Color.fromARGB(
                                                255, 219, 219, 219),
                                            fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            });
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 15, 10, 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: MediaQuery.of(context).size.width / 1.5,
                              child: Text(
                                widget.title,
                                style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white),
                              ),
                            ),
                            Row(
                              children: const [
                                Text(
                                  "Thông tin",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white70),
                                ),
                                Icon(
                                  Icons.navigate_next_sharp,
                                  color: Colors.white70,
                                )
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                      child: Row(
                        children: [
                          Container(
                            color: const Color.fromARGB(255, 57, 57, 57),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                              child: Text(
                                widget.category,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            color: const Color.fromARGB(255, 57, 57, 57),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(5, 3, 5, 3),
                              child: Text(
                                widget.duration,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            color: const Color.fromARGB(255, 57, 57, 57),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(8, 3, 8, 3),
                              child: Text(
                                widget.year,
                                style: const TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(255, 234, 153, 60),
                              borderRadius: BorderRadius.all(
                                Radius.circular(0),
                              ),
                            ),
                            padding: const EdgeInsets.fromLTRB(4, 2.8, 4, 2.8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  widget.rating,
                                  style: const TextStyle(
                                      fontSize: 9,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400),
                                ),
                                const SizedBox(
                                  width: 2,
                                ),
                                const Padding(
                                  padding: EdgeInsets.only(bottom: 1.0),
                                  child: Icon(
                                    Icons.star,
                                    size: 10,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(50, 15, 50, 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            height: 65,
                            width: 70,
                            child: Column(
                              children: [
                                StreamBuilder(
                                  stream: getfar
                                      .doc(widget.uid)
                                      .collection('favorite')
                                      .where('id', isEqualTo: widget.id)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: Icon(
                                          Icons.favorite,
                                          size: 28,
                                          color: Color.fromARGB(
                                              255, 247, 244, 244),
                                        ),
                                      );
                                    } else {
                                      return snapshot.data!.docs.isEmpty
                                          ? IconButton(
                                              onPressed: () async {
                                                await FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(widget.uid)
                                                    .collection('favorite')
                                                    .add(
                                                  {
                                                    'title': widget.title,
                                                    'trailer': widget.trailer,
                                                    'year': widget.year,
                                                    'category': widget.category,
                                                    'description':
                                                        widget.description,
                                                    'duration': widget.duration,
                                                    'rating': widget.rating,
                                                    'imageUrl': widget.imageUrl,
                                                    "timeview": DateTime.now(),
                                                    'view': widget.view,
                                                    "id": widget.id,
                                                    "uid": widget.uid,
                                                  },
                                                );
                                                _showOK(context,
                                                    'Đã lưu vào bộ sưu tập');
                                              },
                                              icon: const Icon(
                                                Icons.favorite,
                                                size: 28,
                                                color: Color.fromARGB(
                                                    255, 247, 244, 244),
                                              ),
                                            )
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount:
                                                  snapshot.data!.docs.length,
                                              itemBuilder: (contex, index) {
                                                return IconButton(
                                                  onPressed: () async {
                                                    showDialog(
                                                      builder: (context) =>
                                                          AlertDialog(
                                                        shape:
                                                            const RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius.all(
                                                            Radius.circular(
                                                                18.0),
                                                          ),
                                                        ),
                                                        title: const Center(
                                                          child: Text(
                                                            'Xóa khỏi danh yêu thích ?',
                                                            style: TextStyle(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          ),
                                                        ),
                                                        actions: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                GestureDetector(
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 85,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: BoxDecoration(
                                                                        color: const Color.fromARGB(
                                                                            255,
                                                                            223,
                                                                            131,
                                                                            10),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                    child:
                                                                        const Text(
                                                                      'Không',
                                                                      style: TextStyle(
                                                                          color: Colors
                                                                              .white,
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                  onTap: () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                ),
                                                                GestureDetector(
                                                                  child:
                                                                      Container(
                                                                    height: 30,
                                                                    width: 85,
                                                                    alignment:
                                                                        Alignment
                                                                            .center,
                                                                    decoration: BoxDecoration(
                                                                        color: const Color.fromARGB(
                                                                            255,
                                                                            232,
                                                                            230,
                                                                            228),
                                                                        borderRadius:
                                                                            BorderRadius.circular(20)),
                                                                    child:
                                                                        const Text(
                                                                      'Vẫn Xóa',
                                                                      style: TextStyle(
                                                                          color: Color.fromARGB(
                                                                              255,
                                                                              215,
                                                                              98,
                                                                              30),
                                                                          fontWeight:
                                                                              FontWeight.w600),
                                                                    ),
                                                                  ),
                                                                  onTap:
                                                                      () async {
                                                                    await FirebaseFirestore
                                                                        .instance
                                                                        .collection(
                                                                            "users")
                                                                        .doc(widget
                                                                            .uid)
                                                                        .collection(
                                                                            'favorite')
                                                                        .doc(snapshot
                                                                            .data!
                                                                            .docs[index]
                                                                            .id)
                                                                        .delete();
                                                                    Navigator.pop(
                                                                        context);
                                                                    _showOK(
                                                                        context,
                                                                        'Đã xóa khỏi yêu thích');
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      context: context,
                                                    );
                                                  },
                                                  icon: const Icon(
                                                    Icons.favorite,
                                                    size: 28,
                                                    color: Color.fromARGB(
                                                        255, 175, 96, 12),
                                                  ),
                                                );
                                              },
                                            );
                                    }
                                  },
                                ),
                                const Text(
                                  " Yêu thích ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            width: 70,
                            child: Column(
                              children: [
                                StreamBuilder(
                                  stream: getfar
                                      .doc(widget.uid)
                                      .collection('download')
                                      .where('id', isEqualTo: widget.id)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: Icon(
                                          Icons.download,
                                          size: 28,
                                          color: Color.fromARGB(
                                              255, 247, 244, 244),
                                        ),
                                      );
                                    } else {
                                      return snapshot.data!.docs.isEmpty
                                          ? IconButton(
                                              onPressed: () async {
                                                _showDownOK(
                                                    context, 'Đang tải về');
                                                await downloadFile();
                                                await FirebaseFirestore.instance
                                                    .collection("users")
                                                    .doc(widget.uid)
                                                    .collection('download')
                                                    .add(
                                                  {
                                                    "uid": widget.uid,
                                                    "id": widget.id,
                                                    "title": widget.title,
                                                    "category": widget.category,
                                                    "duration": widget.duration,
                                                    "imageUrl": widget.imageUrl,
                                                    "trailer": widget.trailer,
                                                  },
                                                );
                                                _showOK(context, 'Đã tải về');
                                              },
                                              icon: const Icon(
                                                Icons.download,
                                                size: 28,
                                                color: Color.fromARGB(
                                                    255, 247, 244, 244),
                                              ),
                                            )
                                          : IconButton(
                                              onPressed: () {
                                                OpenFile.open(
                                                    '/storage/emulated/0/dcim/FireMovie/${widget.title}.mp4',
                                                    type: "video/mp4");
                                                print("open");
                                              },
                                              icon: const Icon(
                                                Icons.download_done_rounded,
                                                size: 28,
                                                color: Color.fromARGB(
                                                    255, 247, 244, 244),
                                              ),
                                            );
                                    }
                                  },
                                ),
                                const Text(
                                  " Tải về ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 65,
                            width: 70,
                            child: Column(
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    await Share.share(
                                        'Chia sẽ ngay với bạn bè !\n${widget.imageUrl}');
                                  },
                                  icon: const Icon(
                                    Icons.share,
                                    size: 26,
                                    color: Color.fromARGB(255, 247, 244, 244),
                                  ),
                                ),
                                const Text(
                                  " Chia sẻ ",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400,
                                      color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return StatefulBuilder(builder:
                                (BuildContext context, StateSetter mystate) {
                              return Scaffold(
                                appBar: PreferredSize(
                                  preferredSize: const Size.fromHeight(
                                      100), // Set this height
                                  child: Container(
                                    color:
                                        const Color.fromARGB(255, 20, 20, 20),
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 5, 0.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Bình luận',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    color: Colors.white,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              Row(children: [
                                                TextButton(
                                                  onPressed: () {
                                                    mystate(() {
                                                      cmtNew = true;
                                                    });
                                                  },
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                      color: cmtNew
                                                          ? const Color
                                                                  .fromARGB(
                                                              213, 54, 54, 54)
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    child: const Padding(
                                                      padding:
                                                          EdgeInsets.fromLTRB(
                                                              10, 5, 10, 5),
                                                      child: Text(
                                                        'Mới nhất',
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: Colors.white,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    mystate(() {
                                                      cmtNew = false;
                                                    });
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(10, 5, 10, 5),
                                                    decoration: BoxDecoration(
                                                      color: !cmtNew
                                                          ? const Color
                                                                  .fromARGB(
                                                              213, 54, 54, 54)
                                                          : Colors.transparent,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              14),
                                                    ),
                                                    child: const Text(
                                                      'Cũ nhất',
                                                      style: TextStyle(
                                                          fontSize: 12,
                                                          color: Colors.white,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                  ),
                                                ),
                                              ]),
                                              IconButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                icon: Container(
                                                  height: 26,
                                                  width: 26,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        162, 46, 46, 47),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: const Center(
                                                      child: Icon(Icons.close,
                                                          color: Colors.white)),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              12, 0, 5, 0),
                                          child: Row(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 5, right: 10),
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    1.25,
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 69, 68, 68),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: TextField(
                                                  maxLines: 2,
                                                  minLines: 1,
                                                  controller: _controller,
                                                  style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14),
                                                  decoration:
                                                      const InputDecoration(
                                                    isDense: true, // Added this
                                                    contentPadding:
                                                        EdgeInsets.all(10),
                                                    hintText:
                                                        '   Nhập nội dung...',
                                                    hintStyle: TextStyle(
                                                        color: Colors.white70,
                                                        fontSize: 13),
                                                    border: InputBorder.none,
                                                    focusedBorder:
                                                        InputBorder.none,
                                                    enabledBorder:
                                                        InputBorder.none,
                                                    errorBorder:
                                                        InputBorder.none,
                                                    disabledBorder:
                                                        InputBorder.none,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () async {
                                                  if (_controller.text.trim() ==
                                                      '') {
                                                    _showNoOK(context,
                                                        'Vui lòng nhập nội dung');
                                                  } else {
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection("movie")
                                                        .doc(widget.id)
                                                        .collection('comment')
                                                        .add(
                                                      {
                                                        "photoUrl":
                                                            widget.photoUrl,
                                                        "id": widget.id,
                                                        "uid": widget.uid,
                                                        "nickname": widget.name,
                                                        "cmt": _controller.text,
                                                        "timeCmt":
                                                            DateTime.now(),
                                                      },
                                                    );

                                                    _showOK(context,
                                                        'Đã thêm bình luận');
                                                  }
                                                  setState(() {
                                                    _controller.clear();
                                                  });
                                                },
                                                icon: Container(
                                                  height: 30,
                                                  width: 30,
                                                  decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 69, 68, 68),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                  ),
                                                  child: const Center(
                                                    child: Icon(
                                                      Icons.send,
                                                      color: Colors.white,
                                                      size: 20,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                backgroundColor:
                                    const Color.fromARGB(255, 14, 14, 14),
                                body: SizedBox(
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: <Widget>[
                                        StreamBuilder(
                                          stream: cmtNew
                                              ? getcmt
                                                  .doc(widget.id)
                                                  .collection('comment')
                                                  .where('uid',
                                                      isEqualTo: widget.uid)
                                                  .orderBy('timeCmt',
                                                      descending: true)
                                                  .snapshots()
                                              : getcmt
                                                  .doc(widget.id)
                                                  .collection('comment')
                                                  .where('uid',
                                                      isEqualTo: widget.uid)
                                                  .orderBy('timeCmt',
                                                      descending: false)
                                                  .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: snapshot.data!.size,
                                                itemBuilder: (context, index) {
                                                  DateTime dateTime = snapshot
                                                      .data!
                                                      .docs[index]['timeCmt']
                                                      .toDate();
                                                  DocumentSnapshot cm = snapshot
                                                      .data!.docs[index];
                                                  final _controller1 =
                                                      TextEditingController(
                                                          text: cm['cmt']);
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(12, 5, 0, 0),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Container(
                                                          height: 25,
                                                          width: 25,
                                                          decoration:
                                                              BoxDecoration(
                                                            color: Colors.black,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        50),
                                                            image:
                                                                DecorationImage(
                                                              fit: BoxFit.cover,
                                                              image:
                                                                  NetworkImage(
                                                                cm['photoUrl'],
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          width: 8,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.38,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    cm['nickname'],
                                                                    style: const TextStyle(
                                                                        fontSize:
                                                                            14,
                                                                        color: Colors
                                                                            .white,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  Text(
                                                                    Timeago.timeAgo(
                                                                        dateTime),
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style:
                                                                        const TextStyle(
                                                                      fontSize:
                                                                          10,
                                                                      color: Color.fromARGB(
                                                                          255,
                                                                          218,
                                                                          218,
                                                                          218),
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w400,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 4,
                                                              ),
                                                              Text(
                                                                cm['cmt'],
                                                                maxLines: 10,
                                                                style: const TextStyle(
                                                                    fontSize:
                                                                        12,
                                                                    color: Colors
                                                                        .white,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w400),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        PopupMenuButton(
                                                          color: const Color
                                                                  .fromARGB(
                                                              255, 41, 41, 41),
                                                          icon: const SizedBox(
                                                            width: 15,
                                                            child: Icon(
                                                                Icons.more_vert,
                                                                size: 25,
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                          itemBuilder:
                                                              (context) {
                                                            return [
                                                              PopupMenuItem(
                                                                height: 30,
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                            builder: (context) =>
                                                                                AlertDialog(
                                                                              backgroundColor: const Color.fromARGB(255, 40, 40, 40),
                                                                              shape: const RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(18.0),
                                                                                ),
                                                                              ),
                                                                              title: const Center(
                                                                                child: Text(
                                                                                  'Xóa bình luận',
                                                                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              content: const Text(
                                                                                'Xóa bình luận của bạn vĩnh viễn?',
                                                                                textAlign: TextAlign.center,
                                                                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.white),
                                                                              ),
                                                                              actions: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.all(8.0),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                        child: Container(
                                                                                          height: 30,
                                                                                          width: 85,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(color: const Color.fromARGB(255, 223, 131, 10), borderRadius: BorderRadius.circular(20)),
                                                                                          child: const Text(
                                                                                            'Không',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                      GestureDetector(
                                                                                        child: Container(
                                                                                          height: 30,
                                                                                          width: 85,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(color: const Color.fromARGB(255, 232, 230, 228), borderRadius: BorderRadius.circular(20)),
                                                                                          child: const Text(
                                                                                            'Vẫn Xóa',
                                                                                            style: TextStyle(color: Color.fromARGB(255, 215, 98, 30), fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                        ),
                                                                                        onTap: () async {
                                                                                          await finaldelete(cm.id);
                                                                                          _showOK(context, 'Đã xóa bình luận');
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            context:
                                                                                context,
                                                                          );
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: const [
                                                                            Icon(Icons.delete,
                                                                                size: 20,
                                                                                color: Color.fromARGB(255, 238, 116, 107)),
                                                                            Text(
                                                                              '     Xóa',
                                                                              style: TextStyle(color: Color.fromARGB(255, 238, 116, 107)),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              ),
                                                              PopupMenuItem(
                                                                height: 30,
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () {
                                                                          showDialog(
                                                                            builder: (context) =>
                                                                                AlertDialog(
                                                                              backgroundColor: const Color.fromARGB(255, 24, 24, 24),
                                                                              shape: const RoundedRectangleBorder(
                                                                                borderRadius: BorderRadius.all(
                                                                                  Radius.circular(18.0),
                                                                                ),
                                                                              ),
                                                                              title: const Center(
                                                                                child: Text(
                                                                                  'Sửa bình luận',
                                                                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
                                                                                ),
                                                                              ),
                                                                              content: Container(
                                                                                width: 500,
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color.fromARGB(255, 48, 48, 48),
                                                                                  borderRadius: BorderRadius.circular(10),
                                                                                ),
                                                                                child: TextFormField(
                                                                                  minLines: 1,
                                                                                  maxLines: 5,
                                                                                  controller: _controller1,
                                                                                  style: const TextStyle(color: Colors.white, fontSize: 14),
                                                                                  decoration: const InputDecoration(
                                                                                    hintText: '  Nhập nội dung...',
                                                                                    hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                                                                                    border: InputBorder.none,
                                                                                    // focusedBorder: InputBorder.none,
                                                                                    // errorBorder: InputBorder.none,
                                                                                    // // disabledBorder: InputBorder.none,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              actions: [
                                                                                Padding(
                                                                                  padding: const EdgeInsets.only(left: 18, right: 18, bottom: 10),
                                                                                  child: Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                                    children: [
                                                                                      GestureDetector(
                                                                                        child: Container(
                                                                                          height: 30,
                                                                                          width: 85,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(color: const Color.fromARGB(255, 223, 131, 10), borderRadius: BorderRadius.circular(20)),
                                                                                          child: const Text(
                                                                                            'Hủy',
                                                                                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                        ),
                                                                                        onTap: () {
                                                                                          Navigator.pop(context);
                                                                                        },
                                                                                      ),
                                                                                      GestureDetector(
                                                                                        child: Container(
                                                                                          height: 30,
                                                                                          width: 85,
                                                                                          alignment: Alignment.center,
                                                                                          decoration: BoxDecoration(color: const Color.fromARGB(255, 232, 230, 228), borderRadius: BorderRadius.circular(20)),
                                                                                          child: const Text(
                                                                                            'Sửa',
                                                                                            style: TextStyle(color: Color.fromARGB(255, 215, 98, 30), fontWeight: FontWeight.w600),
                                                                                          ),
                                                                                        ),
                                                                                        onTap: () async {
                                                                                          if (_controller1.text.trim() == '') {
                                                                                            _showNoOK(context, 'Vui lòng nhập nội dung');
                                                                                          } else {
                                                                                            await FirebaseFirestore.instance.collection("movie").doc(widget.id).collection('comment').doc(cm.id).set(
                                                                                              {
                                                                                                "photoUrl": widget.photoUrl,
                                                                                                "id": widget.id,
                                                                                                "uid": widget.uid,
                                                                                                "nickname": widget.name,
                                                                                                "cmt": _controller1.text,
                                                                                                "timeCmt": cm['timeCmt'],
                                                                                              },
                                                                                            );

                                                                                            _showOK(context, 'Đã cập nhật bình luận');
                                                                                            Navigator.pop(context);
                                                                                            Navigator.pop(context);
                                                                                          }
                                                                                          // setState(() {

                                                                                          // });
                                                                                        },
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            context:
                                                                                context,
                                                                          );
                                                                        },
                                                                        child:
                                                                            Row(
                                                                          children: const [
                                                                            Icon(Icons.edit_sharp,
                                                                                size: 20,
                                                                                color: Color.fromARGB(255, 202, 200, 200)),
                                                                            Text(
                                                                              '     Sửa',
                                                                              style: TextStyle(color: Color.fromARGB(255, 202, 200, 200)),
                                                                            ),
                                                                          ],
                                                                        )),
                                                              ),
                                                            ];
                                                          },
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                        StreamBuilder(
                                          stream: cmtNew
                                              ? getcmt
                                                  .doc(widget.id)
                                                  .collection('comment')
                                                  .orderBy('timeCmt',
                                                      descending: true)
                                                  .snapshots()
                                              : getcmt
                                                  .doc(widget.id)
                                                  .collection('comment')
                                                  .orderBy('timeCmt',
                                                      descending: false)
                                                  .snapshots(),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<QuerySnapshot>
                                                  snapshot) {
                                            if (!snapshot.hasData) {
                                              return const Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            } else {
                                              return ListView.builder(
                                                physics:
                                                    const NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount: snapshot.data!.size,
                                                itemBuilder: (context, index) {
                                                  DateTime dateTime1 = snapshot
                                                      .data!
                                                      .docs[index]['timeCmt']
                                                      .toDate();
                                                  DocumentSnapshot cm = snapshot
                                                      .data!.docs[index];
                                                  return Padding(
                                                    padding: const EdgeInsets
                                                        .fromLTRB(12, 0, 12, 5),
                                                    child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        (cm['uid'] ==
                                                                widget.uid)
                                                            ? Container(
                                                                height: 0,
                                                              )
                                                            : Container(
                                                                height: 25,
                                                                width: 25,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Colors
                                                                      .black,
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              50),
                                                                  image:
                                                                      DecorationImage(
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    image:
                                                                        NetworkImage(
                                                                      cm['photoUrl'],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        SizedBox(
                                                          width: MediaQuery.of(
                                                                      context)
                                                                  .size
                                                                  .width /
                                                              1.38,
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              (cm['uid'] ==
                                                                      widget
                                                                          .uid)
                                                                  ? Container(
                                                                      height: 0,
                                                                    )
                                                                  : Row(
                                                                      children: [
                                                                        Text(
                                                                          cm['nickname'],
                                                                          style: const TextStyle(
                                                                              fontSize: 14,
                                                                              color: Colors.white,
                                                                              fontWeight: FontWeight.w600),
                                                                        ),
                                                                        const SizedBox(
                                                                          width:
                                                                              10,
                                                                        ),
                                                                        Text(
                                                                          Timeago.timeAgo(
                                                                              dateTime1),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                          style:
                                                                              const TextStyle(
                                                                            fontSize:
                                                                                10,
                                                                            color: Color.fromARGB(
                                                                                255,
                                                                                218,
                                                                                218,
                                                                                218),
                                                                            fontWeight:
                                                                                FontWeight.w400,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                              (cm['uid'] ==
                                                                      widget
                                                                          .uid)
                                                                  ? Container(
                                                                      height: 0,
                                                                    )
                                                                  : Padding(
                                                                      padding: const EdgeInsets
                                                                              .only(
                                                                          top:
                                                                              5,
                                                                          bottom:
                                                                              6.0),
                                                                      child:
                                                                          Text(
                                                                        cm['cmt'],
                                                                        maxLines:
                                                                            10,
                                                                        style: const TextStyle(
                                                                            fontSize:
                                                                                12,
                                                                            color:
                                                                                Colors.white,
                                                                            fontWeight: FontWeight.w400),
                                                                      ),
                                                                    ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              );
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            });
                          },
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(15, 0, 10, 10),
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          width: MediaQuery.of(context).size.width / 1.1,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 28, 28, 28),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  children: [
                                    const Text(
                                      'Bình luận',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white),
                                    ),
                                    StreamBuilder(
                                      stream: getcmt
                                          .doc(widget.id)
                                          .collection('comment')
                                          .snapshots(),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<QuerySnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: Text(
                                              '  0',
                                              style: TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          );
                                        } else {
                                          return Text(
                                            '  ${snapshot.data!.size}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 225, 220, 220),
                                                fontWeight: FontWeight.w400),
                                          );
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color:
                                        const Color.fromARGB(255, 36, 36, 36),
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  child: const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      '  Viết bình luận...',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.white70),
                                    ),
                                  ),
                                  height: 35,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(15, 10, 10, 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: const [
                          Text(
                            'Dành cho bạn',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w400,
                              color: Color.fromARGB(255, 237, 234, 234),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            height: 3,
                            width: 95,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 226, 69, 16),
                                  Color.fromRGBO(232, 87, 9, 1),
                                  Color.fromRGBO(241, 110, 16, 1),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(
                      height: 0.5,
                      color: Color.fromARGB(174, 109, 109, 109),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                color: const Color.fromARGB(255, 18, 18, 18),
                height: 190,
                child: RelateWidgetH(
                    tloai: widget.category,
                    title: widget.title,
                    notifyIsMountedFn: addHistory),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future downloadFile() async {
    final teamp = await getTemporaryDirectory();
    final path = '${teamp.path}/${widget.title}.mp4';

    if (await File('/storage/emulated/0/dcim/FireMovie/${widget.title}.mp4')
        .exists()) {
      //OpenFile.open('/storage/emulated/0/dcim/FireMovie/${widget.title}.mp4');
      print("File exists");
    } else {
      await Dio().download(widget.trailer, path);
      await GallerySaver.saveVideo(path, toDcim: true, albumName: 'FireMovie');
    }
    // print(path);
  }

  void _showDownOK(BuildContext context, String value) {
    // ignore: prefer_const_constructors
    final snack = SnackBar(
      padding: const EdgeInsets.all(0),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 20,
          ),
          Lottie.asset('assets/images/Download.json', width: 50, height: 50),
        ],
      ),
      backgroundColor: const Color.fromARGB(255, 6, 82, 82),
      duration: const Duration(seconds: 10),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _showOK(BuildContext context, String value) {
    // ignore: prefer_const_constructors
    final snack = SnackBar(
      content: Text(
        value,
        style: const TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color.fromARGB(255, 6, 82, 82),
      duration: const Duration(seconds: 2),
      // shape: const StadiumBorder(),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _showNoOK(BuildContext context, String value) {
    // ignore: prefer_const_constructors
    final snack = SnackBar(
      content: Text(
        value,
        style: const TextStyle(fontSize: 15),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color.fromARGB(255, 2, 49, 49),
      duration: const Duration(seconds: 2),

      // shape: const StadiumBorder(),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
