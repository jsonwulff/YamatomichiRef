import 'package:flutter/material.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            Text("1"),
            Text("2"),
            Text("3"),
            Text("4"),
            Text("5"),
            Text("6"),
            Text("7"),
            Text("8"),
            // TextField(
            //   keyboardType: TextInputType.multiline,
            //   minLines: 1, 
            //   maxLines: null,
            // ),
          ],
        ),
      ),
    );
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //       body: Center(
  //     child: Column(
  //       mainAxisAlignment: MainAxisAlignment.center,
  //       children: <Widget>[
  //         // Text("TODO: Implement"),
  //         ElevatedButton(
  //           onPressed: () {
  //             Navigator.pop(context);
  //           },
  //           child: Text("Go a page back"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => WebView(
  //                         javascriptMode: JavascriptMode.unrestricted,
  //                         initialUrl:
  //                             'https://www.yamatomichi.com/en/support/faq/'))),
  //           },
  //           child: Text("FAQ"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => WebView(
  //                         javascriptMode: JavascriptMode.unrestricted,
  //                         initialUrl:
  //                             'https://www.yamatomichi.com/en/support/contact/'))),
  //           },
  //           child: Text("Contact"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () => {
  //             Navigator.push(
  //                 context,
  //                 MaterialPageRoute(
  //                     builder: (context) => WebView(
  //                         javascriptMode: JavascriptMode.unrestricted,
  //                         initialUrl:
  //                             'https://www.yamatomichi.com/en/support/online/'))),
  //           },
  //           child: Text("Online Support"),
  //         ),
  //       ],
  //     ),
  //   ));
  // }
}
