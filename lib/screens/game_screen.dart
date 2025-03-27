import 'dart:math';
import 'package:flutter/material.dart';
import '../models/toeic_word.dart';
import '../data/toeic_words.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

enum GamePhase { memorize, test }

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  late List<ToeicWord> gameWords;
  late ToeicWord currentWord;
  late List<String> shuffledLetters;
  List<String> selectedLetters = [];
  int score = 0;
  late AnimationController _controller;
  GamePhase currentPhase = GamePhase.memorize;
  int currentWordIndex = 0;
  bool isTimerActive = false;
  late Map<String, String> hintWords;
  bool showAnswer = false;
  List<ToeicWord> correctWords = [];
  List<ToeicWord> incorrectWords = [];

  @override
  void initState() {
    super.initState();
    _initializeGame();
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    _controller.addListener(() {
      if (_controller.isCompleted && isTimerActive) {
        if (currentWordIndex < gameWords.length - 1) {
          _moveToNextWord();
        } else {
          _showGameOver();
        }
      }
    });
  }

  String _getHintWord() {
    return hintWords[currentWord.word] ?? '';
  }

  void _generateHintWords() {
    hintWords = {};
    for (var word in gameWords) {
      final wordLength = word.word.length;
      final hintCount = (wordLength / 2).floor();
      final positions = List.generate(wordLength, (index) => index)..shuffle();
      final hintPositions = positions.take(hintCount).toSet();

      final hint = word.word
          .split('')
          .asMap()
          .entries
          .map((entry) {
            return hintPositions.contains(entry.key) ? entry.value : '_';
          })
          .join('');
      
      hintWords[word.word] = hint;
    }
  }

  void _initializeGame() {
    gameWords = List.from(ToeicWords.words)..shuffle();
    gameWords = gameWords.take(5).toList();
    currentWordIndex = 0;
    currentWord = gameWords[currentWordIndex];
    shuffledLetters = currentWord.word.split('')..shuffle();
    selectedLetters = [];
    currentPhase = GamePhase.memorize;
    showAnswer = false;
    correctWords = [];
    incorrectWords = [];
    _generateHintWords();
  }

  void _moveToNextWord() {
    if (currentWordIndex >= gameWords.length - 1) {
      _showGameOver();
      return;
    }
    
    setState(() {
      currentWordIndex++;
      currentWord = gameWords[currentWordIndex];
      shuffledLetters = currentWord.word.split('')..shuffle();
      selectedLetters = [];
      showAnswer = false;
      _controller.reset();
      _controller.forward();
    });
  }

  void _checkWord() {
    final enteredWord = selectedLetters.join();
    if (enteredWord == currentWord.word) {
      setState(() {
        score += 20;
        showAnswer = true;
        correctWords.add(currentWord);
      });
    } else {
      setState(() {
        showAnswer = true;
        incorrectWords.add(currentWord);
      });
    }
    
    // Check if this was the last word
    if (currentWordIndex >= gameWords.length - 1) {
      _showGameOver();
    }
  }

  void _giveUp() {
    setState(() {
      showAnswer = true;
      selectedLetters = currentWord.word.split('');
      shuffledLetters = [];
      incorrectWords.add(currentWord);
    });
    
    // Check if this was the last word
    if (currentWordIndex >= gameWords.length - 1) {
      _showGameOver();
    }
  }

  void _startTest() {
    setState(() {
      currentPhase = GamePhase.test;
      currentWordIndex = 0;
      currentWord = gameWords[currentWordIndex];
      shuffledLetters = currentWord.word.split('')..shuffle();
      selectedLetters = [];
      showAnswer = false;
      isTimerActive = true;
      _controller.reset();
      _controller.forward();
    });
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Game Over'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Your final score: $score'),
              const SizedBox(height: 20),
              if (correctWords.isNotEmpty) ...[
                const Text('Correct Words:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...correctWords.map((word) => Text('• ${word.word} - ${word.meaning}')),
                const SizedBox(height: 10),
              ],
              if (incorrectWords.isNotEmpty) ...[
                const Text('Incorrect Words:', style: TextStyle(fontWeight: FontWeight.bold)),
                ...incorrectWords.map((word) => Text('• ${word.word} - ${word.meaning}')),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Return to home screen
            },
            child: const Text('Return to Home'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                score = 0;
                _initializeGame();
                _controller.reset();
                _controller.forward();
              });
            },
            child: const Text('Play Again'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Rest of the build method remains the same...
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('TOEIC Word Spelling Game'),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Text(
                'Score: $score',
                style: const TextStyle(fontSize: 18),
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: 1 - _controller.value,
            backgroundColor: Colors.grey[200],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              currentPhase == GamePhase.memorize ? '記憶階段' : '測驗階段',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (currentPhase == GamePhase.memorize)
                    Column(
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
                                    Text(
                                      word.word,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        letterSpacing: 2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      textAlign: TextAlign.center,
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
                            onPressed: _startTest,
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
                    )
                  else
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Column(
                            children: [
                              Text(
                                'Hint: ${_getHintWord()}',
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
                                Text(
                                  'Answer: ${currentWord.word}',
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Example: ${currentWord.example}',
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Synonyms: ${currentWord.synonyms.join(", ")}',
                                  style: const TextStyle(fontSize: 18),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 20),
                                if (currentWordIndex < gameWords.length - 1)
                                  ElevatedButton(
                                    onPressed: _moveToNextWord,
                                    child: const Text('Next Word'),
                                  ),
                              ],
                            ),
                          ),
                        ] else ...[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.blue),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                selectedLetters.join(' '),
                                style: const TextStyle(
                                  fontSize: 24,
                                  letterSpacing: 2,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: shuffledLetters.map((letter) {
                                return ElevatedButton(
                                  onPressed: selectedLetters.length <
                                          currentWord.word.length
                                      ? () {
                                          setState(() {
                                            selectedLetters.add(letter);
                                            shuffledLetters.remove(letter);
                                            if (selectedLetters.length ==
                                                currentWord.word.length) {
                                              _checkWord();
                                            }
                                          });
                                        }
                                      : null,
                                  child: Text(
                                    letter,
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ElevatedButton(
                                onPressed: selectedLetters.isNotEmpty
                                    ? () {
                                        setState(() {
                                          final letter = selectedLetters.removeLast();
                                          shuffledLetters.add(letter);
                                        });
                                      }
                                    : null,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                ),
                                child: const Text('Undo'),
                              ),
                              const SizedBox(width: 20),
                              ElevatedButton(
                                onPressed: _giveUp,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.orange,
                                ),
                                child: const Text('Give Up'),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 20),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
