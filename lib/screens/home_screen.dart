import 'package:flutter/material.dart';
import '../models/models.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final inputCtrl = TextEditingController();

  String? outputStr;
  String? errorMsg;
  bool isLoading = false;

  void setLoading(bool b) {
    isLoading = b;
    if (mounted) {
      setState(() {});
    }
  }

  Future<List<String>> inputValidator(String input) async {
    final values = input.trim().split('\n');
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

  Future<void> processData() async {
    // Unfocus TextField
    FocusScope.of(context).unfocus();

    // Reset Values
    outputStr = null;
    errorMsg = null;

    setLoading(true);

    try {
      // Load Input
      final inputLines = await inputValidator(inputCtrl.text);

      // Initialize gridsize (x,y)
      List<String> gridSize = inputLines.firstOrNull!.split(' ');
      final x = int.parse(gridSize[0]);
      final y = int.parse(gridSize[1]);

      if (x < 0 || y < 0) {
        throw RoverInputError("maxRow and maxCol can't be negative");
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
        outputStr = '${outputStr ?? ''}$finalPosition \n';
      }

      if (rovers.isEmpty) {
        outputStr = 'Empty data';
      } else {
        outputStr = '${outputStr ?? ''}===========';
      }
    } catch (e) {
      errorMsg = e.toString();
    }
    setLoading(false);
  }

  void clearInputField() {
    inputCtrl.clear();
    outputStr = null;
    errorMsg = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mars Rover Coding Challenge'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 700,
            ),
            child: Column(
              children: [
                Text(
                  'Input',
                  style: Theme.of(context).textTheme.displaySmall,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 20, bottom: 30),
                  child: TextField(
                    maxLines: 10,
                    controller: inputCtrl,
                    textCapitalization: TextCapitalization.characters,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                if (errorMsg != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Text(
                      errorMsg!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    if (inputCtrl.text.trim().isNotEmpty)
                      ElevatedButton(
                        onPressed: isLoading ? null : clearInputField,
                        style: const ButtonStyle(
                          backgroundColor: WidgetStatePropertyAll(Colors.grey),
                          foregroundColor: WidgetStatePropertyAll(Colors.white),
                        ),
                        child: const Text('Clear'),
                      ),
                    ElevatedButton(
                      onPressed: isLoading ? null : processData,
                      style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.blue),
                        foregroundColor: WidgetStatePropertyAll(Colors.white),
                      ),
                      child: const Text('Submit'),
                    ),
                  ],
                ),
                if (isLoading || outputStr != null) buildOutputView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildOutputView() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Divider(height: 50),
        Text(
          'Output',
          style: Theme.of(context).textTheme.displaySmall,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: isLoading
              ? const CircularProgressIndicator()
              : Text(
                  outputStr ?? 'No Output',
                ),
        ),
      ],
    );
  }
}
