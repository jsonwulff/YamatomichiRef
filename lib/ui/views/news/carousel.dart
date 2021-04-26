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

  // Endpoint for newsItems:
  // https://www.yamatomichi.com/wp-json/wp/v2/news/
  List<Map<String, Object>> newsItems = [
    {
      "date": "2021-04-20T17:58:50",
      "status": "publish",
      "link": "https://www.yamatomichi.com/en/news/46715/",
      "title": {"rendered": "MINI2<br><strike>ON SALE FROM APR. 22, 18:00 (JST).</strike>SOLD OUT"},
      "news_category": [96],
      "_links": {
        "wp:featuredmedia": [
          {"embeddable": true, "href": "https://www.yamatomichi.com/wp-json/wp/v2/media/46916"}
        ],
      }
    },
    {
      "date": "2021-04-20T12:05:01",
      "status": "publish",
      "link": "https://www.yamatomichi.com/en/news/46718/",
      "title": {"rendered": "MINI<br><strike>ON SALE FROM APR. 22, 18:00 (JST).</strike>SOLD OUT"},
      "author": 32,
      "news_category": [96],
      "_links": {
        "wp:featuredmedia": [
          {"embeddable": true, "href": "https://www.yamatomichi.com/wp-json/wp/v2/media/46920"}
        ],
      }
    },
  ];

  List<Map<String, Object>> newsCategories = [];

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
        height: 80.0,
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
          return card;
        });
      }).toList(),
    );
  }
}
