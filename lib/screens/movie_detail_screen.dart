import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_api.dart';
import '../thema/app_theme.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<Movie> _future;

  @override
  void initState() {
    super.initState();
    _future = TmdbApi.getMovie(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: appGradient),
        child: SafeArea(
          bottom: false,
          child: FutureBuilder<Movie>(
            future: _future,
            builder: (context, snap) {
              if (snap.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snap.hasError) {
                return Center(child: Text('Hata: ${snap.error}'));
              }
              final m = snap.data!;
              return LayoutBuilder(
                builder: (context, c) {
                  final wide = c.maxWidth >= 900;

                  // --- NARROW SCREEN: fully contained top image + content ---
                  if (!wide) {
                    final heroUrl = m.backdropUrl.isNotEmpty
                        ? m.backdropUrl
                        : (m.posterUrl.isNotEmpty ? m.posterUrl : '');

                    return CustomScrollView(
                      slivers: [
                        SliverAppBar(
                          pinned: true,
                          centerTitle: true,
                          title: const Text('Movie Details'),
                          expandedHeight: 260,
                          flexibleSpace: FlexibleSpaceBar(
                            background: heroUrl.isNotEmpty
                                ? Image.network(
                                    heroUrl,
                                    fit: BoxFit.cover, // FILLS SCREEN COMPLETELY
                                    width: double.infinity,
                                  )
                                : Container(color: Colors.black26),
                          ),
                        ),
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: _DetailText(movie: m),
                          ),
                        ),
                      ],
                    );
                  }

                  // --- WIDE SCREEN: poster on left, text on right (no overflow) ---
                  return CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        pinned: true,
                        centerTitle: true,
                        title: const Text('Movie Details'),
                      ),
                      SliverToBoxAdapter(
                        child: Center(
                          child: ConstrainedBox(
                            constraints: const BoxConstraints(maxWidth: 1100),
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (m.posterUrl.isNotEmpty)
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(16),
                                      child: Image.network(
                                        m.posterUrl,
                                        width: 320,
                                        height: 480,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  const SizedBox(width: 24),
                                  Expanded(child: _DetailText(movie: m)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DetailText extends StatelessWidget {
  final Movie movie;
  const _DetailText({required this.movie});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(movie.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: Colors.amber, size: 20),
            const SizedBox(width: 6),
            Text('${movie.voteAverage}'),
            const SizedBox(width: 16),
            const Icon(Icons.calendar_today, size: 18),
            const SizedBox(width: 6),
            Text(movie.releaseDate.isNotEmpty ? movie.releaseDate : '—'),
          ],
        ),
        const SizedBox(height: 12),
        Text(movie.overview.isNotEmpty ? movie.overview : 'No description available.'),
        const SizedBox(height: 24),
      ],
    );
  }
}
