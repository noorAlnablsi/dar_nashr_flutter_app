// import 'dart:io';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:dar_nashr/main.dart';

// class BookUploadService {
//   static final Dio dio = Dio(
//     BaseOptions(baseUrl: "$url"),
//   );

//   static Future<String?> _getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString("access_token");
//   }

//   static Future<bool> uploadBook({
//     required String title,
//     required String description,
//     required bool isFree,
//     required double price,
//     required List<int> categoryIds,
//     required File bookFile,
//     File? coverImage,
//   }) async {
//     try {
//       final token = await _getToken();
//       if (token == null) throw Exception("Token not found");

//       final formData = FormData.fromMap({
//         "title": title,
//         "description": description,
//         "is_free": isFree,
//         "price": price,
//         "category_ids": categoryIds.join(","),
//         "book_file": await MultipartFile.fromFile(bookFile.path, filename: bookFile.path.split('/').last, contentType: DioMediaType("application", "pdf")),
//         if (coverImage != null)
//           "cover_image": await MultipartFile.fromFile(coverImage.path, filename: coverImage.path.split('/').last),
//       });

//       final response = await dio.post(
//         "/books/with-file",
//         data: formData,
//         options: Options(
//           headers: {"Authorization": "Bearer $token"},
//         ),
//       );

//       return response.statusCode == 200;
//     } catch (e) {
//       print("❌ Error uploading book: $e");
//       return false;
//     }
//   }
// }


import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dar_nashr/main.dart';
import 'package:http_parser/http_parser.dart';

class BookUploadService {
  static final Dio dio = Dio(
    BaseOptions(baseUrl: "$url"),
  );

  // الحصول على التوكن من SharedPreferences
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("access_token");
  }

  // رفع الكتاب
  static Future<bool> uploadBook({
    required String title,
    required String description,
    required bool isFree,
    double? price, // السعر اختياري إذا الكتاب مجاني
    required List<int> categoryIds,
    required File bookFile,
    File? coverImage,
  }) async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception("Token not found");

      final formData = FormData.fromMap({
        "title": title,
        "description": description,
        "is_free": isFree,
        if (!isFree && price != null) "price": price,
        "category_ids": categoryIds, // ترسل كمصفوفة أرقام
        "book_file": await MultipartFile.fromFile(
          bookFile.path,
          filename: bookFile.path.split('/').last,
          contentType: MediaType("application", "pdf"),
        ),
        if (coverImage != null)
          "cover_image": await MultipartFile.fromFile(
            coverImage.path,
            filename: coverImage.path.split('/').last,
            contentType: MediaType("image", "jpeg"),
          ),
      });

      final response = await dio.post(
        "/books/with-file",
        data: formData,
        options: Options(
          headers: {"Authorization": "Bearer $token"},
        ),
      );

      if (response.statusCode == 200) {
        print("✅ Book uploaded successfully: ${response.data}");
      } else {
        print("❌ Failed to upload book: ${response.statusCode}");
      }

      return response.statusCode == 200;
    } catch (e) {
      print("❌ Error uploading book: $e");
      return false;
    }
  }
}
