import 'package:flutter/material.dart';

class BoardPositionSquare extends StatelessWidget {
  final double size;
  final int index;
  const BoardPositionSquare({super.key, required this.size, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      color: index % 2 == 0 ? Colors.red : Colors.yellow,
      alignment: Alignment.center,
      child: Text(index.toString()),
    );
  }
}
