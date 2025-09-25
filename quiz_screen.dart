import 'package:flutter/material.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentQuestion = 0;
  int _score = 0;

  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Which scheduling algorithm is non-preemptive?',
      'options': ['SRTF', 'Round Robin', 'FCFS', 'Priority Preemptive'],
      'answer': 'FCFS',
    },
    {
      'question': 'Which algorithm uses time quantum?',
      'options': ['SJF', 'Round Robin', 'FCFS', 'Priority'],
      'answer': 'Round Robin',
    },
    {
      'question': 'In Priority Scheduling, lower number indicates?',
      'options': ['Lower priority', 'Higher priority', 'Arrival time', 'Burst time'],
      'answer': 'Higher priority',
    },
  ];

  void _answerQuestion(String selected) {
    if (selected == _questions[_currentQuestion]['answer']) {
      _score++;
    }

    if (_currentQuestion < _questions.length - 1) {
      setState(() => _currentQuestion++);
    } else {
      _showResultDialog();
    }
  }

  void _showResultDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Quiz Completed!'),
        content: Text('Your score: $_score / ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Go back to HomeScreen
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final question = _questions[_currentQuestion];
    return Scaffold(
      appBar: AppBar(
        title: const Text('CPU Scheduling Quiz'),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Question ${_currentQuestion + 1}/${_questions.length}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              question['question'],
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            ...List.generate(
              question['options'].length,
                  (index) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: ElevatedButton(
                  onPressed: () => _answerQuestion(question['options'][index]),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurpleAccent),
                  child: Text(question['options'][index]),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
