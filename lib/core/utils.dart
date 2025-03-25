import 'package:app_mobile/core/storage.dart';
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
}
