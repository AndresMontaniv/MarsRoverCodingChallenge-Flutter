import 'package:flutter/material.dart';
import '../enums/enums.dart';

import '../models/models.dart';

class RoverProvider extends ChangeNotifier {
  static const squareMinSize = 30.0;
  bool _isLoading = false;
  //TODO: remove hardcode
  List<Rover> rovers = [
    Rover(
      (1, 2),
      RoverDirection.north,
      [
        RoverCommand.left,
        RoverCommand.move,
        RoverCommand.left,
        RoverCommand.move,
        RoverCommand.left,
        RoverCommand.move,
        RoverCommand.move,
      ],
    ),
  ];
  String? errorMsg;
  //TODO: remove hardcode
  String? inputStr = '''5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM''';

  static int calculateMaxItems(double maxSize) {
    int count = 0;
    while ((maxSize / (count + 1)) >= squareMinSize) {
      count++;
    }
    return count;
  }

  int get roversLoaded => rovers.length;

  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void clearValues() {
    rovers.clear();
    errorMsg = null;
    inputStr = null;
    notifyListeners();
  }

  Future<List<String>> _inputValidator() async {
    if (inputStr?.isEmpty ?? true) {
      return Future.error(
        RoverInputError("The input String can't be empty"),
      );
    }
    final values = inputStr!.trim().split('\n');
    values.removeWhere((e) => e.isEmpty);
    if (values.length < 3 || values.length % 2 == 0) {
      return Future.error(
        RoverInputError('The input String must have an odd number of lines (at least 3), 1 for the the gridsize and 2 for every rover'),
      );
    }

    // Check gridSize input
    if (!RegExp(r'^\d+\s\d+$').hasMatch(values.firstOrNull ?? '')) {
      return Future.error(RoverInputError('The first line of the Input must have 2 elements, each element must be a non negative number'));
    }

    return values;
  }

  Future<void> loadData() async {
    // Reset Values
    errorMsg = null;
    isLoading = true;

    try {
      // Load Input
      final inputLines = await _inputValidator();

      // Initialize gridsize (x,y)
      List<String> gridSize = inputLines.firstOrNull!.split(' ');
      final x = int.parse(gridSize[0]);
      final y = int.parse(gridSize[1]);

      if (x < 0 || y < 0) {
        throw RoverInputError("maxRow and maxCol can't be negative");
      }

      // Build sublists and Parse rovers
      final roversInputLines = inputLines.sublist(1);
      rovers.clear();
      rovers = ListRoverParsing.fromList(roversInputLines);
      await Future.delayed(const Duration(seconds: 1));
    } catch (e) {
      errorMsg = e.toString();
    }
    isLoading = false;
  }
}
