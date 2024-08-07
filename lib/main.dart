import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/screens.dart';
import '../providers/rover_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => RoverProvider()),
      ],
      child: MaterialApp(
        title: 'Mars Rover Coding Challenge',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
        ),
        home: const InputScreen(),
      ),
    );
  }
}
