// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:mars_rover_coding_challenge/models/models.dart';

void main() {
  Future<List<String>> inputValidator(String input) async {
    final values = input.trim().split('\n');
    values.removeWhere((e) => e.isEmpty);
    if (values.length < 3 || values.length % 2 == 0) {
      return Future.error(
        ArgumentError('The input String must have an odd number of lines (at least 3), 1 for the the gridsize and 2 for every rover'),
      );
    }

    // Check gridSize input
    if (!RegExp(r'^\d+\s\d+$').hasMatch(values.firstOrNull ?? '')) {
      return Future.error(ArgumentError('The first line of the Input must have 2 elements, each element must be a non negative number'));
    }

    return values;
  }

  test('test algorithm', () async {
    const input = '''5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM''';
    String? outputStr;
    final inputLines = await inputValidator(input);

    // Initialize gridsize (x,y)
    List<String> gridSize = inputLines.firstOrNull!.split(' ');
    final x = int.parse(gridSize[0]);
    final y = int.parse(gridSize[1]);

    if (x < 0 || y < 0) {
      throw ArgumentError("maxRow and maxCol can't be negative");
    }

    // Build sublists and Parse rovers
    List<Rover> rovers = [];
    for (var i = 1; i < inputLines.length; i += 2) {
      final end = i + 2;
      if (end <= inputLines.length) {
        rovers.add(Rover.fromIterableParam(inputLines.sublist(i, end)));
      }
    }

    // Calculate Output String
    for (var rover in rovers) {
      final finalPosition = await rover.getLastPosition(x, y);
      outputStr = '${outputStr ?? ''}$finalPosition\n';
    }

    // Remove the last newline character
    outputStr = outputStr?.trimRight();

    const expectedResult = '1 3 N\n5 1 E';

    // Set invalid maxRow and maxCol to force an out-of-bound error
    expect(outputStr, expectedResult);
  });
}
