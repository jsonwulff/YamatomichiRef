import 'package:flutter/material.dart';

// TODO : this is just a static dummy implementation to show for Jens in sprint 2

class CarouselItem extends StatelessWidget {
  CarouselItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 0, 0, 16.0),
      elevation: 5.0,
      shadowColor: Colors.black,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18.0),
      ),
      child: Container(
        height: 90,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Image.network('https://www.yamatomichi.com/wp-content/uploads/2021/04/2021_MINI2-1.jpg')
          ],
        ),
      ),
    );
  }
}
// Widget build(BuildContext context) {
//   return Padding(
//     padding: const EdgeInsets.symmetric(vertical: 10.0),
//     child: Row(
//       children: <Widget>[
//         Image.network('https://www.yamatomichi.com/wp-content/uploads/2021/04/2021_MINI2-1.jpg',
//             height: 90, width: 150, fit: BoxFit.cover),
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Text('Test'),
//         ),
//       ],
//     ),
//   );
//   }
// }

// class MyStatelessWidget extends StatelessWidget {
//   const MyStatelessWidget({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Card(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             const ListTile(
//               leading: Icon(Icons.album),
//               title: Text('The Enchanted Nightingale'),
//               subtitle: Text('Music by Julie Gable. Lyrics by Sidney Stein.'),
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: <Widget>[
//                 TextButton(
//                   child: const Text('BUY TICKETS'),
//                   onPressed: () {/* ... */},
//                 ),
//                 const SizedBox(width: 8),
//                 TextButton(
//                   child: const Text('LISTEN'),
//                   onPressed: () {/* ... */},
//                 ),
//                 const SizedBox(width: 8),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
