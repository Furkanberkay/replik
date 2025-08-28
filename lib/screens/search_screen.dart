import 'package:flutter/material.dart';
import '../models/movie.dart';
import '../services/tmdb_api.dart';
import '../widgets/movie_card.dart';
import '../thema/app_theme.dart';
import 'movie_detail_screen.dart';
import 'dart:async';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  Future<List<Movie>>? _future;
  Timer? _debounceTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounceTimer?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 500), () {
      if (_controller.text.trim().length >= 2) {
        _doSearch();
      }
    });
  }

  void _doSearch() {
    final query = _controller.text.trim();
    if (query.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('En az 2 karakter yaz 😊'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() {
      _future = TmdbApi.searchMovies(query);
    });
  }

  void _clearSearch() {
    _controller.clear();
    setState(() {
      _future = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: appGradient),
      child: SafeArea(
        child: Column(
          children: [
            // ÜST ARAMA ŞERİDİ
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (_) => _doSearch(),
                      style: const TextStyle(
                        color: Colors.black87,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        hintText: 'Film ara (örn. Inception)',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                        ),
                        prefixIcon: const Icon(
                          Icons.search,
                          color: Colors.grey,
                        ),
                        suffixIcon: _controller.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear, color: Colors.grey),
                                onPressed: _clearSearch,
                              )
                            : null,
                        border: const OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: _doSearch,
                    icon: const Icon(Icons.search),
                    label: const Text('Ara'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),

            // SONUÇLAR
            Expanded(
              child: _future == null
                  ? const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.search,
                            size: 64,
                            color: Colors.white,
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Film aramak için yaz ve Ara tuşuna bas',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    )
                  : FutureBuilder<List<Movie>>(
                      future: _future,
                      builder: (context, snap) {
                        if (snap.connectionState == ConnectionState.waiting) {
                          return const Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'Filmler aranıyor...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        if (snap.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.error_outline,
                                  size: 64,
                                  color: Colors.red,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Arama sırasında hata oluştu',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${snap.error}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _doSearch,
                                  child: const Text('Tekrar Dene'),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        final list = snap.data ?? [];
                        if (list.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.search_off,
                                  size: 64,
                                  color: Colors.white,
                                ),
                                const SizedBox(height: 16),
                                const Text(
                                  'Sonuç bulunamadı',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '"${_controller.text}" için sonuç bulunamadı',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: _clearSearch,
                                  child: const Text('Yeni Arama Yap'),
                                ),
                              ],
                            ),
                          );
                        }
                        
                        return Column(
                          children: [
                            // Sonuç sayısı
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              color: Colors.white.withOpacity(0.1),
                              child: Text(
                                '${list.length} film bulundu',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            // Film listesi
                            Expanded(
                              child: ListView.builder(
                                padding: const EdgeInsets.only(top: 8, bottom: 16),
                                itemCount: list.length,
                                itemBuilder: (context, i) {
                                  final movie = list[i];
                                  return MovieCard(
                                    movie: movie,
                                    onTap: () {
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (_) => MovieDetailScreen(
                                            movieId: movie.id,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
