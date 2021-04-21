import 'package:app/ui/shared/navigation/app_bar_custom.dart';
import 'package:flutter/material.dart';

import 'calendar/components/comment_widget.dart';

class CommentsViews extends StatefulWidget {
  @override
  _CommentsViewsState createState() => _CommentsViewsState();
}

class _CommentsViewsState extends State<CommentsViews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBarCustom.basicAppBarWithContext('test', context),
        body: Container(
          child: CommentWidget(
            documentRef: '2f1JURIqAzJ2SWPCaK8o',
          ),
        ));
  }
}
