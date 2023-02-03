import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/screen/login/login_screen.dart';
import 'package:movie_app/screen/playvideo_screen.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';

class HorizontalWidgetH1 extends StatefulWidget {
  const HorizontalWidgetH1({
    Key? key,
    required this.tloai,
  }) : super(key: key);
  final String tloai;
  @override
  _HorizontalWidgetH1State createState() => _HorizontalWidgetH1State();
}

class _HorizontalWidgetH1State extends State<HorizontalWidgetH1> {
  bool checklogin = false;
  late AuthProvider authProvider;

  String? uid, name, photoUrl;

  CollectionReference getmovieH =
      FirebaseFirestore.instance.collection('movie');

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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('movie')
          .where('country', isEqualTo: widget.tloai)
          .orderBy('year', descending: true)
          .orderBy('view', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 6,
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
                    padding: const EdgeInsets.fromLTRB(6.5, 6.5, 6.5, 6.5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            snapshot.data!.docs[index]['imageUrl'],
                          ),
                        ),
                      ),
                      // child: Stack(
                      //   children: [
                      //     Positioned(
                      //       top: 0,
                      //       left: 0,
                      //       // child: Padding(
                      //       //   padding: const EdgeInsets.all(6.0),
                      //       //   child: Container(
                      //       //     decoration: const BoxDecoration(
                      //       //       color: Color.fromARGB(255, 216, 135, 42),
                      //       //       borderRadius: BorderRadius.all(
                      //       //         Radius.circular(8),
                      //       //       ),
                      //       //     ),
                      //       //     width: 30,
                      //       //     padding: const EdgeInsets.only(
                      //       //         left: 3, right: 3, top: 2, bottom: 2),
                      //       //     child: Row(
                      //       //       mainAxisAlignment: MainAxisAlignment.center,
                      //       //       children: [
                      //       //         Text(
                      //       //           "${snapshot.data!.docs[index]['rating']} ",
                      //       //           style: const TextStyle(
                      //       //               fontSize: 8,
                      //       //               color: Colors.white,
                      //       //               fontWeight: FontWeight.w600),
                      //       //         ),
                      //       //         const Padding(
                      //       //           padding: EdgeInsets.only(bottom: 1.0),
                      //       //           child: Icon(
                      //       //             Icons.star,
                      //       //             size: 8,
                      //       //             color: Colors.white,
                      //       //           ),
                      //       //         ),
                      //       //       ],
                      //       //     ),
                      //       //   ),
                      //       // ),
                      //     ),
                      //   ],
                      // ),
                    ),
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
