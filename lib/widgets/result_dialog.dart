import 'package:flutter/material.dart';
import '../models/toeic_word.dart';

class ResultDialog extends StatelessWidget {
  final int score;
  final List<ToeicWord> correctWords;
  final List<ToeicWord> incorrectWords;
  final VoidCallback onPlayAgain;
  final VoidCallback onReturnHome;

  const ResultDialog({
    super.key,
    required this.score,
    required this.correctWords,
    required this.incorrectWords,
    required this.onPlayAgain,
    required this.onReturnHome,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Game Over'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Your final score: $score'),
            const SizedBox(height: 20),
            if (correctWords.isNotEmpty) ...[  
              const Text(
                'Correct Words:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...List.generate(
                correctWords.length,
                (index) {
                  final word = correctWords[index];
                  return Text('• ${word.word} - ${word.meaning}');
                },
              ),
              const SizedBox(height: 10),
            ],
            if (incorrectWords.isNotEmpty) ...[  
              const Text(
                'Incorrect Words:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              ...List.generate(
                incorrectWords.length,
                (index) {
                  final word = incorrectWords[index];
                  return Text('• ${word.word} - ${word.meaning}');
                },
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onReturnHome,
          child: const Text('Return to Home'),
        ),
        TextButton(
          onPressed: onPlayAgain,
          child: const Text('Play Again'),
        ),
      ],
    );
  }
}