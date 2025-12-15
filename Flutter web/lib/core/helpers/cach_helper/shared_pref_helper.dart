import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/features/screens/login/user_model/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/screens/login/view.dart';
import '../../cons/api_helper_resources/api_resources.dart';
import '../../cons/context/navigation_key.dart';
import 'package:dio/dio.dart';

class PrefHelper {


  static Future<int?> getId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt("id");
  }

  static Future<String?> getAcademicLevel() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("academicLevel");
  }

  static Future<String?> getCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("city");
  }

  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("email");
  }


  static Future<String?> getFulName () async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("fullName");
  }

  static Future<String?> getGender() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("gender");
  }



  static Future<String?> getRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  static Future<String?> getMessage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("message");
  }

  static Future<String?> getImageProfile() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("profileImageUrl");
  }

  // static Future<bool> isLoggedIn() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.containsKey("tokenKey");
  // }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('tokenKey');

    if (token == null) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('No token found. Please log in first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    AwesomeDialog(
      context: navigatorKey.currentContext!,
      dialogType: DialogType.warning,
      animType: AnimType.bottomSlide,
      title: "Confirm Logout",
      desc: "Are you sure you want to logout?",
      btnCancelText: "No",
      btnOkText: "Yes",
      btnCancelOnPress: () {},
      btnOkOnPress: () async {
        try {
          final dio = Dio();
          final response = await dio.post(
            ApiResources.logoutEndPoint,
            options: Options(headers: {'Authorization': 'Bearer $token'}),
          );

          if (response.statusCode == 200) {
            await prefs.remove('tokenKey');

            ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              SnackBar(
                content: Text(
                  '${response.data["message"] ?? "Logout successful"}',
                ),
                backgroundColor: Colors.green,
              ),
            );

            Navigator.pushAndRemoveUntil(
              navigatorKey.currentContext!,
              MaterialPageRoute(builder: (context) => LoginScreen()),
              (route) => false,
            );
          } else {
            ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
              SnackBar(
                content: Text('Logout failed: ${response.statusMessage}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } on DioException catch (e) {
          String errorMessage =
              e.response?.data["message"] ??
              e.message ??
              "An error occurred while logging out.";

          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text('Error:- $errorMessage'),
              backgroundColor: Colors.red,
            ),
          );
        } catch (e) {
          ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
            SnackBar(
              content: Text('Unexpected error: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
    ).show();
  }





  static Future<void> saveLoginData(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    // await prefs.setString("tokenKey", user.token!);
    await prefs.setInt("id", user.user!.id!);
    await prefs.setString("academicLevel", user.user!.academicLevel!);
    await prefs.setString("city", user.user!.city!);
    await prefs.setString("email", user.user!.email!);
 await prefs.setString("fullName", user.user!.fullName!.split(" ")[0]);
    await prefs.setString("gender", user.user!.gender!);
    await prefs.setString("profileImageUrl", user.user!.profileImageUrl!);
    await prefs.setString("role", user.user!.role!);
    await prefs.setString("message", user.message!);
  }

  // static Future<void> saveTokenSecure(UserModel user) async {
  //   AndroidOptions _getAndroidOptions() => const AndroidOptions(
  //     encryptedSharedPreferences: true,
  //   );
  //   final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  //   await storage.write(key: "tokenKey", value: user.token!);
  //
  // }

}



class TokenStorageHelper {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static Future<void> saveTokenSecure(UserModel user) async {
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.write(key: "tokenKey", value: user.token!);
  }

  // static Future<String?> getTokenSecure() async {
  //   final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  //   String? token = await storage.read(key: "tokenKey");
  //   return token;
  // }
  //
  // static Future<void> deleteTokenSecure() async {
  //   final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  //   await storage.delete(key: "tokenKey");
  // }

  // static Future<bool> isLoggedIn() async {
  //   final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
  //   String? token = await storage.read(key: "tokenKey");
  //   return token != null && token.isNotEmpty;
  // }
}


