part of 'auth_bloc.dart';

@immutable
sealed class AuthState {}

final class AuthInitial extends AuthState {}

final class AuthLoading extends AuthState {}

final class AuthSuccess extends AuthState {
  final int? statusCode;
  final String? message;
  final Map<String, dynamic>? data;

  AuthSuccess({this.statusCode, this.message, this.data});
}

final class AuthFailed extends AuthState {
  final int? errorCode;
  final String? errorMessage;

  AuthFailed({this.errorCode, this.errorMessage});
}
