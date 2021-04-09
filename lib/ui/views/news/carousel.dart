import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'carousel_item.dart';

/* Source: https://medium.com/flutter-community/how-to-create-card-carousel-in-flutter-979bc8ecf19*/

class Carousel extends StatefulWidget {
  Carousel({Key key}) : super(key: key);
  @override
  _Carousel createState() => _Carousel();
}

class _Carousel extends State<Carousel> {
  // ignore: unused_field
  int _currentIndex = 0;

  List cardList = [
    CarouselItem(),
    CarouselItem(),
  ];

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,
        aspectRatio: 2.0,
        onPageChanged: (index, reason) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      items: cardList.map((card) {
        return Builder(builder: (BuildContext context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.30,
            width: MediaQuery.of(context).size.width,
            child: Card(
              //color: Colors.blueAccent,
              child: card,
            ),
          );
        });
      }).toList(),
    );
  }
}
