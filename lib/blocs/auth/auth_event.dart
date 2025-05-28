part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthEvn extends AuthEvent {
  final EventType eventType;
  final Map<String, dynamic>? payload;
  AuthEvn(this.eventType, {this.payload});
}

final class ResetPasswordEvent extends AuthEvent {
  final bool isRequest;
  final Map<String, dynamic>? payload;
  ResetPasswordEvent({required this.isRequest, this.payload});
}
