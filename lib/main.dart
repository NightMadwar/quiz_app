import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:quiz_app/bloc/quiz_bloc.dart';
import 'package:quiz_app/config/bloc_obesrve.dart';
import 'package:quiz_app/finished_page.dart';

void main() {
  Bloc.observer = MyBlocObserver();
  runApp(const QuizApp());
}

List<QuestionModel> questions = [
  QuestionModel(
      questionSentenc: 'How Long Are You ?',
      description: 'This is an easy Question ...',
      time: 7,
      answers: [
        Answer(answer: '20 m', isCorrect: false),
        Answer(answer: '10 m', isCorrect: false),
        Answer(answer: '5 m', isCorrect: false),
        Answer(answer: '1.8 m', isCorrect: true)
      ]),
  QuestionModel(
      questionSentenc: 'How old Are You ?',
      description: 'This is an easy Question ...',
      time: 10,
      answers: [
        Answer(answer: '22 ', isCorrect: true),
        Answer(answer: '23 ', isCorrect: false),
        Answer(answer: '21', isCorrect: false),
        Answer(answer: '20 ', isCorrect: false)
      ])
];

class QuestionModel {
  String questionSentenc;
  String description;
  int time;
  List<Answer> answers;
  QuestionModel(
      {required this.questionSentenc,
      required this.description,
      required this.time,
      required this.answers});
}

class Answer {
  String answer;
  bool isCorrect;
  Answer({required this.answer, required this.isCorrect});
}

class QuizApp extends StatefulWidget {
  const QuizApp({super.key});

  @override
  State<QuizApp> createState() => _QuizAppState();
}

Timer timer = Timer(const Duration(seconds: 1), () {});
int start = 1;

class _QuizAppState extends State<QuizApp> {
  // Future setTime(int time) async {
  //   const oneSec = Duration(seconds: 1);
  //   timer = Timer.periodic(oneSec, (Timer timer) {
  //     if (time == 0) {
  //       setState(() {
  //         timer.cancel();
  //       });
  //     } else {
  //       setState(() {
  //         time++;
  //       });
  //     }
  //   });
  // }

  @override
  void initState() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (Timer timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
        });
      } else {
        setState(() {
          start++;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PageController controller = PageController();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BlocProvider(
        create: (context) => QuizBloc(),
        child: Builder(builder: (context) {
          return Scaffold(
            body: PageView.builder(
              controller: controller,
              itemCount: questions.length,
              itemBuilder: (context, index) {
                // if (start == questions[index].time) {
                //   timer.cancel();
                //   return AlertDialog(
                //     title: Text("Quiz Exam"),
                //     content: Text("Time has finished"),
                //     actions: [
                //       InkWell(
                //         child: Text("Try Again"),
                //         onTap: () {
                //           setState(() {
                //             start = 1;
                //           });
                //           initState();
                //         },
                //       ),
                //       InkWell(
                //         child: Text("Close"),
                //         onTap: () {
                //           Navigator.of(context).push(MaterialPageRoute(
                //             builder: (context) => FinishPage(),
                //           ));
                //         },
                //       )
                //     ],
                //   );
                // }

                return BlocListener<QuizBloc, QuizState>(
                  listener: (context, state) {
                    if (state is CorrectState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.green[600],
                          duration: const Duration(milliseconds: 500),
                          content: const Text("True")));
                      controller.nextPage(
                          duration: Duration(seconds: 1), curve: Curves.linear);
                    } else if (state is ErrorState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.red[500],
                          duration: const Duration(milliseconds: 500),
                          content: const Text("False")));
                    } else if (state is TimeoutState) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.blue[500],
                          duration: const Duration(milliseconds: 500),
                          content: const Text("TimeOut")));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          backgroundColor: Colors.deepPurple[500],
                          duration: const Duration(milliseconds: 500),
                          content: Text(state.toString())));
                    }
                  },
                  child: ListTile(
                    trailing: Text(
                        "time : ${questions[index].time}/${start.toString()}"),
                    title: Text(questions[index].questionSentenc),
                    subtitle: SizedBox(
                      width: 500,
                      height: double.maxFinite,
                      child: GridView.builder(
                        itemCount: questions[index].answers.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                crossAxisCount: 2),
                        itemBuilder: (context, ind) {
                          return InkWell(
                            onTap: () async {
                              context.read<QuizBloc>().add(AnswerEvent(
                                  answerTime: start,
                                  questionTime: questions[index].time,
                                  isCorrect:
                                      questions[index].answers[ind].isCorrect));
                              if (questions[index].answers[ind].isCorrect) {
                                {
                                  setState(() {
                                    start = 1;
                                  });
                                }
                              }
                            },
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: Card(
                                color: Colors.grey[300],
                                child: Center(
                                    child: Text(
                                        questions[index].answers[ind].answer)),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}
