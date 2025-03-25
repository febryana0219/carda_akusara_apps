part of 'profile_bloc.dart';

@immutable
sealed class ProfileState {}

final class ProfileInitial extends ProfileState {}

final class ProfileLoading extends ProfileState {}

final class ProfileSuccess extends ProfileState {
  final int? statusCode;
  final String? message;
  final dynamic totalScore;
  final Map<String, dynamic>? data;
  final List<dynamic>? items;

  ProfileSuccess(
      {this.statusCode, this.message, this.totalScore, this.data, this.items});
}

final class ProfileFailed extends ProfileState {
  final int? errorCode;
  final String? errorMessage;

  ProfileFailed({this.errorCode, this.errorMessage});
}
