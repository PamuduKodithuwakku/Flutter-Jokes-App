import 'package:flutter/material.dart';
import 'api_service.dart';
import 'cache_service.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Jokes App',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        fontFamily: 'Poppins',
        textTheme: TextTheme(
          bodyLarge: TextStyle(fontSize: 16.0, color: Colors.black),
          headlineMedium: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
      home: JokesPage(),
    );
  }
}

class JokesPage extends StatefulWidget {
  @override
  _JokesPageState createState() => _JokesPageState();
}

class _JokesPageState extends State<JokesPage> {
  List<String> jokes = [];
  bool isLoading = false;

  Future<void> fetchJokesAndDisplay() async {
    setState(() {
      isLoading = true;
    });

    try {
      final onlineJokes = await fetchJokes();
      await saveJokes(onlineJokes);
      setState(() {
        jokes = onlineJokes.take(5).toList(); // Fetch only the first 5 jokes
        isLoading = false;
      });
    } catch (_) {
      final cachedJokes = await loadCachedJokes();
      setState(() {
        jokes = cachedJokes?.take(5).toList() ?? ['No jokes available'];
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Jokes App',
          style: TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.teal[100]!, Colors.teal[400]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Make content stretch horizontally
            children: [
              Text(
                'Welcome to the Jokes App!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.teal[900],
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: isLoading ? null : fetchJokesAndDisplay,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  textStyle: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                ),
                child: isLoading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Fetch Jokes'),
              ),
              SizedBox(height: 30),
              if (jokes.isNotEmpty)
                Expanded(
                  child: ListView.builder(
                    itemCount: jokes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Card(
                          elevation: 6.0,
                          color: Colors.white,
                          shadowColor: Colors.teal[200],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              jokes[index],
                              style: TextStyle(
                                fontSize: 18.0,
                                color: Colors.teal[800],
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              if (jokes.isEmpty && !isLoading)
                Text(
                  'No jokes available. Please try fetching jokes!',
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }
}