import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/cast_member.dart';
import '../models/genre.dart';
import '../models/movie_detail.dart';
import '../models/movie.dart';

class TmdbApi {
  // Senin v3 API key'in (TMDB Settings → API → "API Key (v3 auth)")
  static const String _apiKey = 'a535eb4633485c3929ab43af9b97068a';
  static const String _base = 'https://api.themoviedb.org/3';

  // Popüler filmler
  static Future<List<Movie>> fetchPopular() async {
    final uri = Uri.parse(
      '$_base/movie/popular?api_key=$_apiKey&language=en-US&page=1',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Popular fetch failed: ${res.statusCode} • ${res.body}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final List results = data['results'] ?? [];
    return results.map((e) => Movie.fromJson(e)).toList();
  }

  // Arama
  static Future<List<Movie>> searchMovies(String query) async {
    final uri = Uri.parse(
      '$_base/search/movie?api_key=$_apiKey&language=en-US'
      '&query=${Uri.encodeQueryComponent(query)}&page=1&include_adult=false',
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Search failed: ${res.statusCode} • ${res.body}');
    }
    final data = json.decode(res.body) as Map<String, dynamic>;
    final List results = data['results'] ?? [];
    return results.map((e) => Movie.fromJson(e)).toList();
  }

  // Detay
  static Future<Movie> getMovie(int id) async {
    final uri = Uri.parse('$_base/movie/$id?api_key=$_apiKey&language=en-US');
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Detail fetch failed: ${res.statusCode} • ${res.body}');
    }
    return Movie.fromJson(json.decode(res.body) as Map<String, dynamic>);
  }

  // ... fetchPopular ve searchMovies aynı kalsın ...
  // Detay + oyuncular (fragman/recommendation YOK)
  static Future<MovieDetail> getMovieDetail(int id) async {
    final uri = Uri.parse(
      '$_base/movie/$id?api_key=$_apiKey&language=en-US'
      '&append_to_response=credits', // sadece oyuncular için yeterli
    );
    final res = await http.get(uri);
    if (res.statusCode != 200) {
      throw Exception('Detail fetch failed: ${res.statusCode} • ${res.body}');
    }
    final Map<String, dynamic> data = json.decode(res.body);

    final base = Movie.fromJson(data);

    final genres = ((data['genres'] as List?) ?? [])
        .map((e) => Genre.fromJson(e))
        .toList();

    final int? runtime = data['runtime'];
    final String? tagline = (data['tagline'] ?? '').toString().isNotEmpty
        ? data['tagline']
        : null;

    final cast = ((data['credits']?['cast'] as List?) ?? [])
        .take(18) // ilk 18 kişi yeterli
        .map((e) => CastMember.fromJson(e))
        .toList();

    return MovieDetail(
      base: base,
      genres: genres,
      runtime: runtime,
      tagline: tagline,
      cast: cast,
    );
  }
}
