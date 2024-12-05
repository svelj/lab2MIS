import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/joke.dart';

class JokesByTypeScreen extends StatelessWidget {
  final String type;

  const JokesByTypeScreen({required this.type});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes: $type'),
      ),
      body: FutureBuilder<List<Joke>>(
        future: ApiService.fetchJokesByType(type),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final jokes = snapshot.data!;
            return ListView.builder(
              itemCount: jokes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(jokes[index].setup),
                  subtitle: Text(jokes[index].punchline),
                );
              },
            );
          }
        },
      ),
    );
  }
}
