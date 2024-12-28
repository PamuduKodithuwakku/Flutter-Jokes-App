import 'dart:convert';
import 'package:http/http.dart' as http;

Future<List<String>> fetchJokes() async {
  final url = Uri.parse('https://official-joke-api.appspot.com/jokes/ten');
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.take(5).map((j) => '${j['setup']} ${j['punchline']}').toList();
  } else {
    throw Exception('Failed to load jokes');
  }
}