import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:movie_app/widget/playvideo_widget.dart';

class Carouselq extends StatefulWidget {
  const Carouselq({Key? key}) : super(key: key);

  @override
  _CarouselState createState() => _CarouselState();
}

class _CarouselState extends State<Carouselq> {
  CollectionReference getmovie = FirebaseFirestore.instance.collection('movie');

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getmovie.get(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const Text("err");
        }
        return CarouselSlider.builder(
          itemCount: snapshot.data?.size,
          options: CarouselOptions(
            height: MediaQuery.of(context).size.width / 1.2,
            viewportFraction: 0.85,
            initialPage: 0,
            autoPlay: true,
            enlargeCenterPage: true,
          ),
          // ignore: avoid_types_as_parameter_names
          itemBuilder: (BuildContext context, index, int) {
            return Center(
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoMovie(
                        imageUrl: snapshot.data!.docs[index]['imageUrl'],
                        trailer: snapshot.data!.docs[index]['trailer'],
                        title: snapshot.data!.docs[index]['title'],
                      ),
                    ),
                  );
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(
                        snapshot.data!.docs[index]['imageUrl'],
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
