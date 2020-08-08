import 'package:flutter/material.dart';

import '../services/Bible.dart';

import '../routes/MainRoute.dart';
import '../routes/BibleRoute.dart';

import './Buttons.dart';
import './Accordion.dart';

Drawer _layout(List<Widget> children) {
  return Drawer(
    child: Center(
      child: Padding(
        padding: EdgeInsets.fromLTRB(2.0, 50.0, 2.0, 2.0),
        child: ListView(
          children: children,
        ),
      ),
    ),
  );
}

Drawer buildDrawer(BuildContext context, Bible bible) {
  return _layout(<Widget>[
      MaterialTextButton(
        child: Text('Flutter Bible App'),
        onPressed: () {
          Navigator.popAndPushNamed(
            context,
            MainRoute.routeName,
          );
        },
      ),

      Accordion(
        accordionMap: {
          'Old Testament': BookList(bible: bible, testament: Testament.OldTestament),
          'New Testament': BookList(bible: bible, testament: Testament.NewTestament),
        },
      ),
    ],
  );
}

Drawer buildBibleDrawer(BuildContext context, Bible bible) {
  return buildDrawer(context, bible);
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
    if (_books == null) {
      return Text('Loading books');
    }

    var children = List.generate(
      _books.length,
      (index) => MaterialTextButton(
        child: Align(
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

    return ListBody(
      children: children,
    );
  }
}
