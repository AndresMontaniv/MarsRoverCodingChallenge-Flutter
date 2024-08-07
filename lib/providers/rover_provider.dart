import 'package:flutter/material.dart';

import '../models/models.dart';

class RoverProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Rover> rovers = [];
  String? errorMsg;
  String? inputStr = '''5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM''';

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

  Future<List<String>> inputValidator() async {
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
      final inputLines = await inputValidator();

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
    } catch (e) {
      errorMsg = e.toString();
    }
    isLoading = false;
  }
}
