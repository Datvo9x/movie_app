import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/screen/profile/download_screen.dart';
import 'package:movie_app/screen/profile/favorites_screen.dart';
import 'package:movie_app/screen/login/login_screen.dart';
import 'package:movie_app/screen/profile/viewHis_screen.dart';
import 'package:provider/provider.dart';
import '../constract/title_gradient.dart';
import '../providers/auth_provider.dart';
import '../screen/profile/feedback_screen.dart';
import '../screen/profile/support_screen.dart';
import '../screen/profile/update_user.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');
  bool checklogin = false;
  late AuthProvider authProvider;
  String? uid, name, photoUrl;

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

  void _logout(BuildContext context) {
    showDialog(
      builder: (context) => AlertDialog(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18.0),
          ),
        ),
        title: const Center(
          child: Text(
            'Đăng Xuất ?',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        content: const SizedBox(
          height: 20,
          child: Center(
            child: Text(
              'Bạn có muốn đăng xuất ?',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                  child: Container(
                    height: 35,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 223, 131, 10),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Không',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.w600),
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                GestureDetector(
                  child: Container(
                    height: 35,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 232, 230, 228),
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      'Đăng xuất',
                      style: TextStyle(
                          color: Color.fromARGB(255, 215, 98, 30),
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  onTap: () {
                    authProvider.handleSignOut();
                  },
                )
              ],
            ),
          ),
        ],
      ),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 23, 23, 23),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            !checklogin
                ? Container(
                    height: 170,
                    color: const Color.fromARGB(26, 139, 137, 137),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 50),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.account_circle,
                              size: 70,
                              color: Colors.white,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 10.0, bottom: 10),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    top: 4, bottom: 4, right: 30, left: 30),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    width: 1,
                                    color:
                                        const Color.fromARGB(255, 229, 152, 43),
                                  ),
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Row(
                                  children: const [
                                    GradientText(
                                      'Đăng nhập',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                      ),
                                      gradient: LinearGradient(
                                        colors: [
                                          Color.fromARGB(255, 227, 112, 5),
                                          Color.fromARGB(255, 233, 222, 10),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : StreamBuilder<DocumentSnapshot>(
                    stream: users.doc(uid).snapshots(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Container(
                          height: 200,
                        );
                      } else {
                        return GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20.0),
                                  ), //this right here
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    height: 450,
                                    width: 350,
                                    child: UpdateMovie(
                                      id: snapshot.data!.id,
                                      nickname: snapshot.data!['nickname'],
                                      photoUrl: snapshot.data!['photoUrl'],
                                      sex: snapshot.data!['sex'],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            color: const Color.fromARGB(255, 59, 59, 59),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      top: 80.0, left: 15, bottom: 20),
                                  child: Row(
                                    children: [
                                      Container(
                                        height: 70,
                                        width: 70,
                                        decoration: BoxDecoration(
                                          color: Colors.black,
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: NetworkImage(
                                              snapshot.data!['photoUrl'],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0, bottom: 10),
                                        child: Container(
                                          padding: const EdgeInsets.only(
                                              top: 4,
                                              bottom: 4,
                                              right: 10,
                                              left: 10),
                                          child: Row(
                                            children: [
                                              GradientText(
                                                '${snapshot.data!['nickname']}',
                                                style: const TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.w700,
                                                ),
                                                gradient: const LinearGradient(
                                                  colors: [
                                                    Color.fromARGB(
                                                        255, 227, 112, 5),
                                                    Color.fromARGB(
                                                        255, 233, 222, 10),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return Dialog(
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ), //this right here
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            20),
                                                  ),
                                                  height: 450,
                                                  width: 350,
                                                  child: UpdateMovie(
                                                    id: snapshot.data!.id,
                                                    nickname: snapshot
                                                        .data!['nickname'],
                                                    photoUrl: snapshot
                                                        .data!['photoUrl'],
                                                    sex: snapshot.data!['sex'],
                                                  ),
                                                ),
                                              );
                                            },
                                          );
                                        },
                                        icon: const Padding(
                                          padding:
                                              EdgeInsets.only(bottom: 10.0),
                                          child: Icon(
                                            Icons.settings_suggest_sharp,
                                            color: Color.fromARGB(
                                                255, 214, 165, 60),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(15, 10, 15, 0),
                                  child: Container(
                                    padding:
                                        const EdgeInsets.fromLTRB(10, 0, 10, 0),
                                    height: 45,
                                    decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 228, 187, 124),
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(6),
                                        topRight: Radius.circular(6),
                                      ),
                                    ),
                                    child: const Center(
                                      child: Text(
                                        "Ưu đãi có hạn ! Đăng ký thành viên ngay để xem tất cả nội dung độc quyền ",
                                        style: TextStyle(
                                          fontSize: 12,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    },
                  ),
            ListAddType(
              icon: Icons.download_done_rounded,
              text: 'Đã tải về',
              press: !checklogin
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DownLoadsUser(
                            photoUrl: photoUrl.toString(),
                            name: name.toString(),
                            uid: uid.toString(),
                          ),
                        ),
                      );
                    },
            ),
            ListAddType(
              icon: Icons.history,
              text: 'Lịch sử xem',
              press: !checklogin
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => HisScreen(
                            photoUrl: photoUrl.toString(),
                            name: name.toString(),
                            uid: uid.toString(),
                          ),
                        ),
                      );
                    },
            ),
            ListAddType(
              icon: Icons.favorite,
              text: 'Bộ sưu tập',
              press: !checklogin
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    }
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FavoritesUser(
                            photoUrl: photoUrl.toString(),
                            name: name.toString(),
                            uid: uid.toString(),
                          ),
                        ),
                      );
                    },
            ),
            ListAddType(
              icon: Icons.feedback,
              text: 'Phản hồi',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FeedbackUser()),
                );
              },
            ),
            ListAddType(
              icon: Icons.help_outline,
              text: 'Trung tâm hỗ trợ',
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SupportUser()),
                );
              },
            ),
            ListAddType(
              icon: Icons.account_circle,
              text: !checklogin ? 'Đăng Nhập' : "Đăng Xuất",
              press: () async {
                !checklogin
                    ? Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      )
                    : _logout(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class ListAddType extends StatelessWidget {
  final String text;
  final dynamic icon;
  final Function() press;
  const ListAddType(
      {Key? key, required this.text, this.icon, required this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: GestureDetector(
        onTap: press,
        child: Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 59, 59, 59),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: <Widget>[
                Icon(
                  icon,
                  color: const Color.fromARGB(255, 255, 255, 255),
                  size: 30,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
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
