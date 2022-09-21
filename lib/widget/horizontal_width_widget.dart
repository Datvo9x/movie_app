import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/widget/playvideo_widget.dart';

class HorizontalWidgetW extends StatefulWidget {
  const HorizontalWidgetW({Key? key}) : super(key: key);

  @override
  _HorizontalWidgetWState createState() => _HorizontalWidgetWState();
}

class _HorizontalWidgetWState extends State<HorizontalWidgetW> {
  CollectionReference getmovieW =
      FirebaseFirestore.instance.collection('movie');

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
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return SizedBox(
                width: 190,
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.fromLTRB(3, 8, 5, 5),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 110,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(6.0),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      snapshot.data!.docs[index]['imageUrl']),
                                ),
                              ),
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Color.fromARGB(255, 192, 118, 33),
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(6),
                                  topRight: Radius.circular(6),
                                ),
                              ),
                              width: 54,
                              padding: const EdgeInsets.all(4),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${snapshot.data!.docs[index]['rating']}  ",
                                    style: const TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 1.0),
                                    child: Icon(
                                      Icons.star,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding:
                            const EdgeInsets.only(left: 5.0, top: 4, bottom: 4),
                        child: Text(
                          snapshot.data!.docs[index]['title'],
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color.fromRGBO(250, 246, 245, 1),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
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
