# TOEIC Word Spelling Game

An interactive Flutter-based educational game designed to help users learn and memorize TOEIC vocabulary through an engaging word spelling challenge.

## Features

- **Word Memorization Game**: Test your memory and spelling skills with TOEIC vocabulary words
- **Two-Phase Learning**: Memory phase followed by a testing phase for effective learning
- **Scoring System**: Earn points based on word difficulty and completion time
- **Progress Tracking**: Visual progress indicator to track your game session
- **Comprehensive Word Database**: Includes word meanings, example sentences, and synonyms
- **Text-to-Speech**: Built-in TTS functionality for pronunciation practice

## Getting Started

### Prerequisites

- Flutter SDK (^3.7.2)
- Dart SDK
- iOS/Android development environment setup

### Installation

1. Clone the repository
2. Install dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## How to Play

1. Start the game from the home screen
2. You will be presented with TOEIC words in two phases:
   - **Memory Phase**: Study the word and its meaning
   - **Test Phase**: Arrange shuffled letters to spell the correct word
3. Complete each word before the timer runs out
4. Score points based on:
   - Word difficulty level
   - Completion time
   - Accuracy

## Dependencies

- `flutter_tts`: ^3.8.5 - For text-to-speech functionality
- Flutter material design components

## Project Structure

- `lib/screens/` - Game and home screen implementations
- `lib/models/` - Data models for TOEIC words
- `lib/data/` - TOEIC word database and game data

## Contributing

Contributions are welcome! Feel free to submit issues and pull requests.
