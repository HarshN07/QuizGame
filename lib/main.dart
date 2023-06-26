import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:async';

void main() => runApp(QuizApp());

class QuizApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quiz App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    navigateToQuizScreen(); // Call the method to navigate after a delay
  }

  void navigateToQuizScreen() async {
    await Future.delayed(Duration(seconds: 5)); // Add a delay of 2 seconds
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => QuizScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Add your splash screen UI here
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}

class QuizScreen extends StatefulWidget {
  @override
  _QuizScreenState createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int currentQuestionIndex = 0;
  int score = 0;
  int secondsRemaining = 10;
  Timer? timer;

  List<Map<String, Object>> allQuizData = [
    // Quiz questions and answers
    {
      'question':'What is capital of India?',
      'answers':[
        {'text':'New Delhi','correct':true},
        {'text':'Mumbai','correct':false},
        {'text':'Kolkata','correct':false},
        {'text':'Chennai','correct':false},
      ]
    },
    {
      'question':'Which country gifted "The Statue of Liberty" to USA in 1886?',
      'answers':[
        {'text':'Germany','correct':false},
        {'text':'England','correct':false},
        {'text':'France','correct':true},
        {'text':'Italy','correct':false},
      ]
    },
    {
      'question':'Which country is known as playground of Europe?',
      'answers':[
        {'text':'Switzerland','correct':true},
        {'text':'Austria','correct':false},
        {'text':'Holland','correct':true},
        {'text':'Italy','correct':false},
      ]
    },
    {
      'question':'Which country is known as the Land of Thunderbolts?',
      'answers':[
        {'text':'Bhutan','correct':true},
        {'text':'China','correct':false},
        {'text':'Mongolia','correct':true},
        {'text':'Thailand','correct':false},
      ]
    },
    {
      'question':'Which Plateau is known as the Roof of the World?',
      'answers':[
        {'text':'Andes','correct':false},
        {'text':'Deccan','correct':false},
        {'text':'Pamir','correct':true},
        {'text':'Chota Nagpur','correct':false},
      ]
    },
    {
      'question':'What was Queen Elizabeth II surname?',
      'answers':[
        {'text':'Windsor','correct':true},
        {'text':'Charles','correct':false},
        {'text':'Victor','correct':false},
        {'text':'Kingston','correct':false},
      ]
    },
    {
      'question':'Which country is known as Land of Thousand Lakes?',
      'answers':[
        {'text':'Switzerland','correct':false},
        {'text':'Norway','correct':false},
        {'text':'Iceland','correct':false},
        {'text':'Finland','correct':true},
      ]
    },
    {
      'question':'The longest straight road in the world without any corners is located in?',
      'answers':[
        {'text':'Australia','correct':false},
        {'text':'Saudi Arabia','correct':true},
        {'text':'USA','correct':false},
        {'text':'China','correct':false},
      ]
    },
    {
      'question':'In which country highest-altitude civilian airport located?',
      'answers':[
        {'text':'Kloten International Airport,Switzerland','correct':false},
        {'text':'Qamoda Bamda Airport,China','correct':false},
        {'text':'Kushok Bakula Rimpochhe Airport, Leh','correct':false},
        {'text':'Daocheng Yading Airport, China','correct':true},
      ]
    },
    {
      'question':'Which is the longest continental mountain range in the world?',
      'answers':[
        {'text':'Himalaya','correct':false},
        {'text':'Andes','correct':true},
        {'text':'Rocky Mountains','correct':false},
        {'text':'Ural Mountains','correct':false},
      ]
    }
  ];

  List<int> selectedQuestionsIndices = [];
  List<Map<String, dynamic>> selectedQuizData = [];

  @override
  void initState() {
    super.initState();
    selectRandomQuestions();
    startTimer();
  }

  void selectRandomQuestions() {
    selectedQuestionsIndices = [];
    selectedQuizData = [];

    final random = Random();
    while (selectedQuestionsIndices.length < 5) {
      final randomIndex = random.nextInt(allQuizData.length);
      if (!selectedQuestionsIndices.contains(randomIndex)) {
        selectedQuestionsIndices.add(randomIndex);
        selectedQuizData.add(allQuizData[randomIndex]);
      }
    }
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer timer) {
      setState(() {
        if (secondsRemaining > 0) {
          secondsRemaining--;
        } else {
          // Timer expired, move to the next question
          answerQuestion(false);
        }
      });
    });
  }

  void answerQuestion(bool isCorrect) {
    if (isCorrect) {
      setState(() {
        score++;
      });
    }
    resetTimer();
    if (currentQuestionIndex < selectedQuizData.length - 1) {
      setState(() {
        currentQuestionIndex++;
        secondsRemaining = 10;
      });
    } else {
      // Quiz completed
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Quiz Completed!'),
            content: Text('Score: $score/5'),
            actions: [
              TextButton(
                child: Text('Restart Quiz'),
                onPressed: () {
                  setState(() {
                    currentQuestionIndex = 0;
                    score = 0;
                    selectRandomQuestions();
                  });
                  startTimer();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
    Widget _buildProgressIndicator() {
      return Container(
        height: 10,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(5),
        ),
        child: FractionallySizedBox(
          alignment: Alignment.centerLeft,
          widthFactor: (currentQuestionIndex + 1) / selectedQuizData.length,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(5),
            ),
          ),
        ),
      );
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Quiz App'),
        ),
        body: Column(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              child: Text(
                'Timer: $secondsRemaining seconds',
                style: TextStyle(fontSize: 18),
              ),
            ),
            _buildProgressIndicator(),
            SizedBox(height: 10),
            selectedQuizData.isNotEmpty
                ? QuizQuestion(
              question: selectedQuizData[currentQuestionIndex]['question'] as String,
              answers: selectedQuizData[currentQuestionIndex]['answers'] as List<Map<String, dynamic>>,
              answerQuestion: answerQuestion,
              isLastQuestion: currentQuestionIndex == selectedQuizData.length - 1,
            )
                : Center(
              child: CircularProgressIndicator(),
            ),
          ],
        ),
      );
    }
  }


  void resetTimer() {
    timer?.cancel();
    timer = null;
  }

  @override
  void dispose() {
    resetTimer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz App'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              'Timer: $secondsRemaining seconds',
              style: TextStyle(fontSize: 18),
            ),
          ),
          selectedQuizData.isNotEmpty
              ? QuizQuestion(
            question: selectedQuizData[currentQuestionIndex]['question'] as String,
            answers: selectedQuizData[currentQuestionIndex]['answers'] as List<Map<String, dynamic>>,
            answerQuestion: answerQuestion,
            isLastQuestion: currentQuestionIndex == selectedQuizData.length - 1,
          )
              : Center(
            child: CircularProgressIndicator(),
          ),
        ],
      ),
    );
  }
}

class QuizQuestion extends StatefulWidget {
  final String question;
  final List<Map<String, dynamic>> answers;
  final Function(bool) answerQuestion;
  final bool isLastQuestion;

  QuizQuestion({
    required this.question,
    required this.answers,
    required this.answerQuestion,
    required this.isLastQuestion,
  });

  @override
  _QuizQuestionState createState() => _QuizQuestionState();
}

class _QuizQuestionState extends State<QuizQuestion> {
  int selectedOptionIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          padding: EdgeInsets.all(20),
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Text(
                widget.question,
                style: TextStyle(fontSize: 20),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ...widget.answers.asMap().entries.map(
                    (entry) => QuizAnswer(
                  answerText: entry.value['text'] as String,
                  isCorrect: entry.value['correct'] as bool,
                  isSelected: selectedOptionIndex == entry.key,
                  onTap: () {
                    setState(() {
                      selectedOptionIndex = entry.key;
                    });
                  },
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                child: Text(widget.isLastQuestion ? 'Finish' : 'Next'),
                onPressed: selectedOptionIndex != -1
                    ? () {
                  widget.answerQuestion(
                    widget.answers[selectedOptionIndex]['correct'] as bool,
                  );
                  setState(() {
                    selectedOptionIndex = -1;
                  });
                }
                    : null,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class QuizAnswer extends StatelessWidget {
  final String answerText;
  final bool isCorrect;
  final bool isSelected;
  final VoidCallback onTap;

  QuizAnswer({
    required this.answerText,
    required this.isCorrect,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue : Colors.white,
          border: Border.all(
            color: isSelected ? Colors.blue : Colors.grey,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(10),
        child: Text(
          answerText,
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
