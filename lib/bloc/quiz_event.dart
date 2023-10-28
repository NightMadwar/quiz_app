part of 'quiz_bloc.dart';

sealed class QuizEvent {}

final class AnswerEvent extends QuizEvent {
  int questionTime;
  int answerTime;
  bool isCorrect;
  AnswerEvent(
      {required this.answerTime,
      required this.questionTime,
      required this.isCorrect});
}
