import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'favorite_jokes_screen.dart';
import 'jokes_by_type_screen.dart';
import '../models/joke.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<String>> jokeTypes;
  List<Joke> favoriteJokes = [];  // Store the favorite jokes

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiService.fetchJokeTypes();
  }

  // Function to add joke to favorite list
  void addFavoriteJoke(Joke joke) {
    setState(() {
      favoriteJokes.add(joke);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Types'),
        actions: [
          // Button to navigate to the Favorite Jokes Screen
          IconButton(
            icon: Icon(Icons.favorite),
            onPressed: () {
              // Navigate to FavoriteJokesScreen and pass the list of favorite jokes
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoriteJokesScreen(favoriteJokes: favoriteJokes),
                ),
              );
            },
          ),
          // Button to get a random joke
          IconButton(
            icon: Icon(Icons.casino),
            onPressed: () async {
              final randomJoke = await ApiService.fetchRandomJoke();
              addFavoriteJoke(randomJoke);  // Add the random joke to favorites
              Navigator.pushNamed(context, '/randomJoke', arguments: randomJoke);
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: jokeTypes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final types = snapshot.data!;
            return ListView.builder(
              itemCount: types.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(types[index]),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => JokesByTypeScreen(type: types[index]),
                      ),
                    );
                  },
                );
              },
            );
          }
        },
      ),
    );
  }
}
