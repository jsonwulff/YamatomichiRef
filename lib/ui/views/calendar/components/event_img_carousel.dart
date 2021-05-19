import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class EventCarousel extends StatefulWidget {
  EventCarousel({Key key, @required this.images, this.mainImage}) : super(key: key);

  final String mainImage;
  final List<dynamic> images;

  @override
  _Carousel createState() => _Carousel();
}

class _Carousel extends State<EventCarousel> {
  List<dynamic> createItems() {
    List<dynamic> foo = [];
    var image = widget.mainImage == null
        ? AssetImage('lib/assets/images/event_default.png')
        : NetworkImage(widget.mainImage);
    if (true) {
      foo.add(Container(
          decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        image: DecorationImage(image: image, fit: BoxFit.cover),
      )));
    }
    if (widget.images.length != 0) {
      for (dynamic d in widget.images) {
        foo.add(Container(
            decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          image: DecorationImage(image: NetworkImage(d.toString()), fit: BoxFit.cover),
        )));
      }
    }
    return foo;
  }

  int _currentIndex = 0;

  List<T> map<T>(List list, Function handler) {
    List<T> result = [];
    for (var i = 0; i < list.length; i++) {
      result.add(handler(i, list[i]));
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    // if (widget.images.length == 0 && widget.mainImage == null) {
    //   return Container(
    //     height: 230,
    //     width: MediaQuery.of(context).size.width,
    //   );
    //} else {
    List cardList = createItems();

    return Column(children: [
      CarouselSlider(
          options: CarouselOptions(
            height: 230.0,
            autoPlay: false,
            viewportFraction: 1,
            /*autoPlayInterval: Duration(seconds: 3),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
        pauseAutoPlayOnTouch: true,*/
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
                  color: Colors.transparent,
                  elevation: 0,
                  //color: Colors.blueAccent,
                  child: card,
                ),
              );
            });
          }).toList()),
      widget.images.length == 0
          ? Row()
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: cardList.map((url) {
                int index = cardList.indexOf(url);
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.fromLTRB(
                      2, 5, 2, 0), //EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentIndex == index
                        ? Color.fromRGBO(0, 0, 0, 0.9)
                        : Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                );
              }).toList(),
            ),
    ]);
    /*items: cardList.map((card) {
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
        }).toList(),*7
      );*/
    // }
  }
}
