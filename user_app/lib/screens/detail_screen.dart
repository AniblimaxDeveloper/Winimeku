import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import '../models/anime.dart';

class DetailScreen extends StatefulWidget {
  final Anime anime;
  const DetailScreen({super.key, required this.anime});
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late final Player player;
  late final VideoController controller;

  @override
  void initState() {
    super.initState();
    player = Player();
    controller = VideoController(player);
    if (widget.anime.episodes.isNotEmpty) player.open(Media(widget.anime.episodes.first.videoUrl));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.anime.title), backgroundColor: Colors.black, foregroundColor: Colors.white),
      body: Column(
        children: [
          if (widget.anime.episodes.isNotEmpty) SizedBox(height: 220, child: Video(controller: controller)) else const Padding(padding: EdgeInsets.all(16), child: Text("Belum ada episode.", style: TextStyle(color: Colors.white70))),
          Expanded(
            child: ListView(
              children: [
                Padding(padding: const EdgeInsets.all(16), child: Text(widget.anime.synopsis, style: const TextStyle(color: Colors.white70))),
                ...widget.anime.episodes.map((ep) => ListTile(
                  leading: const Icon(Icons.play_arrow, color: Colors.white),
                  title: Text("Episode ${ep.number}", style: const TextStyle(color: Colors.white)),
                  onTap: () => player.open(Media(ep.videoUrl)),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
