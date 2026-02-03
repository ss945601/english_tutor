import 'package:flutter/material.dart';
import '../models/toeic_word.dart';
import '../services/tts_service.dart';

class TestPhaseWidget extends StatelessWidget {
  final ToeicWord currentWord;
  final String hintWord;
  final List<String> shuffledLetters;
  final List<String> selectedLetters;
  final bool showAnswer;
  final TtsService ttsService;
  final Function(String) onLetterSelected;
  final VoidCallback onCheck;
  final VoidCallback onGiveUp;
  final VoidCallback onUndo;
  final VoidCallback onNextWord;

  const TestPhaseWidget({
    super.key,
    required this.currentWord,
    required this.hintWord,
    required this.shuffledLetters,
    required this.selectedLetters,
    required this.showAnswer,
    required this.ttsService,
    required this.onLetterSelected,
    required this.onCheck,
    required this.onGiveUp,
    required this.onUndo,
    required this.onNextWord,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: [
                Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
                    child: Column(
                      children: [
                        Text(
                          hintWord,
                          style: const TextStyle(fontSize: 28, letterSpacing: 4, fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Chip(
                              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                              label: Text('Level ${currentWord.difficulty}'),
                            ),
                            const SizedBox(width: 8),
                            IconButton(
                              icon: const Icon(Icons.volume_up),
                              onPressed: () => ttsService.speakWord(currentWord.word),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Card(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Meaning: ${currentWord.meaning}',
                      style: const TextStyle(fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          if (showAnswer) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Answer: ${currentWord.word}',
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.volume_up),
                        onPressed: () => ttsService.speakWord(currentWord.word),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Example: ${currentWord.example}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Synonyms: ${currentWord.synonyms.join(', ')}',
                    style: const TextStyle(fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: onNextWord,
                    icon: const Icon(Icons.arrow_forward),
                    label: const Text('Next Word'),
                  ),
                ],
              ),
            ),
          ] else ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.surface,
                    ),
                    child: selectedLetters.isEmpty
                        ? const SizedBox(height: 40)
                        : Wrap(
                            spacing: 6,
                            children: selectedLetters
                                .map((c) => Chip(
                                      label: Text(
                                        c,
                                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                      ),
                                    ))
                                .toList(),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: List.generate(
                      shuffledLetters.length,
                      (index) {
                        final letter = shuffledLetters[index];
                        return Material(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          shape: const CircleBorder(),
                          child: InkWell(
                            onTap: () => onLetterSelected(letter),
                            customBorder: const CircleBorder(),
                            child: Container(
                              width: 56,
                              height: 56,
                              alignment: Alignment.center,
                              child: Text(
                                letter,
                                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: onCheck,
                        icon: const Icon(Icons.check),
                        label: const Text('Check'),
                      ),
                      ElevatedButton.icon(
                        onPressed: onUndo,
                        icon: const Icon(Icons.undo),
                        label: const Text('Undo'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.blueAccent),
                      ),
                      ElevatedButton.icon(
                        onPressed: onGiveUp,
                        icon: const Icon(Icons.flag),
                        label: const Text('Give Up'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

