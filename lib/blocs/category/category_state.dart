part of 'category_bloc.dart';

@immutable
sealed class CategoryState {}

final class CategoryInitial extends CategoryState {}

final class CategoryLoading extends CategoryState {}

final class CategorySuccess extends CategoryState {
  final int? statusCode;
  final String? message;
  final dynamic totalScore;
  final Map<String, dynamic>? data;
  final List<dynamic>? items;

  CategorySuccess(
      {this.statusCode, this.message, this.totalScore, this.data, this.items});
}

final class CategoryFailed extends CategoryState {
  final int? errorCode;
  final String? errorMessage;

  CategoryFailed({this.errorCode, this.errorMessage});
}
