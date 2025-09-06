import 'package:dar_nashr/main.dart';
import 'package:dio/dio.dart';

class RegisterService {
  static final Dio dio = Dio();

  static Future<bool> register({
    required String username,
    required String phone,
    required String email,
    required String password,
    required String role,
  }) async {
     String url1 = '$url/register';

    final data = {
      "username": username,
      "phone_number": phone,
      "email": email,
      "password": password,
      "role": role,
    };

    try {
      final response = await dio.post(
        url1,
        data: data,
        options: Options(
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        print("تم التسجيل بنجاح: ${response.data}");
        return true;
        
      } else {
        print("فشل التسجيل: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("خطأ أثناء التسجيل: $e");
      return false;
    }
  }
}
