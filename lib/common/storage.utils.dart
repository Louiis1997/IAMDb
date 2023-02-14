import 'package:iamdb/exceptions/storage-not-found.exception.dart';
import 'package:iamdb/main.dart';

class StorageUtils {
  static Future<String> getAuthToken() async {
    final token = await storage.read(key: "token");
    if (token == null) {
      throw StorageNotFoundException('No JWT token found');
    }
    return token;
  }
}
