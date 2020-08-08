import 'package:flutter/material.dart';

import '../components/Drawer.dart';

import '../services/Bible.dart';

class MainLayout extends StatelessWidget {
  MainLayout({Key key, this.bible}) : super(key: key);

  final Bible bible;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Bible App'),
        primary: true,
        centerTitle: true,
      ),

      drawer: buildDrawer(context, bible),

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
                child: Text('My bible app'),
              )
            ),
          ],
        ),
      ),
    );
  }
}
