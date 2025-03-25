import 'package:app_mobile/core/utils.dart';
import 'package:app_mobile/services/api_header.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:app_mobile/services/api_service.dart';

class ProfileRepo {
  final _apiService = ApiService();

  Future<ApiResponse> getProfile(String accessToken) async {
    final response = await _apiService.get(
        path: "/api/auth/user",
        headers: ApiHeader.getHeader(accessToken: accessToken));

    if (response.statusCode == 200) {
      if (await Utils.isDoctype(response.data.toString())) {
        return ApiResponse(statusCode: 105, message: 'Server Error');
      }
      // Map<String, dynamic> data = json.decode(response.body);
      var data = response.data;
      return ApiResponse(
          statusCode: data['status_code'],
          message: data['message'],
          data: data['data']);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }
}
