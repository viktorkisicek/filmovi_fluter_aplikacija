import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../widgets/rating_badge.dart';

class DetailScreen extends StatefulWidget {
  final Movie movie;

  const DetailScreen({super.key, required this.movie});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.15,
    ).animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));

    if (widget.movie.rating >= 8.5) _pulse.repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final movie = widget.movie;

    return Scaffold(
      appBar: AppBar(title: Text(movie.title)),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Center(
            child: ScaleTransition(
              scale: _scale,
              child: Hero(
                tag: 'rating-${movie.id}',
                child: RatingBadge(rating: movie.rating, size: 140),
              ),
            ),
          ),
          const SizedBox(height: 24),
          if (movie.imageUrl.isNotEmpty)
            Center(
              child: Image.network(
                movie.imageUrl,
                height: 220,
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.movie, size: 100),
              ),
            ),
          const SizedBox(height: 24),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Godina'),
            trailing: Text(movie.yearLabel),
          ),
          ListTile(
            leading: const Icon(Icons.schedule),
            title: const Text('Trajanje'),
            trailing: Text('${movie.runningTime} min'),
          ),
          ListTile(
            leading: const Icon(Icons.movie_creation),
            title: const Text('Redatelj'),
            trailing: Text(movie.director),
          ),
          ListTile(
            leading: const Icon(Icons.business),
            title: const Text('Producent'),
            trailing: Text(movie.producer),
          ),
          const SizedBox(height: 16),
          const Text(
            'Opis',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(movie.description),
        ],
      ),
    );
  }
}
