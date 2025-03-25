import 'dart:convert';

import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/services/api_header.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:app_mobile/services/api_service.dart';

class CategoryRepo {
  final _apiService = ApiService();

  Future<ApiResponse> findCategory({String? accessToken}) async {
    // Map<String, dynamic> items = {
    //   "status_code": 1,
    //   "message": "Successfully",
    //   "items": [
    //     {
    //       "no": 1,
    //       "id": 1,
    //       "category_name": "Aksara Ngalagena",
    //       "materi": [
    //         {"id": 1, "title": "ka ga nga", "score": 250, "is_start": true},
    //         {"id": 2, "title": "ca ja nya", "score": 253, "is_start": true},
    //         {"id": 3, "title": "ta da na", "score": 255, "is_start": true},
    //         {"id": 4, "title": "pa ba ma", "score": 0, "is_start": false},
    //         {"id": 5, "title": "ya ra la", "score": 0, "is_start": false},
    //         {"id": 6, "title": "wa sa ha", "score": 0, "is_start": false}
    //       ]
    //     },
    //     {
    //       "no": 2,
    //       "id": 2,
    //       "category_name": "Aksara Swara",
    //       "materi": [
    //         {"id": 7, "title": "a i u", "score": 0, "is_start": false},
    //         {"id": 8, "title": "e o ue è", "score": 0, "is_start": false}
    //       ]
    //     }
    //   ]
    // };
    // return items;

    var response = await _apiService.get(
        path: "/api/categories",
        headers: ApiHeader.getHeader(accessToken: accessToken));

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
}
