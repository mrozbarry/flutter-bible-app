import 'package:flutter/material.dart';
import 'dart:math';

class Grid extends StatelessWidget {
  final List<Widget> children;
  final int columns;

  Grid({this.children = const [], this.columns = 2});

  @override
  Widget build(BuildContext context) {
    if (children.length == 0) {
      return Container();
    }

    List<List<Widget>> rows = List.generate(
      (children.length / columns).ceil(),
      (index) {
        var start = index * columns;
        var end = min(children.length, start + columns);
        return children.sublist(start, end);
      }
    );

    rows.removeWhere((row) => row.length == 0);

    return Column(
      children: List.generate(
        rows.length,
        (index) {
          print('grid.row ${rows[index]}');
          return Row(
            children: List.generate(
              columns,
              (rowIndex) {
                var child = rowIndex < rows[index].length
                  ? rows[index][rowIndex]
                  : Container();

                return Expanded(child: child);
              },
            ),
          );
        },
      ),
    );
  }
}
