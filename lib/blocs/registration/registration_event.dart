part of 'registration_bloc.dart';

@immutable
sealed class RegistrationEvent {}

final class RegistrationEvn extends RegistrationEvent {
  final EventType eventType;
  final Map<String, dynamic> payload;
  RegistrationEvn(this.eventType, this.payload);
}
