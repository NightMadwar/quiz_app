part of 'quiz_bloc.dart';

@immutable
sealed class QuizState {}

final class QuizInitial extends QuizState {}

final class CorrectState extends QuizState {}

final class ErrorState extends QuizState {}

final class TimeoutState extends QuizState {}
