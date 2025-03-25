part of 'materi_bloc.dart';

@immutable
sealed class MateriEvent {}

final class MateriEvn extends MateriEvent {
  final EventType eventType;
  final int? materiId;
  final int? materiNo;
  MateriEvn(this.eventType, {this.materiId, this.materiNo});
}
