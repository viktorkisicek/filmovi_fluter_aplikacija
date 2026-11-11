import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movie.dart';

class MovieService {
  const MovieService();

  static final _feed = Uri.parse('https://ghibliapi.vercel.app/films');

  Future<List<Movie>> fetchMovies() async {
    final response = await http.get(_feed).timeout(
      const Duration(seconds: 10),
    );

    if (response.statusCode != 200) {
      throw Exception('API je vratio status ${response.statusCode}');
    }

    final json = jsonDecode(response.body) as List<dynamic>;
    return json
        .map((movie) => Movie.fromJson(movie as Map<String, dynamic>))
        .toList();
  }

  Stream<List<Movie>> watchMovies() async* {
    while (true) {
      yield await fetchMovies();
      await Future.delayed(const Duration(minutes: 1));
    }
  }
}
