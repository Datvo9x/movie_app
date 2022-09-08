import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/widget/playvideo_widget.dart';

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
                width: 140,
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
                        padding: const EdgeInsets.fromLTRB(3, 8, 8, 5),
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 180,
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
                              padding: const EdgeInsets.all(5),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    snapshot.data!.docs[index]['duration'],
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.white70,
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
                      Padding(
                        padding: const EdgeInsets.only(left: 5.0),
                        child: Text(
                          'Thời lượng: ${snapshot.data!.docs[index]['duration']}',
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.white70,
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
