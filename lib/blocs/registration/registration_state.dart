part of 'registration_bloc.dart';

@immutable
sealed class RegistrationState {}

final class RegistrationInitial extends RegistrationState {}

final class RegistrationLoading extends RegistrationState {}

final class RegistrationSuccess extends RegistrationState {
  final int? statusCode;
  final String? message;
  final Map<String, dynamic>? data;

  RegistrationSuccess({this.statusCode, this.message, this.data});
}

final class RegistrationFailed extends RegistrationState {
  final int? errorCode;
  final String? errorMessage;

  RegistrationFailed({this.errorCode, this.errorMessage});
}
