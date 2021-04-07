import 'package:flutter/material.dart';

// TODO : this is just a static dummy implementation to show for Jens in sprint 2

class CarouselItem extends StatelessWidget {
  CarouselItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: NetworkImage(
                "https://lh3.googleusercontent.com/pw/ACtC-3dZNi60W7xeIbH645bgZ94dVseFZ3gWNcuCxOGAEk1uEid9ZO8-g1J9v8nsHcuKjS4DeC2obXS_P59laQaHcXqlYcUwSBN7PT0hc0Ojep_nAyU7dEBLZWoXvRdTL2p73R2jB_TunJXWwJMFMf-Cl4ey=w640-h228-no?authuser=0"),
            fit: BoxFit.fitWidth),
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
