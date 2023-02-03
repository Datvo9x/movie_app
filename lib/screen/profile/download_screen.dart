import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:lottie/lottie.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class DownLoadsUser extends StatefulWidget {
  const DownLoadsUser({
    Key? key,
    required this.uid,
    required this.name,
    required this.photoUrl,
  }) : super(key: key);
  final String uid, name, photoUrl;
  @override
  _DownLoadsUserState createState() => _DownLoadsUserState();
}

enum MenuItem {
  item1,
  item2,
}

class _DownLoadsUserState extends State<DownLoadsUser> {
  bool newC = true;
  bool checkselec = false;
  late String loc = 'Mới nhất';
  CollectionReference getfaUser =
      FirebaseFirestore.instance.collection('users');
  finaldelete(String document) {
    getfaUser.doc(widget.uid).collection('download').doc(document).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 35, 39),
        title: const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Center(
            child: Text(
              " Đã tải về",
            ),
          ),
        ),
        actions: [
          Center(
              child: SizedBox(
            width: 48,
            child: Text(
              loc.toString(),
              style: const TextStyle(
                  color: Color.fromARGB(221, 218, 218, 218), fontSize: 11),
            ),
          )),
          PopupMenuButton<MenuItem>(
              color: const Color.fromARGB(255, 22, 25, 34),
              icon: const Icon(Icons.filter_alt_rounded),
              onSelected: ((value) {
                if (value == MenuItem.item1) {
                  setState(() {
                    loc = 'Mới nhất';
                    newC = true;
                  });
                } else if (value == MenuItem.item2) {
                  setState(() {
                    loc = 'Cũ nhất';
                    newC = false;
                  });
                }
              }),
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: MenuItem.item1,
                      child: Text(
                        'Mới nhất',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const PopupMenuItem(
                      value: MenuItem.item2,
                      child: Text(
                        'Cũ nhất',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    PopupMenuItem(
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            builder: (context) => AlertDialog(
                              shape: const RoundedRectangleBorder(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(18.0),
                                ),
                              ),
                              title: const Center(
                                child: Text(
                                  'Xóa tất cả lịch sử ?',
                                  style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              actions: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextButton(
                                        child: Container(
                                          height: 30,
                                          width: 85,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 223, 131, 10),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Text(
                                            'Không',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                      TextButton(
                                        child: Container(
                                          height: 30,
                                          width: 85,
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                              color: const Color.fromARGB(
                                                  255, 232, 230, 228),
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: const Text(
                                            'Vẫn Xóa',
                                            style: TextStyle(
                                                color: Color.fromARGB(
                                                    255, 215, 98, 30),
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        onPressed: () async {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                          _showOK(context,
                                              'Đã xóa toàn bộ yêu thích');
                                          var snapshots = await getfaUser
                                              .doc(widget.uid)
                                              .collection('favorite')
                                              .get();
                                          for (var doc in snapshots.docs) {
                                            await doc.reference.delete();
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
                        child: const Text(
                          'Xóa tất cả',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ]),
        ],
      ),
      body: StreamBuilder(
        stream: getfaUser
            .doc(widget.uid)
            .collection('download')
            // .orderBy('timeview', descending: false)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot dowload = snapshot.data!.docs[index];
                return Slidable(
                  key: ValueKey(dowload),
                  endActionPane: ActionPane(
                    extentRatio: 0.7,
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () async {
                      await finaldelete(dowload.id);
                      _showOK(context, 'Đã xóa khỏi bộ sưu tập');
                    }),
                    children: [
                      // SlidableAction(
                      //   onPressed: (context) async {
                      //     await Share.share(
                      //       'Chia sẻ ngay phim - \n${dowload['title']}\n${dowload['imageUrl']}',
                      //     );
                      //   },
                      //   backgroundColor:
                      //       const Color.fromARGB(255, 11, 158, 119),
                      //   foregroundColor: Colors.white,
                      //   icon: Icons.share,
                      //   label: 'Chia sẻ',
                      // ),
                      SlidableAction(
                        onPressed: (context) async {
                          await finaldelete(dowload.id);
                          _showOK(context, 'Đã xóa khỏi bộ sưu tập');
                          const Duration(seconds: 2);
                        },
                        backgroundColor: const Color(0xFFFE4A49),
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Xóa',
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    onTap: () {
                      downloadFile(dowload['title'], dowload['trailer']);
                    },
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(5, 10, 5, 0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 80,
                            width: 130,
                            decoration: BoxDecoration(
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(
                                  dowload['imageUrl'],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding:
                                    const EdgeInsets.fromLTRB(5.0, 3, 0, 3),
                                width: 220,
                                child: Text(
                                  "${dowload['title']}",
                                  maxLines: 2,
                                  style: const TextStyle(
                                      fontSize: 14,
                                      color: Color.fromARGB(255, 224, 224, 224),
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5.0, 3, 0, 3),
                                child: Text(
                                  "${dowload['category']}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 201, 201, 201),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(5.0, 3, 0, 3),
                                child: Text(
                                  "${dowload['duration']}",
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: Color.fromARGB(255, 201, 201, 201),
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  Future downloadFile(String title, String trailer) async {
    final teamp = await getTemporaryDirectory();
    final path = '${teamp.path}/$title.mp4';

    if (await File("/storage/emulated/0/dcim/FireMovie/$title.mp4").exists()) {
      OpenFile.open("/storage/emulated/0/dcim/FireMovie/$title.mp4");
      print("File exists");
    } else {
      showDialog(
        builder: (context) => AlertDialog(
          backgroundColor: const Color.fromARGB(255, 24, 24, 24),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(18.0),
            ),
          ),
          title: const Text(
            'Phim bị lỗi',
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          content: const Text(
            'Bạn có muốn tải lại ?',
            style: TextStyle(
                fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
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
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 232, 230, 228),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                            color: Color.fromARGB(255, 215, 98, 30),
                            fontWeight: FontWeight.w600),
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
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 223, 131, 10),
                            borderRadius: BorderRadius.circular(20)),
                        child: const Text(
                          'Tải',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                      onTap: () async {
                        Navigator.pop(context);
                        _showDownOK(context, 'Đang tải phim về ');
                        await Dio().download(trailer, path);
                        await GallerySaver.saveVideo(path,
                            toDcim: true, albumName: 'FireMovie');
                      }),
                ],
              ),
            ),
          ],
        ),
        context: context,
      );
    }
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
      duration: const Duration(seconds: 6),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }

  void _showOK(BuildContext context, String valu) {
    // ignore: prefer_const_constructors
    final snack = SnackBar(
      content: Text(
        valu,
        style: const TextStyle(fontSize: 14),
        textAlign: TextAlign.center,
      ),
      backgroundColor: const Color.fromARGB(255, 49, 124, 53),
      duration: const Duration(seconds: 2),

      // shape: const StadiumBorder(),
    );
    ScaffoldMessenger.of(context).showSnackBar(snack);
  }
}
