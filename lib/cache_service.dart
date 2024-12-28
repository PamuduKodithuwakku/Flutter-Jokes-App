import 'package:shared_preferences/shared_preferences.dart';

Future<void> saveJokes(List<String> jokes) async {
  final prefs = await SharedPreferences.getInstance();
  prefs.setStringList('cachedJokes', jokes);
}

Future<List<String>?> loadCachedJokes() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getStringList('cachedJokes');
}