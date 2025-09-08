// services/advertisement_service.dart
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dar_nashr/main.dart'; // لحتى نجيب الـ baseUrl

class AdvertisementService {
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

  Future<List<dynamic>> getAdvertisements() async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        "/advertisements/",
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
        throw Exception("فشل في جلب الإعلانات");
      }
    } catch (e) {
      print("خطأ في getAdvertisements: $e");
      return [];
    }
  }
}


