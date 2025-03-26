import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/repositories/quiz_repo.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'quiz_event.dart';
part 'quiz_state.dart';

QuizRepo _repo = QuizRepo();

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  QuizBloc() : super(QuizInitial()) {
    on<QuizEvn>(_onGetQuiz);
  }

  String? _accessToken;
  String? _refreshToken;
  String? _userId;

  Future<void> _onGetQuiz(QuizEvn event, Emitter<QuizState> emit) async {
    try {
      emit(QuizLoading());

      Map<String, dynamic> dataStorage = await Utils.getDataStorage();
      _accessToken = dataStorage['accessToken'];
      _refreshToken = dataStorage['refreshToken'];
      _userId = dataStorage['userId'];

      Map<String, dynamic> dataResponse = {};
      if (EventType.direct == event.eventType) {
        int deleted = await _repo.deleteQuizByMateriId(event.materiId!);
        print(
            "delete from materi_id ${event.materiId} event direct : $deleted");

        Map<String, dynamic> request = //{};
            {
          "materi_id": event.materiId.toString(),
        };

        ApiResponse result = await _repo.findQuizById(
            accessToken: _accessToken, request: request);

        List<dynamic> data = result.data;

        if (data.isEmpty) {
          emit(QuizSuccess(
              statusCode: 0,
              message: 'Not Found',
              eventType: EventType.quiz,
              data: {}));
          return;
        }

        int i = 1;
        for (Map<String, Object?> data in data) {
          data['seqno'] = i++;
          _repo.insertQuiz(data);
        }
        print('Data Insert quiz id ${event.materiId} total insert : ${i - 1}');
      }

      dataResponse =
          await _repo.findQuizByIdFromLocal(event.materiId!, event.questionId!);

      if (EventType.back == event.eventType) {
        int deleted = await _repo.deleteQuizByMateriId(event.materiId!);
        print("delete from materi_id ${event.materiId} event back : $deleted");
        emit(QuizSuccess(
            statusCode: 103,
            message: 'Back page.',
            eventType: EventType.quiz,
            data: dataResponse));
        return;
      }

      int statusCode = 102;
      String message = "Quiz Finish";
      if (dataResponse.isNotEmpty) {
        if (EventType.send == event.eventType) {
          // di sini kode repo post materi ketika nyawa telah habis
          ApiResponse sendQuiz =
              await _sendQuiz(event, _accessToken!, _refreshToken!, _userId!);

          print(
              'Not Empty -> Send Quiz statusCode : ${sendQuiz.statusCode} message : ${sendQuiz.message}');
          if (sendQuiz.statusCode == 1 || sendQuiz.statusCode == 0) {
            statusCode = 101;
          }
        } else {
          statusCode = 1;
          message = "Success";
        }
      } else {
        dataResponse = await _repo.findQuizByIdFromLocal(
            event.materiId!, event.questionId! - 1);
        // di sini kode repo post materi ketika semua pertanyaan terjawab
        ApiResponse sendQuiz =
            await _sendQuiz(event, _accessToken!, _refreshToken!, _userId!);
        if (sendQuiz.statusCode == 1) {
          print('Empty -> Send Quiz message : ${sendQuiz.message}');
        }
      }

      emit(QuizSuccess(
          statusCode: statusCode,
          message: message,
          eventType: EventType.quiz,
          data: dataResponse));
    } catch (e) {
      emit(QuizFailed(
          errorCode: -1, errorMessage: await Utils.exceptionMessage(e)));
    }
  }

  Future<ApiResponse> _sendQuiz(QuizEvn event, String accessToken,
      String refreshToken, String userId) async {
    Map<String, dynamic> payload = {
      "materi_id": event.materiId,
      "user_id": userId,
      "score": event.score
    };

    ApiResponse result =
        await _repo.sendQuiz(accessToken: _accessToken, payload: payload);

    return result;
  }
}
