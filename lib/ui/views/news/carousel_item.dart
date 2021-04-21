import 'package:flutter/material.dart';

// TODO : this is just a static dummy implementation to show for Jens in sprint 2

class CarouselItem extends StatelessWidget {
  CarouselItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage("https://i.imgur.com/SoCtifk.png"), fit: BoxFit.fitWidth),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        /*children: <Widget>[
          Text("News Carousel",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 22.0,
                  fontWeight: FontWeight.bold)),
          Text("foo",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 17.0,
                  fontWeight: FontWeight.w600)),
        ],*/
      ),
    );
  }
}
