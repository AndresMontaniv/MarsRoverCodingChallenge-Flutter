import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import '../providers/rover_provider.dart';

class InputScreen extends StatefulWidget {
  static const name = 'InputScreen';

  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final inputCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    final roverProvider = context.read<RoverProvider>();
    inputCtrl.text = roverProvider.inputStr ?? '';
  }

  void loadData() {
    // Unfocus TextField
    FocusScope.of(context).unfocus();
    final roverProvider = context.read<RoverProvider>();
    roverProvider.loadData();
  }

  void clearInputField() {
    // Unfocus TextField
    FocusScope.of(context).unfocus();
    final roverProvider = context.read<RoverProvider>();
    inputCtrl.clear();
    roverProvider.clearValues();
  }

  @override
  Widget build(BuildContext context) {
    final roverProvider = context.watch<RoverProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('BoardGame Style'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 15,
        ),
        child: CustomScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          slivers: [
            SliverToBoxAdapter(
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
                          enabled: !roverProvider.isLoading,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (value) => roverProvider.inputStr = value,
                        ),
                      ),
                      if (roverProvider.errorMsg != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            roverProvider.errorMsg!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          if (inputCtrl.text.trim().isNotEmpty)
                            ElevatedButton(
                              onPressed: roverProvider.isLoading ? null : clearInputField,
                              style: const ButtonStyle(
                                backgroundColor: WidgetStatePropertyAll(Colors.grey),
                                foregroundColor: WidgetStatePropertyAll(Colors.white),
                              ),
                              child: const Text('Clear'),
                            ),
                          ElevatedButton(
                            onPressed: roverProvider.isLoading ? null : loadData,
                            style: const ButtonStyle(
                              backgroundColor: WidgetStatePropertyAll(Colors.blue),
                              foregroundColor: WidgetStatePropertyAll(Colors.white),
                            ),
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 40),
                      Text(
                        'Ready to go => ${roverProvider.roversLoaded}',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: CustomMaterialButton(
                  title: 'Ready to go',
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
