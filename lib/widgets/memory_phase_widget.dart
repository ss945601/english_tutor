import 'package:flutter/material.dart';
import '../models/toeic_word.dart';
import '../services/tts_service.dart';

class MemoryPhaseWidget extends StatelessWidget {
  final List<ToeicWord> gameWords;
  final VoidCallback onStartTest;
  final TtsService ttsService;

  const MemoryPhaseWidget({
    super.key,
    required this.gameWords,
    required this.onStartTest,
    required this.ttsService,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          ...gameWords
              .map(
                (word) => Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                    horizontal: 16,
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            word.word,
                            style: const TextStyle(
                              fontSize: 24,
                              letterSpacing: 2,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          IconButton(
                            icon: const Icon(Icons.volume_up),
                            onPressed: () => ttsService.speakWord(word.word),
                          ),
                        ],
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Meaning: ${word.meaning}',
                        style: const TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      Text(
                        'Example: ${word.example}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      Text(
                        'Synonyms: ${word.synonyms.join(', ')}',
                        style: const TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                      const Divider(),
                    ],
                  ),
                ),
              )
              .toList(),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: ElevatedButton(
              onPressed: onStartTest,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                '開始測驗',
                style: TextStyle(fontSize: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }
}