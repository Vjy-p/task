import 'package:assessment/core/network/api_client.dart';
import 'package:dio/dio.dart';

class NotificationsServices {
  NotificationsServices({Dio? api}) : _api = api ?? ApiClient().dio;

  final Dio _api;

  Future<Map<String, dynamic>> loadNotifications({
    required int index,
    required int limit,
  }) async {
    final url = '/notifications?&skip=$index&limit=$limit';

    final response = await _api.get(url);

    return Map<String, dynamic>.from(response.data as Map);
  }

  Future<Map<String, dynamic>> deleteNotificationByID(String id) async {
    final url = '/notifications/$id';
    final response = await _api.get(url);

    return Map<String, dynamic>.from(response as Map);
  }

  Future<Map<String, dynamic>> deleteAllNotifications() async {
    const url = '/notifications';
    final response = await _api.get(url);

    return Map<String, dynamic>.from(response as Map);
  }

  Future<Map<String, dynamic>> deleteNotifications({
    required List<String> ids,
  }) async {
    final url = '/notifications/$ids';
    final response = await _api.get(url);

    return Map<String, dynamic>.from(response as Map);
  }
}
