import 'movie.dart';
import 'genre.dart';
import 'cast_member.dart';

class MovieDetail {
  final Movie base;
  final List<Genre> genres;
  final int? runtime; // minutes
  final String? tagline;
  final List<CastMember> cast;

  MovieDetail({
    required this.base,
    required this.genres,
    required this.runtime,
    required this.tagline,
    required this.cast,
  });

  String get runtimeText {
    final r = runtime;
    if (r == null || r <= 0) return '—';
    final h = r ~/ 60, m = r % 60;
    return h > 0 ? '${h}h ${m}m' : '${m}m';
  }

  // Helper methods for cleaner UI code
  bool get hasGenres => genres.isNotEmpty;
  bool get hasCast => cast.isNotEmpty;
  bool get hasTagline => tagline != null && tagline!.isNotEmpty;
  bool get hasRuntime => runtime != null && runtime! > 0;
}
