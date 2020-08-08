import 'package:flutter/material.dart';

import '../layouts/MainLayout.dart';

import '../services/Bible.dart';

class MainRoute extends StatelessWidget {
  static const routeName = '/';

  MainRoute({Key key, this.bible}) : super(key: key);

  final Bible bible;

  @override
  Widget build(BuildContext context) {
    return MainLayout(bible: bible);
  }
}
