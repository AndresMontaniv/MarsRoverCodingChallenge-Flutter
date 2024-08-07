import 'package:flutter/material.dart';

import '../providers/rover_provider.dart';
import '../widgets/widgets.dart';

class BoardScreen extends StatelessWidget {
  static const name = 'BoardScreen';

  const BoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BoardScreen'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Rovers current Position
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Text(
                'Rover 1 => (1 ,2) N',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),

            // Here I want to know how tall this Sizedbox can be. The layoutbuilder return maxHeight = infinity
            Expanded(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  final maxWidth = constrains.maxWidth;
                  final maxHeight = constrains.maxHeight;
                  print("Max Sizes (width , height) => $maxWidth , $maxHeight");
                  int maxColumns = RoverProvider.calculateMaxItems(maxWidth);
                  int maxRows = RoverProvider.calculateMaxItems(maxHeight);

                  print('Max rows, cols => $maxRows , $maxColumns');
                  // return Container(
                  //   width: maxWidth,
                  //   height: maxHeight,
                  //   color: Colors.lightBlue,
                  // );

                  return Stack(
                    children: [
                      CustomPaint(
                        size: Size(maxWidth, maxHeight),
                        painter: GridPainter(
                          maxColumns,
                          maxRows,
                          RoverProvider.squareMinSize,
                        ),
                      ),
                      const Positioned(
                        left: 0,
                        top: 30,
                        child: Icon(
                          Icons.arrow_back,
                          size: 30,
                          color: Colors.red,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Control Buttons
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_left_outlined),
                    iconSize: 50,
                    onPressed: () {},
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_circle_up_outlined),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_circle_down_outlined),
                        iconSize: 50,
                        onPressed: () {},
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    iconSize: 50,
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final int columns;
  final int rows;
  final double squareSize;

  GridPainter(this.columns, this.rows, this.squareSize);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.0;

    for (int i = 0; i <= columns; i++) {
      double dx = i * (size.width / columns);
      canvas.drawLine(Offset(dx, 0), Offset(dx, size.height), paint);
    }

    for (int i = 0; i <= rows; i++) {
      double dy = i * (size.height / rows);
      canvas.drawLine(Offset(0, dy), Offset(size.width, dy), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}





                  // child: Column(
                  //   mainAxisAlignment: MainAxisAlignment.start,
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     BoardPositionSquare(size: maxWidth / 10, index: 0),
                  //   ],
                  // ),