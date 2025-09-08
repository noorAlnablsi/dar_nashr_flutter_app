import 'package:dar_nashr/main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInterestService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "$url",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // الحصول على التوكن
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  // جلب كل الفئات المتاحة
  Future<List<dynamic>> getAllCategories() async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        "/users/interests",
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
        throw Exception("فشل في جلب الفئات");
      }
    } catch (e) {
      print("خطأ في getAllCategories: $e");
      return [];
    }
  }

  // جلب اهتمامات المستخدم
  Future<List<int>> getUserInterests() async {
    try {
      final token = await _getToken();
      final response = await dio.get(
        "/users/me/interests",
        options: Options(
          headers: {
            "accept": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        // بافتراض أن response.data = [1,2,3] أو مصفوفة أوبجكت مع id
        return List<int>.from(response.data.map((e) => e['id']));
      } else {
        throw Exception("فشل في جلب اهتمامات المستخدم");
      }
    } catch (e) {
      print("خطأ في getUserInterests: $e");
      return [];
    }
  }

  // حفظ اهتمامات المستخدم
  Future<bool> saveUserInterests(List<int> categoryIds) async {
    try {
      final token = await _getToken();
      final response = await dio.post(
        "/users/me/interests",
        data: {"category_ids": categoryIds},
        options: Options(
          headers: {
            "accept": "application/json",
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        ),
      );
      if (response.statusCode == 200) {
        return true;
      } else {
        print("فشل حفظ الاهتمامات: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("خطأ في saveUserInterests: $e");
      return false;
    }
  }
}
