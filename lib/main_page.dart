import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:movie_app/page/home_page.dart';
import 'package:movie_app/page/fastscreen_page.dart';
import 'package:movie_app/page/login.dart';
import 'package:movie_app/page/profile.dart';
import 'package:movie_app/page/ttttt.dart';
import 'package:movie_app/screen/test.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    initialization();
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  int _selectedIndex = 0;
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const Fastscreen(),
    const TTT(),
    const SettingPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color.fromARGB(255, 20, 20, 20),
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: Icon(Icons.home_rounded),
            ),
            label: 'Trang Chủ',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: Icon(Icons.video_library),
            ),
            label: 'Xem Nhanh',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: Icon(Icons.dashboard_outlined),
            ),
            label: 'Khám phá',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(bottom: 3.0),
              child: Icon(Icons.account_circle),
            ),
            label: 'Cá Nhân',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        iconSize: 25,
        selectedIconTheme: const IconThemeData(
          color: Color.fromARGB(255, 255, 255, 255),
          // Color.fromARGB(255, 227, 112, 5),
        ),
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: const Color.fromARGB(255, 255, 255, 255),
        //const Color.fromARGB(255, 227, 112, 5),
        unselectedItemColor: Colors.white70,
      ),
    );
  }
}
