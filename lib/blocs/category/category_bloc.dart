import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/repositories/auth_repo.dart';
import 'package:app_mobile/repositories/category_repo.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'category_event.dart';
part 'category_state.dart';

CategoryRepo repo = CategoryRepo();
AuthRepo authRepo = AuthRepo();

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  CategoryBloc() : super(CategoryInitial()) {
    on<CategoryEvn>(_onGetKategori);
  }

  Future<void> _onGetKategori(
      CategoryEvn event, Emitter<CategoryState> emit) async {
    try {
      await _getCategory(emit);
    } catch (e) {
      print('Error : ${e.toString()}');
      emit(CategoryFailed(errorCode: -1, errorMessage: e.toString()));
    }
  }

  Future<void> _getCategory(Emitter<CategoryState> emit) async {
    emit(CategoryLoading());

    Map<String, dynamic> dataStorage = await Utils.getDataStorage();
    String accessToken = dataStorage['accessToken'];
    String refreshToken = dataStorage['refreshToken'];

    ApiResponse dataResponse =
        await repo.findCategory(accessToken: accessToken);
    var statusCode = dataResponse.statusCode;
    var message = dataResponse.message;

    if (statusCode != 1) {
      if (statusCode == 401) {
        await _doRefreshToken(emit, accessToken, refreshToken);
        return;
      }
      emit(CategoryFailed(errorCode: statusCode, errorMessage: message));
    } else {
      // print('masuk sini');
      var items = dataResponse.data;
      // print('items : $items');
      emit(CategorySuccess(
          statusCode: statusCode,
          message: message,
          totalScore: dataResponse.totalScore,
          items: items));
    }
  }

  Future<void> _doRefreshToken(Emitter<CategoryState> emit, String accessToken,
      String refreshToken) async {
    ApiResponse dataResponse = await authRepo.doRefreshToken(
        accessToken: accessToken, refreshToken: refreshToken);

    if (dataResponse.statusCode == 1) {
      await Utils.setNewAccessToken(dataResponse.data['token']);
      await _getCategory(emit);
    } else {
      emit(CategoryFailed(
          errorCode: 104, errorMessage: 'Refresh token unauthorized'));
    }
  }
}
