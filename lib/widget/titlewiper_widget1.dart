import 'package:flutter/material.dart';

import 'package:movie_app/screen/list_film_page1.dart';

class TitleSlide1 extends StatelessWidget {
  final String text, text1;
  const TitleSlide1({Key? key, required this.text, required this.text1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8, left: 5, bottom: 4, right: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            text,
            style: const TextStyle(
              fontSize: 16,
              color: Color.fromARGB(255, 241, 239, 239),
              fontWeight: FontWeight.w500,
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListFilmPage1(
                    title: text,
                  ),
                ),
              );
            },
            child: Text(
              text1,
              style: const TextStyle(
                fontSize: 13,
                color: Color.fromARGB(255, 200, 200, 200),
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
