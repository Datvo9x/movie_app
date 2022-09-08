import 'package:flutter/material.dart';

class DestiniApp extends StatefulWidget {
  @override
  _DestiniAppState createState() => _DestiniAppState();
}

class _DestiniAppState extends State<DestiniApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: const Color.fromRGBO(245, 0, 87, 1),
      //   title: const Text(
      //     "Landing Page Bankground Image",
      //   ),
      // ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: ExactAssetImage("images/appBack.jpg"), fit: BoxFit.cover),
        ),
      ),
    );
  }
}
