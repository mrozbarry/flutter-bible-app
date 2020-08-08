import 'package:flutter/material.dart';

import './Buttons.dart';

class Accordion extends StatefulWidget {
  final Map<String, Widget> accordionMap;

  Accordion({Key key, this.accordionMap}) : super(key: key);

  @override
  _AccordionState createState() => _AccordionState();
}

class _AccordionState extends State<Accordion> {
  String _opened = '';

  void _open(String sectionKey) async {
    if (!widget.accordionMap.containsKey(sectionKey)) {
      return;
    }

    setState(() {
      _opened = _opened == sectionKey ? '' : sectionKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    var sections = List.generate(
      widget.accordionMap.length,
      (index) => section(
          widget.accordionMap.keys.elementAt(index),
      ),
    );

    return Column(children: sections);
  }

  Widget section(String sectionKey) {
    var children = <Widget>[
      MaterialRaisedTextIconButton(
        label: Text(sectionKey),
        icon: Icon(Icons.arrow_drop_down),
        onPressed: () {
          _open(sectionKey);
        },
        iconSide: IconSide.Right,
      ),
    ];

    if (_opened == sectionKey) {
      children.add(widget.accordionMap[sectionKey]);
    }

    return Column(
      children: children,
    );
  }
}

