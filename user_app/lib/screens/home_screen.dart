import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/anime.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  late Future<List<Anime>> _trendingAnime;

  @override
  void initState() {
    super.initState();
    _trendingAnime = _apiService.fetchTrendingAnime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("WIBINIME"), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: FutureBuilder<List<Anime>>(
        future: _trendingAnime,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) return const Center(child: CircularProgressIndicator(color: Colors.white));
          if (snapshot.hasError) return Center(child: Text("Error: ${snapshot.error}", style: const TextStyle(color: Colors.white)));
          final animes = snapshot.data ?? [];
          if (animes.isEmpty) return const Center(child: Text("Belum ada anime.", style: TextStyle(color: Colors.white70)));
          return ListView.builder(
            itemCount: animes.length,
            itemBuilder: (context, index) {
              final anime = animes[index];
              return ListTile(
                leading: anime.coverImage.isNotEmpty ? Image.network(anime.coverImage, width: 50, fit: BoxFit.cover) : const Icon(Icons.image, color: Colors.white54),
                title: Text(anime.title, style: const TextStyle(color: Colors.white)),
                subtitle: Text(anime.status, style: const TextStyle(color: Colors.white70)),
                trailing: const Icon(Icons.play_circle_fill, color: Colors.white),
                onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DetailScreen(anime: anime))),
              );
            },
          );
        },
      ),
    );
  }
}
