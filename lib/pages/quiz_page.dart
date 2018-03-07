import 'package:flutter/material.dart';

import '../utils/question.dart';
import '../utils/quiz.dart';
import '../UI/answer_button.dart';
import '../UI/question_text.dart';
import '../UI/correct_wrong_overlay.dart';

import './score_page.dart';

class QuizPage extends StatefulWidget {
  @override
  State createState() => new QuizPageState();
}

class QuizPageState extends State<QuizPage> {

  Question currentQuestion;
  Quiz quiz = new Quiz([
    new Question("Lightning never strikes in the same place twice?", false),
    new Question("If you cut earthworm in half, both halves can regrow their body?", false),
    new Question("Adults have fewer bones than babies do?", true),
    new Question("If you cry in space, the tears just stick to your face?", true),
    new Question("Human can distinguish between over a trillion different smells?", true),
    new Question("Birds are dinosaurs?", true),
    new Question("Napolean Bonapate was extremely short?", false),
    new Question("There are more cells of bacteria in your body than there are human cells?", true),
    new Question("GoldFish only have a memory of three seconds?", false),
    new Question("Your fingernails and hair keep growing after you die?", false),
    new Question("Neil Armstrong was the first man to urinate on the moon?", false),
    new Question("Human can't breathe and swallow at the same time?", true)
  ]);
  String questionText;
  int questionNumber;
  bool isCorrect;
  bool overlayShouldBeVisible = false;

  void handleAnswer(bool answer) {
    isCorrect = (currentQuestion.answer == answer);
    quiz.answer(isCorrect);
    this.setState(() {
      overlayShouldBeVisible = true;
    });
  }

  @override
  void initState() {
    super.initState();
    currentQuestion = quiz.nextQuestion;
    questionText = currentQuestion.question;
    questionNumber = quiz.questionNumber;
  }

  @override
  Widget build(BuildContext context) {
    return new Stack(
      fit: StackFit.expand,
      children: <Widget>[
        new Column( //this is our main page
          children: <Widget>[
            new AnswerButton(true, () => handleAnswer(true) ),     //true button
            new QuestionText(questionText, questionNumber),
            new AnswerButton(false, () => handleAnswer(false) ),   //false button
          ],
        ),
        overlayShouldBeVisible == true ? new CorrectWrongOverlay(
          isCorrect,
          () {
            if(quiz.length == questionNumber) {
              Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => new ScorePage(quiz.score, quiz.length)), (Route route) => route == null);
              return;
            }
            currentQuestion = quiz.nextQuestion;
            this.setState(() {
              overlayShouldBeVisible = false;
              questionText = currentQuestion.question;
              questionNumber = quiz.questionNumber;
            });
          }
        ) : new Container()
      ],
    );
  }
}