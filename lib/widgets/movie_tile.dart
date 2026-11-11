import 'package:flutter/material.dart';
import '../models/movie.dart';
import 'rating_badge.dart';

class MovieTile extends StatelessWidget {
  final Movie movie;
  final bool pinned;
  final VoidCallback onTap;
  final VoidCallback onLongPress;
  final VoidCallback onDismissed;

  const MovieTile({
    super.key,
    required this.movie,
    required this.pinned,
    required this.onTap,
    required this.onLongPress,
    required this.onDismissed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(movie.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (direction) => onDismissed(),
      child: ListTile(
        leading: Hero(
          tag: 'rating-${movie.id}',
          child: RatingBadge(rating: movie.rating),
        ),
        title: Text(movie.title),
        subtitle: Text(movie.yearLabel),
        trailing: AnimatedScale(
          scale: pinned ? 1 : 0,
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutBack,
          child: const Icon(Icons.push_pin),
        ),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
