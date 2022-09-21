import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../page/title_page.dart';

class HorizontalWidgetH extends StatefulWidget {
  const HorizontalWidgetH({Key? key}) : super(key: key);

  @override
  _HorizontalWidgetHState createState() => _HorizontalWidgetHState();
}

class _HorizontalWidgetHState extends State<HorizontalWidgetH> {
  CollectionReference getmovieH =
      FirebaseFirestore.instance.collection('movie');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getmovieH.get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 120,
                height: 150,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Titlevideo(
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
