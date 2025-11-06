import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MusicScreenState();
}

class _MusicScreenState extends State<MusicScreen> {
  final AudioPlayer _player = AudioPlayer();
  bool _isPlaying = false;
  String? _currentSong;

  final List<Map<String, String>> _songs = [
    {
      'title': 'Lo-Fi Chill Beats',
      'artist': 'DJ Sunset',
      'url': 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
    },
    {
      'title': 'City Drive',
      'artist': 'Urban Mood',
      'url': 'https://www.soundhelix.com/examples/mp3/SoundHelix-Song-2.mp3',
    },
  ];

  Future<void> _playSong(String title, String url) async {
    await _player.stop();
    await _player.play(UrlSource(url));
    setState(() {
      _currentSong = title;
      _isPlaying = true;
    });
  }

  Future<void> _pauseSong() async {
    await _player.pause();
    setState(() => _isPlaying = false);
  }

  Future<void> _resumeSong() async {
    await _player.resume();
    setState(() => _isPlaying = true);
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('🎧 Music List')),
      body: Column(
        children: [
          if (_currentSong != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                'Now Playing: $_currentSong',
                style: const TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          Expanded(
            child: ListView.builder(
              itemCount: _songs.length,
              itemBuilder: (context, index) {
                final song = _songs[index];
                return ListTile(
                  title: Text(song['title']!, style: const TextStyle(color: Colors.white)),
                  subtitle: Text(song['artist']!, style: const TextStyle(color: Colors.white70)),
                  trailing: ElevatedButton(
                    onPressed: () => _playSong(song['title']!, song['url']!),
                    child: const Text('Play'),
                  ),
                );
              },
            ),
          ),
          if (_currentSong != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      size: 50,
                      color: Colors.purpleAccent,
                    ),
                    onPressed: _isPlaying ? _pauseSong : _resumeSong,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
