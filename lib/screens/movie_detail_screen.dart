import 'package:flutter/material.dart';
import 'package:replik/models/cast_member.dart';
import '../models/movie_detail.dart';
import '../services/tmdb_api.dart';
import '../thema/app_theme.dart';

class MovieDetailScreen extends StatefulWidget {
  final int movieId;
  const MovieDetailScreen({super.key, required this.movieId});

  @override
  State<MovieDetailScreen> createState() => _MovieDetailScreenState();
}

class _MovieDetailScreenState extends State<MovieDetailScreen> {
  late Future<MovieDetail> _future;

  @override
  void initState() {
    super.initState();
    _future = TmdbApi.getMovieDetail(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(gradient: appGradient),
        child: FutureBuilder<MovieDetail>(
          future: _future,
          builder: (context, snap) {
            if (snap.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                ),
              );
            }

            if (snap.hasError) {
              return Center(
                child: Text(
                  'Error: ${snap.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            if (!snap.hasData) {
              return const Center(
                child: Text(
                  'No data available',
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            final movieDetail = snap.data!;
            final movie = movieDetail.base;

            return ListView(
              padding: EdgeInsets.zero,
              children: [
                // Header Image
                _HeaderImage(
                  imageUrl: movie.backdropUrl.isNotEmpty
                      ? movie.backdropUrl
                      : movie.posterUrl,
                ),

                // Content
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Title
                      Text(
                        movie.title,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                      ),

                      const SizedBox(height: 16),

                      // Basic Info
                      Row(
                        children: [
                          _InfoChip(
                            icon: Icons.star,
                            text: movie.voteAverage.toStringAsFixed(1),
                            color: Colors.amber,
                          ),
                          const SizedBox(width: 12),
                          _InfoChip(
                            icon: Icons.calendar_today,
                            text: movie.releaseDate.isNotEmpty
                                ? movie.releaseDate.split('-')[0]
                                : '—',
                            color: Colors.blue,
                          ),
                          if (movieDetail.hasRuntime) ...[
                            const SizedBox(width: 12),
                            _InfoChip(
                              icon: Icons.schedule,
                              text: movieDetail.runtimeText,
                              color: Colors.green,
                            ),
                          ],
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Genres
                      if (movieDetail.hasGenres) ...[
                        Text(
                          'Genres:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          children: movieDetail.genres
                              .take(5) // Sadece ilk 5 tür
                              .map((g) => Chip(
                                    label: Text(g.name),
                                    backgroundColor:
                                        Colors.white.withOpacity(0.2),
                                    labelStyle:
                                        const TextStyle(color: Colors.white),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Overview
                      Text(
                        'Overview:',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.9),
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        movie.overview.isNotEmpty
                            ? movie.overview
                            : 'No description available.',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 15,
                          height: 1.5,
                        ),
                      ),

                      // Cast (Sadece 3 oyuncu)
                      if (movieDetail.hasCast) ...[
                        const SizedBox(height: 24),
                        Text(
                          'Cast:',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: movieDetail.cast
                              .take(3) // Sadece 3 oyuncu
                              .map((cast) => Expanded(
                                    child: _CastCard(cast: cast),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 16), // Alt boşluk azaltıldı
                      ],
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderImage extends StatelessWidget {
  final String imageUrl;
  const _HeaderImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      width: double.infinity,
      child: imageUrl.isNotEmpty
          ? Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: Colors.grey.shade800,
                  child: const Icon(
                    Icons.movie,
                    size: 80,
                    color: Colors.white,
                  ),
                );
              },
            )
          : Container(
              color: Colors.grey.shade800,
              child: const Icon(
                Icons.movie,
                size: 80,
                color: Colors.white,
              ),
            ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _InfoChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _CastCard extends StatelessWidget {
  final CastMember cast;
  const _CastCard({required this.cast});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          CircleAvatar(
            radius: 35,
            backgroundImage: cast.profileUrl.isNotEmpty
                ? NetworkImage(cast.profileUrl)
                : null,
            backgroundColor: Colors.grey.shade700,
            child: cast.profileUrl.isEmpty
                ? const Icon(Icons.person, size: 35, color: Colors.white)
                : null,
          ),
          const SizedBox(height: 8),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            cast.character,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
