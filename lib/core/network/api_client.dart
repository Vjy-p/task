import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:assessment/core/common_services.dart';
import 'package:assessment/features/auth/controllers/auth_controller.dart';
import 'package:assessment/utils/constants.dart';
import 'package:assessment/utils/custom_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;

  late final Dio dio;

  ApiClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: Constants.baseUrl,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        contentType: Headers.jsonContentType,
      ),
    );

    dio.interceptors.addAll([
      ApiInterceptor(),
      ExpiredTokenRetryInterceptor(dio),
    ]);
  }
}

class ApiInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      final token = await CommonServices().getToken();
      log("token $token");

      if (token.isNotEmpty) {
        options.headers['accept'] = 'application/json';
        options.headers['Authorization'] = 'Bearer $token';
      } else {
        options.headers.remove('Authorization');
      }
    } catch (e, stackTrace) {
      debugPrint("\napi Error $e $stackTrace");
    }
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log(
      "Status code ${response.statusCode}\n"
      "${response.requestOptions.uri}\n"
      "${response.requestOptions.method}\n",
    );
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final data = err.response?.data;
    log("Error $status ${err.requestOptions.uri} data: $data");

    String message = 'Unexpected error';

    if (data is Map) {
      final error = data['error'];
      final msg = data['message'];

      if (status != 401) {
        if (error != null && error.toString().isNotEmpty) {
          customToast(text: error.toString());
        } else if (msg != null && msg.toString().isNotEmpty) {
          customToast(text: msg.toString());
        }
      }
      message = (error ?? msg ?? 'Unexpected error').toString();
    } else if (err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout ||
        err.type == DioExceptionType.sendTimeout) {
      message = 'Request timed out';
    } else if (err.type == DioExceptionType.connectionError) {
      message = 'No internet connection';
    }

    // Callers can read the message via `e.error` (or e.message).
    handler.next(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        type: err.type,
        error: message,
        stackTrace: err.stackTrace,
        message: message,
      ),
    );
  }
}

class ExpiredTokenRetryInterceptor extends Interceptor {
  ExpiredTokenRetryInterceptor(this._dio);

  final Dio _dio;

  static const int maxRetryAttempts = 3;
  static const String _retryCountKey = 'retry_count';
  static const String _refreshedKey = 'token_refreshed';

  Future<bool>? _refreshing;

  final Dio _refreshDio = Dio(
    BaseOptions(
      baseUrl: Constants.baseUrl,
      headers: {'Content-Type': 'application/json'},
    ),
  );

  Duration _backoff(int attempt) =>
      Duration(milliseconds: 500 * math.pow(2, attempt).toInt());

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final status = err.response?.statusCode;
    final options = err.requestOptions;

    // ---------- 401: refresh token & retry once ----------
    if (status == 401 && options.extra[_refreshedKey] != true) {
      final refreshed = await (_refreshing ??= _refreshToken().whenComplete(
        () => _refreshing = null,
      ));

      if (refreshed) {
        options.extra[_refreshedKey] = true;
        try {
          // onRequest runs again, so the NEW token is picked up from storage.
          final response = await _dio.fetch(options);
          return handler.resolve(response);
        } on DioException catch (e) {
          // Nested call already ran the full chain (toast etc.),
          // so don't call following error interceptors again.
          return handler.reject(e);
        }
      }
      return handler.next(err);
    }

    // ---------- 429: wait & retry ----------
    if (status == 429) {
      final attempt = (options.extra[_retryCountKey] as int? ?? 0) + 1;
      if (attempt > maxRetryAttempts) return handler.next(err);

      options.extra[_retryCountKey] = attempt;

      final retryAfter = int.tryParse(
        err.response?.headers.value('retry-after') ?? '',
      );
      final wait = retryAfter != null
          ? Duration(seconds: retryAfter)
          : _backoff(attempt);

      log(
        "429 Too Many Requests. Waiting ${wait.inSeconds}s (attempt $attempt)",
      );
      await Future.delayed(wait);

      try {
        final response = await _dio.fetch(options);
        return handler.resolve(response);
      } on DioException catch (e) {
        return handler.reject(e);
      }
    }

    handler.next(err);
  }

  Future<bool> _refreshToken() async {
    try {
      final refreshToken = await CommonServices().getRefreshToken();
      if (refreshToken.isEmpty) {
        _logout();
        return false;
      }

      final res = await _refreshDio.post(
        '/user/refresh-token',
        data: {'refreshToken': refreshToken},
      );

      if (res.statusCode == 200) {
        await CommonServices().setToken(
          token: res.data["accessToken"],
          refreshToken: res.data["refreshToken"],
        );
        return true;
      }

      _logout();
      return false;
    } catch (e, stack) {
      log("Error refreshing token: $e\n$stack");
      _logout();
      return false;
    }
  }

  void _logout() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        if (!getx.Get.isRegistered<AuthController>()) {
          getx.Get.lazyPut(() => AuthController(), fenix: true);
        }
        await getx.Get.find<AuthController>().signout();
      } catch (_) {
        await getx.Get.put(AuthController()).signout();
      }
    });
  }
}
