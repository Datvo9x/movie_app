// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Titlevideo extends StatefulWidget {
  String title, imageUrl, trailer;
  Titlevideo(
      {Key? key,
      required this.title,
      required this.imageUrl,
      required this.trailer})
      : super(key: key);

  @override
  State<Titlevideo> createState() => _TitlevideoState();
}

class _TitlevideoState extends State<Titlevideo> {
  bool morong = true;
  var _gradientColor1 = Colors.transparent;

  late ScrollController _scrollViewController;

  void changeColor() {
    if ((_scrollViewController.offset == 0) &&
        (_gradientColor1 != Colors.red[400])) {
      setState(() {
        _gradientColor1 = Colors.transparent;
      });
    } else if ((_scrollViewController.offset <= 40) &&
        (_gradientColor1 != const Color.fromARGB(186, 206, 81, 9))) {
      setState(() {
        _gradientColor1 = const Color.fromARGB(186, 206, 81, 9);
      });
    } else if ((_scrollViewController.offset <= 100) &&
        (_scrollViewController.offset > 40)) {
      var opacity = _scrollViewController.offset / 100;
      setState(() {
        _gradientColor1 = Color.fromRGBO(66, 165, 245, opacity);
      });
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          color: const Color.fromARGB(255, 34, 33, 33),
          child: Stack(
            children: [
              SingleChildScrollView(
                controller: _scrollViewController,
                child: Column(
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(
                          height: morong != false ? 420 : 1000,
                        ),
                        Positioned(
                          height: 350,
                          width: 420,
                          child: Image.network(
                            widget.imageUrl,
                            fit: BoxFit.fill,
                          ),
                        ),
                        Positioned(
                          top: 250,
                          width: 380,
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'The Loai : ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      Text(
                                        'Ten khac',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 8.0),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'The Loai : ',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                      Text(
                                        'Ten khac',
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  height: morong != false ? 0 : 560,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      morong = !morong;
                                    });
                                  },
                                  child: morong != false
                                      ? const Text(
                                          'Xem them',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 206, 81, 9),
                                          ),
                                        )
                                      : const Text(
                                          'Thu nho',
                                          style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 14,
                                            color:
                                                Color.fromARGB(255, 206, 81, 9),
                                          ),
                                        ),
                                ),
                              ],
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: const Color.fromARGB(255, 48, 45, 45),
                            ),
                          ),
                        ),
                        Positioned(
                          top: 95,
                          height: 350,
                          width: 350,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const <Widget>[
                              Expanded(
                                child: Text(
                                  'THAM TU LUNG DANH dwdwdwd',
                                  maxLines: 2,
                                  style: TextStyle(
                                      fontSize: 30,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 800,
                      child: DefaultTabController(
                        initialIndex: 1,
                        length: 2,
                        child: Scaffold(
                          backgroundColor: Colors.transparent,
                          appBar: AppBar(
                            toolbarHeight: 20,
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.black12,
                            automaticallyImplyLeading: false,
                            bottom: const TabBar(
                              indicatorColor: Color.fromARGB(255, 206, 81, 9),
                              tabs: <Widget>[
                                Tab(
                                  child: Text(
                                    'Tap phim',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 206, 81, 9),
                                        fontSize: 15),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    'Phim khac',
                                    style: TextStyle(
                                        color: Color.fromARGB(255, 206, 81, 9),
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          body: const TabBarView(
                            children: <Widget>[
                              Center(
                                child: Text("It's cloudy here"),
                              ),
                              Center(
                                child: Text("It's rainy here"),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 50,
                child: AppBar(
                  bottomOpacity: 1,
                  backgroundColor: _gradientColor1,
                  elevation: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
