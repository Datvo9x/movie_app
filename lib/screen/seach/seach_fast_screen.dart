import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screen/seach/seach_play.dart';
import 'package:tiengviet/tiengviet.dart';
import '../../providers/auth_provider.dart';
import '../login/login_screen.dart';

class SeachFast extends StatefulWidget {
  const SeachFast({Key? key}) : super(key: key);

  @override
  _SeachFastState createState() => _SeachFastState();
}

class _SeachFastState extends State<SeachFast> {
  bool checklogin = false;
  late AuthProvider authProvider;
  String? uid, name, photoUrl;
  final _controller = TextEditingController();
  CollectionReference getP = FirebaseFirestore.instance.collection('fastfilm');

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
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 37, 36, 36),
          leading: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                size: 25,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search_sharp,
                size: 25,
              ),
              onPressed: () {
                setState(() {
                  _controller.text = TiengViet.parse(_controller.text);
                });
              },
            ),
          ],
          bottom: const TabBar(
              indicatorColor: Color.fromARGB(255, 215, 121, 14),
              tabs: [
                Tab(
                  text: 'Phổ biến',
                ),
                Tab(
                  text: 'Mới nhất',
                ),
                Tab(
                  text: 'Lượt xem',
                ),
              ]),
          leadingWidth: 40,
          titleSpacing: 10,
          title: Container(
            height: 40,
            width: 250,
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 69, 68, 68),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TextFormField(
              controller: _controller,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                suffixIcon: GestureDetector(
                    child:
                        const Icon(Icons.cancel_rounded, color: Colors.white70),
                    onTap: () {
                      setState(() {
                        _controller.clear();
                      });
                    }),
                prefixIcon: const Icon(Icons.search, color: Colors.white70),
                hintText: 'Tên phim | Thể loại | Tác giả...',
                hintStyle: const TextStyle(
                  color: Colors.white70,
                ),
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                disabledBorder: InputBorder.none,
              ),
              onEditingComplete: () {
                setState(() {
                  _controller.text = TiengViet.parse(_controller.text);
                });
              },
            ),
          ),
        ),
        body: TabBarView(children: [
          Container(
            color: const Color.fromARGB(255, 26, 25, 25),
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('fastfilm').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (_controller.text.isEmpty) {
                    return Container(
                      color: const Color.fromARGB(255, 26, 25, 25),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot<Object?>? data =
                            snapshot.data?.docs[index];
                        if ((TiengViet.parse(data!['nameFast'])
                                .toString()
                                .toLowerCase()
                                .contains(_controller.text.toLowerCase())) ||
                            (TiengViet.parse(data['cateFast'])
                                .toString()
                                .toLowerCase()
                                .contains(_controller.text.toLowerCase()))) {
                          return SizedBox(
                            child: GestureDetector(
                              onTap: () {
                                checklogin
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FastReplace(
                                            cateFast: data['cateFast'],
                                            desFast: data['desFast'],
                                            videoFast: data['videoFast'],
                                            nameFast: data['nameFast'],
                                            view: data['view'],
                                            id: data.id,
                                            photoUrl: photoUrl.toString(),
                                            uid: uid.toString(),
                                            name: name.toString(),
                                          ),
                                        ),
                                      )
                                    : _dialogBuilder(context);
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    data['imageFast']),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 220,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              data['nameFast'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              'Thể loại: ${data['cateFast']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              'Lượt xem: ${data['view']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    );
                  }
                }
              },
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 26, 25, 25),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('fastfilm')
                  .orderBy("view", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (_controller.text.isEmpty) {
                    return Container(
                      color: const Color.fromARGB(255, 26, 25, 25),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot<Object?>? data =
                            snapshot.data?.docs[index];
                        if ((TiengViet.parse(data!['nameFast'])
                                .toString()
                                .toLowerCase()
                                .contains(_controller.text.toLowerCase())) ||
                            (TiengViet.parse(data['cateFast'])
                                .toString()
                                .toLowerCase()
                                .contains(_controller.text.toLowerCase()))) {
                          return SizedBox(
                            child: GestureDetector(
                              onTap: () {
                                checklogin
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FastReplace(
                                            cateFast: data['year'],
                                            desFast: data['category'],
                                            videoFast: data['description'],
                                            nameFast: data['duration'],
                                            view: data['view'],
                                            id: data.id,
                                            photoUrl: photoUrl.toString(),
                                            uid: uid.toString(),
                                            name: name.toString(),
                                          ),
                                        ),
                                      )
                                    : _dialogBuilder(context);
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    data['imageFast']),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 220,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              data['nameFast'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              'Thể loại : ${data['cateFast']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              'Lượt xem: ${data['view']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    );
                  }
                }
              },
            ),
          ),
          Container(
            color: const Color.fromARGB(255, 26, 25, 25),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('fastfilm')
                  .orderBy("view", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  if (_controller.text.isEmpty) {
                    return Container(
                      color: const Color.fromARGB(255, 26, 25, 25),
                    );
                  } else {
                    return ListView.builder(
                      padding: const EdgeInsets.all(10),
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        QueryDocumentSnapshot<Object?>? data =
                            snapshot.data?.docs[index];
                        if ((TiengViet.parse(data!['nameFast'])
                                .toString()
                                .toLowerCase()
                                .contains(_controller.text.toLowerCase())) ||
                            (TiengViet.parse(data['cateFast'])
                                .toString()
                                .toLowerCase()
                                .contains(_controller.text.toLowerCase()))) {
                          return SizedBox(
                            child: GestureDetector(
                              onTap: () {
                                checklogin
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => FastReplace(
                                            cateFast: data['year'],
                                            desFast: data['category'],
                                            videoFast: data['description'],
                                            nameFast: data['duration'],
                                            view: data['view'],
                                            id: data.id,
                                            photoUrl: photoUrl.toString(),
                                            uid: uid.toString(),
                                            name: name.toString(),
                                          ),
                                        ),
                                      )
                                    : _dialogBuilder(context);
                              },
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10.0),
                                      child: Stack(
                                        alignment: Alignment.topRight,
                                        children: [
                                          Container(
                                            height: 100,
                                            width: 160,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(0),
                                              image: DecorationImage(
                                                fit: BoxFit.cover,
                                                image: NetworkImage(
                                                    data['imageFast']),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 220,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              data['nameFast'],
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 2,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 16,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              'Thể loại : ${data['cateFast']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                          Container(
                                            padding: const EdgeInsets.only(
                                                left: 5, top: 0, bottom: 5),
                                            child: Text(
                                              'Lượt xem: ${data['view']}',
                                              style: const TextStyle(
                                                  fontSize: 14,
                                                  color: Colors.white70),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }
                        return Container();
                      },
                    );
                  }
                }
              },
            ),
          ),
        ]),
      ),
    );
  }
}
