import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  bool _ttsInitialized = false;

  Future<void> initTts() async {
    try {
      await _flutterTts.setLanguage('en-US');
      await _flutterTts.setSpeechRate(0.5);
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _ttsInitialized = true;
    } catch (e) {
      debugPrint('TTS initialization failed: $e');
      _ttsInitialized = false;
    }
  }

  Future<void> speakWord(String word) async {
    if (!_ttsInitialized) {
      await initTts();
    }
    try {
      await _flutterTts.speak(word);
    } catch (e) {
      debugPrint('TTS speak failed: $e');
    }
  }

  Future<void> dispose() async {
    await _flutterTts.stop();
  }
}