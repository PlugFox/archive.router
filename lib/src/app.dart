import 'package:flutter/material.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  static void run() => runApp(
        const App(),
      );

  @override
  Widget build(BuildContext context) => const MaterialApp(
        title: 'Router',
        home: Scaffold(
          body: SafeArea(
            child: Center(
              child: Text('Router'),
            ),
          ),
        ),
      );
}
