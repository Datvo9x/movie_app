import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:movie_app/screen/login/login_screen1.dart';
import 'package:path_provider/path_provider.dart';
import 'package:preload_page_view/preload_page_view.dart';
import 'package:share_plus/share_plus.dart';
import '../constract/title_gradient.dart';
import '../modal/timeago.dart';
import '../providers/auth_provider.dart';
import '../screen/seach/seach_fast_screen.dart';
import '../widget/fastvideo_widget.dart';

class Fastscreen extends StatefulWidget {
  const Fastscreen({Key? key}) : super(key: key);

  @override
  State<Fastscreen> createState() => _FastscreenState();
}

class _FastscreenState extends State<Fastscreen> {
  bool checklogin = false;
  late AuthProvider authProvider;
  String? uid, name, photoUrl;
  int _pageIndex = 0;

  CollectionReference getmovie =
      FirebaseFirestore.instance.collection('fastfilm');
  CollectionReference getcmt =
      FirebaseFirestore.instance.collection('fastfilm');
  CollectionReference getcmt1 =
      FirebaseFirestore.instance.collection('fastfilm');

  final _controller = TextEditingController();
  bool cmtNew = true;

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      checklogin = true;
      setState(() {
        uid = authProvider.getUserFirebaseId().toString();
        name = authProvider.getUserFirebaseName().toString();
        photoUrl = authProvider.getUserFirebaseImage().toString();
      });
    } else {
      checklogin = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return !checklogin
        ? const Scaffold(body: LoginScreen1())
        : Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Center(
                  //   child: Text('Dành cho bạn'),
                  // ),
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SeachFast(),
                        ),
                      );
                    },
                    icon: const Padding(
                      padding: EdgeInsets.only(right: 10.0),
                      child: Icon(
                        Icons.search,
                        size: 26,
                      ),
                    ),
                  ),
                  // Padding(
                  //   padding: EdgeInsets.only(top: 8.0),
                  //   child: Icon(Icons.camera_alt_outlined),
                  // ),
                ],
              ),
            ),
            body: StreamBuilder(
              stream: getmovie.orderBy('view', descending: true).snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return Container(
                    color: const Color.fromARGB(255, 14, 14, 14),
                  );
                }
                return PreloadPageView.builder(
                  onPageChanged: (int page) {
                    setState(() {
                      _pageIndex = page;
                    });
                  },
                  preloadPagesCount: 1,
                  scrollDirection: Axis.vertical,
                  itemCount: snapshot.data!.size,
                  itemBuilder: (context, index) {
                    DocumentSnapshot data = snapshot.data!.docs[index];
                    return Container(
                      color: const Color.fromARGB(255, 3, 3, 3),
                      child: Stack(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 30.0),
                            child: Center(
                              child: Stack(
                                children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height /
                                        1.9,
                                    child: Fastvideo(
                                      id: data.id,
                                      view: data['view'],
                                      videoFast: data['videoFast'],
                                      currentIndex: index,
                                      pageIndex: _pageIndex,
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 70,
                                    right: 0,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width /
                                                  7,
                                              child: Column(
                                                children: [
                                                  StreamBuilder(
                                                    stream: FirebaseFirestore
                                                        .instance
                                                        .collection('fastfilm')
                                                        .doc(data.id)
                                                        .collection('likeFast')
                                                        .where('id',
                                                            isEqualTo: snapshot
                                                                .data!
                                                                .docs[index]
                                                                .id)
                                                        .snapshots(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                QuerySnapshot>
                                                            snapshot1) {
                                                      if (!snapshot1.hasData) {
                                                        return const Icon(
                                                          Icons.favorite,
                                                          size: 35,
                                                          color: Color.fromARGB(
                                                              255,
                                                              247,
                                                              244,
                                                              244),
                                                        );
                                                      } else {
                                                        return snapshot1.data!
                                                                .docs.isEmpty
                                                            ? IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  await FirebaseFirestore
                                                                      .instance
                                                                      .collection(
                                                                          'fastfilm')
                                                                      .doc(data
                                                                          .id)
                                                                      .collection(
                                                                          'likeFast')
                                                                      .add(
                                                                    {
                                                                      'id': data
                                                                          .id,
                                                                      "timeview":
                                                                          DateTime
                                                                              .now(),
                                                                      "uid":
                                                                          uid,
                                                                    },
                                                                  );
                                                                  _showOK(
                                                                      context,
                                                                      'Đã thích video');
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  size: 35,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          247,
                                                                          244,
                                                                          244),
                                                                ),
                                                              )
                                                            : IconButton(
                                                                onPressed:
                                                                    () async {
                                                                  await getmovie
                                                                      .doc(data
                                                                          .id)
                                                                      .collection(
                                                                          'likeFast')
                                                                      .doc(snapshot1
                                                                          .data!
                                                                          .docs
                                                                          .first
                                                                          .id)
                                                                      .delete();

                                                                  _showOK(
                                                                      context,
                                                                      'Đã xóa khỏi yêu thích');
                                                                },
                                                                icon:
                                                                    const Icon(
                                                                  Icons
                                                                      .favorite,
                                                                  size: 35,
                                                                  color: Color
                                                                      .fromARGB(
                                                                          255,
                                                                          203,
                                                                          82,
                                                                          7),
                                                                ),
                                                              );
                                                      }
                                                    },
                                                  ),
                                                  StreamBuilder(
                                                    stream: getmovie
                                                        .doc(data.id)
                                                        .collection('likeFast')
                                                        .snapshots(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                QuerySnapshot>
                                                            snapshot2) {
                                                      if (!snapshot2.hasData) {
                                                        return const Text(
                                                          ' 0',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white),
                                                        );
                                                      } else {
                                                        return Text(
                                                          " ${snapshot2.data!.size.toString()}",
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  IconButton(
                                                    onPressed: () {
                                                      showModalBottomSheet(
                                                        context: context,
                                                        builder: (BuildContext
                                                            context) {
                                                          return StatefulBuilder(
                                                              builder: (BuildContext
                                                                      context,
                                                                  StateSetter
                                                                      mystate) {
                                                            return Scaffold(
                                                              appBar:
                                                                  PreferredSize(
                                                                preferredSize:
                                                                    const Size
                                                                            .fromHeight(
                                                                        100), // Set this height
                                                                child:
                                                                    Container(
                                                                  color: const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      20,
                                                                      20,
                                                                      20),
                                                                  child: Column(
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            12,
                                                                            0,
                                                                            5,
                                                                            0.0),
                                                                        child:
                                                                            Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            const Text(
                                                                              'Bình luận',
                                                                              style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600),
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
                                                                                    color: cmtNew ? const Color.fromARGB(213, 54, 54, 54) : Colors.transparent,
                                                                                    borderRadius: BorderRadius.circular(14),
                                                                                  ),
                                                                                  child: const Padding(
                                                                                    padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                                                    child: Text(
                                                                                      'Mới nhất',
                                                                                      style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
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
                                                                                  padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                                                                  decoration: BoxDecoration(
                                                                                    color: !cmtNew ? const Color.fromARGB(213, 54, 54, 54) : Colors.transparent,
                                                                                    borderRadius: BorderRadius.circular(14),
                                                                                  ),
                                                                                  child: const Text(
                                                                                    'Cũ nhất',
                                                                                    style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w500),
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
                                                                                  color: const Color.fromARGB(162, 46, 46, 47),
                                                                                  borderRadius: BorderRadius.circular(50),
                                                                                ),
                                                                                child: const Center(child: Icon(Icons.close, color: Colors.white)),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      Padding(
                                                                        padding: const EdgeInsets.fromLTRB(
                                                                            12,
                                                                            0,
                                                                            5,
                                                                            0),
                                                                        child:
                                                                            Row(
                                                                          children: [
                                                                            Container(
                                                                              padding: const EdgeInsets.only(left: 5, right: 10),
                                                                              width: MediaQuery.of(context).size.width / 1.25,
                                                                              decoration: BoxDecoration(
                                                                                color: const Color.fromARGB(255, 69, 68, 68),
                                                                                borderRadius: BorderRadius.circular(8),
                                                                              ),
                                                                              child: TextField(
                                                                                maxLines: 2,
                                                                                minLines: 1,
                                                                                controller: _controller,
                                                                                style: const TextStyle(color: Colors.white, fontSize: 14),
                                                                                decoration: const InputDecoration(
                                                                                  isDense: true,
                                                                                  contentPadding: EdgeInsets.all(10),
                                                                                  hintText: '   Nhập nội dung...',
                                                                                  hintStyle: TextStyle(color: Colors.white70, fontSize: 13),
                                                                                  border: InputBorder.none,
                                                                                  focusedBorder: InputBorder.none,
                                                                                  enabledBorder: InputBorder.none,
                                                                                  errorBorder: InputBorder.none,
                                                                                  disabledBorder: InputBorder.none,
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            IconButton(
                                                                              onPressed: () async {
                                                                                if (_controller.text.trim() == '') {
                                                                                  _showNoOK(context, 'Vui lòng nhập nội dung');
                                                                                } else {
                                                                                  await FirebaseFirestore.instance.collection("fastfilm").doc(data.id).collection('comment').add(
                                                                                    {
                                                                                      "photoUrl": photoUrl,
                                                                                      "id": data.id,
                                                                                      "uid": uid,
                                                                                      "nickname": name,
                                                                                      "cmt": _controller.text,
                                                                                      "timeCmt": DateTime.now(),
                                                                                    },
                                                                                  );

                                                                                  _showOK(context, 'Đã thêm bình luận');
                                                                                }
                                                                                setState(() {
                                                                                  _controller.clear();
                                                                                });
                                                                              },
                                                                              icon: Container(
                                                                                height: 30,
                                                                                width: 30,
                                                                                decoration: BoxDecoration(
                                                                                  color: const Color.fromARGB(255, 69, 68, 68),
                                                                                  borderRadius: BorderRadius.circular(50),
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
                                                                  const Color
                                                                          .fromARGB(
                                                                      255,
                                                                      14,
                                                                      14,
                                                                      14),
                                                              body:
                                                                  SingleChildScrollView(
                                                                child: Column(
                                                                  children: [
                                                                    StreamBuilder(
                                                                      stream: cmtNew
                                                                          ? getcmt
                                                                              .doc(data.id)
                                                                              .collection('comment')
                                                                              .where('uid', isEqualTo: uid)
                                                                              .orderBy('timeCmt', descending: true)
                                                                              .snapshots()
                                                                          : getcmt.doc(data.id).collection('comment').where('uid', isEqualTo: uid).orderBy('timeCmt', descending: false).snapshots(),
                                                                      builder: (BuildContext
                                                                              context,
                                                                          AsyncSnapshot<QuerySnapshot>
                                                                              getcmtt) {
                                                                        if (!getcmtt
                                                                            .hasData) {
                                                                          return const Center(
                                                                            child:
                                                                                Text(''),
                                                                          );
                                                                        } else {
                                                                          return ListView
                                                                              .builder(
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                getcmtt.data!.size,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              DateTime dateTime = getcmtt.data!.docs[index]['timeCmt'].toDate();
                                                                              DocumentSnapshot cm = getcmtt.data!.docs[index];
                                                                              final _controller1 = TextEditingController(text: cm['cmt']);
                                                                              return Padding(
                                                                                padding: const EdgeInsets.fromLTRB(12, 5, 0, 0),
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    Container(
                                                                                      height: 25,
                                                                                      width: 25,
                                                                                      decoration: BoxDecoration(
                                                                                        color: Colors.black,
                                                                                        borderRadius: BorderRadius.circular(50),
                                                                                        image: DecorationImage(
                                                                                          fit: BoxFit.cover,
                                                                                          image: NetworkImage(
                                                                                            cm['photoUrl'],
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    const SizedBox(
                                                                                      width: 8,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 1.38,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          Row(
                                                                                            children: [
                                                                                              Text(
                                                                                                cm['nickname'],
                                                                                                style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                                                                                              ),
                                                                                              const SizedBox(
                                                                                                width: 10,
                                                                                              ),
                                                                                              Text(
                                                                                                Timeago.timeAgo(dateTime),
                                                                                                overflow: TextOverflow.ellipsis,
                                                                                                style: const TextStyle(
                                                                                                  fontSize: 10,
                                                                                                  color: Color.fromARGB(255, 218, 218, 218),
                                                                                                  fontWeight: FontWeight.w400,
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
                                                                                            style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    PopupMenuButton(
                                                                                      color: const Color.fromARGB(255, 41, 41, 41),
                                                                                      icon: const SizedBox(
                                                                                        width: 15,
                                                                                        child: Icon(Icons.more_vert, size: 25, color: Colors.white),
                                                                                      ),
                                                                                      itemBuilder: (context) {
                                                                                        return [
                                                                                          PopupMenuItem(
                                                                                            height: 30,
                                                                                            child: GestureDetector(
                                                                                                onTap: () {
                                                                                                  showDialog(
                                                                                                    builder: (context) => AlertDialog(
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
                                                                                                                  await getcmt.doc(data.id).collection('comment').doc(cm.id).delete();

                                                                                                                  _showOK(context, 'Đã xóa bình luận');
                                                                                                                  Navigator.pop(context);
                                                                                                                  Navigator.pop(context);
                                                                                                                },
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    context: context,
                                                                                                  );
                                                                                                },
                                                                                                child: Row(
                                                                                                  children: const [
                                                                                                    Icon(Icons.delete, size: 20, color: Color.fromARGB(255, 238, 116, 107)),
                                                                                                    Text(
                                                                                                      '     Xóa',
                                                                                                      style: TextStyle(color: Color.fromARGB(255, 238, 116, 107)),
                                                                                                    ),
                                                                                                  ],
                                                                                                )),
                                                                                          ),
                                                                                          PopupMenuItem(
                                                                                            height: 30,
                                                                                            child: GestureDetector(
                                                                                                onTap: () {
                                                                                                  showDialog(
                                                                                                    builder: (context) => AlertDialog(
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
                                                                                                        padding: const EdgeInsets.only(left: 10),
                                                                                                        width: 600,
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
                                                                                                                    await FirebaseFirestore.instance.collection("fastfilm").doc(data.id).collection('comment').doc(cm.id).set(
                                                                                                                      {
                                                                                                                        "photoUrl": photoUrl,
                                                                                                                        "id": data.id,
                                                                                                                        "uid": uid,
                                                                                                                        "nickname": name,
                                                                                                                        "cmt": _controller1.text,
                                                                                                                        "timeCmt": cm['timeCmt'],
                                                                                                                      },
                                                                                                                    );

                                                                                                                    _showOK(context, 'Đã cập nhật bình luận');
                                                                                                                    Navigator.pop(context);
                                                                                                                    Navigator.pop(context);
                                                                                                                  }
                                                                                                                },
                                                                                                              ),
                                                                                                            ],
                                                                                                          ),
                                                                                                        ),
                                                                                                      ],
                                                                                                    ),
                                                                                                    context: context,
                                                                                                  );
                                                                                                },
                                                                                                child: Row(
                                                                                                  children: const [
                                                                                                    Icon(Icons.edit_sharp, size: 20, color: Color.fromARGB(255, 202, 200, 200)),
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
                                                                          ? getcmt1
                                                                              .doc(data.id)
                                                                              .collection('comment')
                                                                              .orderBy('timeCmt', descending: true)
                                                                              .snapshots()
                                                                          : getcmt1.doc(data.id).collection('comment').orderBy('timeCmt', descending: false).snapshots(),
                                                                      builder: (BuildContext
                                                                              context,
                                                                          AsyncSnapshot<QuerySnapshot>
                                                                              getcmtt2) {
                                                                        if (!getcmtt2
                                                                            .hasData) {
                                                                          return const Center(
                                                                            child:
                                                                                CircularProgressIndicator(),
                                                                          );
                                                                        } else {
                                                                          return ListView
                                                                              .builder(
                                                                            physics:
                                                                                const NeverScrollableScrollPhysics(),
                                                                            shrinkWrap:
                                                                                true,
                                                                            itemCount:
                                                                                getcmtt2.data!.size,
                                                                            itemBuilder:
                                                                                (context, index) {
                                                                              DateTime dateTime1 = getcmtt2.data!.docs[index]['timeCmt'].toDate();
                                                                              DocumentSnapshot cm1 = getcmtt2.data!.docs[index];
                                                                              return Padding(
                                                                                padding: const EdgeInsets.fromLTRB(12, 0, 12, 5),
                                                                                child: Row(
                                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                                  children: [
                                                                                    (cm1['uid'] == uid)
                                                                                        ? Container(
                                                                                            height: 0,
                                                                                          )
                                                                                        : Container(
                                                                                            height: 25,
                                                                                            width: 25,
                                                                                            decoration: BoxDecoration(
                                                                                              color: Colors.black,
                                                                                              borderRadius: BorderRadius.circular(50),
                                                                                              image: DecorationImage(
                                                                                                fit: BoxFit.cover,
                                                                                                image: NetworkImage(
                                                                                                  cm1['photoUrl'],
                                                                                                ),
                                                                                              ),
                                                                                            ),
                                                                                          ),
                                                                                    const SizedBox(
                                                                                      width: 10,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: MediaQuery.of(context).size.width / 1.38,
                                                                                      child: Column(
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          (cm1['uid'] == uid)
                                                                                              ? Container(
                                                                                                  height: 0,
                                                                                                )
                                                                                              : Row(
                                                                                                  children: [
                                                                                                    Text(
                                                                                                      cm1['nickname'],
                                                                                                      style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.w600),
                                                                                                    ),
                                                                                                    const SizedBox(
                                                                                                      width: 10,
                                                                                                    ),
                                                                                                    Text(
                                                                                                      Timeago.timeAgo(dateTime1),
                                                                                                      overflow: TextOverflow.ellipsis,
                                                                                                      style: const TextStyle(
                                                                                                        fontSize: 10,
                                                                                                        color: Color.fromARGB(255, 218, 218, 218),
                                                                                                        fontWeight: FontWeight.w400,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                ),
                                                                                          (cm1['uid'] == uid)
                                                                                              ? Container(
                                                                                                  height: 0,
                                                                                                )
                                                                                              : Padding(
                                                                                                  padding: const EdgeInsets.only(top: 5, bottom: 6.0),
                                                                                                  child: Text(
                                                                                                    cm1['cmt'],
                                                                                                    maxLines: 10,
                                                                                                    style: const TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.w400),
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
                                                            );
                                                          });
                                                        },
                                                      );
                                                    },
                                                    icon: const Icon(
                                                      Icons.comment,
                                                      size: 28,
                                                      color: Color.fromARGB(
                                                          255, 255, 255, 255),
                                                    ),
                                                  ),
                                                  StreamBuilder(
                                                    stream: getmovie
                                                        .doc(data.id)
                                                        .collection('comment')
                                                        .snapshots(),
                                                    builder: (BuildContext
                                                            context,
                                                        AsyncSnapshot<
                                                                QuerySnapshot>
                                                            snapshot2) {
                                                      if (!snapshot2.hasData) {
                                                        return const Text(
                                                          '0',
                                                          style: TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w400,
                                                              color:
                                                                  Colors.white),
                                                        );
                                                      } else {
                                                        return Text(
                                                          snapshot2.data!.size
                                                              .toString(),
                                                          style:
                                                              const TextStyle(
                                                                  fontSize: 16,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w400,
                                                                  color: Colors
                                                                      .white),
                                                        );
                                                      }
                                                    },
                                                  ),
                                                  GestureDetector(
                                                    onTap: () {
                                                      showModalBottomSheet(
                                                          backgroundColor:
                                                              const Color
                                                                      .fromARGB(
                                                                  255,
                                                                  28,
                                                                  28,
                                                                  28),
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return SizedBox(
                                                              height: 240,
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .all(
                                                                        20.0),
                                                                child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.article_outlined,
                                                                              size: 25,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 40,
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                print('null');
                                                                                // downloadFile(
                                                                                //   data['videoFast'],
                                                                                //   data['nameFast'],
                                                                                // );
                                                                              },
                                                                              child: const Text(
                                                                                'Hỗ trợ về nội dung',
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                      Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.share,
                                                                              size: 25,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 40,
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                Navigator.pop(context);
                                                                                await Share.share('Chia sẽ ngay với bạn bè ! \n ${data['videoFast']}');
                                                                              },
                                                                              child: const Text(
                                                                                'Chia sẽ ngay',
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                      Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.download_rounded,
                                                                              size: 25,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 40,
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                Navigator.pop(context);
                                                                                downloadFile(
                                                                                  data['videoFast'],
                                                                                  data['nameFast'],
                                                                                );
                                                                              },
                                                                              child: const Text(
                                                                                'Tải video về máy',
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                      Row(
                                                                          children: [
                                                                            const Icon(
                                                                              Icons.error_sharp,
                                                                              size: 25,
                                                                              color: Colors.white,
                                                                            ),
                                                                            const SizedBox(
                                                                              width: 40,
                                                                            ),
                                                                            TextButton(
                                                                              onPressed: () {
                                                                                print('null');
                                                                                // downloadFile(
                                                                                //   data['videoFast'],
                                                                                //   data['nameFast'],
                                                                                // );
                                                                              },
                                                                              child: const Text(
                                                                                'Hỗ trợ về nội dung',
                                                                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400, color: Colors.white),
                                                                              ),
                                                                            )
                                                                          ]),
                                                                    ]),
                                                              ),
                                                            );
                                                          });
                                                    },
                                                    child: const Icon(
                                                      Icons.more_horiz,
                                                      size: 30,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            bottom: 25,
                            left: 10,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  height: 45,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                1.1,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0, bottom: 10),
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['desFast'],
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      255, 231, 231, 231),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width /
                                              1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, bottom: 10),
                                            child: Text(
                                              'Review: ${snapshot.data!.docs[index]['nameFast']}',
                                              style: const TextStyle(
                                                // decoration: TextDecoration.underline,
                                                fontWeight: FontWeight.w500,
                                                fontSize: 18,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, bottom: 10),
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 4, bottom: 4, right: 10, left: 10),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                        width: 0.8,
                                        color: const Color.fromARGB(
                                            193, 218, 233, 46),
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Row(
                                      children: const [
                                        GradientText(
                                          ' Xem Ngay ',
                                          style: TextStyle(
                                            fontSize: 17,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          gradient: LinearGradient(
                                            colors: [
                                              Color.fromARGB(255, 227, 112, 5),
                                              Color.fromARGB(255, 233, 222, 10),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
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
              },
            ),
          );
  }

  Future downloadFile(String pathFast, String titleFast) async {
    final teamp = await getTemporaryDirectory();
    final path = '${teamp.path}/$titleFast.mp4';

    if (await File('/storage/emulated/0/dcim/FastMovie/$titleFast.mp4')
        .exists()) {
      _showNoOK(context, '$titleFast đã có sẵn');
      //OpenFile.open('/storage/emulated/0/dcim/FireMovie/${widget.title}.mp4');
      print("File exists");
    } else {
      _showDown(context, 'Đang tải $titleFast');
      await Dio().download(pathFast, path);
      await GallerySaver.saveVideo(path, toDcim: true, albumName: 'FastMovie');
      _showOK(context, 'Đã tải $titleFast');
    }
    print(path);
  }

  void _showOK(BuildContext context, String value) {
    // ignore: prefer_const_constructors
    final snack = SnackBar(
      content: Text(
        value,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color.fromARGB(255, 10, 146, 114),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 55),
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _showDown(BuildContext context, String value) {
    // ignore: prefer_const_constructors
    final snack = SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            width: 20,
          ),
          Lottie.asset(
            'assets/images/Download.json',
            width: 25,
            height: 25,
            fit: BoxFit.cover,
          ),
        ],
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      padding: const EdgeInsets.fromLTRB(0, 3, 0, 3),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 55),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 10, 84, 84),
      duration: const Duration(seconds: 14),
      // shape: const StadiumBorder(),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _showNoOK(BuildContext context, String value) {
    // ignore: prefer_const_constructors
    final snack = SnackBar(
      content: Text(
        value,
        style: const TextStyle(fontSize: 13),
        textAlign: TextAlign.center,
      ),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(0))),
      padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
      margin: const EdgeInsets.fromLTRB(0, 0, 0, 55),
      behavior: SnackBarBehavior.floating,
      backgroundColor: const Color.fromARGB(255, 10, 84, 84),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
