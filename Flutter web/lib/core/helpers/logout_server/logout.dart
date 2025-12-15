
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../features/screens/login/view.dart';
import '../../cons/Colors/app_colors.dart';
import '../../cons/api_helper_resources/api_resources.dart';
import '../../cons/context/navigation_key.dart';

class LogoutServer {
  static AndroidOptions _getAndroidOptions() => const AndroidOptions(
    encryptedSharedPreferences: true,
  );

  static Future<void> logout() async {
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    final token = await storage.read(key: 'tokenKey');
    final context = navigatorKey.currentContext!;

    if (token == null || token.isEmpty) {
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        const SnackBar(
          content: Text('No token found. Please log in first.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (_) => Dialog(
        // backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          width: 420,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                MYColors.gradientColor_3,
                MYColors.gradientColor_2.withValues(alpha: 0.25),
                MYColors.gradientColor_3,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Icon(Icons.logout, color: Colors.red.withValues(alpha: 0.6), size: 60),
              const SizedBox(height: 10),
              const Text(
                "Confirm Logout",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Are you sure you want to logout?",
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.blueGrey,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text("No"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.of(context).pop(); // close confirm dialog
                      await _showLoadingAndHandleLogout(token);

                    },
                    child: const Text("Yes"),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Future<void> _showLoadingAndHandleLogout(String token) async {
    showDialog(
      context: navigatorKey.currentContext!,
      barrierDismissible: false,
      builder: (_) => const Center(
        child: CircularProgressIndicator(color: Colors.blueAccent),
      ),
    );

    final result = await _performLogoutRequest(token);

    if (Navigator.canPop(navigatorKey.currentContext!)) Navigator.of(navigatorKey.currentContext!, rootNavigator: true).pop();

    if (result.containsKey('error')) {
      final err = result['error'];
      debugPrint('Error is => " $err');
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(
            'Error:- Check Your Connection',
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    final response = result['response'] as Response;
    if (response.statusCode == 200) {
      final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
      await storage.delete(key: 'tokenKey');

      final message = (response.data is Map && response.data['message'] != null)
          ? response.data['message'].toString()
          : 'Logout successful';


      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.check_circle, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
          backgroundColor: Colors.green.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          duration: const Duration(seconds: 3),
          elevation: 6,
        ),



      );

      await Future.delayed(const Duration(milliseconds: 600));

      Navigator.pushAndRemoveUntil(
        navigatorKey.currentContext!,
        MaterialPageRoute(builder: (_) => LoginScreen()),
            (route) => false,
      );
    } else {
      final statusMsg = response.statusMessage ?? 'Logout failed';
      String serverMsg = '';
      try {
        if (response.data is Map && response.data['message'] != null) {
          serverMsg = response.data['message'].toString();
        }
      } catch (_) {}
      ScaffoldMessenger.of(navigatorKey.currentContext!).showSnackBar(
        SnackBar(
          content: Text(serverMsg.isNotEmpty ? serverMsg : statusMsg),
          backgroundColor: Colors.red,
        ),
      );
    }
  }



  static Future<Map<String, dynamic>> _performLogoutRequest(String token) async {
    try {
      final dio = Dio(BaseOptions(
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ));

      String endpoint = "${ApiResources.apiUrl}${ApiResources.logoutEndPoint}";

      final response = await dio.post(
        endpoint,
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );

      return {'response': response};
    } on DioException catch (e) {
      String err = 'Network error';
      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;
        if (data is Map && data['message'] != null) {
          err = data['message'].toString();
        } else if (e.response?.statusMessage != null) {
          err = e.response!.statusMessage!;
        }
      } else if (e.message != null && e.message!.isNotEmpty) {
        err = e.message!;
      }
      return {'error': err};
    } catch (e) {
      return {'error': e.toString()};
    }
  }



  static Future<void> clearAll() async {
    final storage = FlutterSecureStorage(aOptions: _getAndroidOptions());
    await storage.deleteAll();
  }
}



