import 'package:dance_motion/screens/music_details_screen.dart';
import 'package:dance_motion/state/app_state.dart';
import 'package:dance_motion/widgets/music_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryMusicScreen extends StatelessWidget {
  final String categoryName;

  const CategoryMusicScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final categoryMusic = state.combinedMusic
        .where((music) => music.category.toLowerCase() == categoryName.toLowerCase())
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: categoryMusic.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final music = categoryMusic.elementAt(index);
          return MusicCard(
            musicItem: music,
            isLiked: state.isLiked(music.id),
            onLike: () => state.toggleLikeStatus(music.id),
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => MusicDetailsScreen(musicItem: music),
              ),
            ),
          );
        },
      ),
    );
  }
}
