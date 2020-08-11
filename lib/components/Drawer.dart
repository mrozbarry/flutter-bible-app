import 'package:flutter/material.dart';

import '../services/Bible.dart';

import '../routes/MainRoute.dart';
import '../routes/BibleRoute.dart';

import './Buttons.dart';
import './Accordion.dart';
import './Heading.dart';
import './Grid.dart';

Drawer drawerLayout(List<Widget> children) {
  return Drawer(
    child: Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 2.0),
        child: ListView(
          children: children,
        ),
      ),
    ),
  );
}

Drawer buildDrawer(BuildContext context, Bible bible) {
  return drawerLayout(<Widget>[
    heading('Flutter Bible'),
    ListBody(
      children: [
        MaterialTextButton(
          child: Text('Home'),
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              MainRoute.routeName,
            );
          },
        ),
      ],
    ),

    heading('Read the Bible'),
    Accordion(
      accordionMap: {
        'Old Testament': BookList(bible: bible, testament: Testament.OldTestament),
        'New Testament': BookList(bible: bible, testament: Testament.NewTestament),
      },
    ),
  ]);
}

class BookList extends StatefulWidget {
  BookList({Key key, this.bible, this.testament}) : super(key: key);

  final Bible bible;
  final Testament testament;

  @override
  _BookListState createState() => _BookListState();
}

class _BookListState extends State<BookList> {
  List<Book> _books;

  @override
  void initState() {
    super.initState();
    _read();
  }

  void _read() async {
    setState(() {
      _books = null;
    });

    var books = await widget.bible.books();
    books.retainWhere((book) {
      return widget.testament == Testament.OldTestament
        ? book.isOldTestament()
        : book.isNewTestament();
    });

    setState(() {
      _books = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    var count = _books == null ? 0 : _books.length;

    return Grid(
      children: List.generate(
        count,
        (index) => CustomButton(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                _books[index].name.trim(),
                textAlign: TextAlign.start,
                softWrap: false,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
          ],
          onPressed: () {
            Navigator.popAndPushNamed(
              context,
              BibleRoute.routeName,
              arguments: BibleRouteArguments(
                  _books[index].name,
                  1,
              ),
            );
          },
        ),
      ),
    );
  }
}
