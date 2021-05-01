import 'package:app/ui/views/news/news_items.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'carousel_item.dart';
import 'package:wordpress_api/wordpress_api.dart';

/* Source: https://medium.com/flutter-community/how-to-create-card-carousel-in-flutter-979bc8ecf19*/

class Carousel extends StatefulWidget {
  Carousel({Key key}) : super(key: key);
  @override
  _Carousel createState() => _Carousel();
}

class _Carousel extends State<Carousel> {
  final WordPressAPI api = WordPressAPI('https://www.yamatomichi.com/en/');
  final Future<WPResponse> newsItems =
      WordPressAPI('https://www.yamatomichi.com/en/').getAsync('news?per_page=2&_embed=about');

  // ignore: unused_field
  int _currentIndex = 0;

  void getNewsItems() async {
    final res = await api.getAsync('news?per_page=2&_embed=about');
    for (final doc in res.data as List) {
      print(doc);
    }
  }

  List cardList = [
    CarouselItem(newsItem: newsItemsList[0]),
    CarouselItem(newsItem: newsItemsList[1])
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
    return Column(
      children: [
        FutureBuilder(
            future: newsItems,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.hasData) {
                // print(snapshot.data.runtimeType);
                // print(snapshot.data);
                // for (final doc in snapshot.data as List) {
                //   print(doc);
                // }
                return Text('Got data');
              } else if (snapshot.hasError) {
                return Text('Something went wrong');
              } else {
                print('no data');
                return CircularProgressIndicator();
              }
            }),
        ElevatedButton(onPressed: () => getNewsItems(), child: Text('Get wordpress data'))
      ],
    );
    // CarouselSlider(
    //   options: CarouselOptions(
    //     height: 80.0,
    //     autoPlay: true,
    //     autoPlayInterval: Duration(seconds: 3),
    //     autoPlayAnimationDuration: Duration(milliseconds: 800),
    //     autoPlayCurve: Curves.fastOutSlowIn,
    //     pauseAutoPlayOnTouch: true,
    //     aspectRatio: 2.0,
    //     onPageChanged: (index, reason) {
    //       setState(() {
    //         _currentIndex = index;
    //       });
    //     },
    //   ),
    //   items: cardList.map((card) {
    //     return Builder(builder: (BuildContext context) {
    //       return card;
    //     });
    //   }).toList(),
    // );
  }
}
