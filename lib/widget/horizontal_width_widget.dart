import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/screen/playvideo_screen.dart';
import 'package:provider/provider.dart';
import '../modal/timeago.dart';
import '../providers/auth_provider.dart';

class HorizontalWidgetW extends StatefulWidget {
  const HorizontalWidgetW({Key? key}) : super(key: key);

  @override
  _HorizontalWidgetWState createState() => _HorizontalWidgetWState();
}

class _HorizontalWidgetWState extends State<HorizontalWidgetW> {
  bool checklogin = false;
  late AuthProvider authProvider;
  String? uid, name, photoUrl;
  CollectionReference getmovieW =
      FirebaseFirestore.instance.collection('movie');

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Thông báo'),
          content: const Text('Đăng nhập đi rồi xem .'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Xác nhận'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    authProvider = context.read<AuthProvider>();
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      checklogin = true;
      uid = authProvider.getUserFirebaseId().toString();
      name = authProvider.getUserFirebaseName().toString();
      photoUrl = authProvider.getUserFirebaseImage().toString();
    } else {
      checklogin = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('movie')
          .orderBy('timeput', descending: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Center();
        } else {
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              DateTime dateTime =
                  snapshot.data!.docs[index]['timeput'].toDate();
              return SizedBox(
                width: 190,
                child: GestureDetector(
                  onTap: () {
                    checklogin
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoMovie(
                                photoUrl: photoUrl.toString(),
                                uid: uid.toString(),
                                name: name.toString(),
                                year: snapshot.data!.docs[index]['year'],
                                category: snapshot.data!.docs[index]
                                    ['category'],
                                description: snapshot.data!.docs[index]
                                    ['description'],
                                duration: snapshot.data!.docs[index]
                                    ['duration'],
                                rating: snapshot.data!.docs[index]['rating'],
                                imageUrl: snapshot.data!.docs[index]
                                    ['imageUrl'],
                                trailer: snapshot.data!.docs[index]["trailer"],
                                view: snapshot.data!.docs[index]['view'],
                                title: snapshot.data!.docs[index]["title"],
                                id: snapshot.data!.docs[index].id,
                              ),
                            ),
                          )
                        : _dialogBuilder(context);
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
                          Timeago.timeAgo(dateTime),
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
