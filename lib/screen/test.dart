import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widget/playvideo_widget.dart';

class CloudFirestoreSearch1 extends StatefulWidget {
  const CloudFirestoreSearch1({Key? key}) : super(key: key);

  @override
  _CloudFirestoreSearch1State createState() => _CloudFirestoreSearch1State();
}

class _CloudFirestoreSearch1State extends State<CloudFirestoreSearch1> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        leadingWidth: 40,
        titleSpacing: 10,
        title: Container(
          height: 40,
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 69, 68, 68),
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            style: const TextStyle(color: Colors.white),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search, color: Colors.white70),
              hintText: 'Tên phim | Thể loại | Tác giả...',
              hintStyle: TextStyle(color: Colors.white70),
              border: InputBorder.none,
              focusedBorder: InputBorder.none,
              enabledBorder: InputBorder.none,
              errorBorder: InputBorder.none,
              disabledBorder: InputBorder.none,
            ),
            onChanged: (val) {
              setState(() {
                name = val;
              });
            },
          ),
        ),
      ),
      body: Container(
        color: const Color.fromARGB(255, 26, 25, 25),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('movie').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              if (name.isEmpty) {
                return Container(
                  color: Colors.red,
                  child: Text('dsfsds'),
                );
              } else {
                return ListView.builder(
                  padding: const EdgeInsets.all(15),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    QueryDocumentSnapshot<Object?>? data =
                        snapshot.data?.docs[index];
                    if (data!['title']
                        .toString()
                        .toLowerCase()
                        .startsWith(name.toLowerCase())) {
                      return SizedBox(
                          child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => VideoMovie(
                                imageUrl: data['imageUrl'],
                                trailer: data['trailer'],
                                title: data['title'],
                              ),
                            ),
                          );
                        },
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    Container(
                                      height: 100,
                                      width: 160,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(6),
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(data['imageUrl']),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      decoration: const BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 215, 128, 14),
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(6),
                                          topRight: Radius.circular(6),
                                        ),
                                      ),
                                      padding: const EdgeInsets.all(5),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            " ${data['rating']}  ",
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: Colors.white,
                                            ),
                                          ),
                                          const Padding(
                                            padding: EdgeInsets.only(
                                                bottom: 1.0, right: 2),
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
                              SizedBox(
                                width: 200,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 0, bottom: 5),
                                      child: Text(
                                        data['title'],
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
                                        'Thời lượng: ${data['duration']}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 0, bottom: 5),
                                      child: Text(
                                        'Thể loại: ${data['year']}',
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
                      ));
                    }
                    return Container();
                  },
                );
              }
            }
          },
        ),
      ),
    );
  }
}
