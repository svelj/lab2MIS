import 'package:flutter/material.dart';
import '../services/api_services.dart';
import '../models/joke.dart';
import 'favorite_jokes_screen.dart';

class JokesByTypeScreen extends StatefulWidget {
  final String type;

  const JokesByTypeScreen({required this.type});

  @override
  _JokesByTypeScreenState createState() => _JokesByTypeScreenState();
}

class _JokesByTypeScreenState extends State<JokesByTypeScreen> {
  late Future<List<Joke>> _jokesFuture;
  final List<Joke> _favoriteJokes = [];

  @override
  void initState() {
    super.initState();
    _jokesFuture = ApiService.fetchJokesByType(widget.type);
  }

  void _toggleFavorite(Joke joke) {
    setState(() {
      if (_favoriteJokes.contains(joke)) {
        _favoriteJokes.remove(joke);
      } else {
        _favoriteJokes.add(joke);
      }
    });
  }

  bool _isFavorite(Joke joke) {
    return _favoriteJokes.contains(joke);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Jokes: ${widget.type}'),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteJokesScreen(favoriteJokes: _favoriteJokes),
                ),
              );
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Joke>>(
        future: _jokesFuture,
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
                final joke = jokes[index];
                return ListTile(
                  title: Text(joke.setup),
                  subtitle: Text(joke.punchline),
                  trailing: IconButton(
                    icon: Icon(
                      _isFavorite(joke) ? Icons.favorite : Icons.favorite_border,
                      color: _isFavorite(joke) ? Colors.red : null,
                    ),
                    onPressed: () {
                      _toggleFavorite(joke);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}