class ToeicWord {
  final String word;
  final String meaning;
  final String example;
  final int difficulty;
  final List<String> synonyms;
  final int frequency;

  const ToeicWord({
    required this.word,
    required this.meaning,
    required this.example,
    required this.difficulty,
    required this.synonyms,
    required this.frequency,
  });

  factory ToeicWord.fromJson(Map<String, dynamic> json) {
    return ToeicWord(
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      example: json['example'] as String,
      difficulty: json['difficulty'] as int,
      synonyms: List<String>.from(json['synonyms']),
      frequency: json['frequency'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'meaning': meaning,
      'example': example,
      'difficulty': difficulty,
      'synonyms': synonyms,
      'frequency': frequency,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ToeicWord &&
          runtimeType == other.runtimeType &&
          word == other.word;

  @override
  int get hashCode => word.hashCode;
}