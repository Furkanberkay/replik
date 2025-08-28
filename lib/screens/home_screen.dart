import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_api.dart';
import '../widgets/movie_card.dart';
import '../thema/app_theme.dart';
import 'movie_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<List<Movie>> _future;

  @override
  void initState() {
    super.initState();
    _future = TmdbApi.fetchPopular();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: appGradient),
      child: SafeArea(
        child: FutureBuilder<List<Movie>>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snap.hasError) {
              return Center(child: Text('Hata: ${snap.error}'));
            }
            final list = snap.data ?? [];
            if (list.isEmpty) {
              return const Center(child: Text('Veri yok'));
            }
            return ListView.builder(
              padding: const EdgeInsets.only(top: 8, bottom: 16),
              itemCount: list.length,
              itemBuilder: (context, i) {
                final m = list[i];
                return MovieCard(
                  movie: m,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MovieDetailScreen(movieId: m.id),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
