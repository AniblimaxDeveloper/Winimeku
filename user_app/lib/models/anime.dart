class Anime {
  final String id;
  final String title;
  final String synopsis;
  final String coverImage;
  final String status;
  final List<Episode> episodes;

  Anime({required this.id, required this.title, required this.synopsis, required this.coverImage, required this.status, required this.episodes});

  factory Anime.fromJson(Map<String, dynamic> json) {
    return Anime(
      id: json['_id'] ?? '',
      title: json['title'] ?? 'Tanpa Judul',
      synopsis: json['synopsis'] ?? '',
      coverImage: json['coverImage'] ?? '',
      status: json['status'] ?? 'Ongoing',
      episodes: (json['episodes'] as List<dynamic>? ?? []).map((e) => Episode.fromJson(e)).toList(),
    );
  }
}

class Episode {
  final int number;
  final String videoUrl;
  Episode({required this.number, required this.videoUrl});
  factory Episode.fromJson(Map<String, dynamic> json) => Episode(number: json['number'] ?? 0, videoUrl: json['videoUrl'] ?? '');
}
