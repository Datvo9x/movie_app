import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:movie_app/screen/playvideo_screen.dart';
import 'package:share_plus/share_plus.dart';

class FavoritesUser extends StatefulWidget {
  const FavoritesUser({
    Key? key,
    required this.uid,
    required this.name,
    required this.photoUrl,
  }) : super(key: key);
  final String uid, name, photoUrl;
  @override
  _FavoritesUserState createState() => _FavoritesUserState();
}

enum MenuItem {
  item1,
  item2,
}

class _FavoritesUserState extends State<FavoritesUser> {
  bool newC = true;
  bool checkselec = false;
  late String loc = 'Mới nhất';
  CollectionReference getfaUser =
      FirebaseFirestore.instance.collection('users');
  finaldelete(String document) {
    getfaUser.doc(widget.uid).collection('favorite').doc(document).delete();
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
              " Bộ sưu tập",
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
        stream: newC
            ? getfaUser
                .doc(widget.uid)
                .collection('favorite')
                .orderBy('timeview', descending: true)
                .snapshots()
            : getfaUser
                .doc(widget.uid)
                .collection('favorite')
                .orderBy('timeview', descending: false)
                .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: snapshot.data!.size,
              itemBuilder: (context, index) {
                DocumentSnapshot farU = snapshot.data!.docs[index];
                return Slidable(
                  key: ValueKey(farU),
                  endActionPane: ActionPane(
                    extentRatio: 0.7,
                    motion: const ScrollMotion(),
                    dismissible: DismissiblePane(onDismissed: () async {
                      await finaldelete(farU.id);
                      _showOK(context, 'Đã xóa khỏi bộ sưu tập');
                    }),
                    children: [
                      SlidableAction(
                        onPressed: (context) async {
                          await Share.share(
                            'Chia sẻ ngay phim - \n${farU['title']}\n${farU['imageUrl']}',
                          );
                        },
                        backgroundColor:
                            const Color.fromARGB(255, 11, 158, 119),
                        foregroundColor: Colors.white,
                        icon: Icons.share,
                        label: 'Chia sẻ',
                      ),
                      SlidableAction(
                        onPressed: (context) async {
                          await finaldelete(farU.id);
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoMovie(
                            category: farU['category'],
                            year: farU['year'],
                            description: farU['description'],
                            duration: farU['duration'],
                            rating: farU['rating'],
                            imageUrl: farU['imageUrl'],
                            trailer: farU["trailer"],
                            title: farU["title"],
                            view: farU['view'],
                            id: farU['id'],
                            uid: widget.uid.toString(),
                            name: widget.name.toString(),
                            photoUrl: widget.photoUrl.toString(),
                          ),
                        ),
                      );
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
                                  farU['imageUrl'],
                                ),
                              ),
                            ),
                            child: Stack(
                              children: [
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.all(6.0),
                                    child: Container(
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 216, 135, 42),
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8),
                                        ),
                                      ),
                                      width: 30,
                                      padding: const EdgeInsets.only(
                                          left: 3, right: 3, top: 2, bottom: 2),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "${farU['rating']} ",
                                            style: const TextStyle(
                                                fontSize: 8,
                                                color: Colors.white,
                                                fontWeight: FontWeight.w600),
                                          ),
                                          const Padding(
                                            padding:
                                                EdgeInsets.only(bottom: 1.0),
                                            child: Icon(
                                              Icons.star,
                                              size: 8,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
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
                                  "${farU['title']}",
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
                                  "${farU['category']}",
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
                                  "${farU['duration']}",
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
