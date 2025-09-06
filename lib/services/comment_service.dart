import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class CommentService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "$url",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<bool> addComment({required int bookId, required String text}) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token not found");

      final response = await dio.post(
        "/comments/",
        data: {"book_id": bookId, "text": text},
        options: Options(
          headers: {"Authorization": "Bearer $token", "accept": "application/json"},
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error adding comment: $e");
      return false;
    }
  }

  Future<List<dynamic>> getBookComments({required int bookId, int skip = 0, int limit = 10}) async {
    try {
      final response = await dio.get(
        "/comments/book/$bookId",
        queryParameters: {"skip": skip, "limit": limit},
        options: Options(headers: {"accept": "application/json"}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch comments");
      }
    } catch (e) {
      print("❌ Error fetching comments: $e");
      return [];
    }
  }
}



/*import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../main.dart';

class CommentService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "$url",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  Future<bool> addComment({required int bookId, required String text}) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token not found");

      final response = await dio.post(
        "/comments/",
        data: {"book_id": bookId, "text": text},
        options: Options(
          headers: {"Authorization": "Bearer $token", "accept": "application/json"},
        ),
      );

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error adding comment: $e");
      return false;
    }
  }

  Future<List<dynamic>> getBookComments({required int bookId, int skip = 0, int limit = 10}) async {
    try {
      final response = await dio.get(
        "/comments/book/$bookId",
        queryParameters: {"skip": skip, "limit": limit},
        options: Options(headers: {"accept": "application/json"}),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("Failed to fetch comments");
      }
    } catch (e) {
      print("❌ Error fetching comments: $e");
      return [];
    }
  }
}
*/