import 'package:flutter/material.dart';
import 'package:movie_app/screen/test.dart';
import 'package:movie_app/widget/horizontal_height_widget.dart';
import 'package:movie_app/widget/horizontal_width_widget.dart';
import 'package:movie_app/widget/titlewiper_widget.dart';
import '../constract/title_gradient.dart';
import '../screen/seach_screen.dart';
import '../widget/horizontal_top_widget.dart.dart';

class TTT extends StatefulWidget {
  const TTT({Key? key}) : super(key: key);

  @override
  State<TTT> createState() => _TTTState();
}

class _TTTState extends State<TTT> {
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
        _gradientColor1 = const Color.fromARGB(254, 29, 29, 28);
      });
      // } else if ((_scrollViewController.offset <= 180) &&
      //     (_scrollViewController.offset > 120)) {
      //   setState(() {
      //     _gradientColor1 = const Color.fromARGB(185, 126, 9, 133);
      //   });
    }
  }

  @override
  // ignore: must_call_super
  void initState() {
    _scrollViewController = ScrollController(initialScrollOffset: 0.0);
    _scrollViewController.addListener(changeColor);
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
            style: TextStyle(fontSize: 25),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 241, 132, 16),
                Color.fromARGB(255, 189, 199, 7),
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
                child: const Meo(),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 5, right: 5, bottom: 5, top: 30),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Top 5 Phim Hay',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetT(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Phim Mới Thịnh Hành Trên Fire Movie',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 5, right: 5, bottom: 5),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Hành Động HollyWood',
                    ),
                    SizedBox(
                      height: 165,
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
                      height: 150,
                      child: HorizontalWidgetW(),
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
