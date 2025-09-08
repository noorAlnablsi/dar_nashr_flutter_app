import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/writer_model.dart';

class WriterService {
  final Dio _dio = Dio();

  Future<List<Writer>> getWriters({int skip = 0, int limit = 20}) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");

    final response = await _dio.get(
      "https://project2copyrepo-21.onrender.com/users/writers",
      queryParameters: {
        "skip": skip,
        "limit": limit,
        "featured_only": false,
      },
      options: Options(
        headers: {
          "Authorization": "Bearer $token",
          "accept": "application/json",
        },
      ),
    );

    final data = response.data as List;
    return data.map((e) => Writer.fromJson(e)).toList();
  }
}
