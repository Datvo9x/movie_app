import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:movie_app/widget/horizontal_height_widget.dart';
import 'package:movie_app/widget/horizontal_height_widget1.dart';
import 'package:movie_app/widget/titlewiper_widget.dart';
import 'package:movie_app/widget/titlewiper_widget1.dart';
import '../constract/title_gradient.dart';
import '../screen/seach/seach_screen.dart';

class MorePage extends StatefulWidget {
  const MorePage({Key? key}) : super(key: key);

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
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
        toolbarHeight: 40,
        title: const Padding(
          padding: EdgeInsets.only(left: 0.0),
          child: GradientText(
            'Khám Phá',
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
              const SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 14, right: 5, bottom: 8, top: 0),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Theo Thể Loại  *',
                      text1: '',
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 17, right: 5, bottom: 10, top: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Huyền bí  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Viễn tưởng  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Hành động  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Hoạt hình  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Võ thuật  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 17, right: 5, bottom: 10, top: 10),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Âu Mỹ  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Trung Quốc  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Nhật Bản  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 30, 30, 30),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            '  Hàn Quốc  ',
                            style: TextStyle(
                                fontSize: 14,
                                color: Color.fromRGBO(240, 240, 240, 1)),
                          ),
                        ),
                        height: 35,
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 10),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Hành động',
                      text1: 'Xem tất cả',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: "Hành động"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 10),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Huyền bí',
                      text1: 'Xem tất cả',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: 'Huyền bí'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 5,
                  bottom: 10,
                ),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Viễn tưởng',
                      text1: 'Xem tất cả',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: 'Viễn tưởng'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 10),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Hoạt hình',
                      text1: 'Xem tất cả',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: "Hoạt hình"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 10),
                child: Column(
                  children: const [
                    TitleSlide(
                      text: 'Võ thuật',
                      text1: 'Xem tất cả',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH(tloai: "Võ thuật"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 10),
                child: Column(
                  children: const [
                    TitleSlide1(
                      text: 'Âu Mỹ',
                      text1: 'Xem tất cả',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH1(tloai: "Âu Mỹ"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 10),
                child: Column(
                  children: const [
                    TitleSlide1(
                      text: 'Trung Quốc',
                      text1: 'Xem tất cả',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH1(tloai: "Trung Quốc"),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 14, right: 5, bottom: 10),
                child: Column(
                  children: const [
                    TitleSlide1(
                      text: 'Nhật Bản',
                      text1: 'Xem tất cả',
                    ),
                    SizedBox(
                      height: 165,
                      child: HorizontalWidgetH1(tloai: "Nhật Bản"),
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
