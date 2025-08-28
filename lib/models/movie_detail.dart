import 'movie.dart';
import 'genre.dart';
import 'cast_member.dart';

class MovieDetail {
  final Movie base; // daha önceki Movie modelin
  final List<Genre> genres;
  final int? runtime; // dakika
  final String? tagline;
  final List<CastMember> cast; // sadece oyuncular (fragman yok)

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
    return h > 0 ? '${h}sa ${m}dk' : '${m}dk';
  }
}
