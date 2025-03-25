import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  final String accessToken = 'accessToken';
  final String refreshToken = 'refreshToken';

  AndroidOptions getAndroidOptions() => const AndroidOptions(
        encryptedSharedPreferences: true,
      );

  FlutterSecureStorage storage = const FlutterSecureStorage();

  Future<void> setStorage(String key, String value) async {
    await storage.write(key: key, value: value, aOptions: getAndroidOptions());
  }

  Future<String?> getStorage(String key) async {
    return await storage.read(key: key, aOptions: getAndroidOptions());
  }

  Future<void> clearStorage() async {
    await storage.deleteAll();
  }

  Future<void> removeStorage(String key) async {
    await storage.delete(key: key);
  }
}
