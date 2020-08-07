import './Bible.dart';

class TextNode {
  final int verse;
  final String text;

  TextNode({ this.verse, this.text });
}

class Paragraph {
  List<TextNode> nodes = List<TextNode>();
  bool startWithIndent = true;
}

List<TextNode> toTextNodes(String text) {
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
