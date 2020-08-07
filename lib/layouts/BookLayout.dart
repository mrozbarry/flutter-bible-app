import 'dart:math';
import 'package:flutter/material.dart';

import '../components/Drawer.dart';
import '../components/Chapter.dart';

import '../services/Bible.dart';

class BookLayout extends StatefulWidget {
  BookLayout({Key key, this.bookName, this.bible, this.chapter = 1}) : super(key: key);

  final String bookName;
  final Bible bible;
  final int chapter;

  @override
  _BookLayoutState createState() => _BookLayoutState();
}

class _BookLayoutState extends State<BookLayout> {
  Book _book;
  int _chapters;
  PageController _controller = PageController(initialPage: 0);

  @override
  void initState() {
    super.initState();
    _load(widget.bookName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _load(String bookToFind) async {
    setState(() {
      _book = null;
      _chapters = null;
    });

    var book = await Book.findByBookName(widget.bible, bookToFind);
    var chapters = await book.chapters();

    setState(() {
      _book = book;
      _chapters = chapters;
    });

    var chapter = min(widget.chapter, _chapters);
    _controller.jumpToPage(chapter - 1);
  }

  @override
  Widget build(BuildContext context) {
    var title = _book == null
        ? ''
        : _book.name;

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: buildDrawer(widget.bible),
      endDrawer: buildBibleDrawer(widget.bible),
      body: Center(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              //child: Container(
                  //child: Text('Body here...'),
              //),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: chapters(),
              )
            ),
          ],
        ),
      ),
    );
  }

  Widget chapters() {
    return PageView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      children: List.generate(
        _chapters == null ? 0 : _chapters,
        (index) {
          return Chapter(
            bible: widget.bible,
            bookName: widget.bookName,
            chapter: index + 1,
          );
        },
      ),
    );

    //return ListView(
        //children: chapters,
        //controller: _controller,
    //);
  }
}
