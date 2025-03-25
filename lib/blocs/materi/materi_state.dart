part of 'materi_bloc.dart';

@immutable
sealed class MateriState {}

final class MateriInitial extends MateriState {}

final class MateriLoading extends MateriState {}

final class MateriSuccess extends MateriState {
  final int? statusCode;
  final String? message;
  final String? totalScore;
  final EventType? eventType;
  final Map<String, dynamic>? data;

  MateriSuccess(
      {this.statusCode,
      this.message,
      this.totalScore,
      this.eventType,
      this.data});
}

final class MateriFailed extends MateriState {
  final int? errorCode;
  final String? errorMessage;

  MateriFailed({this.errorCode, this.errorMessage});
}
