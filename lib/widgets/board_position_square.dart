import 'package:flutter/material.dart';
import '../enums/enums.dart';

class BoardPositionSquare extends StatelessWidget {
  final double size;
  final (int, int) position;
  final bool isLastCol;
  final bool isLastRow;
  final RoverDirection? direction;
  const BoardPositionSquare({
    super.key,
    required this.size,
    required this.position,
    this.isLastCol = false,
    this.isLastRow = false,
    this.direction,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border(
          top: const BorderSide(),
          left: const BorderSide(),
          right: isLastCol ? const BorderSide() : BorderSide.none,
          bottom: isLastRow ? const BorderSide() : BorderSide.none,
        ),
      ),
      alignment: Alignment.center,
      child: direction == null
          ? null
          : Icon(
              direction!.icon,
              size: 30,
              color: Colors.red,
            ),
    );
  }
}
