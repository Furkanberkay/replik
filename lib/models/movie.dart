// TMDB'den gelen film nesnesini temsil eder.
class Movie {
  final int id;
  final String title;
  final String overview;
  final String? posterPath;
  final String? backdropPath;
  final String releaseDate;
  final num voteAverage;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
  });

  // JSON -> Movie (TMDB alan adlarıyla birebir)
  factory Movie.fromJson(Map<String, dynamic> json) => Movie(
    id: json['id'],
    title: json['title'] ?? '',
    overview: json['overview'] ?? '',
    posterPath: json['poster_path'],
    backdropPath: json['backdrop_path'],
    releaseDate: json['release_date'] ?? '',
    voteAverage: json['vote_average'] ?? 0,
  );

  // Görsel URL'lerini hazır ver (UI tarafını kolaylaştırır)
  String get posterUrl =>
      posterPath != null ? 'https://image.tmdb.org/t/p/w500$posterPath' : '';
  String get backdropUrl => backdropPath != null
      ? 'https://image.tmdb.org/t/p/w780$backdropPath'
      : '';
}
