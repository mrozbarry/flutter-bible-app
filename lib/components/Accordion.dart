import 'package:flutter/material.dart';

import './Buttons.dart';

class Accordion extends StatefulWidget {
  final Map<String, Widget> accordionMap;

  Accordion({Key key, this.accordionMap}) : super(key: key);

  @override
  _AccordionState createState() => _AccordionState();
}

class _PendingAnimation {
  final String sectionKey;
  final bool open;

  _PendingAnimation({this.sectionKey, this.open});
}

class _AccordionState extends State<Accordion> with TickerProviderStateMixin {
  String _opened = '';
  Map<String, AnimationController> _controllers = Map<String, AnimationController>();
  _PendingAnimation _pendingAnimation;

  @override
  void initState() {
    super.initState();
    widget.accordionMap.forEach((key, _) {
      var controller = AnimationController(vsync: this);
      controller.addStatusListener(onAnimationStatusChange);
      _controllers.addAll({ key: controller });
    });
  }

  void onAnimationStatusChange(AnimationStatus status) {
    if (status != AnimationStatus.completed) {
      return;
    }
    if (_pendingAnimation != null) {
      if (_pendingAnimation.open) {
        _open(_pendingAnimation.sectionKey);
      } else {
        _close(_pendingAnimation.sectionKey);
      }
      _pendingAnimation = null;
    }
  }

  void _close(String sectionKey) {
    _controllers[sectionKey]
        .animateTo(
          0,
          duration: Duration(milliseconds: 150),
        );

    setState(() {
      _opened = '';
    });
  }

  void _open(String sectionKey) {
    _controllers[sectionKey]
        .animateTo(
          _controllers[sectionKey].upperBound,
          duration: Duration(milliseconds: 150),
        );

    setState(() {
      _opened = sectionKey;
    });
  }

  void _toggle(String sectionKey) {
    _pendingAnimation = null;
    if (sectionKey == _opened) {
      _close(sectionKey);
      return;
    }
    if (_opened == '') {
      _open(sectionKey);
      return;
    }

    _pendingAnimation = _PendingAnimation(sectionKey: sectionKey, open: true);
    _close(_opened);
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
    return Column(
      children: <Widget>[
        MaterialRaisedTextIconButton(
          label: Text(sectionKey),
          icon: _opened == sectionKey
            ? Icon(Icons.arrow_drop_up)
            : Icon(Icons.arrow_drop_down),
          onPressed: () {
            _toggle(sectionKey);
          },
          iconSide: IconSide.Right,
          materialTapTargetSize: MaterialTapTargetSize.padded,
        ),
        Padding(
          padding: EdgeInsets.all(2.0),
          child: SizeTransition(
            sizeFactor: CurvedAnimation(
              parent: _controllers[sectionKey],
              curve: Curves.easeInOut,
            ),
            child: widget.accordionMap[sectionKey],
          ),
        ),
      ],
    );
  }
}

