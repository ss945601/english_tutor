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
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  'Hint: $hintWord',
                  style: const TextStyle(
                    fontSize: 24,
                    letterSpacing: 2,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 10),
                Text(
                  'Meaning: ${currentWord.meaning}',
                  style: const TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                  softWrap: true,
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
                  ElevatedButton(
                    onPressed: onNextWord,
                    child: const Text('Next Word'),
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
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: selectedLetters.isEmpty
                        ? const SizedBox(height: 32)
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              selectedLetters.length,
                              (index) => Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  selectedLetters[index],
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                  ),
                  const SizedBox(height: 20),
                  Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 8,
                    runSpacing: 8,
                    children: List.generate(
                      shuffledLetters.length,
                      (index) {
                        final letter = shuffledLetters[index];
                        return ElevatedButton(
                          key: ValueKey('shuffled_$index'),
                          onPressed: () => onLetterSelected(letter),
                          child: Text(
                            letter,
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: onCheck,
                        child: const Text('Check'),
                      ),
                      ElevatedButton(
                        onPressed: onUndo,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text('Undo'),
                      ),
                      ElevatedButton(
                        onPressed: onGiveUp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        child: const Text('Give Up'),
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