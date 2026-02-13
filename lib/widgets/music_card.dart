import 'package:dance_motion/models/music_item.dart';
import 'package:flutter/material.dart';

class MusicCard extends StatelessWidget {
  final MusicItem musicItem;
  final VoidCallback onLike;
  final VoidCallback onTap;
  final bool isLiked;

  const MusicCard({
    super.key,
    required this.musicItem,
    required this.onLike,
    required this.onTap,
    this.isLiked = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: Theme.of(context).cardColor,
        ),
        child: Row(
          children: [
            Hero(
              tag: 'music_${musicItem.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  musicItem.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    musicItem.title,
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    musicItem.artist,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      _InfoBadge(label: 'Category', value: musicItem.category),
                      const SizedBox(width: 12),
                      _InfoBadge(label: 'Year', value: musicItem.year.toString()),
                    ],
                  ),
                ],
              ),
            ),
            IconButton(
              icon: Icon(isLiked ? Icons.favorite : Icons.favorite_border),
              color: Colors.deepPurple,
              onPressed: onLike,
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
    return Row(
      children: [
        Text(
          '$label: ',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}
