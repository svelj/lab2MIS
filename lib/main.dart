import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/notification_service.dart';
import 'screens/main_screen.dart'; // Import the main screen for jokes
import 'screens/random_joke_screen.dart'; // Import the random joke screen
import 'models/joke.dart'; // Import your joke model

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final NotificationService notificationService = NotificationService();
  await notificationService.init();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Joke App',
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(), // Main screen that will show jokes
        '/randomJoke': (context) => RandomJokeScreen(
          joke: ModalRoute.of(context)!.settings.arguments as Joke, // Pass the joke to the screen
        ),
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Notifications and Jokes'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to the random joke screen
                Navigator.pushNamed(
                    context,
                    '/randomJoke',
                    arguments: Joke(id: 1, type: 'general', setup: 'Why did the chicken cross the road?', punchline: 'To get to the other side!')
                );
              },
              child: Text('Go to Random Joke'),
            ),
            ElevatedButton(
              onPressed: () {
                // Trigger a test push notification
              },
              child: Text('Test Notification'),
            ),
          ],
        ),
      ),
    );
  }
}
