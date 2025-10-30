import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(HangmanApp());
}

class HangmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hangman Game',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HangmanHomePage(),
    );
  }
}

class HangmanHomePage extends StatefulWidget {
  @override
  _HangmanHomePageState createState() => _HangmanHomePageState();
}

class _HangmanHomePageState extends State<HangmanHomePage> {
  final List<String> words = [
    "HAPPY",
    "REFLECT",
    "FLUTTER",
    "COMPUTER",
    "PROGRAMMING",
    "CHATGPT",
    "DEVELOPER"
  ];
  late String wordToGuess;
  List<String> guessedLetters = [];
  int wrongGuesses = 0;
  final int maxWrongGuesses = 6;

  @override
  void initState() {
    super.initState();
    startNewGame();
  }

  void startNewGame() {
    final random = Random();
    wordToGuess = words[random.nextInt(words.length)];
    guessedLetters = [];
    wrongGuesses = 0;
    setState(() {});
  }

  void guessLetter(String letter) {
    if (!guessedLetters.contains(letter)) {
      guessedLetters.add(letter);
      if (!wordToGuess.contains(letter)) {
        wrongGuesses++;
      }
    }
    setState(() {});
  }

  String displayWord() {
    return wordToGuess
        .split('')
        .map((letter) => guessedLetters.contains(letter) ? letter : "_")
        .join(" ");
  }

  List<String> wrongGuessedLetters() {
    return guessedLetters.where((letter) => !wordToGuess.contains(letter)).toList();
  }

  bool isWon() {
    return wordToGuess.split('').every((letter) => guessedLetters.contains(letter));
  }

  bool isLost() {
    return wrongGuesses >= maxWrongGuesses;
  }

  Widget hangmanImage() {
    // You can replace with images or draw simple shapes
    return Text(
      "Hangman: ${wrongGuesses} / $maxWrongGuesses",
      style: TextStyle(fontSize: 20, color: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hangman Game")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            hangmanImage(),
            SizedBox(height: 20),
            Container(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
              ),
              child: Text(
                displayWord(),
                style: TextStyle(
                  fontSize: 36,
                  letterSpacing: 6,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (wrongGuessedLetters().isNotEmpty)
              Wrap(
                children: [
                  Text(
                    "Wrong letters: ",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    wrongGuessedLetters().join(", "),
                    style: TextStyle(fontSize: 18, color: Colors.red),
                  ),
                ],
              ),
            SizedBox(height: 20),
            Expanded(
              child: GridView.count(
                crossAxisCount: 7,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                children: 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'.split('').map((letter) {
                  bool guessed = guessedLetters.contains(letter);
                  Color buttonColor;
                  if (guessed && wordToGuess.contains(letter)) {
                    buttonColor = Colors.green;
                  } else if (guessed && !wordToGuess.contains(letter)) {
                    buttonColor = Colors.red;
                  } else {
                    buttonColor = Colors.blue;
                  }

                  return ElevatedButton(
                    onPressed: guessed || isWon() || isLost() ? null : () => guessLetter(letter),
                    child: Text(letter),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: buttonColor,
                      minimumSize: Size(40, 40),
                    ),
                  );
                }).toList(),
              ),
            ),
            if (isWon())
              Column(
                children: [
                  Text(
                    "🎉 Congratulations! You WON! 🎉",
                    style: TextStyle(fontSize: 24, color: Colors.green),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: startNewGame, child: Text("Play Again")),
                ],
              ),
            if (isLost())
              Column(
                children: [
                  Text(
                    "💀 You LOST! Word was: $wordToGuess",
                    style: TextStyle(fontSize: 24, color: Colors.red),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(onPressed: startNewGame, child: Text("Play Again")),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
