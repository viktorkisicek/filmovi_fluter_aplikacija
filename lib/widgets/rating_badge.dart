import 'package:flutter/material.dart';

Color ratingColor(double rating) {
  if (rating >= 8.5) return Colors.green;
  if (rating >= 7) return Colors.orange;
  return Colors.amber;
}

class RatingBadge extends StatelessWidget {
  final double rating;
  final double size;

  const RatingBadge({super.key, required this.rating, this.size = 40});

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Container(
        width: size,
        height: size,
        padding: EdgeInsets.all(size * 0.22),
        decoration: BoxDecoration(
          color: ratingColor(rating),
          shape: BoxShape.circle,
        ),
        child: FittedBox(
          child: Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
