import 'package:flutter/material.dart';

class InputScreen extends StatefulWidget {
  static const name = 'InputScreen';

  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final inputCtrl = TextEditingController();
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
        ArgumentError('The input String must have an odd number of lines (at least 3), 1 for the the gridsize and 2 for every rover'),
      );
    }

    // Check gridSize input
    if (!RegExp(r'^\d+\s\d+$').hasMatch(values.firstOrNull ?? '')) {
      return Future.error(ArgumentError('The first line of the Input must have 2 elements, each element must be a non negative number'));
    }

    return values;
  }

  Future<void> processData() async {}

  void clearInputField() {
    inputCtrl.clear();
    errorMsg = null;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BoardGame Style'),
      ),
      body: Column(
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
        ],
      ),
    );
  }
}
