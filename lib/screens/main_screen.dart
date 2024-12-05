import 'package:flutter/material.dart';
import '../services/api_services.dart';
import 'jokes_by_type_screen.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<List<String>> jokeTypes;

  @override
  void initState() {
    super.initState();
    jokeTypes = ApiService.fetchJokeTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Joke Types'),
        actions: [
          IconButton(
            icon: Icon(Icons.casino),
            onPressed: () async {
              final randomJoke = await ApiService.fetchRandomJoke();
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
