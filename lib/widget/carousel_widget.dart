import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/widget/playvideo_widget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class Carouselq extends StatefulWidget {
  const Carouselq({Key? key}) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carouselq> {
  late int activeIndex = 0;

  CollectionReference getmovie = FirebaseFirestore.instance.collection('movie');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getmovie.get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 600,
          );
        }
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: snapshot.data?.size,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 1.35,
                viewportFraction: 1,
                initialPage: 0,
                autoPlay: false,
                onPageChanged: ((index, reason) => setState(
                      () => activeIndex = index,
                    )),
              ),
              // ignore: avoid_types_as_parameter_names
              itemBuilder: (BuildContext context, index, int) {
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoMovie(
                            imageUrl: snapshot.data!.docs[index]['imageUrl'],
                            trailer: snapshot.data!.docs[index]['trailer'],
                            title: snapshot.data!.docs[index]['title'],
                          ),
                        ),
                      );
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                snapshot.data!.docs[index]['imageUrl'],
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 200,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 0, 0, 0),
                                  Color.fromARGB(161, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0),
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 150,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(211, 0, 0, 0),
                                  Color.fromARGB(133, 0, 0, 0),
                                  Color.fromARGB(0, 0, 0, 0),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 0.0,
                          left: 0.0,
                          right: 0.0,
                          child: Container(
                            height: 800,
                            decoration: const BoxDecoration(
                              color: Color.fromARGB(28, 0, 0, 0),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 15.0,
                          left: 20.0,
                          right: 20.0,
                          child: Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(14)),
                              gradient: LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 226, 69, 16),
                                  Color.fromRGBO(232, 87, 9, 1),
                                  Color.fromRGBO(241, 110, 16, 1),
                                ],
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Icon(
                                  Icons.play_arrow_rounded,
                                  size: 33,
                                  color: Color.fromARGB(255, 219, 217, 216),
                                ),
                                Text(
                                  ' Xem ngay',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Color.fromARGB(255, 219, 217, 216),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
            AnimatedSmoothIndicator(
              activeIndex: activeIndex,
              count: snapshot.data!.size,
              effect: const WormEffect(
                dotColor: Color.fromARGB(183, 215, 214, 213),
                activeDotColor: Color.fromARGB(255, 231, 229, 227),
                dotHeight: 8,
                dotWidth: 8,
              ),
            ),
          ],
        );
      },
    );
  }
}
