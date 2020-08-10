import 'package:tuple/tuple.dart';

import './Bible.dart';

enum TextNodeType {
  VerseAnchor,
  Text,
}

class TextNode {
  final int verse;
  final String text;
  final TextNodeType textNodeType;

  TextNode({
    this.verse,
    this.text,
    this.textNodeType = TextNodeType.Text,
  });
}

class Paragraph {
  List<TextNode> nodes = List<TextNode>();
  bool startWithIndent = true;

  Tuple2<Paragraph, int> appendFrom(Verse verse, { int offset = 0 }) {
    var initialText = _cleanVerseText(verse);
    var end = initialText.indexOf('</pb>', offset + 1);
    var text = end == -1
        ? initialText.substring(offset)
        : initialText.substring(offset, end);

    if (offset == 0) {
      nodes.add(TextNode(
        verse: verse.verse,
        text: verse.verse.toString(),
        textNodeType: TextNodeType.VerseAnchor,
      ));
    }

    nodes.add(TextNode(
      verse: verse.verse,
      text: text,
    ));

    return end == -1
      ? Tuple2<Paragraph, int>(this, 0)
      : Tuple2<Paragraph, int>(Paragraph(), end + 1);
  }

  String _cleanVerseText(Verse verse) {
    return verse.text
        .replaceAll(new RegExp(r'<S>\d+</S>'), '')
        .replaceAll(new RegExp(r'</?%s>'), '');
  }
}

List<Paragraph> toParagraphs(List<Verse> verses) {
  List<Paragraph> paragraphs;
  var paragraph = Paragraph();

  if (!verses[0].text.startsWith('<pb/>')) {
    paragraph.startWithIndent = false;
  }

  verses.forEach((verse) {
    if (verse.text.startsWith('<pb/>')) {
      paragraphs.add(paragraph);
      paragraph = Paragraph();
    }

    var innerParagraphs = verse.text
        .split('<pb/>');

    innerParagraphs.retainWhere((part) => part.trim().length == 0);
  });

  return paragraphs;
}
