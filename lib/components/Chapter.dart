import 'package:flutter/material.dart';
import '../services/Bible.dart';

class Chapter extends StatefulWidget {
  Chapter({Key key, this.bible, this.bookName, this.chapter}) : super(key: key);

  final Bible bible;
  final String bookName;
  final int chapter;

  @override
  _ChapterState createState() => _ChapterState();
}

class _ChapterState extends State<Chapter> {
  Book _book;
  List<Verse> _verses = [];

  @override
  void initState() {
    super.initState();
    _read(bookToFind: widget.bookName);
  }

  void _read({ String bookToFind }) async {
    setState(() {
      _book = null;
    });

    var book = await Book.findByBookName(widget.bible, bookToFind);
    var verses = await book.verses(widget.chapter);

    setState(() {
      _book = book;
      _verses = verses;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_book == null) {
      return Column(
          children: <Widget>[
            Text('Loading...'),
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
      );
    }

    var textSpans = _verses.map((v) => verse(v)).toList();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        ClipRRect(
          child: Container(
            margin: const EdgeInsets.only(bottom: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  offset: Offset(0, 1),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 16, bottom: 16),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  "Chapter ${widget.chapter}",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 1,
          child: Padding(
            padding: EdgeInsets.only(left: 16.0, right: 16.0),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.only(bottom: 64),
                child: Text.rich(
                  TextSpan(
                      children: <InlineSpan>[
                        TextSpan(children: textSpans),
                      ],
                      style: TextStyle(
                          letterSpacing: 0.5,
                          fontSize: 16,
                          height: 1.5,
                      )
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  TextSpan verse(Verse verse) {
    bool isNewParagraph = verse.text.startsWith('<pb/>');

    var text = verse.text
        .replaceAll(new RegExp(r'<pb/>'), '')
        .replaceAll(new RegExp(r'<t>'), '')
        .replaceAll(new RegExp(r'</t>'), '')
        .replaceAll(new RegExp(r'<J>'), '')
        .replaceAll(new RegExp(r'</J>'), '')
        .replaceAll(new RegExp(r'<S>\d+</S>'), '');

    var prefix = isNewParagraph ? '\n  ' : '';

    return TextSpan(
      children: <InlineSpan>[
        TextSpan(text: prefix),
        WidgetSpan(
          child: Transform.translate(
              offset: const Offset(0, -8),
              child: Text(
                verse.verse.toString(),
                style: TextStyle(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                ),
              ),
          ),
        ),
        TextSpan(
          text: text + ' ',
          style: TextStyle(
            inherit: true,
          ),
        ),
      ],
    );
  }
}
