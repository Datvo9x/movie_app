import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:preload_page_view/preload_page_view.dart';
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
              padding: EdgeInsets.only(right: 8.0),
              child: Icon(Icons.search),
            ),
            Icon(Icons.camera_alt_outlined),
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
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                  image: DecorationImage(
                      image: ExactAssetImage("assets/images/a2jpg.jpg"),
                      fit: BoxFit.cover),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Center(
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height / 2,
                        child: Fastvideo(
                          videoFast: snapshot.data!.docs[index]['videoFast'],
                          currentIndex: index,
                          pageIndex: _pageIndex,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 200,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Stack(
                            alignment: Alignment.bottomCenter,
                            children: [
                              Column(
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.2,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 8),
                                          child: Text(
                                            'Miễn phí cho sử dụng thương mại Không cần thẩm quyền'
                                            'Miễn phí cho sử dụng thương mại Không cần thẩm quyền',
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  55,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, bottom: 10),
                                          child: Text(
                                            '#Anna #Anna2022 ',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: MediaQuery.of(context)
                                                      .size
                                                      .height /
                                                  54,
                                              color: const Color.fromARGB(
                                                  237, 227, 224, 224),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                8,
                                        child: Padding(
                                          padding: const EdgeInsets.all(0.0),
                                          child: Column(
                                            children: const [
                                              Icon(
                                                Icons.favorite,
                                                size: 25,
                                                color: Colors.white,
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '126',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.w500,
                                                  fontSize: 14,
                                                  color: Color.fromARGB(
                                                      237, 227, 224, 224),
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
                                        width:
                                            MediaQuery.of(context).size.width /
                                                8,
                                        child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: const [
                                                Icon(
                                                  Icons.comment_outlined,
                                                  size: 25,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  '12',
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14,
                                                    color: Color.fromARGB(
                                                        237, 227, 224, 224),
                                                  ),
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width /
                                                8,
                                        child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: Column(
                                              children: const [
                                                Icon(
                                                  Icons.more_horiz,
                                                  size: 26,
                                                  color: Colors.white,
                                                ),
                                              ],
                                            )),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            height: 34,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      '[Review] ',
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              42,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                    Text(
                                      snapshot.data!.docs[index]['nameFast'],
                                      style: TextStyle(
                                          fontSize: MediaQuery.of(context)
                                                  .size
                                                  .height /
                                              42,
                                          fontWeight: FontWeight.w700,
                                          color: Colors.white),
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Lottie.asset('assets/images/ex.json',
                                      width: MediaQuery.maybeOf(context)!
                                              .size
                                              .height /
                                          26),
                                ),
                              ],
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
