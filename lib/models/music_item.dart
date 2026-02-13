class MusicItem {
  final String id;
  final String title;
  final String artist;
  final String imageUrl;
  final String category;
  final String description;
  final String duration;
  final int year;

  const MusicItem({
    required this.id,
    required this.title,
    required this.artist,
    required this.imageUrl,
    required this.category,
    required this.description,
    required this.duration,
    required this.year,
  });

  MusicItem copyWith({
    String? id,
    String? title,
    String? artist,
    String? imageUrl,
    String? category,
    String? description,
    String? duration,
    int? year,
  }) {
    return MusicItem(
      id: id ?? this.id,
      title: title ?? this.title,
      artist: artist ?? this.artist,
      imageUrl: imageUrl ?? this.imageUrl,
      category: category ?? this.category,
      description: description ?? this.description,
      duration: duration ?? this.duration,
      year: year ?? this.year,
    );
  }
}
