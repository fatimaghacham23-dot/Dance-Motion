import 'dart:io';

import 'package:dance_motion/state/app_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final _picker = ImagePicker();
  final _usernameController = TextEditingController();
  bool _isEditingName = false;

  Future<void> _pickProfileImage(BuildContext context) async {
    final result = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (result != null) {
      await context.read<AppState>().setProfileImagePath(result.path);
    }
  }

  void _startEditing(AppState state) {
    _usernameController.text = state.username;
    setState(() => _isEditingName = true);
  }

  Future<void> _saveUsername(BuildContext context) async {
    final state = context.read<AppState>();
    if (_usernameController.text.trim().isEmpty) return;
    await state.updateUsername(_usernameController.text);
    setState(() => _isEditingName = false);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Saved')));
    }
  }

  Widget _buildProfileAvatar(AppState state) {
    final imagePath = state.profileImagePath;
    return Stack(
      children: [
        CircleAvatar(
          radius: 58,
          backgroundColor: Colors.deepPurple.shade100,
          backgroundImage: imagePath != null && File(imagePath).existsSync()
              ? FileImage(File(imagePath)) as ImageProvider
              : null,
          child: imagePath == null || !File(imagePath).existsSync()
              ? const Icon(Icons.person, size: 48, color: Colors.white)
              : null,
        ),
        Positioned(
          right: 0,
          bottom: 0,
          child: GestureDetector(
            onTap: () => _pickProfileImage(context),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.edit, size: 18, color: Colors.deepPurple),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUsernameSection(AppState state) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              state.username,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: _isEditingName ? null : () => _startEditing(state),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.deepPurple.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'edit',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        if (_isEditingName)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _usernameController,
                    decoration: const InputDecoration(labelText: 'Username'),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _saveUsername(context),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('Save'),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildThemeSelection(AppState state) {
    const themeOptions = [ThemeMode.light, ThemeMode.dark];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Theme',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
        ),
        const SizedBox(height: 8),
        Row(
          children: themeOptions.asMap().entries.map((entry) {
            final mode = entry.value;
            final isSelected = state.themeMode == mode;
            final label = mode == ThemeMode.dark ? 'Dark' : 'Light';
            return Expanded(
              child: GestureDetector(
                onTap: () => state.toggleTheme(mode),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: EdgeInsets.only(right: entry.key == themeOptions.length - 1 ? 0 : 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.deepPurple : Colors.transparent,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.deepPurple.withOpacity(0.5)),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.deepPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              _buildProfileAvatar(state),
              const SizedBox(height: 20),
              _buildUsernameSection(state),
              const SizedBox(height: 28),
              _buildThemeSelection(state),
            ],
          ),
        ),
      ),
    );
  }
}
