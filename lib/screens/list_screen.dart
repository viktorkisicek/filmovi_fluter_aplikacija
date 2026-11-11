import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import '../widgets/movie_tile.dart';
import 'detail_screen.dart';

class ListScreen extends StatefulWidget {
  const ListScreen({super.key});

  @override
  State<ListScreen> createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  final _service = const MovieService();
  late Future<List<Movie>> _movies;
  final _removed = <String>{};
  final _pinned = <String>{};

  @override
  void initState() {
    super.initState();
    _movies = _service.fetchMovies();
  }

  Future<void> _reload() {
    setState(() => _movies = _service.fetchMovies());
    return _movies;
  }

  void _openDetail(Movie movie) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
        pageBuilder: (context, animation, secondaryAnimation) =>
            DetailScreen(movie: movie),
      ),
    );
  }

  void _togglePin(Movie movie) {
    setState(() {
      if (!_pinned.remove(movie.id)) _pinned.add(movie.id);
    });
  }

  void _remove(Movie movie) {
    setState(() => _removed.add(movie.id));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Uklonjeno: ${movie.title}'),
        action: SnackBarAction(
          label: 'Poništi',
          onPressed: () {
            if (!mounted) return;
            setState(() => _removed.remove(movie.id));
          },
        ),
      ),
    );
  }

  Widget _buildList(List<Movie> movies) {
    final visible = movies.where((movie) => !_removed.contains(movie.id)).toList();

    if (visible.isEmpty) {
      return const Center(child: Text('Nema filmova za prikaz'));
    }

    return RefreshIndicator(
      onRefresh: _reload,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: visible.length,
        itemBuilder: (context, index) {
          final movie = visible[index];
          return MovieTile(
            movie: movie,
            pinned: _pinned.contains(movie.id),
            onTap: () => _openDetail(movie),
            onLongPress: () => _togglePin(movie),
            onDismissed: () => _remove(movie),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Filmovi')),
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              !snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.wifi_off, size: 48),
                  const SizedBox(height: 12),
                  const Text('Provjeri internetsku vezu i pokušaj ponovno'),
                  FilledButton(
                    onPressed: _reload,
                    child: const Text('Pokušaj ponovno'),
                  ),
                ],
              ),
            );
          }
          return _buildList(snapshot.data ?? []);
        },
      ),
    );
  }
}
