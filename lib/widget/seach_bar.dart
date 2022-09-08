import 'package:flutter/material.dart';

import '../page/home_page.dart';

class Seachbar extends StatelessWidget {
  const Seachbar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(left: 20),
          child: Text(
            "Trang Chủ",
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const HomePage(),
              ),
            );
          },
          icon: const Icon(Icons.search, color: Colors.white),
        ),
      ],
    );
  }
}
