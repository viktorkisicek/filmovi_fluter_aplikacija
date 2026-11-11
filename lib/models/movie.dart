class Movie {
  final String id;
  final String title;
  final String description;
  final String director;
  final String producer;
  final int releaseYear;
  final int runningTime;
  final double rating;
  final String imageUrl;
  final String bannerUrl;

  const Movie({
    required this.id,
    required this.title,
    required this.description,
    required this.director,
    required this.producer,
    required this.releaseYear,
    required this.runningTime,
    required this.rating,
    required this.imageUrl,
    required this.bannerUrl,
  });

  String get yearLabel => releaseYear > 0 ? '$releaseYear.' : 'Nepoznato';

  factory Movie.fromJson(Map<String, dynamic> json) {
    final score = double.tryParse('${json['rt_score'] ?? 0}') ?? 0;

    return Movie(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Nepoznat naslov',
      description: json['description'] as String? ?? 'Opis nije dostupan.',
      director: json['director'] as String? ?? 'Nepoznato',
      producer: json['producer'] as String? ?? 'Nepoznato',
      releaseYear: int.tryParse('${json['release_date'] ?? 0}') ?? 0,
      runningTime: int.tryParse('${json['running_time'] ?? 0}') ?? 0,
      rating: score / 10,
      imageUrl: json['image'] as String? ?? '',
      bannerUrl: json['movie_banner'] as String? ?? '',
    );
  }
}
