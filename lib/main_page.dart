import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:movie_app/page/home_page.dart';
import 'package:movie_app/page/fastscreen_page.dart';
import 'package:movie_app/page/more_page.dart';
import 'package:movie_app/page/profile.dart';
import 'package:movie_app/providers/auth_provider.dart';
import 'package:movie_app/screen/block_user.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);
  @override
  _MainPageState createState() => _MainPageState();
}

/// This is the private State class that goes with MyStatefulWidget.
class _MainPageState extends State<MainPage> {
  late AuthProvider authProvider;
  bool checklogin = false;
  bool checkBlockU = false;
  String? uid, name, photoUrl;
  final List<Widget> _widgetOptions = [
    const HomePage(),
    const Fastscreen(),
    const MorePage(),
    const Profile(),
  ];
  @override
  void initState() {
    super.initState();
    initialization();
    authProvider = context.read<AuthProvider>();
    if (authProvider.getUserFirebaseId()?.isNotEmpty == true) {
      checklogin = true;
      setState(() {
        uid = authProvider.getUserFirebaseId().toString();
        name = authProvider.getUserFirebaseName().toString();
        photoUrl = authProvider.getUserFirebaseImage().toString();
        checkBlock();
      });
    } else {
      setState(() {
        checklogin = false;
        checkBlockU = false;
      });
    }
  }

  void checkBlockTap() async {
    if (checklogin == true) {
      setState(() {
        checkBlock();
      });
    } else {
      setState(() {
        checkBlockU = false;
      });
    }
  }

  void checkBlock() async {
    try {
      CollectionReference getP = FirebaseFirestore.instance.collection('users');
      QuerySnapshot checker = await getP.where('id', isEqualTo: uid).get();
      if (checker.docs.isNotEmpty) {
        if (checker.docs.first['type'] == true) {
          setState(() {
            checkBlockU = true;
          });
        } else {
          setState(() {
            checkBlockU = false;
          });
        }
      } else {
        setState(() {
          checkBlockU = false;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void initialization() async {
    await Future.delayed(const Duration(seconds: 2));
    FlutterNativeSplash.remove();
  }

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      checkBlockTap();
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return checkBlockU
        ? Container(
            color: Colors.black,
            child: const BlockUser(),
          )
        : Scaffold(
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
