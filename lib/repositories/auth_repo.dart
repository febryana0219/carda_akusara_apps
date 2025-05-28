import 'dart:convert';

import 'package:app_mobile/services/api_header.dart';
import 'package:app_mobile/services/api_response.dart';
import 'package:app_mobile/services/api_service.dart';

class AuthRepo {
  final _apiService = ApiService();

  Future<ApiResponse> doLogin(
      {String? accessToken, Map<String, dynamic>? payload}) async {
    final response = await _apiService.post(
        path: '/api/auth/login', headers: ApiHeader.getHeader(), body: payload);

    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      var data = response.data;
      return ApiResponse(
          statusCode: data['status_code'], message: 'Do Login', data: data);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }

  Future<ApiResponse> doLogout({String? accessToken}) async {
    final response = await _apiService.post(
        path: '/api/auth/logout',
        headers: ApiHeader.getHeader(accessToken: accessToken));

    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      var data = response.data;
      return ApiResponse(
          statusCode: data['status_code'],
          message: data['message'],
          data: data);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }

  Future<ApiResponse> doRegistration(
      {String? accessToken, Map<String, dynamic>? payload}) async {
    final response = await _apiService.post(
        path: '/api/auth/register',
        headers: ApiHeader.getHeader(),
        body: payload);

    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      var data = response.data;
      return ApiResponse(
          statusCode: data['status_code'], message: 'Do Login', data: data);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }

  Future<ApiResponse> doRefreshToken(
      {String? accessToken, String? refreshToken}) async {
    final response = await _apiService.post(
        path: '/api/auth/refresh',
        headers: ApiHeader.getHeader(
            accessToken: accessToken, refreshToken: refreshToken));

    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      var data = response.data;
      return ApiResponse(
          statusCode: data['status_code'],
          message: data['message'],
          data: data);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }

  Future<ApiResponse> doRequestCode({Map<String, dynamic>? payload}) async {
    final response = await _apiService.post(
        path: '/api/auth/request-code',
        headers: ApiHeader.getHeader(),
        body: payload);

    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      var data = response.data;
      return ApiResponse(
          statusCode: data['status_code'],
          message: data['message'],
          data: data);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }

  Future<ApiResponse> doResetPassword({Map<String, dynamic>? payload}) async {
    final response = await _apiService.post(
        path: '/api/auth/reset-password',
        headers: ApiHeader.getHeader(),
        body: payload);

    if (response.statusCode == 200) {
      // var data = json.decode(response.body);
      var data = response.data;
      return ApiResponse(
          statusCode: data['status_code'],
          message: data['message'],
          data: data);
    } else {
      return ApiResponse(
          statusCode: response.statusCode, message: response.toString());
    }
  }
}
