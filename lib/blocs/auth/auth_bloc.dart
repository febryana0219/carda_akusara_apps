import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/storage.dart';
import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/repositories/auth_repo.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

AuthRepo _repo = AuthRepo();

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<AuthEvn>(_postAuth);
    on<ResetPasswordEvent>(_resetPassword);
  }

  Future<void> _postAuth(AuthEvn event, Emitter<AuthState> emit) async {
    try {
      emit(AuthLoading());
      ApiResponse dataResponse = ApiResponse();

      if (EventType.logout == event.eventType) {
        Map<String, dynamic> dataStorage = await Utils.getDataStorage();
        String accessToken = dataStorage['accessToken'];
        // String refreshToken = dataStorage['refreshToken'];

        dataResponse = await _repo.doLogout(accessToken: accessToken);
        // if (dataResponse.statusCode == 1) {
        //   Storage storage = Storage();
        //   storage.clearStorage();
        // }
        Storage storage = Storage();
        storage.clearStorage();
      }

      if (EventType.login == event.eventType) {
        dataResponse = await _repo.doLogin(payload: event.payload);
      }

      if (dataResponse.statusCode == 1) {
        emit(AuthSuccess(
            statusCode: dataResponse.statusCode,
            message: dataResponse.message,
            data: dataResponse.data));
      } else {
        emit(AuthFailed(
            errorCode: dataResponse.statusCode,
            errorMessage: dataResponse.message));
      }
    } catch (e) {
      emit(AuthFailed(
          errorCode: -1, errorMessage: await Utils.exceptionMessage(e)));
    }
  }

  Future<void> _resetPassword(
      ResetPasswordEvent event, Emitter<AuthState> emit) async {
    try {
      emit(ResetPasswordLoading());
      ApiResponse dataResponse = ApiResponse();

      if (event.isRequest) {
        dataResponse = await _repo.doRequestCode(payload: event.payload);
      } else {
        dataResponse = await _repo.doResetPassword(payload: event.payload);
      }

      if (dataResponse.statusCode == 1) {
        emit(ResetPasswordSuccess(
            statusCode: dataResponse.statusCode,
            message: dataResponse.message,
            data: dataResponse.data));
      } else {
        emit(ResetPasswordFailed(
            errorCode: dataResponse.statusCode,
            errorMessage: dataResponse.message));
      }
    } catch (e) {
      emit(ResetPasswordFailed(
          errorCode: -1, errorMessage: await Utils.exceptionMessage(e)));
    }
  }
}
