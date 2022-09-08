import 'package:flutter/material.dart';
import 'package:movie_app/page/refd.dart';
import 'package:movie_app/screen/test.dart';
import 'package:movie_app/widget/carousel_widget.dart';
import 'package:movie_app/widget/horizontal_height_widget.dart';
import 'package:movie_app/widget/horizontal_width_widget.dart';
import 'package:movie_app/widget/titlewiper_widget.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 14, 14, 14),
      body: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.1, color: Colors.black),
        ),
        child: NestedScrollView(
          floatHeaderSlivers: true,
          headerSliverBuilder: (context, innerBoxIsScrolled) => [
            SliverAppBar(
              elevation: 0,
              toolbarHeight: 70,
              backgroundColor: const Color.fromRGBO(14, 14, 14, 1),
              floating: true,
              title: const Padding(
                padding: EdgeInsets.only(left: 5.0),
                child: GradientText(
                  'Fire Movie',
                  style: TextStyle(fontSize: 25),
                  gradient: LinearGradient(
                    colors: [
                      Color.fromARGB(255, 241, 132, 16),
                      Color.fromARGB(255, 216, 226, 17),
                    ],
                  ),
                ),
                // child: Text(
                //   "Trang Chủ",
                //   style: TextStyle(
                //     fontSize: 28,
                //     color: Colors.white,
                //   ),
                // ),
              ),
              actions: [
                IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const CloudFirestoreSearch1(),
                      ),
                    );
                  },
                  icon: const Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(
                      Icons.search,
                      size: 28,
                    ),
                  ),
                ),
              ],
            )
          ],
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  color: const Color.fromARGB(255, 14, 14, 14),
                  child: const Carouselq(),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: const [
                      TitleSlide(
                        text: 'Top Phim Mới',
                      ),
                      SizedBox(
                        height: 175,
                        child: HorizontalWidgetW(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: const [
                      TitleSlide(
                        text: 'Top Phim Mới',
                      ),
                      SizedBox(
                        height: 235,
                        child: HorizontalWidgetH(),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, right: 5),
                  child: Column(
                    children: const [
                      TitleSlide(
                        text: 'Top Phim Mới',
                      ),
                      SizedBox(
                        height: 235,
                        child: HorizontalWidgetH(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
