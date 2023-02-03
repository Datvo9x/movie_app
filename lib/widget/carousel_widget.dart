import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:movie_app/screen/playvideo_screen.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../providers/auth_provider.dart';
import '../screen/login/login_screen.dart';

class Carouselq extends StatefulWidget {
  const Carouselq({Key? key}) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carouselq> {
  late int activeIndex = 0;
  String? uid, name, photoUrl;
  bool checklogin = false;
  late AuthProvider authProvider;

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
    return StreamBuilder(
      stream: FirebaseFirestore.instance
          .collection('movie')
          .orderBy('view', descending: true)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox(
            height: 600,
          );
        }
        return Column(
          children: [
            CarouselSlider.builder(
              itemCount: 5,
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 1.35,
                viewportFraction: 1,
                initialPage: 0,
                autoPlay: true,
                onPageChanged: ((index, reason) => setState(
                      () => activeIndex = index,
                    )),
              ),
              // ignore: avoid_types_as_parameter_names
              itemBuilder: (BuildContext context, index, int) {
                DocumentSnapshot car = snapshot.data!.docs[index];
                return Center(
                  child: GestureDetector(
                    onTap: () {
                      checklogin
                          ? Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => VideoMovie(
                                  photoUrl: photoUrl.toString(),
                                  year: car['year'],
                                  category: car['category'],
                                  description: car['description'],
                                  duration: car['duration'],
                                  rating: car['rating'],
                                  imageUrl: car['imageUrl'],
                                  trailer: car["trailer"],
                                  title: car["title"],
                                  view: car["view"],
                                  id: car.id,
                                  uid: uid.toString(),
                                  name: name.toString(),
                                ),
                              ),
                            )
                          : _dialogBuilder(context);
                    },
                    child: Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                car['imageUrl'],
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
                          left: 30.0,
                          right: 30.0,
                          child: Container(
                            height: 40,
                            decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(18)),
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
              count: 5,
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
