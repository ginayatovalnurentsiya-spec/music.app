import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final AudioPlayer _player = AudioPlayer();
  int _currentIndex = 0;
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  final List<Map<String, String>> _songs = [
    {
      'title': 'Dreamy Night',
      'artist': 'Lo-Fi Studio',
      'url': 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
      'cover': 'https://cdn.pixabay.com/photo/2020/03/14/23/58/girl-4939643_1280.jpg',
    },
    {
      'title': 'Sunny Morning',
      'artist': 'Acoustic Vibes',
      'url': 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Canon.mp3',
      'cover': 'https://cdn.pixabay.com/photo/2017/02/07/05/57/woman-2048905_1280.jpg',
    },
    {
      'title': 'Ocean Breath',
      'artist': 'Chillwave',
      'url': 'https://www.learningcontainer.com/wp-content/uploads/2020/02/Kalimba.mp3',
      'cover': 'https://cdn.pixabay.com/photo/2016/11/14/03/16/beach-1824855_1280.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();

    _player.onPositionChanged.listen((position) {
      setState(() => _currentPosition = position);
    });

    _player.onDurationChanged.listen((duration) {
      setState(() => _totalDuration = duration);
    });

    _player.onPlayerComplete.listen((event) {
      _nextSong();
    });
  }

  Future<void> _playSong(int index) async {
    final song = _songs[index];
    await _player.stop();
    await _player.play(UrlSource(song['url']!));
    setState(() {
      _currentIndex = index;
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

  Future<void> _stopSong() async {
    await _player.stop();
    setState(() {
      _isPlaying = false;
      _currentPosition = Duration.zero;
    });
  }

  void _nextSong() {
    final nextIndex = (_currentIndex + 1) % _songs.length;
    _playSong(nextIndex);
  }

  void _prevSong() {
    final prevIndex = (_currentIndex - 1 + _songs.length) % _songs.length;
    _playSong(prevIndex);
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(d.inMinutes.remainder(60));
    final seconds = twoDigits(d.inSeconds.remainder(60));
    return "$minutes:$seconds";
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentSong = _songs[_currentIndex];

    return Scaffold(
      appBar: AppBar(title: const Text('🎧 Space Beats Player')),
      body: Column(
        children: [
          const SizedBox(height: 20),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.network(currentSong['cover']!, width: 250, height: 250, fit: BoxFit.cover),
          ),
          const SizedBox(height: 20),
          Text(currentSong['title']!,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
          Text(currentSong['artist']!, style: const TextStyle(color: Colors.white70)),
          const SizedBox(height: 20),
          Slider(
            value: _currentPosition.inSeconds.toDouble(),
            max: _totalDuration.inSeconds.toDouble() > 0 ? _totalDuration.inSeconds.toDouble() : 1,
            onChanged: (value) async {
              await _player.seek(Duration(seconds: value.toInt()));
            },
            activeColor: Colors.purpleAccent,
            inactiveColor: Colors.white24,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(_formatDuration(_currentPosition)),
                Text(_formatDuration(_totalDuration)),
              ],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(onPressed: _prevSong, icon: const Icon(Icons.skip_previous, size: 45, color: Colors.white)),
              IconButton(
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle,
                    size: 65, color: Colors.purpleAccent),
                onPressed: _isPlaying ? _pauseSong : () => _playSong(_currentIndex),
              ),
              IconButton(onPressed: _nextSong, icon: const Icon(Icons.skip_next, size: 45, color: Colors.white)),
            ],
          ),
          const Spacer(),
          ElevatedButton.icon(
            onPressed: _stopSong,
            style: ElevatedButton.styleFrom(backgroundColor: Colors.purple),
            icon: const Icon(Icons.stop),
            label: const Text("Stop"),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
