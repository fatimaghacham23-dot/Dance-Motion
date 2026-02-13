import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:dance_motion/data/mock_data.dart';
import 'package:dance_motion/models/music_item.dart';

class AppState extends ChangeNotifier {
  ThemeMode themeMode = ThemeMode.light;
  String username = 'Dance Lover';
  String? profileImagePath;
  final Set<String> likedMusicIds = {};
  final List<MusicItem> userMusicItems = [];

  Future<void> loadPreferences() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString('themeMode');
    if (themeString != null) {
      themeMode = themeString == 'dark' ? ThemeMode.dark : ThemeMode.light;
    }
    username = prefs.getString('username') ?? username;
    profileImagePath = prefs.getString('profileImagePath');
    final savedLikes = prefs.getStringList('likedMusic') ?? [];
    likedMusicIds
      ..clear()
      ..addAll(savedLikes);
    notifyListeners();
  }

  Future<void> toggleTheme(ThemeMode mode) async {
    themeMode = mode;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('themeMode', mode == ThemeMode.dark ? 'dark' : 'light');
  }

  Future<void> updateUsername(String value) async {
    username = value.trim();
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
  }

  Future<void> setProfileImagePath(String? path) async {
    profileImagePath = path;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    if (path == null) {
      await prefs.remove('profileImagePath');
    } else {
      await prefs.setString('profileImagePath', path);
    }
  }

  Future<void> toggleLikeStatus(String musicId) async {
    if (likedMusicIds.contains(musicId)) {
      likedMusicIds.remove(musicId);
    } else {
      likedMusicIds.add(musicId);
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('likedMusic', likedMusicIds.toList());
  }

  void addUserMusic(MusicItem item) {
    userMusicItems.insert(0, item);
    notifyListeners();
  }

  List<MusicItem> get combinedMusic => [...userMusicItems, ...mockMusicItems];

  List<MusicItem> get wishlistMusic => combinedMusic.where((music) => likedMusicIds.contains(music.id)).toList();

  bool isLiked(String id) => likedMusicIds.contains(id);
}
