import 'package:dar_nashr/main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookServiceFav {
  final Dio _dio = Dio();

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<bool> toggleFavorite(int bookId) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token not found");

      final response = await _dio.post(
        "$url/books/$bookId/like",
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );

      if (response.statusCode == 200) {
        return true; // نجاح
      }
      return false;
    } catch (e) {
      rethrow;
    }
  }
}
