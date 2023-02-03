
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class BlockUser extends StatefulWidget {
  const BlockUser({Key? key}) : super(key: key);

  @override
  _BlockUserState createState() => _BlockUserState();
}

late AuthProvider authProvider;

class _BlockUserState extends State<BlockUser> {
  @override
  Widget build(BuildContext context) {
    authProvider = context.read<AuthProvider>();
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Image.asset(
              'assets/images/aaa.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 180,
                  ),
                  const Text(
                    'Tài khoản bị khóa',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    height: 120,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width / 1.7,
                    child: const Text(
                      'Vui lòng liên hệ nhà phát hành để được trợ giúp',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  TextButton(
                    child: Container(
                      height: 30,
                      width: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 53, 79, 135),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    onPressed: () async {
                      await authProvider.handleSignOut();
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
