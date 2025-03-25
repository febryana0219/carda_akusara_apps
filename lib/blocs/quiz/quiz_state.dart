part of 'quiz_bloc.dart';

@immutable
sealed class QuizState {}

final class QuizInitial extends QuizState {}

final class QuizLoading extends QuizState {}

final class QuizSuccess extends QuizState {
  final int? statusCode;
  final String? message;
  final EventType? eventType;
  final Map<String, dynamic>? data;

  QuizSuccess({this.statusCode, this.message, this.eventType, this.data});
}

final class QuizFailed extends QuizState {
  final int? errorCode;
  final String? errorMessage;

  QuizFailed({this.errorCode, this.errorMessage});
}
