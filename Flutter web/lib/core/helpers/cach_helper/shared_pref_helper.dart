import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:lms/features/screens/login/user_model/data.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../features/screens/ActivateAccountScreen/user_model/data.dart';
import '../../../features/screens/Create_user/User_model/model.dart';
import '../../../features/screens/Verify_email/user_model/data.dart';
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
    // await prefs.setString("academicLevel", user.user!.academicLevel!);
    // await prefs.setString("city", user.user!.city!);
    await prefs.setString("email", user.user!.email!);
 await prefs.setString("fullName", user.user!.fullName!.split(" ")[0]);
    // await prefs.setString("gender", user.user!.gender!);
    // await prefs.setString("profileImageUrl", user.user!.profileImageUrl!);
    await prefs.setString("role", user.user!.role!);
    await prefs.setString("message", user.message!);
  }
  static Future<void> saveCreatedUserData(CreateUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("email", user.email);
    await prefs.setString("fullName", user.fullName);
    await prefs.setString("role", user.role);
    await prefs.setString("nationalId", user.nationalId);
    await prefs.setString("dateOfBirth", user.dateOfBirth.toString());
    await prefs.setString("gender", user.gender!);
    await prefs.setString("city", user.city!);
    await prefs.setString("academicLevel", user.academicInfo!.department!.name!);
    await prefs.setString("academicLevel", user.academicInfo!.department!.id!.toString());
    await prefs.setString("academicLevel", user.academicInfo!.year! as String);
    await prefs.setString("academicLevel", user.academicInfo!.admissionYear! as String);
    await prefs.setString("academicLevel", user.academicInfo!.squadron!.name!);

    await prefs.setString("profileImageUrl", user.profileImageUrl!);
    await prefs.setBool("emailConfirmed", user.emailConfirmed);
    await prefs.setString("createdAt", user.createdAt.toString());
    await prefs.setString("updatedAt", user.updatedAt.toString());




  }




  static Future<Map<String, dynamic>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();

    return {
      "email": prefs.getString("email") ?? "",
      "fullName": prefs.getString("fullName") ?? "User",
      "role": prefs.getString("role") ?? "",
      "nationalId": prefs.getString("nationalId") ?? "",
      "dateOfBirth": prefs.getString("dateOfBirth") ?? "",
      "gender": prefs.getString("gender") ?? "",
      "city": prefs.getString("city") ?? "",
      "academicLevel": prefs.getString("academicLevel") ?? "",
      "profileImageUrl": prefs.getString("profileImageUrl") ?? "assets/logo/logo.jpg",
      "isActive": prefs.getBool("isActive") ?? false,
      "emailConfirmed": prefs.getBool("emailConfirmed") ?? false,
      "createdAt": prefs.getString("createdAt") ?? "",
      "updatedAt": prefs.getString("updatedAt") ?? "",
    };
  }

  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("fullName");
  }


  static Future<String?> getUserCreatedRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("role");
  }

  static Future<String?> getUserCreatedProfileImageUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("profileImageUrl");
  }


}



// class TokenStorageHelper {
//   static AndroidOptions _getAndroidOptions() => const AndroidOptions(
//     encryptedSharedPreferences: true,
//   );
//
//   static Future<void> saveTokenSecure(UserModel user) async {
//     final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
//     await storage.write(key: "tokenKey", value: user.token!);
//   }
//
//   static Future<String?> getTokenSecure() async {
//     final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
//     String? token = await storage.read(key: "tokenKey");
//     return token;
//   }
//
// }

class TokenStorageHelper {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static Future<void> saveTokenSecure(String token) async {
    final storage =
    FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.write(key: "tokenKey", value: token);
  }

  static Future<String?> getTokenSecure() async {
    final storage =
    FlutterSecureStorage(aOptions: _getAndroidOptions());
    return await storage.read(key: "tokenKey");
  }

  static Future<void> clearToken() async {
    final storage =
    FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.delete(key: "tokenKey");
  }
}

class UserStorageHelper {
  static Future<void> saveCreatedUserData(CreateUserModel user) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt("id", user.id);
    await prefs.setString("email", user.email);
    await prefs.setString("fullName", user.fullName);
    await prefs.setString("role", user.role);
    await prefs.setString("nationalId", user.nationalId);

    if (user.dateOfBirth != null) {
      await prefs.setString("dateOfBirth", user.dateOfBirth!.toIso8601String());
    }

    if (user.gender != null) {
      await prefs.setString("gender", user.gender!);
    }

    if (user.city != null) {
      await prefs.setString("city", user.city!);
    }

    if (user.academicInfo != null) {
      final info = user.academicInfo!;

      if (info.department != null && info.department!.name != null) {
        await prefs.setString("academicDepartment", info.department!.name!);
      }

      if (info.year != null && info.year!.name != null) {
        await prefs.setString("academicYear", info.year!.name!);
      }

      if (info.squadron != null && info.squadron!.name != null) {
        await prefs.setString("squadron", info.squadron!.name!);
      }

      if (info.admissionYear != null) {
        await prefs.setInt("admissionYear", info.admissionYear!);
      }
    }

    if (user.profileImageUrl != null) {
      await prefs.setString("profileImageUrl", user.profileImageUrl!);
    }

    await prefs.setBool("isActive", user.accountStatus == "Active");
    await prefs.setBool("emailConfirmed", user.emailConfirmed);

    await prefs.setString("createdAt", user.createdAt.toIso8601String());
    await prefs.setString("updatedAt", user.updatedAt.toIso8601String());

    if (user.lastLoginAt != null) {
      await prefs.setString("lastLoginAt", user.lastLoginAt!.toIso8601String());
    }
  }
}

class VerifyStorageHelper {
  static Future<void> saveVerifyData(UserStatusModel status) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool("exists", status.exists);
    await prefs.setBool("isActivated", status.isActivated);
  }

  static Future<UserStatusModel?> getVerifyData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!prefs.containsKey("exists")) return null;

    return UserStatusModel(
      exists: prefs.getBool("exists") ?? false,
      isActivated: prefs.getBool("isActivated") ?? false,
    );
  }

  static Future<void> clearVerifyData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("exists");
    await prefs.remove("isActivated");
  }
}


class ActivateUserPrefs {
  static Future<void> saveActivateUserData(
      ActivateUserModel model) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt('user_id', model.user.id);
    await prefs.setString('email', model.user.email);
    await prefs.setString(
      'fullName',
      model.user.fullName.split(' ').first,
    );
    await prefs.setString('role', model.user.role);

    if (model.user.nationalId != null) {
      await prefs.setString(
          'nationalId', model.user.nationalId!);
    }

    if (model.user.accountStatus != null) {
      await prefs.setString(
          'accountStatus', model.user.accountStatus!);
    }

    if (model.user.profileImageUrl != null) {
      await prefs.setString(
          'profileImageUrl', model.user.profileImageUrl!);
    }

    await prefs.setString('activateMessage', model.message);
    await prefs.setString('expiresIn', model.expiresIn);
  }
}
