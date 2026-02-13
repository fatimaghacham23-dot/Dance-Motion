import 'package:dance_motion/models/music_item.dart';
import 'package:dance_motion/state/app_state.dart';
import 'package:dance_motion/widgets/music_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MusicDetailsScreen extends StatelessWidget {
  final MusicItem musicItem;

  const MusicDetailsScreen({super.key, required this.musicItem});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isLiked = state.isLiked(musicItem.id);
    final suggestions = state.combinedMusic
        .where((item) => item.id != musicItem.id && item.category == musicItem.category)
        .take(4)
        .toList();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
            onPressed: () => state.toggleLikeStatus(musicItem.id),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Hero(
              tag: 'music_${musicItem.id}',
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                child: Image.network(
                  musicItem.imageUrl,
                  height: 240,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          musicItem.title,
                          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                      ),
                      IconButton(
                        icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
                        color: Colors.deepPurple,
                        onPressed: () => state.toggleLikeStatus(musicItem.id),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    musicItem.artist,
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoBadge(label: 'Year', value: musicItem.year.toString()),
                      _InfoBadge(label: 'Duration', value: musicItem.duration),
                      _InfoBadge(label: 'Category', value: musicItem.category),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Description',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    musicItem.description.isNotEmpty
                        ? musicItem.description
                        : 'A crafted track ready to inspire choreography.',
                    style: const TextStyle(height: 1.4),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'You may also like',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final suggestion = suggestions[index];
                        return SizedBox(
                          width: 180,
                          child: MusicCard(
                            musicItem: suggestion,
                            isLiked: state.isLiked(suggestion.id),
                            onLike: () => state.toggleLikeStatus(suggestion.id),
                            onTap: () => Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) => MusicDetailsScreen(musicItem: suggestion),
                              ),
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (_, __) => const SizedBox(width: 12),
                      itemCount: suggestions.length,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final String label;
  final String value;

  const _InfoBadge({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
