part of 'auth_bloc.dart';

@immutable
sealed class AuthEvent {}

final class AuthEvn extends AuthEvent {
  final EventType eventType;
  final Map<String, dynamic>? payload;
  AuthEvn(this.eventType, {this.payload});
}
