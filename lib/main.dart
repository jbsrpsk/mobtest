import 'package:flutter/material.dart';
import 'dart:math';

void main() => runApp(HangmanApp());

class HangmanApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hangman Game',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HangmanScreen(),
    );
  }
}

class HangmanScreen extends StatefulWidget {
  @override
  _HangmanScreenState createState() => _HangmanScreenState();
}

class _HangmanScreenState extends State<HangmanScreen> {
  final List<String> words = ["hangman", "chill", "banana", "computer", "python"];
  late String secretWord;
  late List<String> guessedLetters;
  int remainingChances = 5;
  int mistakes = 0;

  @override
  void initState() {
    super.initState();
    startGame();
  }

  void startGame() {
    Random random = Random();
    secretWord = words[random.nextInt(words.length)];
    guessedLetters = List.filled(secretWord.length, "_");
    remainingChances = 5;
    mistakes = 0;
  }

  void guessLetter(String letter) {
    setState(() {
      if (secretWord.contains(letter)) {
        for (int i = 0; i < secretWord.length; i++) {
          if (secretWord[i] == letter) {
            guessedLetters[i] = letter;
          }
        }
      } else {
        remainingChances--;
        mistakes++;
      }
      if (remainingChances == 0 || !guessedLetters.contains("_")) {
        // Game over, reset the game
        showResetDialog();
      }
    });
  }

  void showResetDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Game Over'),
          content: Text(remainingChances == 0
              ? 'You ran out of chances. The word was: $secretWord'
              : 'Congratulations! You guessed the word: $secretWord'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  startGame(); // Start a new game
                });
              },
              child: Text('New Game'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hangman Game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Remaining Chances: $remainingChances',
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 20),
                    if (mistakes > 0)
                      Image.asset(
                        'assets/snow$mistakes.jpeg',
                        height: 150,
                      ),
                    SizedBox(height: 20),
                    Text(
                      guessedLetters.join(" "),
                      style: TextStyle(fontSize: 40),
                    ),
                    SizedBox(height: 5),
                    GridView.count(
                      shrinkWrap: true,
                      crossAxisCount: 9,
                      childAspectRatio: 1.0,
                      mainAxisSpacing: 5,
                      crossAxisSpacing: 5,
                      children: List.generate(26, (index) {
                        String letter = String.fromCharCode('a'.codeUnitAt(0) + index);
                        return SizedBox(
                          width: 10,
                          height: 10,
                          child: ElevatedButton(
                            onPressed: remainingChances > 0 && guessedLetters.contains("_") ? () => guessLetter(letter) : null,
                            child: Text(
                              letter.toUpperCase(),
                              style: TextStyle(fontSize: 14),
                            ),
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.zero,
                              ),
                            ),
                          ),
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
