import 'package:app_mobile/core/message.dart';
import 'package:app_mobile/core/storage.dart';
import 'package:dio/dio.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class Utils {
  static Future<Map<String, dynamic>> getDataStorage() async {
    Storage storage = Storage();

    var values = await Future.wait([
      storage.getStorage(storage.accessToken),
      storage.getStorage(storage.refreshToken),
    ]);

    String accessToken = values[0]!;
    String refreshToken = values[1]!;

    Map<String, dynamic> decodedToken = JwtDecoder.decode(accessToken);
    String userId = decodedToken['sub'];

    Map<String, dynamic> data = {
      "accessToken": accessToken,
      "refreshToken": refreshToken,
      "userId": userId
    };

    return data;
  }

  static Future<void> setNewAccessToken(String accessToken) async {
    Storage storage = Storage();
    storage.removeStorage(storage.accessToken);
    storage.setStorage(storage.accessToken, accessToken);
  }

  static Future<bool> isDoctype(String html) async {
    // String html = "<!DOCTYPE html><html><head><title>Test</title></head><body>Body content</body></html>";

    RegExp regExp =
        RegExp(r'<!DOCTYPE'); // Mencari kata DOCTYPE dengan tanda seru

    // Mengekstrak DOCTYPE
    var match = regExp.firstMatch(html);

    if (match != null) {
      return true;
    }
    return false;
  }

  static Future<String> exceptionMessage(Object e) async {
    print('Error : ${e.toString()}');
    String message = Message.connectionCheck;
    if (e is DioException) {
      if (e.response != null) {
        if (e.response?.statusCode == 403) {
          print(
              "Forbidden: You do not have permission to access this resource.");
          message = 'Forbidden: ${Message.forbidden}';
        } else {
          print(
              "Error: ${e.response?.statusCode} - ${e.response?.statusMessage}");
          message = e.response!.statusMessage!;
        }
      } else {
        print("Error: ${e.message}");
      }
    }
    return message;
  }
}
