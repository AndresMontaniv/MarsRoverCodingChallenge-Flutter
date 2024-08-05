import 'package:flutter/material.dart';
import '../rover.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mars Rover Coding Challenge',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final inputCtrl = TextEditingController(
    text: '''5 5
1 2 N
LMLMLMLMM
3 3 E
MMRMMRMRRM''',
  );

  String? outputStr;
  bool isLoading = false;

  Future<void> processData() async {
    FocusScope.of(context).unfocus();
    outputStr = null;
    final inputStr = inputCtrl.text.trim();

    if (inputStr.isEmpty) return;
    isLoading = true;
    if (mounted) {
      setState(() {});
    }

    // Load Input
    final values = inputStr.split('\n');
    assert(
      values.length >= 3 && values.length % 2 != 0,
      'The input String must contain at least 3 sentences, 1 for the the gridsize and 2 for every rover',
    );
    if (values.isEmpty) return;
    print(values);
    List<String> gridSize = values.firstOrNull!.split(' ');
    assert(gridSize.length == 2, 'The first line of the Input must have 2 elements');
    final x = int.tryParse(gridSize[0]);
    assert(x is int, 'The value of maxRow must be an integer');
    final y = int.tryParse(gridSize[1]);
    assert(y is int, 'The value of maxCol must be an integer');
    List<Rover> rovers = [];
    final inputLength = values.length;
    for (var i = 1; i < inputLength; i += 2) {
      final end = i + 2;
      print('Searching elements at ($i , ${end - 1})');
      if (end <= inputLength) {
        rovers.add(Rover.fromIterableParam(values.sublist(i, end)));
      }
    }

    int index = 0;

    // Process steps
    for (var rover in rovers) {
      print('rover $index');
      try {
        final finalPosition = await rover.getLastPosition(x!, y!);
        outputStr = '${outputStr ?? ''}$finalPosition \n';
        index++;
      } catch (e) {
        print(e);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(e.toString()),
              backgroundColor: Colors.red,
            ),
          );
        }
        break;
      }
    }

    if (rovers.isEmpty) {
      outputStr = 'Empty data\n';
    } else {
      outputStr = '${outputStr ?? ''}===========';
    }

    // Finish processing
    isLoading = false;
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mars Rover Coding Challenge'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 10,
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
                maxLines: 5,
                controller: inputCtrl,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isLoading ? null : processData,
              child: const Text('Submit'),
            ),
            if (isLoading || outputStr != null) buildOutputView(),
          ],
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
