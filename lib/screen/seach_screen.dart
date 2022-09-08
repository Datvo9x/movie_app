import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../widget/playvideo_widget.dart';

class CloudFirestoreSearch extends StatefulWidget {
  const CloudFirestoreSearch({Key? key}) : super(key: key);

  @override
  _CloudFirestoreSearchState createState() => _CloudFirestoreSearchState();
}

class _CloudFirestoreSearchState extends State<CloudFirestoreSearch> {
  String name = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
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
              hintText: 'Search...',
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
        color: Colors.black,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('movie').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return (snapshot.connectionState == ConnectionState.waiting)
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      QueryDocumentSnapshot<Object?>? data =
                          snapshot.data?.docs[index];
                      if (name.isEmpty) {
                        return const SizedBox(
                          child: Text(
                            'Thể loại dưdwdw',
                            style:
                                TextStyle(fontSize: 14, color: Colors.white70),
                          ),
                        );
                      }
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
                                          borderRadius:
                                              BorderRadius.circular(6),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image:
                                                NetworkImage(data['imageUrl']),
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
                                              "${data['rating']}  ",
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(bottom: 1.0),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                        );
                      }
                      return Container(
                        padding:
                            const EdgeInsets.only(left: 5, top: 0, bottom: 5),
                        child: Text(
                          'Thể loại dưdwdw',
                          style: const TextStyle(
                              fontSize: 14, color: Colors.white70),
                        ),
                      );
                    },
                  );
          },
        ),
      ),
    );
  }
}
