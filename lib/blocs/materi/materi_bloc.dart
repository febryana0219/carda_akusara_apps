import 'package:app_mobile/core/event_type.dart';
import 'package:app_mobile/core/message.dart';
import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/repositories/materi_repo.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'materi_event.dart';
part 'materi_state.dart';

MateriRepo _materiRepo = MateriRepo();

class MateriBloc extends Bloc<MateriEvent, MateriState> {
  MateriBloc() : super(MateriInitial()) {
    on<MateriEvn>(_onGetMateri);
  }

  int materiNo = 0;

  Future<void> _onGetMateri(MateriEvn event, Emitter<MateriState> emit) async {
    try {
      emit(MateriLoading());

      Map<String, dynamic> dataStorage = await Utils.getDataStorage();
      String accessToken = dataStorage['accessToken'];
      String refreshToken = dataStorage['refreshToken'];

      if (EventType.next == event.eventType) {
        // print('materi no : $materiNo');
        int updated = await _materiRepo.updateMateriByIdAndSeqno(
            event.materiId!, event.materiNo!, true);

        print(
            "1. update materi from materi_id ${event.materiId} event direct : $updated");
        materiNo = event.materiNo! + 1;
        print('Next - Materi No : $materiNo');
      } else if (EventType.prev == event.eventType) {
        if (event.materiNo! > 1) {
          materiNo = event.materiNo! - 1;
          // print('materi no : $materiNo');
          int updated = await _materiRepo.updateMateriByIdAndSeqno(
              event.materiId!, materiNo, false);
          print(
              "2. update materi from materi_id ${event.materiId} event direct : $updated");
        } else {
          materiNo = event.materiNo!;
        }
      } else {
        materiNo = event.materiNo!;
      }

      Map<String, dynamic> dataResponse = {};
      if (EventType.direct == event.eventType) {
        Map<String, dynamic> dataNotCompleted = await _materiRepo
            .findMateriByMateriIdAndIsNotCompletedFromLocal(event.materiId!);
        print('masuk sini dengan data : $dataNotCompleted');
        if (dataNotCompleted.isNotEmpty) {
          emit(MateriSuccess(
              statusCode: 1,
              message: 'Materi data is not completed',
              eventType: EventType.single,
              data: dataNotCompleted));

          return;
        }

        int deleted = await _materiRepo.deleteMateriByMateriId(event.materiId!);
        print(
            "1. delete materi from materi_id ${event.materiId} event direct : $deleted");

        Map<String, dynamic> request = //{};
            {
          "materi_id": event.materiId.toString(),
        };

        ApiResponse result = await _materiRepo.findMateriById(
            accessToken: accessToken, request: request);

        print('Result : $result');
        if (result.statusCode == 1) {
          List<dynamic> dataMateries = result.data;
          if (dataMateries.isEmpty) {
            emit(MateriFailed(errorCode: 0, errorMessage: Message.dataEmpty));
            return;
          }

          int i = 1;
          for (Map<String, Object?> data in dataMateries) {
            data['seqno'] = i++;
            data['total_score'] = result.totalScore.toString();
            _materiRepo.insertMateri(data);
          }
          print(
              'Data Insert materi id ${event.materiId} total insert : ${i - 1}');
        }
      }

      dataResponse =
          await _materiRepo.findMateriByIdFromLocal(event.materiId!, materiNo);

      if (EventType.back == event.eventType) {
        // int deleted = await _materiRepo.deleteMateriByMateriId(event.materiId!);
        // print("delete from materi_id ${event.materiId} event back : $deleted");
        emit(MateriSuccess(
            statusCode: 103,
            message: 'Back page.',
            eventType: EventType.materi,
            data: dataResponse));
        return;
      }

      int statusCode = 102;
      String message = "Materi Finish";
      if (dataResponse.isNotEmpty) {
        // int deleted = await _materiRepo.deleteMateriByMateriId(event.materiId!);
        // print(
        //     "2. delete materi from materi_id ${event.materiId} event back : $deleted");
        statusCode = 1;
        message = "Success";
      } else {
        dataResponse = await _materiRepo.findMateriByIdFromLocal(
            event.materiId!, materiNo - 1);
      }

      emit(MateriSuccess(
          statusCode: statusCode,
          message: message,
          eventType: EventType.single,
          data: dataResponse));
    } catch (e) {
      print('Error Response : ${e.toString()}');
      emit(MateriFailed(errorCode: -1, errorMessage: e.toString()));
    }
  }
}
