import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageService {
  static const _storage = FlutterSecureStorage();

  /// Save login credentials securely
  static Future<void> saveCredentials({
    required bool isTeacher,
    String? accountId,
    String? email,
    required String password,
  }) async {
    await _storage.write(key: 'isTeacher', value: isTeacher.toString());
    await _storage.write(key: 'accountId', value: accountId);
    await _storage.write(key: 'email', value: email);
    await _storage.write(key: 'password', value: password);
  }

  /// Get saved credentials (or null if none)
  static Future<Map<String, String?>?> getCredentials() async {
    final isTeacher = await _storage.read(key: 'isTeacher');
    final accountId = await _storage.read(key: 'accountId');
    final email = await _storage.read(key: 'email');
    final password = await _storage.read(key: 'password');

    if (password == null) return null;

    return {
      'isTeacher': isTeacher,
      'accountId': accountId,
      'email': email,
      'password': password,
    };
  }

  static Future<void> logout() async {
    await _storage.deleteAll();
  }
}
