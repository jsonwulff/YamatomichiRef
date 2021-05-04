import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class NewsItem extends StatelessWidget {
  final String title;
  final String imageUrl;
  final String newsUrl;
  final String category;
  final String date;

  const NewsItem({
    Key key,
    this.title,
    this.imageUrl,
    this.newsUrl,
    this.category,
    this.date,
  }) : super(key: key);

  String removeAllHtmlTags(String htmlText) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

    return htmlText.replaceAll(exp, ' ');
  }

  String dateTimeStringToDate(String dateTime) {
    final DateTime parsedDateTime = DateTime.parse(dateTime);
    final DateFormat dateFormatter = DateFormat('yyyy.MM.dd');
    return dateFormatter.format(parsedDateTime);
  }

  Widget _leftPicture(imageUrl) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(18),
          bottomLeft: Radius.circular(18),
        ),
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: GestureDetector(
        child: Card(
            elevation: 5.0,
            shadowColor: Colors.black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: _leftPicture(imageUrl),
                ),
                Expanded(
                  flex: 7,
                  child: Padding(
                    padding: const EdgeInsets.all(6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Chip(
                              label: Text(
                                  category[0].toUpperCase() + category.substring(1).toLowerCase()),
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                              backgroundColor: Theme.of(context).primaryColor,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(12, 0, 0, 0),
                              child: Text(
                                dateTimeStringToDate(date),
                                style: Theme.of(context).textTheme.bodyText2,
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(4.0, 0, 0, 0),
                          child: Text(
                            removeAllHtmlTags(title),
                            textAlign: TextAlign.left,
                            style: Theme.of(context).textTheme.bodyText1,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            )),
        onTap: () => launch(newsUrl),
      ),
    );
  }
}
