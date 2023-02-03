import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/constract/title_gradient.dart';
import 'package:movie_app/screen/playvideo_screen.dart';

import '../providers/auth_provider.dart';
import '../screen/login/login_screen.dart';

class HorizontalWidgetT extends StatefulWidget {
  const HorizontalWidgetT({Key? key}) : super(key: key);

  @override
  _HorizontalWidgetTState createState() => _HorizontalWidgetTState();
}

class _HorizontalWidgetTState extends State<HorizontalWidgetT> {
  CollectionReference getmovieW =
      FirebaseFirestore.instance.collection('movie');
  List count = [1, 2, 3, 4, 5];
  String? uid, name, imageUser;

  bool checklogin = false;
  late AuthProvider authProvider;

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
        imageUser = authProvider.getUserFirebaseImage().toString();
        name = authProvider.getUserFirebaseName().toString();
      });
    } else {
      checklogin = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: getmovieW
          .orderBy('year', descending: true)
          .orderBy('view', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center();
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              DocumentSnapshot topp = snapshot.data!.docs[index];
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
                                photoUrl: imageUser.toString(),
                                year: topp['year'],
                                category: topp['category'],
                                description: topp['description'],
                                duration: topp['duration'],
                                rating: topp['rating'],
                                imageUrl: topp['imageUrl'],
                                trailer: topp["trailer"],
                                title: topp["title"],
                                view: topp["view"],
                                id: topp.id,
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
                            topp['imageUrl'],
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -27,
                            right: -10,
                            child: GradientText(
                              count[index].toString(),
                              style: const TextStyle(
                                fontSize: 100,
                                fontWeight: FontWeight.bold,
                              ),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 214, 96, 5),
                                  Color.fromARGB(255, 222, 233, 9),
                                ],
                              ),
                            ),
                          ),
                          // Positioned(
                          //   top: 0,
                          //   left: 0,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(6.0),
                          //     child: Container(
                          //       decoration: const BoxDecoration(
                          //         color: Color.fromARGB(255, 216, 135, 42),
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(8),
                          //         ),
                          //       ),
                          //       width: 35,
                          //       padding: const EdgeInsets.only(
                          //           left: 3, right: 3, top: 2, bottom: 2),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: [
                          //           Text(
                          //             "${topp['rating']} ",
                          //             style: const TextStyle(
                          //                 fontSize: 9,
                          //                 color: Colors.white,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //           const Padding(
                          //             padding: EdgeInsets.only(bottom: 1.0),
                          //             child: Icon(
                          //               Icons.star,
                          //               size: 9,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
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
