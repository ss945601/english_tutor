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
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: gameWords.length,
            itemBuilder: (context, index) {
              final word = gameWords[index];
              return Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 16,
                ),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    leading: CircleAvatar(
                      backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          word.word,
                          style: const TextStyle(
                            fontSize: 22,
                            letterSpacing: 2,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          icon: const Icon(Icons.volume_up),
                          onPressed: () => ttsService.speakWord(word.word),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        const SizedBox(height: 6),
                        Text('Meaning: ${word.meaning}', textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text('Example: ${word.example}', textAlign: TextAlign.center),
                        const SizedBox(height: 4),
                        Text('Synonyms: ${word.synonyms.join(', ')}', textAlign: TextAlign.center),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: ElevatedButton.icon(
            onPressed: onStartTest,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.play_arrow),
            label: const Text(
              '開始測驗',
              style: TextStyle(fontSize: 20),
            ),
          ),
        ),
      ],
    );
  }
}