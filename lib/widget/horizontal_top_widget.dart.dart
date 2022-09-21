import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/constract/title_gradient.dart';
import 'package:movie_app/widget/playvideo_widget.dart';

class HorizontalWidgetT extends StatefulWidget {
  const HorizontalWidgetT({Key? key}) : super(key: key);

  @override
  _HorizontalWidgetTState createState() => _HorizontalWidgetTState();
}

class _HorizontalWidgetTState extends State<HorizontalWidgetT> {
  CollectionReference getmovieW =
      FirebaseFirestore.instance.collection('movie');
  List count = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getmovieW.get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center();
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 120,
                height: 150,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => VideoMovie(
                          trailer: snapshot.data!.docs[index]["trailer"],
                          title: snapshot.data!.docs[index]["title"],
                          imageUrl: snapshot.data!.docs[index]["imageUrl"],
                        ),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(3, 8, 5, 5),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(0.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(
                            snapshot.data!.docs[index]['imageUrl'],
                          ),
                        ),
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            bottom: -28,
                            right: -10,
                            child: GradientText(
                              count[index].toString(),
                              style: const TextStyle(
                                fontSize: 110,
                                fontWeight: FontWeight.bold,
                              ),
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 218, 122, 48),
                                  Color.fromARGB(255, 222, 233, 9),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 0,
                            left: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Color.fromARGB(255, 216, 135, 42),
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(8),
                                  ),
                                ),
                                width: 35,
                                padding: const EdgeInsets.only(
                                    left: 3, right: 3, top: 2, bottom: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "${snapshot.data!.docs[index]['rating']} ",
                                      style: const TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const Padding(
                                      padding: EdgeInsets.only(bottom: 1.0),
                                      child: Icon(
                                        Icons.star,
                                        size: 9,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   top: 0,
                          //   right: 0,
                          //   child: Padding(
                          //     padding: const EdgeInsets.all(6.0),
                          //     child: Container(
                          //       decoration: const BoxDecoration(
                          //         color: Color.fromARGB(127, 146, 144, 142),
                          //         borderRadius: BorderRadius.all(
                          //           Radius.circular(8),
                          //         ),
                          //       ),
                          //       width: 22,
                          //       padding: const EdgeInsets.only(
                          //           left: 3, right: 3, top: 2, bottom: 2),
                          //       child: Row(
                          //         mainAxisAlignment: MainAxisAlignment.center,
                          //         children: const [
                          //           Text(
                          //             "HD",
                          //             style: TextStyle(
                          //                 fontSize: 9,
                          //                 color: Colors.white,
                          //                 fontWeight: FontWeight.w600),
                          //           ),
                          //         ],
                          //       ),
                          //     ),
                          //   ),
                          // )
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
