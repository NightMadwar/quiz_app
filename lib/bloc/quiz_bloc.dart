import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<AnswerEvent>((event, emit) {
      if (event.questionTime > event.answerTime) {
        if (event.isCorrect) {
          emit(CorrectState());
        } else {
          emit(ErrorState());
        }
      } else {
        emit(TimeoutState());
      }
    });
  }
}
