import 'dart:async';

import 'package:dance_motion/data/mock_data.dart';
import 'package:dance_motion/models/music_item.dart';
import 'package:dance_motion/screens/add_music_screen.dart';
import 'package:dance_motion/screens/category_music_screen.dart';
import 'package:dance_motion/screens/music_details_screen.dart';
import 'package:dance_motion/state/app_state.dart';
import 'package:dance_motion/widgets/ad_card.dart';
import 'package:dance_motion/widgets/category_chip.dart';
import 'package:dance_motion/widgets/music_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _pageController = PageController();
  Timer? _bannerTimer;
  String _searchQuery = '';
  static const int _bannerPages = 3;

  @override
  void initState() {
    super.initState();
    _startBannerTimer();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    _bannerTimer?.cancel();
    super.dispose();
  }

  void _startBannerTimer() {
    _bannerTimer?.cancel();
    _bannerTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted) return;
      final currentPage = _pageController.page?.round() ?? 0;
      final nextPage = (currentPage + 1) % _bannerPages;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    });
  }

  List<String> _imagesForPage(int page) {
    return List.generate(4, (index) {
      final combinedIndex = (page * 4 + index) % mockBannerImages.length;
      return mockBannerImages[combinedIndex];
    });
  }

  void _onCategoryTap(BuildContext context, String categoryName) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CategoryMusicScreen(categoryName: categoryName),
      ),
    );
  }

  void _onAddMusic(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const AddMusicScreen()),
    );
  }

  List<MusicItem> _filteredMusic(AppState state) {
    return state.combinedMusic.where((music) {
      final query = _searchQuery.toLowerCase();
      final matchesQuery =
          music.title.toLowerCase().contains(query) || music.artist.toLowerCase().contains(query);
      return query.isEmpty ? true : matchesQuery;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final appState = context.watch<AppState>();
    final filteredMusic = _filteredMusic(appState);
    return SafeArea(
      bottom: false,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBanner(),
            const SizedBox(height: 16),
            _buildSearchField(),
            const SizedBox(height: 18),
            _buildCategoryGrid(),
            const SizedBox(height: 18),
            _buildSectionHeader(context),
            const SizedBox(height: 12),
            _buildAdRow(),
            const SizedBox(height: 16),
            if (filteredMusic.isEmpty)
              const Padding(
                padding: EdgeInsets.only(top: 40),
                child: Text(
                  'No music matches that search yet. Try another keyword.',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ...filteredMusic.map(
              (music) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: MusicCard(
                  musicItem: music,
                  isLiked: appState.isLiked(music.id),
                  onLike: () => appState.toggleLikeStatus(music.id),
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => MusicDetailsScreen(musicItem: music),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBanner() {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: PageView.builder(
          controller: _pageController,
          itemCount: _bannerPages,
          itemBuilder: (context, page) {
            final images = _imagesForPage(page);
            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade400, Colors.pinkAccent.shade400],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                physics: const NeverScrollableScrollPhysics(),
                children: images
                    .map(
                      (url) => ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          url,
                          fit: BoxFit.cover,
                        ),
                      ),
                    )
                    .toList(),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSearchField() {
    final color = Theme.of(context).cardColor;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 12,
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.black54),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Search music…',
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Column(
      children: [
        Row(
          children: mockCategories.sublist(0, 3).map(
            (category) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CategoryChip(
                    category: category,
                    onTap: () => _onCategoryTap(context, category.name),
                  ),
                ),
              );
            },
          ).toList(),
        ),
        const SizedBox(height: 12),
        Row(
          children: mockCategories.sublist(3).map(
            (category) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: CategoryChip(
                    category: category,
                    onTap: () => _onCategoryTap(context, category.name),
                  ),
                ),
              );
            },
          ).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Music',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        IconButton(
          onPressed: () => _onAddMusic(context),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple,
            ),
            child: const Icon(Icons.arrow_forward, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }

  Widget _buildAdRow() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: mockAdBanners.length,
        itemBuilder: (context, index) {
          final ad = mockAdBanners[index];
          return Padding(
            padding: EdgeInsets.only(right: index == mockAdBanners.length - 1 ? 0 : 12),
            child: AdCard(banner: ad),
          );
        },
      ),
    );
  }
}
