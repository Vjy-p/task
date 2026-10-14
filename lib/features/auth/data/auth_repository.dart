import 'dart:developer';

import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/profile/models/user_model.dart';
import 'package:dio/dio.dart';

import '../../../core/network/api_client.dart';

class AuthRepository {
  AuthRepository({Dio? api}) : _api = api ?? ApiClient().dio;
  final Dio _api;

  Future requestOtp({required String mobile}) async {
    try {
      final res = await _api.post(
        "/auth/otp/request",
        data: {"mobile": mobile},
      );
      return res.data;
    } on DioException catch (e) {
      final msg = e.error;
    }
  }

  Future<UserModel?> signupAndVerifyOtp({
    required String name,
    required String mobile,
    String? email,
    required String selectedRole,
    required String otp,
  }) async {
    try {
      final response = await _api.post<Map<String, dynamic>>(
        '/auth/register/verify-otp',
        data: {
          'name': name,
          'mobile': mobile,
          'email': email,
          'selectedRole': selectedRole,
          'otp': otp,
        },
      );
      if (response.data != null) {
        return UserModel.fromMap(response.data!);
      } else {
        return null;
      }
    } on DioException catch (e) {
      final msg = e.error;
      log("Error  $msg");
      return null;
    }
  }

  Future<UserModel?> loginWithOtp({
    required String mobile,
    required String otp,
  }) async {
    try {
      // final response = await _api.post<Map<String, dynamic>>(
      //   '/auth/login/verify-otp',
      //   data: {'mobile': mobile, 'otp': otp},
      // );
      // if (response.data != null) {
      //   return UserModel.fromMap(response.data!);
      // } else {
      //   return null;
      // }
      return CommonServices().getUserDetails();
    } on DioException catch (e) {
      final msg = e.error;
      log("Error  $msg");
      return null;
    }
  }
}
