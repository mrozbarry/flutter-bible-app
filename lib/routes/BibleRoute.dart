import 'package:flutter/material.dart';

import '../layouts/BookLayout.dart';

import '../services/Bible.dart';

class BibleRouteArguments {
  final String bookName;
  final int bookChapter;

  BibleRouteArguments(this.bookName, this.bookChapter);
}

class BibleRoute extends StatelessWidget {
  static const routeName = '/bible/read';

  BibleRoute({Key key, this.bible}) : super(key: key);

  final Bible bible;

  @override
  Widget build(BuildContext context) {
    final BibleRouteArguments args = ModalRoute.of(context).settings.arguments;

    return BookLayout(
        bible: bible,
        bookName: args.bookName,
        chapter: args.bookChapter,
    );
  }
}
