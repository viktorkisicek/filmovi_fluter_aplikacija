import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/movie_service.dart';
import 'detail_screen.dart';

class GalleryScreen extends StatefulWidget {
  const GalleryScreen({super.key});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  late final Future<List<Movie>> _movies;

  @override
  void initState() {
    super.initState();
    _movies = const MovieService().fetchMovies();
  }

  void _openDetail(Movie movie) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => DetailScreen(movie: movie)),
    );
  }

  Widget _buildGallery(List<Movie> movies) {
    final rows = (movies.length / 3).ceil();
    return InteractiveViewer(
      minScale: 1,
      maxScale: 4,
      child: SizedBox(
        width: 840,
        height: rows * 300.0,
        child: Stack(
          children: [
            for (var index = 0; index < movies.length; index++)
              Positioned(
                left: (index % 3) * 275.0 + 12,
                top: (index ~/ 3) * 300.0 + 12,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () => _openDetail(movies[index]),
                  child: SizedBox(
                    width: 250,
                    height: 275,
                    child: Card(
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: SizedBox(
                              width: double.infinity,
                              child: movies[index].imageUrl.isEmpty
                                  ? const Icon(Icons.movie, size: 70)
                                  : Image.network(
                                      movies[index].imageUrl,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) =>
                                          const Icon(Icons.movie, size: 70),
                                    ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(
                              movies[index].title,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Galerija filmova')),
      body: FutureBuilder<List<Movie>>(
        future: _movies,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(child: Text('Nije moguće učitati galeriju'));
          }
          return _buildGallery(snapshot.data ?? []);
        },
      ),
    );
  }
}
