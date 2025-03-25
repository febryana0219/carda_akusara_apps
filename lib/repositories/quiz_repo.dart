import 'dart:convert';

import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/services/api_header.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:app_mobile/services/api_service.dart';
import 'package:app_mobile/services/database.dart';
import 'package:sqflite/sqflite.dart';

class QuizRepo {
  final _apiService = ApiService();

  Future<ApiResponse> findQuizById(
      {String? accessToken, Map<String, dynamic>? request}) async {
    print('request : $request');

    final response = await _apiService.get(
        path: "/api/quiz",
        headers: ApiHeader.getHeader(accessToken: accessToken),
        queryParams: request);

    if (response.statusCode == 200) {
      if (await Utils.isDoctype(response.data.toString())) {
        return ApiResponse(statusCode: 105, message: 'Server Error');
      }
      // Map<String, dynamic> data = json.decode(response.body);
      var data = response.data;
      print('Data : ${data['status_code']}');
      return ApiResponse(
          statusCode: data['status_code'],
          message: data['message'],
          data: data['data']);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }

  Future<ApiResponse> sendQuiz(
      {String? accessToken, Map<String, dynamic>? payload}) async {
    print('Payload : $payload');

    final response = await _apiService.post(
        path: "/api/score",
        headers: ApiHeader.getHeader(accessToken: accessToken),
        body: payload);

    if (response.statusCode == 200) {
      if (await Utils.isDoctype(response.data.toString())) {
        return ApiResponse(statusCode: 105, message: 'Server Error');
      }
      // Map<String, dynamic> data = json.decode(response.body);
      var data = response.data;
      print('Data : ${data['status_code']}');
      return ApiResponse(
          statusCode: data['status_code'],
          message: data['message'],
          data: data['data']);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }

  Future<Map<String, Object?>> insertQuiz(Map<String, Object?> materi) async {
    final db = await DatabaseCarda.getDB();
    final id = await db.insert(DatabaseCarda.tableQuiz, materi,
        conflictAlgorithm: ConflictAlgorithm.replace);
    materi['id'] = id;
    return materi;
  }

  Future<Map<String, Object?>> findQuizByIdFromLocal(
      int materiId, int seqno) async {
    final db = await DatabaseCarda.getDB();

    final maps = await db.query(
      DatabaseCarda.tableQuiz,
      columns: [
        'id',
        'seqno',
        'materi_id',
        'pertanyaan',
        'opsi_a',
        'opsi_b',
        'opsi_c',
        'jawaban',
        'score',
        'live'
      ],
      where: 'materi_id = ? AND seqno = ?',
      whereArgs: [materiId, seqno],
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return {};
    }
  }

  Future<int> updateQuizById(Map<String, Object?> materi) async {
    final db = await DatabaseCarda.getDB();

    return db.update(
      DatabaseCarda.tableQuiz,
      materi,
      where: 'id = ?',
      whereArgs: [materi['id']],
    );
  }

  Future<int> deleteQuizByMateriId(int materiId) async {
    final db = await DatabaseCarda.getDB();
    return await db.delete(
      DatabaseCarda.tableQuiz,
      where: 'materi_id = ?',
      whereArgs: [materiId],
    );
  }
}
