// report_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dar_nashr/main.dart';

class ReportService {
  static final Dio dio = Dio(BaseOptions(baseUrl: url));

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  static Future<bool> sendReport({
    required int bookId,
    required String reason,
    required String description,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token not found");

      final data = {
        "book_id": bookId,
        "reason": reason,
        "description": description,
      };

      final response = await dio.post(
        "/reports/",
        data: data,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        print("✅ Report submitted: ${response.data}");
      } else {
        print("❌ Failed to submit report: ${response.statusCode}");
      }

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error sending report: $e");
      return false;
    }
  }
}
