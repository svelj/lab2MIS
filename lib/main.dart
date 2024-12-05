import 'package:flutter/material.dart';
import 'screens/main_screen.dart';
import 'screens/random_joke_screen.dart';
import 'models/joke.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/randomJoke': (context) => RandomJokeScreen(
          joke: ModalRoute.of(context)!.settings.arguments as Joke,
        ),
      },
    );
  }
}
