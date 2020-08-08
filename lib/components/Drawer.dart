import 'package:flutter/material.dart';

import '../services/Bible.dart';
import '../routes/MainRoute.dart';
import '../routes/BibleRoute.dart';

Drawer _layout(List<Widget> children) {
  return Drawer(
    child: Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(2.0, 50.0, 2.0, 2.0),
        child: Column(
            children: children,
        ),
      ),
    ),
  );
}

Drawer buildDrawer(BuildContext context, Bible bible) {
  return _layout(<Widget>[
      FlatButton(
        child: Text('Flutter Bible App'),
        onPressed: () {
          Navigator.popAndPushNamed(
            context,
            MainRoute.routeName,
          );
        },
      ),
      Expanded(
        flex: 1,
        child: BookList(
          bible: bible,
        ),
      ),
    ],
  );
}

Drawer buildBibleDrawer(BuildContext context, Bible bible) {
  return buildDrawer(context, bible);
}

class BookList extends StatefulWidget {
  BookList({Key key, this.bible}) : super(key: key);

  final Bible bible;

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

    setState(() {
      _books = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_books == null) {
      return Text('Loading books');
    }

    var children = List.generate(
      _books.length,
      (index) => FlatButton(
        child: Text(_books[index].name),
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
    );

    return ListView(
      children: children,
    );
  }
}
