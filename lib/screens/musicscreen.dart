import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MusicScreen extends StatefulWidget {
  const MusicScreen({super.key});

  @override
  State<MusicScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MusicScreen> {
  int _count = 0;

  void _setCount(int newCount) {
    setState(() {
      _count = newCount;
      saveData();
    });
  }

  Future<void> saveData() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('count', _count);
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    int count = prefs.getInt("count") ?? 0;
    
    _setCount(count);
  }

  @override
  void initState() {
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(children: [
        Text(_count.toString()),
        ElevatedButton(onPressed: () => _setCount(_count + 1), child: Text('CLICK'))
      ],)
    );
  }
}
