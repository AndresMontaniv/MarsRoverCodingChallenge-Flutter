import 'package:flutter/material.dart';

class RoverListScreen extends StatelessWidget {
  static const name = 'RoverListScreen';

  const RoverListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loaded Rovers'),
      ),
      body: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 700),
        child: const Column(
          children: [
            Text('RoverListScreen'),
          ],
        ),
      ),
    );
  }
}
