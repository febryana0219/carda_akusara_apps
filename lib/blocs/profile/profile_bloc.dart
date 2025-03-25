import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/repositories/auth_repo.dart';
import 'package:app_mobile/repositories/profile_repo.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

ProfileRepo _repo = ProfileRepo();
AuthRepo _authRepo = AuthRepo();

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  ProfileBloc() : super(ProfileInitial()) {
    on<ProfileEvn>(_onGetProfile);
  }

  Future<void> _onGetProfile(
      ProfileEvn event, Emitter<ProfileState> emit) async {
    try {
      await _getProfile(emit);
    } catch (e) {
      print('Error Response : ${e.toString()}');
      emit(ProfileFailed(errorCode: -1, errorMessage: e.toString()));
    }
  }

  Future<void> _getProfile(Emitter<ProfileState> emit) async {
    emit(ProfileLoading());
    Map<String, dynamic> dataStorage = await Utils.getDataStorage();
    String accessToken = dataStorage['accessToken'];
    String refreshToken = dataStorage['refreshToken'];

    ApiResponse dataResponse = await _repo.getProfile(accessToken);
    var statusCode = dataResponse.statusCode;
    var message = dataResponse.message;

    if (statusCode != 1) {
      if (statusCode == 401) {
        await _doRefreshToken(emit, accessToken, refreshToken);
        return;
      }
      emit(ProfileFailed(errorCode: statusCode, errorMessage: message));
    } else {
      emit(ProfileSuccess(
          statusCode: statusCode, message: message, data: dataResponse.data));
    }
  }

  Future<void> _doRefreshToken(Emitter<ProfileState> emit, String accessToken,
      String refreshToken) async {
    ApiResponse dataResponse = await _authRepo.doRefreshToken(
        accessToken: accessToken, refreshToken: refreshToken);

    if (dataResponse.statusCode == 1) {
      await Utils.setNewAccessToken(dataResponse.data['token']);
      await _getProfile(emit);
    } else {
      emit(ProfileFailed(
          errorCode: 104, errorMessage: 'Refresh token unauthorized'));
    }
  }
}
