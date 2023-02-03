import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/widget/horizontal_height_widget.dart';
import 'package:movie_app/widget/horizontal_height_widget1.dart';
import 'package:movie_app/widget/titlewiper_widget.dart';
import 'package:movie_app/widget/titlewiper_widget1.dart';
import '../constract/title_gradient.dart';
import '../screen/seach/seach_screen.dart';
import '../widget/carousel_widget.dart';
import '../widget/horizontal_top_widget.dart.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _gradientColor1 = Colors.transparent;

  late ScrollController _scrollViewController;

  void changeColor() {
    if ((_scrollViewController.offset == 0) &&
        (_scrollViewController.offset < 200)) {
      setState(() {
        _gradientColor1 = Colors.transparent;
      });
    } else if ((_scrollViewController.offset >= 200)) {
      setState(() {
        _gradientColor1 = const Color.fromARGB(255, 18, 18, 18);
      });
    }
  }

  @override

  // ignore: must_call_super
  void initState() {
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _scrollViewController.addListener(changeColor);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 0, 0, 0),
      statusBarBrightness: Brightness.dark,
      statusBarIconBrightness: Brightness.light,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: _gradientColor1,
        excludeHeaderSemantics: true,
        elevation: 0,
        toolbarHeight: 50,
        title: const Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: GradientText(
            'Fire Movie',
            style: TextStyle(fontSize: 24),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 255, 115, 1),
                Color.fromARGB(255, 207, 218, 5),
              ],
            ),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CloudFirestoreSearch(),
                ),
              );
            },
            icon: const Padding(
              padding: EdgeInsets.only(right: 0.0),
              child: Icon(
                Icons.notifications_outlined,
                size: 26,
              ),
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CloudFirestoreSearch(),
                ),
              );
            },
            icon: const Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(
                Icons.search,
                size: 26,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        color: const Color.fromARGB(255, 0, 0, 0),
        child: SingleChildScrollView(
          controller: _scrollViewController,
          child: Column(
            children: <Widget>[
              Container(
                color: const Color.fromARGB(255, 0, 0, 0),
                child: const Carouselq(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 14, right: 5, bottom: 5, top: 20),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Top 5 Phim Thịnh Hành ',
                      text1: '',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetT(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 5),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Hành Động HollyWood',
                      text1: '',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: "Hành động"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 5,
                  bottom: 5,
                ),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Phim Viễn Tưởng Hot',
                      text1: '',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: 'Viễn tưởng'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 5),
                child: Column(
                  children: const [
                    TitleSlide1(
                      text: 'Hành Động Võ Thuật Trung Hoa',
                      text1: '',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH1(tloai: "Trung Quốc"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 5),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Phim Huyền Bí Ma Thuật Hot',
                      text1: '',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: 'Huyền bí'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 5),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Phim hoạt hình Hot',
                      text1: '',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: "Hoạt hình"),
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
}
