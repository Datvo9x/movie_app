import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screen/playvideo_screen.dart';
import '../providers/auth_provider.dart';
import 'login/login_screen.dart';

class ListFilmPage extends StatefulWidget {
  const ListFilmPage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _ListFilmPageState createState() => _ListFilmPageState();
}

enum MenuItem {
  item1,
  item2,
  item3,
}
var snapshot1;

class _ListFilmPageState extends State<ListFilmPage> {
  CollectionReference getP = FirebaseFirestore.instance.collection('movie');
  bool checklogin = false;
  bool checkselec = false;
  late AuthProvider authProvider;
  String? uid, name, photoUrl;
  late String loc = 'Mới nhất';

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return const LoginScreen();
      },
    );
  }

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 35, 39),
        title: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              widget.title,
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
                    checkselec = true;
                    snapshot1 = getP
                        .where('category', isEqualTo: widget.title)
                        .orderBy('year', descending: true)
                        .snapshots();
                  });
                } else if (value == MenuItem.item2) {
                  setState(() {
                    loc = 'Lượt xem';
                    checkselec = true;
                    snapshot1 = (getP
                        .where('category', isEqualTo: widget.title)
                        .orderBy('view', descending: true)
                        .snapshots());
                  });
                } else if (value == MenuItem.item3) {
                  setState(() {
                    loc = 'Từ  A - Z';
                    checkselec = true;
                    snapshot1 = getP
                        .where('category', isEqualTo: widget.title)
                        .orderBy('title', descending: false)
                        .snapshots();
                  });
                }
              }),
              itemBuilder: (context) => [
                    const PopupMenuItem(
                      enabled: true,
                      value: MenuItem.item1,
                      child: Text(
                        'Mới nhất',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const PopupMenuItem(
                      value: MenuItem.item2,
                      child: Text(
                        'Lượt xem',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    const PopupMenuItem(
                      value: MenuItem.item3,
                      child: Text(
                        'Từ  A  -  Z',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ]),
        ],
      ),
      body: StreamBuilder(
        stream: checkselec
            ? snapshot1
            : getP
                .where('category', isEqualTo: widget.title)
                .orderBy('year', descending: true)
                .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          } else {
            return Padding(
              padding: const EdgeInsets.all(5),
              child: GridView.builder(
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 5 / 7,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2,
                ),
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data!.size,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];

                  return SizedBox(
                    width: 120,
                    height: 140,
                    child: GestureDetector(
                      onTap: () {
                        checklogin
                            ? Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VideoMovie(
                                    photoUrl: photoUrl.toString(),
                                    year: ds['year'],
                                    category: ds['category'],
                                    description: ds['description'],
                                    duration: ds['duration'],
                                    rating: ds['rating'],
                                    imageUrl: ds['imageUrl'],
                                    trailer: ds["trailer"],
                                    title: ds["title"],
                                    view: ds['view'],
                                    id: ds.id,
                                    uid: uid.toString(),
                                    name: name.toString(),
                                  ),
                                ),
                              )
                            : _dialogBuilder(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(4, 4, 4, 4),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(0.0),
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                ds['imageUrl'],
                              ),
                            ),
                          ),
                          // child: Stack(
                          //   children: [
                          //     Positioned(
                          //       top: 0,
                          //       left: 0,
                          //       child: Padding(
                          //         padding: const EdgeInsets.all(6.0),
                          //         child: Container(
                          //           decoration: const BoxDecoration(
                          //             color: Color.fromARGB(255, 216, 135, 42),
                          //             borderRadius: BorderRadius.all(
                          //               Radius.circular(8),
                          //             ),
                          //           ),
                          //           width: 35,
                          //           padding: const EdgeInsets.only(
                          //               left: 3, right: 3, top: 2, bottom: 2),
                          //           child: Row(
                          //             mainAxisAlignment: MainAxisAlignment.center,
                          //             children: [
                          //               Text(
                          //                 "${snapshot.data!.docs[index]['rating']} ",
                          //                 style: const TextStyle(
                          //                     fontSize: 9,
                          //                     color: Colors.white,
                          //                     fontWeight: FontWeight.w600),
                          //               ),
                          //               const Padding(
                          //                 padding: EdgeInsets.only(bottom: 1.0),
                          //                 child: Icon(
                          //                   Icons.star,
                          //                   size: 9,
                          //                   color: Colors.white,
                          //                 ),
                          //               ),
                          //             ],
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //   ],
                          // ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
