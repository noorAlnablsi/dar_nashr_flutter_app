// // import 'package:dar_nashr/main.dart';
// // import 'package:dio/dio.dart';

// // class BookService {
// //   final Dio dio = Dio(
// //     BaseOptions(
// //       baseUrl: "$url",
// //       connectTimeout: const Duration(seconds: 15),
// //       receiveTimeout: const Duration(seconds: 15),
// //     ),
// //   );

// //   Future<List<dynamic>> getAllBooks({int skip = 0, int limit = 10}) async {
// //     try {
// //       final response = await dio.get(
// //         "/books/",
// //         queryParameters: {"skip": skip, "limit": limit},
// //         options: Options(
// //           headers: {
// //             "accept": "application/json",
// //           },
// //         ),
// //       );

// //       if (response.statusCode == 200) {
// //         return response.data;
// //       } else {
// //         throw Exception("فشل في جلب الكتب");
// //       }
// //     } catch (e) {
// //       print(" خطأ في getAllBooks: $e");
// //       return [];
// //     }
// //   }
// // }




// import 'package:dar_nashr/main.dart';
// import 'package:dio/dio.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class BookService {
//   final Dio dio = Dio(
//     BaseOptions(
//       baseUrl: "$url",
//       connectTimeout: const Duration(seconds: 15),
//       receiveTimeout: const Duration(seconds: 15),
//     ),
//   );

//   // existing getAllBooks() ... لا نعدل عليها

//   // ✅ جلب الكتب الموصى بها حسب اهتمامات المستخدم
//   Future<List<dynamic>>getRecommendedBooks() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("access_token");
//       if (token == null) throw Exception("Token not found");

//       final response = await dio.get(
//         "/books/recommended",
//         options: Options(
//           headers: {
//             "accept": "application/json",
//             "Authorization": "Bearer $token",
//           },
//         ),
//       );

//       if (response.statusCode == 200) {
//         return response.data;
//       } else {
//         throw Exception("فشل في جلب الكتب الموصى بها");
//       }
//     } catch (e) {
//       print("خطأ في getRecommendedBooks: $e");
//       return [];
//     }
//   }
// }



import 'package:dar_nashr/main.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookService {
  final Dio dio = Dio(
    BaseOptions(
      baseUrl: "$url",
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );

  // الدالة الموجودة مسبقًا
  Future<List<dynamic>> getAllBooks({int skip = 0, int limit = 10}) async {
    try {
      final response = await dio.get(
        "/books/",
        queryParameters: {"skip": skip, "limit": limit},
        options: Options(
          headers: {
            "accept": "application/json",
          },
        ),
      );

      if (response.statusCode == 200) {
        return response.data;
      } else {
        throw Exception("فشل في جلب الكتب");
      }
    } catch (e) {
      print("خطأ في getAllBooks: $e");
      return [];
    }
  }

  // ✅ الدالة الجديدة للحصول على Recommended Books
  Future<List<dynamic>> getRecommendedBooks() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString("access_token");
      if (token == null) throw Exception("Token not found");

      final response = await dio.get(
        "/books/recommended",
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
        throw Exception("فشل في جلب الكتب الموصى بها");
      }
    } catch (e) {
      print("خطأ في getRecommendedBooks: $e");
      return [];
    }
  }
}
