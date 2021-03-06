import 'package:flutter/material.dart';

import './routes/MainRoute.dart';
import './routes/BibleRoute.dart';

import './services/Bible.dart';

void main() {
  runApp(FlutterBibleApp());
}

class FlutterBibleApp extends StatelessWidget {
  final Bible bible = Bible();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Bible App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      routes: <String, WidgetBuilder>{
        MainRoute.routeName: (context) => MainRoute(bible: bible),
        BibleRoute.routeName: (context) => BibleRoute(bible: bible),
      },
    );
  }
}
