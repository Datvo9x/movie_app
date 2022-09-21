import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:preload_page_view/preload_page_view.dart';
import '../constract/title_gradient.dart';
import '../widget/fastvideo_widget.dart';

class Fastscreen extends StatefulWidget {
  const Fastscreen({Key? key}) : super(key: key);

  @override
  State<Fastscreen> createState() => _FastscreenState();
}

class _FastscreenState extends State<Fastscreen> {
  int _pageIndex = 0;

  CollectionReference getmovie1 =
      FirebaseFirestore.instance.collection('fastfilm');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: const [
            // Center(
            //   child: Text('Dành cho bạn'),
            // ),
            Padding(
              padding: EdgeInsets.only(right: 10.0, top: 10),
              child: Icon(Icons.search),
            ),
            Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.camera_alt_outlined),
            ),
          ],
        ),
      ),
      body: FutureBuilder(
        future: getmovie1.get(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              color: const Color.fromARGB(255, 14, 14, 14),
            );
          }
          return PreloadPageView.builder(
            onPageChanged: (int page) {
              setState(() {
                _pageIndex = page;
              });
            },
            preloadPagesCount: 1,
            scrollDirection: Axis.vertical,
            itemCount: snapshot.data!.size,
            itemBuilder: (context, index) {
              return Container(
                color: const Color.fromARGB(255, 3, 3, 3),
                child: Stack(
                  children: <Widget>[
                    Center(
                      child: Stack(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height / 1.9,
                            child: Fastvideo(
                              videoFast: snapshot.data!.docs[index]
                                  ['videoFast'],
                              currentIndex: index,
                              pageIndex: _pageIndex,
                            ),
                          ),
                          Positioned(
                            bottom: 50,
                            right: 0,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          children: const [
                                            Icon(
                                              Icons.favorite,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 6),
                                            Text(
                                              '126',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          children: const [
                                            Icon(
                                              Icons.comment_rounded,
                                              size: 28,
                                              color: Colors.white,
                                            ),
                                            SizedBox(height: 4),
                                            Text(
                                              '12',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w700,
                                                fontSize: 14,
                                                color: Color.fromARGB(
                                                    255, 255, 255, 255),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          10,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Column(
                                          children: const [
                                            Icon(
                                              Icons.more_horiz,
                                              size: 30,
                                              color: Colors.white,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 10.0, bottom: 6),
                                        child: Text(
                                          'Shang-Chi và huyền thoại Thập Luân - là bộ phim siêu anh '
                                          'hùng của Mỹ được ra mắt vào năm 2021 dựa trên nhân vật Shang-Chi của Marvels. trên nhân vật',
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width / 1,
                                    child: const Padding(
                                      padding: EdgeInsets.only(
                                          left: 10.0, bottom: 8),
                                      child: Text(
                                        '#Anna #Anna2022 ',
                                        style: TextStyle(
                                          // decoration: TextDecoration.underline,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: Color.fromARGB(
                                              237, 227, 224, 224),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, bottom: 10),
                            child: Container(
                              padding: const EdgeInsets.only(
                                  top: 4, bottom: 4, right: 8, left: 8),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  width: 0.7,
                                  color:
                                      const Color.fromARGB(193, 218, 233, 46),
                                ),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                children: [
                                  const GradientText(
                                    'Review ',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    gradient: LinearGradient(
                                      colors: [
                                        Color.fromARGB(255, 227, 112, 5),
                                        Color.fromARGB(255, 233, 222, 10),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    snapshot.data!.docs[index]['nameFast'],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
