import 'package:app/middleware/api/wp_api.dart';
import 'package:app/ui/views/news/news_item.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Carousel extends StatefulWidget {
  Carousel({Key key}) : super(key: key);
  @override
  _Carousel createState() => _Carousel();
}

class _Carousel extends State<Carousel> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: fetchWpNews(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return CarouselSlider(
              options: CarouselOptions(
                height: 125.0,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 20),
                autoPlayAnimationDuration: Duration(milliseconds: 800),
                pauseAutoPlayOnTouch: true,
                viewportFraction: 1,
              ),
              items: snapshot.data.map<Widget>((newsItem) {
                return NewsItem(
                    title: newsItem['title']['rendered'],
                    imageUrl:
                        'https://www.yamatomichi.com/wp-content/uploads/2017/07/2021_Light_Alpha_Vest_Jacket_mens_Black_eyecatch.jpg',
                    newsUrl: newsItem['acf']['onlylink'],
                    category: newsItem['_embedded']['wp:term'][0][0]['name'],
                    date: newsItem['date']);
              }).toList(),
            );
          } else if (snapshot.hasError) {
            return Text('Something went wrong');
          } else {
            return Text('No data');
          }
        },
      ),
    );
  }
}
