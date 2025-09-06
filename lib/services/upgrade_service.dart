import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class UpgradeService {
  final Dio _dio = Dio();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<Map<String, dynamic>?> upgradeToWriter() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token not found");

      final response = await _dio.post(
        '$url/upgrade-to-writer',
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("فشل الترقية: ${response.statusCode}");
      }
    } catch (e) {
      print("خطأ أثناء الترقية: $e");
      return null;
    }
  }
}
