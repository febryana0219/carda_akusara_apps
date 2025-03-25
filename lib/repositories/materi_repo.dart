import 'dart:convert';

import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/services/api_header.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:app_mobile/services/api_service.dart';
import 'package:app_mobile/services/database.dart';
import 'package:sqflite/sqflite.dart';

class MateriRepo {
  final _apiService = ApiService();

  Future<ApiResponse> findMateriById(
      {String? accessToken, Map<String, dynamic>? request}) async {
    print('request : $request');

    final response = await _apiService.get(
        path: "/api/materi",
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
          totalScore: data['total_score'],
          data: data['data']);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }

  Future<Map<String, Object?>> insertMateri(Map<String, Object?> materi) async {
    print('Data Insert Materi : $materi');
    final db = await DatabaseCarda.getDB();
    final id = await db.insert(DatabaseCarda.tableMateri, materi,
        conflictAlgorithm: ConflictAlgorithm.replace);
    materi['id'] = id;
    return materi;
  }

  Future<Map<String, Object?>> findMateriByIdFromLocal(
      int materiId, int seqno) async {
    final db = await DatabaseCarda.getDB();

    final maps = await db.query(
      DatabaseCarda.tableMateri,
      columns: [
        'id',
        'seqno',
        'materi_id',
        'title',
        'aksun',
        'suara',
        'is_completed',
        'total_score'
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

  Future<Map<String, Object?>> findMateriByMateriIdAndIsNotCompletedFromLocal(
      int materiId) async {
    final db = await DatabaseCarda.getDB();

    final maps = await db.query(
      DatabaseCarda.tableMateri,
      columns: [
        'id',
        'seqno',
        'materi_id',
        'title',
        'aksun',
        'suara',
        'is_completed',
        'total_score'
      ],
      where: 'materi_id = ? AND is_completed = false',
      whereArgs: [materiId],
      orderBy: 'seqno ASC',
      limit: 1,
    );

    if (maps.isNotEmpty) {
      return maps.first;
    } else {
      return {};
    }
  }

  Future<int> updateMateriByIdAndSeqno(
      int materiId, int seqno, bool isCompleted) async {
    final db = await DatabaseCarda.getDB();

    int isCompletedInt = isCompleted ? 1 : 0;

    return db.update(
      DatabaseCarda.tableMateri,
      {'is_completed': isCompletedInt},
      where: 'materi_id = ? AND seqno = ?',
      whereArgs: [materiId, seqno],
    );
  }

  Future<int> deleteMateriByMateriId(int materiId) async {
    final db = await DatabaseCarda.getDB();
    return await db.delete(
      DatabaseCarda.tableMateri,
      where: 'materi_id = ?',
      whereArgs: [materiId],
    );
  }
}
