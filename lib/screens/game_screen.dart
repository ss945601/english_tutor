import 'package:flutter/material.dart';
import '../models/toeic_word.dart';
import '../data/toeic_words.dart';
import '../services/tts_service.dart';
import '../widgets/memory_phase_widget.dart';
import '../widgets/test_phase_widget.dart';
import '../widgets/result_dialog.dart';

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
  late String currentHintWord;
  
  final TtsService ttsService = TtsService();

  @override
  void initState() {
    super.initState();
    _initializeGame();
    ttsService.initTts(); // Initialize TTS early
    _controller = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    );
    _controller.addStatusListener(_onTimerStatusChanged);
  }

  void _onTimerStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed && isTimerActive) {
      if (currentWordIndex < gameWords.length - 1) {
        _moveToNextWord();
      } else {
        _showGameOver();
      }
    }
  }

  String _getHintWord() {
    return currentHintWord;
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
    currentHintWord = hintWords[currentWord.word] ?? '';
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
      currentHintWord = hintWords[currentWord.word] ?? '';
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
      currentHintWord = hintWords[currentWord.word] ?? '';
      isTimerActive = true;
      _controller.reset();
      _controller.forward();
    });
  }

  void _showGameOver() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ResultDialog(
        score: score,
        correctWords: correctWords,
        incorrectWords: incorrectWords,
        onPlayAgain: () {
          Navigator.of(context).pop();
          setState(() {
            score = 0;
            _initializeGame();
            _controller.reset();
            _controller.forward();
          });
        },
        onReturnHome: () {
          Navigator.of(context).pop();
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _onLetterSelected(String letter) {
    final index = shuffledLetters.indexOf(letter);
    if (index != -1) {
      setState(() {
        selectedLetters.add(letter);
        shuffledLetters.removeAt(index);
      });
    }
  }

  void _onUndo() {
    if (selectedLetters.isNotEmpty) {
      setState(() {
        final lastLetter = selectedLetters.removeLast();
        shuffledLetters.add(lastLetter);
      });
    }
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    ttsService.dispose();
    super.dispose();
  }

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
            child: currentPhase == GamePhase.memorize
                ? MemoryPhaseWidget(
                    gameWords: gameWords,
                    onStartTest: _startTest,
                    ttsService: ttsService,
                  )
                : TestPhaseWidget(
                    currentWord: currentWord,
                    hintWord: _getHintWord(),
                    shuffledLetters: shuffledLetters,
                    selectedLetters: selectedLetters,
                    showAnswer: showAnswer,
                    ttsService: ttsService,
                    onLetterSelected: _onLetterSelected,
                    onCheck: _checkWord,
                    onGiveUp: _giveUp,
                    onNextWord: _moveToNextWord,
                    onUndo: _onUndo,
                  ),
          ),
        ],
      ),
    );
  }
}
