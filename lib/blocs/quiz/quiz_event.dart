part of 'quiz_bloc.dart';

@immutable
sealed class QuizEvent {}

final class QuizEvn extends QuizEvent {
  final EventType eventType;
  final int? materiId;
  final int? questionId;
  final int? score;
  QuizEvn(this.eventType, {this.materiId, this.questionId, this.score});
}
