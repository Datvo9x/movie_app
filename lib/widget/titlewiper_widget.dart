import 'package:flutter/material.dart';

class TitleSlide extends StatelessWidget {
  final String text;
  const TitleSlide({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(
              fontSize: 17,
              color: Color.fromARGB(255, 219, 216, 216),
              fontWeight: FontWeight.w500,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: Icon(
              Icons.navigate_next,
              color: Color.fromARGB(255, 187, 182, 182),
              size: 0,
            ),
          ),
        ],
      ),
    );
  }
}
