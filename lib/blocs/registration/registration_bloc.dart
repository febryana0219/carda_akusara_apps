import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/repositories/auth_repo.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'registration_event.dart';
part 'registration_state.dart';

AuthRepo _repo = AuthRepo();

class RegistrationBloc extends Bloc<RegistrationEvent, RegistrationState> {
  RegistrationBloc() : super(RegistrationInitial()) {
    on<RegistrationEvn>(_postRegistration);
  }

  Future<void> _postRegistration(
      RegistrationEvn event, Emitter<RegistrationState> emit) async {
    try {
      emit(RegistrationLoading());

      ApiResponse dataResponse = ApiResponse();
      if (EventType.registration == event.eventType) {
        dataResponse = await _repo.doRegistration(payload: event.payload);
      }

      if (dataResponse.statusCode == 1) {
        emit(RegistrationSuccess(
            statusCode: dataResponse.statusCode,
            message: dataResponse.message,
            data: dataResponse.data));
      } else {
        emit(RegistrationFailed(
            errorCode: dataResponse.statusCode,
            errorMessage: dataResponse.message));
      }
    } catch (e) {
      emit(RegistrationFailed(
          errorCode: -1, errorMessage: await Utils.exceptionMessage(e)));
    }
  }
}
