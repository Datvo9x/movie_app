import 'package:flutter/material.dart';

class TitleSlide extends StatelessWidget {
  final String text;
  const TitleSlide({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 20),
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Icon(
            Icons.navigate_next,
            color: Colors.white,
            size: 30,
          ),
        ],
      ),
    );
  }
}
