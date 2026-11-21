import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config.dart';
import '../models/anime.dart';

class ApiService {
  Future<List<Anime>> fetchTrendingAnime() async {
    final response = await http.get(Uri.parse('${AppConfig.baseUrl}/anime/trending'));
    if (response.statusCode == 200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Anime.fromJson(json)).toList();
    }
    throw Exception('Gagal memuat data (${response.statusCode})');
  }
}
