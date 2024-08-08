import 'package:flutter/material.dart';

import '../enums/enums.dart';
import '../widgets/widgets.dart';
import '../providers/rover_provider.dart';

class BoardScreen extends StatefulWidget {
  static const name = 'BoardScreen';

  const BoardScreen({super.key});

  @override
  State<BoardScreen> createState() => _BoardScreenState();
}

class _BoardScreenState extends State<BoardScreen> {
  RoverDirection currentDirection = RoverDirection.south;
  double currentX = 0;
  double currentY = 0;

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
                'Rover 1 => ($currentX ,$currentY) ${currentDirection.label}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),

            // Board
            Expanded(
              child: LayoutBuilder(
                builder: (context, constrains) {
                  final maxWidth = constrains.maxWidth;
                  final maxHeight = constrains.maxHeight;
                  print("Max Sizes (width , height) => $maxWidth , $maxHeight");
                  int maxColumns = RoverProvider.calculateMaxItems(maxWidth);
                  int maxRows = RoverProvider.calculateMaxItems(maxHeight);

                  print('Max rows, cols => $maxRows , $maxColumns');

                  double pieceWidth = maxWidth / maxColumns;
                  double pieceHeight = maxHeight / maxRows;

                  print('size $pieceWidth, $pieceHeight');

                  return Column(
                    verticalDirection: VerticalDirection.up,
                    children: List.generate(maxRows, (rowIndex) {
                      return Row(
                        children: List.generate(maxColumns, (colIndex) {
                          int x = colIndex;
                          int y = (maxRows - 1) - rowIndex;

                          print('rxa => $x, $y');

                          return BoardPositionSquare(
                            size: 31,
                            position: (x, y),
                            isLastCol: x == maxColumns - 1,
                            isLastRow: y == maxRows - 1,
                            direction: x == currentX && y == currentY ? currentDirection : null,
                          );
                        }),
                      );
                    }),
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
                    onPressed: () {
                      currentDirection = RoverDirection.west;
                      currentX--;
                      setState(() {});
                    },
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.arrow_circle_up_outlined),
                        iconSize: 50,
                        onPressed: () {
                          currentDirection = RoverDirection.north;
                          currentY--;
                          setState(() {});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.arrow_circle_down_outlined),
                        iconSize: 50,
                        onPressed: () {
                          currentDirection = RoverDirection.south;
                          currentY++;
                          setState(() {});
                        },
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_circle_right_outlined),
                    iconSize: 50,
                    onPressed: () {
                      currentDirection = RoverDirection.east;
                      currentX++;
                      setState(() {});
                    },
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
